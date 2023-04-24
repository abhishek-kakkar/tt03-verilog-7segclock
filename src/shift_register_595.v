module shift_register_595 #(
    parameter NUM_ICS = 2
) (
    input   clk_i,
    input   rst_i,

    input   trigger_i,                  // Active high
    input   [((NUM_ICS*8)-1):0] data_i, // Data input

    output  wire sclk_o,                // SHCP of all 595s tied together
    output  wire data_o,                // DS pin of 1st 595 in chain
    output  wire latch_en_o             // STCP pin of all 595s together
);
    localparam NUM_COUNT_BITS = NUM_ICS * 8;
    localparam NUM_COUNT_REG_BITS = $clog2(NUM_COUNT_BITS);

    reg data;
    reg sclk;
    reg is_idle;
    reg latch_en;
    reg [NUM_COUNT_REG_BITS-1:0] shift_count;

    assign sclk_o = sclk;
    assign data_o = data;
    assign latch_en_o = latch_en;

    always @(posedge clk_i) begin
        if (rst_i) begin
            data <= 1'b0;
            sclk <= 1'b1;
            is_idle <= 1'b1;
            latch_en <= 1'b0;
            shift_count <= 0;
        end else if (trigger_i) begin
            is_idle <= 1'b0;
            latch_en <= 1'b0;
            shift_count <= (NUM_COUNT_BITS - 1);
        end else if (!is_idle) begin
            if (sclk == 1'b1) begin
                sclk <= 1'b0;
                data <= data_i[shift_count];
            end else begin
                sclk <= 1'b1;
                shift_count <= shift_count - 1;
                is_idle <= (shift_count == 0);
            end
        end else begin
            latch_en <= 1'b1;
        end
    end

endmodule