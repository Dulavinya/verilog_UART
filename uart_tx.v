module uart_tx(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);
    parameter CLK_FREQ = 50000000;  // 50 MHz
    parameter BAUD_RATE = 9600;
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    
    reg [15:0] clk_count = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] tx_shift = 10'b1111111111;
    reg tx_active = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;
            tx_busy <= 0;
            clk_count <= 0;
            bit_index <= 0;
            tx_active <= 0;
        end else begin
            if (tx_start && !tx_busy) begin
                tx_shift <= {1'b1, tx_data, 1'b0}; // Stop, Data, Start
                tx_busy <= 1;
                tx_active <= 1;
                clk_count <= 0;
                bit_index <= 0;
            end

            if (tx_active) begin
                if (clk_count == CLKS_PER_BIT - 1) begin
                    clk_count <= 0;
                    tx <= tx_shift[bit_index];
                    bit_index <= bit_index + 1;

                    if (bit_index == 9) begin
                        tx_active <= 0;
                        tx_busy <= 0;
                        tx <= 1;
                    end
                end else begin
                    clk_count <= clk_count + 1;
                end
            end
        end
    end
endmodule
