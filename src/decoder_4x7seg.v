
/*
      -- A --
     |       |
     F       B  N
     |       |
      -- G --
     |       |  N --> colon
     E       C
     |       |
      -- D --

    Reference circuit: https://wokwi.com/projects/362790299842764801
        (for shift register, tested on virtual RPi Pico)

    15  14  13  12  11  10  09  08  07  06  05  04  03  02  01  00
     C   G   4   N   B   3  xx  xx   2   F   A   1   E   D  xx  xx

    Each segment is active low, display is common anode. 1, 2, 3, 4
    are the respective common anodes. N is the colon pin. If the
    display does not have a colon pin, it can be connected to the middle
    decimal point.
*/

module seg7x4withColon (
    input wire [3:0] disp_i,
    input wire [1:0] digit_i,
    input wire colon_i,
    output reg [15:0] data_o
);

    always @(*) begin
        data_o[12] = ~(colon_i & (digit_i == 1));

        {data_o[9:8], data_o[1:0]} = 4'b0000;

        case (digit_i)
            0: {data_o[4], data_o[7], data_o[10], data_o[13]} = 4'b1000;
            1: {data_o[4], data_o[7], data_o[10], data_o[13]} = 4'b0100;
            2: {data_o[4], data_o[7], data_o[10], data_o[13]} = 4'b0010;
            3: {data_o[4], data_o[7], data_o[10], data_o[13]} = 4'b0001;
        endcase

        case(disp_i)
            0:  {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b1000000;
            1:  {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b1111001;
            2:  {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b0100100;
            3:  {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b0110000;
            4:  {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b0011001;
            5:  {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b0010010;
            6:  {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b0000010;
            7:  {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b1111000;
            8:  {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b0000000;
            9:  {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b0010000;
            default:    
                {data_o[14], data_o[6], data_o[3], data_o[2], data_o[15], data_o[11], data_o[5]} = 7'b1111111;
        endcase
    end

endmodule

