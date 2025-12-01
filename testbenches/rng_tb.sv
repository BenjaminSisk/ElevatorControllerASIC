`default_nettype none
module rng_tb ();

    // Input stimulus signals
    logic clk, rst;

    // Output value
    logic [11:0] rand_value;

    rng dut (.clk(clk), .rst(rst), .randy(rand_value));

    initial begin
        $dumpfile("rng_tb.vcd");
        $dumpvars(1, rng_tb);
    end

endmodule
