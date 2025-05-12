`timescale 1ns / 1ps

module tb_uart_transceiver;

    // Clock and reset
    reg clk = 0;
    reg rst = 1;

    // UART TX signals
    reg [7:0] tx_data = 8'h00;
    reg tx_start = 0;
    wire tx;
    wire tx_busy;

    // UART RX signals
    wire [7:0] rx_data;
    wire rx_valid;

    // Instantiate the transceiver
    uart_transceiver #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(115200)
    ) uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .rx(tx),  // Loopback: connect tx to rx
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    // Generate 50MHz clock
    always #10 clk = ~clk;

    initial begin
        $display("UART Transceiver Testbench");
        $dumpfile("tb_uart_transceiver.vcd");
        $dumpvars(0, tb_uart_transceiver);

        // Apply reset
        #100 rst = 0;

        // Wait a bit
        #200;

        // Send a byte
        tx_data = 8'hA5;
        tx_start = 1;
        #20 tx_start = 0;

        // Wait for transmission and reception
        wait (rx_valid == 1);

        // Display result
        if (rx_data == 8'hA5)
            $display("SUCCESS: Received byte = %h", rx_data);
        else
            $display("FAIL: Expected 0xA5, got %h", rx_data);

        #5000;
        $finish;
    end

endmodule
