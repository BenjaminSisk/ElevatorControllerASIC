`timescale 1ns/1ps
`default_nettype none

module synckey_tb();

    // wire instantiations
    logic clk, rst;
    logic [3:0] row;
    logic [3:0] buttonBus;
    logic pressed;
    logic [3:0] columns;    // <-- REQUIRED

    // DUT Instantiation
    synckey dut (
        .clk(clk),
        .rst(rst),
        .row(row),
        .buttonBus(buttonBus),
        .pressed(pressed),
        .columns(columns)    // <-- MISSING FIXED
    );

    // Clock generation: 10ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk; 

    // reset
    initial begin
        rst = 1'b1;
        row = 4'b0000;
        repeat (5) @(posedge clk);
        rst = 1'b0;
    end

    // Task to press a button for a specified time
    task press_button(input [3:0] keyrow, input time hold_time);
        begin
            row = keyrow;
            $display("[%0t] PRESS row = %b", $time, row);
            #(hold_time);
            row = 4'b0000; 
            $display("[%0t] RELEASE row = %b", $time, row);
            #(hold_time);
        end
    endtask

    // Stimulus
    initial begin
        @ (negedge rst); 
        @ (posedge clk); 

        press_button(4'b0001, 2000);
        press_button(4'b0010, 2000);
        press_button(4'b0100, 2000);
        press_button(4'b1000, 2000);

        press_button(4'b1010, 3000); 

        repeat (5) begin
            row = $urandom_range(0,15);
            $display("[%0t] RANDOM PRESS row = %b", $time, row);
            #(1500);
            row = 4'b0000;
            #1000;
        end

        $display("Simulation done.");
        $finish;
    end

    // Monitor
    initial begin
        $monitor("[%0t] row=%b | columns=%b | buttonBus=%h | pressed=%b | encoder=%h",
                 $time, row, columns, buttonBus, pressed, dut.encoderIn);
    end

endmodule
