`timescale 1ns/1ps

module tb_uart_tx;

    reg clk = 0;
    reg rst = 1;
    reg tx_start = 0;
    reg [7:0] tx_data = 8'h00;
    wire tx;
    wire tx_busy;

    // Clock generation (50 MHz)
    always #10 clk = ~clk;

    // Instantiate UART Transmitter
    uart_tx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    initial begin
        $display("UART TX Testbench");
        $dumpfile("uart_tx_tb.vcd");
        $dumpvars(0, tb_uart_tx);

        #100;  // Wait for reset
        rst = 0;
        #100;

        tx_data = 8'h3C;  // Send data
        tx_start = 1;
        #20;
        tx_start = 0;

        // Wait until transmission is done
        wait (!tx_busy);
        #100;

        $finish;
    end
endmodule
