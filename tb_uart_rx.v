`timescale 1ns / 1ps

module tb_uart_rx;

    reg clk = 0;
    reg rst = 1;
    reg rx = 1;
    reg baud_tick = 0;
    wire [7:0] data;
    wire valid;

    // Instantiate DUT
    uart_rx uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .baud_tick(baud_tick),
        .data(data),
        .valid(valid)
    );

    // 50 MHz clock = 20ns period
    always #10 clk = ~clk;

    // Task to simulate a UART byte transfer (LSB first)
    task send_uart_byte(input [7:0] byte);
        integer i;
        begin
            // Start bit
            rx = 0;
            trigger_baud();
            
            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = byte[i];
                trigger_baud();
            end
            
            // Stop bit
            rx = 1;
            trigger_baud();
        end
    endtask

    // Task to generate a baud_tick pulse
    task trigger_baud;
        begin
            #5000 baud_tick = 1;
            #100 baud_tick = 0;
            #5000;
        end
    endtask

    initial begin
        $display("UART RX Testbench Start");
        $dumpfile("tb_uart_rx.vcd");
        $dumpvars(0, tb_uart_rx);

        // Wait for reset
        #100 rst = 0;
        #100;

        // Send byte 0xA5 (10100101)
        send_uart_byte(8'hA5);

        // Wait to catch result
        #50000;

        if (valid)
            $display("Received: %h", data);
        else
            $display("No valid data received");

        #1000 $finish;
    end

endmodule
