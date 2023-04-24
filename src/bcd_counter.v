module bcd_counter #(
    MAX_COUNT = 99
) (
    input wire clk_i,
    input wire rst_i,

    input wire increment_i,

    output wire [3:0] count_tens_o,
    output wire [3:0] count_ones_o,
    output wire [6:0] count_o,

    output wire overflow_o
);
    reg [3:0] count_ones_reg;
    reg [3:0] count_tens_reg;
    reg [6:0] count_reg;

    reg ovf;

    assign count_ones_o = count_ones_reg;
    assign count_tens_o = count_tens_reg;
    assign count_o = count_reg;
    assign overflow_o = ovf & increment_i;

    always @(posedge clk_i) begin
        if (rst_i) begin
            count_ones_reg = 4'b0;
            count_tens_reg = 4'b0;
            count_reg = 7'b0;
        end else if (increment_i) begin
            if (count_reg == MAX_COUNT) begin
                ovf <= 1;
                count_reg <= 0;
                count_ones_reg <= 0;
                count_tens_reg <= 0;
            end else begin
                ovf <= 0;
                count_reg <= count_reg + 1;
                if (count_ones_reg == 9) begin
                    count_ones_reg <= 0;
                    if (count_tens_reg == 9) begin
                        count_tens_reg <= 0;
                    end else begin
                        count_tens_reg <= count_tens_reg + 1;
                    end
                end else begin
                    count_ones_reg <= count_ones_reg + 1;
                end
            end
            count_reg <= count_reg + 1;
        end  
    end

endmodule