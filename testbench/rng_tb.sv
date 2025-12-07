`timescale 1ns/1ps
module rng_tb ();

    logic [11:0] rand_mod;
    logic [11:0] rand_test;
    logic clk, rst;

    // Read the file into memory
    logic [11:0] mem [0:255];
    initial begin
        $readmemh("press.mem", mem);
    end

    // Clock, roughly 750 kHz
    initial begin
        clk = 1'b0;
        forever begin
            #1333 clk = ~clk;
        end
    end

    // Module instantiation
    rng uut (.clk(clk), .rst(rst), .randy(rand_mod));

    initial begin
        $dumpfile("rng_tb.vcd");
        $dumpvars(0, rng_tb);
    end

    initial begin
        // Counter to check the same values
        rst = 1;
        #1333;
        rst = 0;
        for (int i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
            rand_test = mem[i];

        end
        $finish;
    end
endmodule
