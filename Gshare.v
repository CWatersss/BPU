module Gshare #(parameter LENGTH = 4) (
    input clock,
    input reset,

    input [31:0] pc,
    output pred_taken,
    output [LENGTH-1:0] pred_index,

    input actural_valid,    //指令为分支指令时，actural_valid为1
    input [31:0] actural_pc, //分支指令实际PC
    input [LENGTH-1:0] actural_index,//预测时用的index
    input actural_taken    //分支指令实际taken
);
//存储
    reg [LENGTH-1:0] GHR;//全局历史记录寄存器
    reg [1:0] PHT [2**LENGTH-1:0];//分支预测表

//预测
    wire [LENGTH-1:0] index = pc[LENGTH+1:2] ^ GHR;
    assign pred_index = index;
    assign pred_taken = PHT[index][1];

//更新（用actural_index进行更新）
    wire [LENGTH-1:0] GHR_next = {GHR[LENGTH-2:0], actural_taken};
    wire [1:0] PHT_max = 2'b11;
    wire [1:0] PHT_next = actural_taken
        ? (PHT[actural_index] == PHT_max ? PHT_max : PHT[actural_index] + 1)
        : (PHT[actural_index] == 0 ? 0 : PHT[actural_index] - 1);
    
    integer i;
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            GHR <= 0;
            for (i = 0; i < 2**LENGTH; i = i + 1) PHT[i] <= 2'b01;  // weakly not taken
        end else if (actural_valid) begin
            GHR <= GHR_next;
            PHT[actural_index] <= PHT_next; 
            /* 
            * ! index已经不是之前内个了 
            */
        end
    end
endmodule
