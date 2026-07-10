`include "../tao_defines.v"

module BPU (
    input clock,
    input reset,
    input flush,  // flush 时清空 S1 事件，避免 stale correction

    //预测（L1 快速路径，1 拍，喂 IFU，行为不变）
    input [31:0] pc,
    input pred_fire,
    output [1:0] pred_info,//用于调试
    output pred_taken,
    output [31:0] pred_npc,
    output [`TAO_GSHARE_LENGTH-1:0] pred_index,

    output ras_pred_pop,
    output [3:0] ras_checkpoint,

    //更新（提交）—— Gshare / BTB / RAS
    input BTB_unvalid,
    input actural_valid,
    input [31:0] actural_pc,
    input [`TAO_GSHARE_LENGTH-1:0] actural_index,
    input actural_taken,
    input [31:0] actural_npc, //实际的下一个PC
    //RAS更新
    input actural_cond,
    input actural_call,
    input actural_ret,
    input ras_recover,
    input [3:0] ras_recover_count,
    input ras_commit_pred_pop
    //================= 两级 overriding：TAGE L2 =======
    //两级分支的纠正 ---- TAGE
    output correct_valid,      // L2 覆盖 L1（针对落后 1 拍的取指）
    output correct_taken,      // TAGE 方向
    output [31:0] correct_npc, // 纠正 NPC = btb_target 或 branch_pc+4
    output [31:0] correct_pc,  // 被纠正分支 PC（供 IFU FIFO 匹配）
    //TAGE 预测 metadata（输出，C2 有效，后续锁进流水携带）
    output tage_meta_valid,
    output [`TAO_TAGE_META_W-1:0] tage_meta,
    //TAGE 提交 metadata（输入，用于更新）
    input tage_upd_valid,      // = actural_valid & actural_cond
    input tage_upd_taken,      // = actural_taken
    input [`TAO_TAGE_META_W-1:0] tage_upd_meta
);
    wire direct_pred_taken;

    // ---- 方向预测：Gshare（仅条件分支更新）----
    Gshare #(.LENGTH(`TAO_GSHARE_LENGTH)) BPU_Gshare (
        .clock(clock),
        .reset(reset),
        .pc(pc),
        .pred_taken(direct_pred_taken),
        .pred_index(pred_index),
        .actural_valid(actural_valid & actural_cond),
        .actural_pc(actural_pc),
        .actural_taken(actural_taken),
        .actural_index(actural_index)
    );

    // ---- 目标预测：BTB（恢复为携带 cond/call/ret/jump 类型）----
    wire pred_valid;
    wire [31:0] pred_target;
    wire pred_cond;
    wire pred_call;
    wire pred_ret;
    wire pred_jump;
    BTB BPU_BTB (
        .clock(clock),
        .reset(reset),
        .pc(pc),
        .pred_valid(pred_valid),
        .pred_target(pred_target),
        .pred_cond(pred_cond),
        .pred_call(pred_call),
        .pred_ret(pred_ret),
        .pred_jump(pred_jump),

        .BTB_unvalid(BTB_unvalid),
        .actural_valid(actural_valid),
        .actural_pc(actural_pc),
        .actural_taken(actural_taken),
        .actural_target(actural_npc),
        .actural_cond(actural_cond),
        .actural_call(actural_call),
        .actural_ret(actural_ret)
    );

    // ---- 返回地址：RAS（ret 类型由 BTB 提供，RAS 只维护返回地址栈）----
    wire ras_top_valid;
    wire [31:0] ras_top_addr;
    wire [3:0] ras_count;
    assign ras_pred_pop = pred_fire & pred_ret & ras_top_valid;
    assign ras_checkpoint = ras_count;
    RAS BPU_RAS (
        .clock(clock),
        .reset(reset),
        .pred_pop(ras_pred_pop),
        //stack commit / recover
        .commit_valid(actural_valid),
        .commit_pc(actural_pc),
        .commit_call(actural_call),
        .commit_ret(actural_ret),
        .commit_pred_pop(ras_commit_pred_pop),
        .recover(ras_recover),
        .recover_count(ras_recover_count),
        //output
        .top_valid(ras_top_valid),
        .top_addr(ras_top_addr),
        .count_out(ras_count)
    );

    // ---- 最终预测：BTB 提供类型；条件分支再叠加 Gshare 方向，ret 优先 RAS 栈顶 ----
    wire pred_cond_taken = pred_cond & direct_pred_taken;
    wire pred_call_taken = pred_call;
    wire pred_ret_taken  = pred_ret;
    wire pred_jump_taken = pred_jump;

    assign pred_info = {pred_valid, direct_pred_taken};
    assign pred_taken = pred_cond_taken | pred_call_taken | pred_ret_taken | pred_jump_taken;
    assign pred_npc = (
        (pred_ret_taken & ras_top_valid) ? ras_top_addr :
        pred_taken ? pred_target :
        pc + 4
    );

    // ================= TAGE L2（2 拍） + correction =================
    wire        tage_valid;
    wire [31:0] tage_pc;
    wire        tage_taken;
    wire [`TAO_TAGE_META_W-1:0] tage_meta_w;
    TAGE BPU_TAGE (
        .clock(clock),
        .reset(reset),
        .flush(flush),
        .pc(pc),
        .pred_fire(pred_fire),
        .tage_valid(tage_valid),
        .tage_pc(tage_pc),
        .tage_taken(tage_taken),
        .tage_meta(tage_meta_w),
        .upd_valid(tage_upd_valid),
        .upd_taken(tage_upd_taken),
        .upd_meta(tage_upd_meta)
    );

    // BPU 侧 S1：与 TAGE S1 同拍（pred_fire）锁存 L1 结果，供 C2 比较
    // s1_valid 是事件脉冲，不保持；连续 pred_fire 时每拍代表一个新 C2 结果
    reg        s1_valid;
    reg [31:0] s1_pc;
    reg        s1_gshare_taken;
    reg        s1_pred_cond;
    reg [31:0] s1_btb_target;
    reg        s1_ras_pred_pop;
    always @(posedge clock) begin
        if (reset || flush) begin
            s1_valid <= 1'b0;
        end else begin
            s1_valid <= pred_fire;
        end

        if (!reset && !flush && pred_fire) begin
            s1_pc           <= pc;
            s1_gshare_taken <= direct_pred_taken;
            s1_pred_cond    <= pred_cond;
            s1_btb_target   <= pred_target;
            s1_ras_pred_pop <= ras_pred_pop;
        end
    end

    // C2：TAGE 只覆盖 BTB 已识别出的条件分支；call/ret/jump 不参与 TAGE correction。
    wire disagree   = (tage_taken != s1_gshare_taken);
    wire cond_scope = s1_pred_cond & ~s1_ras_pred_pop;
    assign correct_valid   = s1_valid & tage_valid & cond_scope & disagree;
    assign correct_taken   = tage_taken;
    assign correct_npc     = tage_taken ? s1_btb_target : (s1_pc + 32'd4);
    assign correct_pc      = tage_pc; 
    assign tage_meta_valid = tage_valid;
    assign tage_meta       = tage_meta_w;

endmodule

