module RAS #(
    parameter STACK_DEPTH = 8,
    parameter PTR_WIDTH   = 3
) (
    input  wire                 clock,
    input  wire                 reset,

    input  wire                 pred_pop,

    input  wire                 commit_valid,
    input  wire [31:0]          commit_pc,
    input  wire                 commit_call,
    input  wire                 commit_ret,
    input  wire                 commit_pred_pop,

    input  wire                 recover,
    input  wire [PTR_WIDTH:0]   recover_count,

    output wire                 top_valid,
    output wire [31:0]          top_addr,
    output wire [PTR_WIDTH:0]   count_out
);
    localparam [PTR_WIDTH:0] COUNT_ZERO = {(PTR_WIDTH+1){1'b0}};
    localparam [PTR_WIDTH:0] COUNT_ONE  = {{PTR_WIDTH{1'b0}}, 1'b1};
    localparam [PTR_WIDTH:0] COUNT_MAX  = {1'b1, {PTR_WIDTH{1'b0}}};

    integer i;

    reg [31:0]            stack [0:STACK_DEPTH-1];
    reg [PTR_WIDTH:0]     count;

    wire                  commit_push = commit_valid & commit_call;
    wire                  commit_pop  = commit_valid & commit_ret & (recover | !commit_pred_pop);
    wire [31:0]           commit_push_addr = commit_pc + 32'd4;

    wire [PTR_WIDTH:0]    base_count = recover ? recover_count : count;
    wire                  base_empty = (base_count == COUNT_ZERO);
    wire                  base_full  = (base_count == COUNT_MAX);

    wire [PTR_WIDTH-1:0]  top_index = count[PTR_WIDTH-1:0] - {{(PTR_WIDTH-1){1'b0}}, 1'b1};
    wire [PTR_WIDTH-1:0]  replace_index =
        base_empty ? {PTR_WIDTH{1'b0}} :
        base_count[PTR_WIDTH-1:0] - {{(PTR_WIDTH-1){1'b0}}, 1'b1};
    wire [PTR_WIDTH-1:0]  push_index =
        base_full ? {PTR_WIDTH{1'b1}} : base_count[PTR_WIDTH-1:0];

    wire [PTR_WIDTH:0] count_after_commit =
        (commit_push & commit_pop) ? (base_empty ? COUNT_ONE : base_count) :
        commit_push                ? (base_full  ? COUNT_MAX : base_count + COUNT_ONE) :
        commit_pop                 ? (base_empty ? COUNT_ZERO : base_count - COUNT_ONE) :
                                    base_count;

    wire [PTR_WIDTH:0] count_next =
        (pred_pop & (count_after_commit != COUNT_ZERO)) ? count_after_commit - COUNT_ONE :
                                                        count_after_commit;

    assign top_valid = (count != COUNT_ZERO);
    assign top_addr  = top_valid ? stack[top_index] : 32'b0;
    assign count_out = count;

    always @(posedge clock) begin
        if (reset) begin
            count <= COUNT_ZERO;
        end
        else begin
            count <= count_next;
        end
    end

    always @(posedge clock) begin
        if (reset) begin
            for (i = 0; i < STACK_DEPTH; i = i + 1) begin
                stack[i] <= 32'b0;
            end
        end
        else begin
            if (commit_push & commit_pop) begin
                stack[replace_index] <= commit_push_addr;
            end
            else if (commit_push) begin
                stack[push_index] <= commit_push_addr;
            end
        end
    end

endmodule

