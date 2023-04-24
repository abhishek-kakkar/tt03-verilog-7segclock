// Source: https://github.com/abhishek-kakkar/100DayFPGA/blob/master/day29%2Bex7-zipcpu/debouncer.v

module debouncer(
    input wire i_rst,
    input wire i_clk,
    input wire i_btn,
    output reg o_debounced
);
    // f = 12.5 kHz, so 20ms bounce needs 250 clock ticks
    parameter TIME_PERIOD = 250;

    reg r_btn, r_aux;
    reg [7:0] timer;

    always @(posedge i_clk) begin
        if (i_rst) begin
            { r_btn, r_aux } = 2'b00;
            timer = 0;
            o_debounced = 0;
        end else begin
            // 2FF sync
            {r_btn, r_aux} <= {r_aux, i_btn};
            if (timer != 0) begin
                timer <= timer - 1;
            end
            else if (r_btn != o_debounced) begin
                timer <= TIME_PERIOD - 1;
                o_debounced <= r_btn;
            end
            if (timer == 0) begin
                o_debounced <= r_btn;
            end
        end
    end    
endmodule