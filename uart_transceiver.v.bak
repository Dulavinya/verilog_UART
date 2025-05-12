module uart_transceiver (
    input  wire clk,
    input  wire rst,
    
    // Transmit interface
    input  wire        tx_start,
    input  wire [7:0]  tx_data,
    output wire        tx,
    output wire        tx_busy,
    
    // Receive interface
    input  wire        rx,
    output wire [7:0]  rx_data,
    output wire        rx_valid
);

    parameter CLK_FREQ = 50000000;
    parameter BAUD_RATE = 115200;
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    // Baud rate tick generator
    reg [15:0] baud_count = 0;
    reg        baud_tick = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            baud_count <= 0;
            baud_tick <= 0;
        end else begin
            if (baud_count == CLKS_PER_BIT - 1) begin
                baud_count <= 0;
                baud_tick <= 1;
            end else begin
                baud_count <= baud_count + 1;
                baud_tick <= 0;
            end
        end
    end

    // UART Transmitter
    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // UART Receiver (expects baud_tick as input)
    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .baud_tick(baud_tick),
        .data(rx_data),
        .valid(rx_valid)
    );

endmodule
