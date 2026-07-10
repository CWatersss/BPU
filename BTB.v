module BTB #(
    parameter INDEX_WIDTH  = 6,
    parameter TARGET_WIDTH = 12   // JYDSOC IROM: 16KB -> [13:2] 共12位
) (
    input  wire         clock,
    input  wire         reset,

    input  wire [31:0]  pc,
    output wire         pred_valid,
    output wire [31:0]  pred_target,
    output wire         pred_cond,
    output wire         pred_call,
    output wire         pred_ret,
    output wire         pred_jump,

    input  wire         BTB_unvalid,
    input  wire         actural_valid,      // 指令为分支/跳转指令时为1
    input  wire [31:0]  actural_pc,
    input  wire         actural_taken,
    input  wire [31:0]  actural_target,
    input  wire         actural_cond,
    input  wire         actural_call,
    input  wire         actural_ret
);

    //============================================================
    // JYDSOC IROM 地址范围
    // 0x8000_0000 ~ 0x8000_3FFF
    // 共16KB，按4字节对齐后，有效PC位为 [13:2]，共12位
    //============================================================
    localparam [31:0] IROM_BASE      = 32'h8000_0000;
    localparam integer PC_WORD_BITS  = 12;                 // 对应 pc[13:2]
    localparam integer TAG_WIDTH     = PC_WORD_BITS - INDEX_WIDTH;  // 6
    localparam integer N             = (1 << INDEX_WIDTH);          // 64
    // 打包字：{tag, target, cond, call, ret, jump}
    localparam integer DW            = TAG_WIDTH + TARGET_WIDTH + 4; // 22

    //============================================================
    // 存储体
    //   valid：触发器向量，唯一需 reset（BTB_unvalid 也作用于此）
    //   btb_mem：distributed LUTRAM（RAM64X1D，单同步写口 + 异步读口，不 reset）
    //            脏内容靠 valid[index]=0 屏蔽
    //============================================================
    reg [N-1:0] valid;
    (* ram_style = "distributed" *) reg [DW-1:0] btb_mem [0:N-1];

    //============================================================
    // 预测查询（异步读）
    //   index = pc[INDEX_WIDTH+1:2]
    //   tag   = pc[13 : INDEX_WIDTH+2]
    //============================================================
    wire [INDEX_WIDTH-1:0] index  = pc[INDEX_WIDTH+1:2];
    wire [TAG_WIDTH-1:0]   pc_tag = pc[13:INDEX_WIDTH+2];

    wire [DW-1:0]           rd     = btb_mem[index];             // RAM64X1D DPO 口
    wire [TAG_WIDTH-1:0]    tag_rd = rd[DW-1 -: TAG_WIDTH];            // [21:16]
    wire [TARGET_WIDTH-1:0] tgt_rd = rd[TARGET_WIDTH+3 -: TARGET_WIDTH]; // [15:4]
    wire cond_rd = rd[3];
    wire call_rd = rd[2];
    wire ret_rd  = rd[1];
    wire jump_rd = rd[0];

    assign pred_valid  = valid[index] && (tag_rd == pc_tag);

    // target 存的是目标地址的 [13:2]，重建时高位直接补 IROM_BASE[31:14]
    assign pred_target = {IROM_BASE[31:14], tgt_rd, 2'b00};

    assign pred_cond = pred_valid & cond_rd;
    assign pred_call = pred_valid & call_rd;
    assign pred_ret  = pred_valid & ret_rd;
    assign pred_jump = pred_valid & jump_rd;

    //============================================================
    // 更新
    //   写入信息（仅在实际分支有效且 taken 时写）
    //============================================================
    wire [INDEX_WIDTH-1:0]  index_update = actural_pc[INDEX_WIDTH+1:2];
    wire [TAG_WIDTH-1:0]    tag_next     = actural_pc[13:INDEX_WIDTH+2];
    wire [TARGET_WIDTH-1:0] target_next  = actural_target[13:2];
    wire                    actural_jump = !(actural_cond | actural_call | actural_ret);
    wire [DW-1:0]           wr_data      = {tag_next, target_next,
                                            actural_cond, actural_call, actural_ret, actural_jump};
    wire                    mem_we       = actural_valid & actural_taken;

    // btb_mem：单写口、单条件、无 reset
    always @(posedge clock) begin
        if (mem_we) btb_mem[index_update] <= wr_data;
    end

    // valid：触发器，带 reset；taken 置位 / BTB_unvalid 清位
    always @(posedge clock or posedge reset) begin
        if (reset)            valid <= {N{1'b0}};
        else if (mem_we)      valid[index_update] <= 1'b1;
        else if (BTB_unvalid) valid[index_update] <= 1'b0;
    end

endmodule

