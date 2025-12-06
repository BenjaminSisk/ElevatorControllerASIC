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
        $finish;
    end

    initial begin
        // Counter to check the same values
        for (int i = 0; i < 10; i++) begin
            rand_test = mem[i];
            #1333;
        end
        $finish;
    end
endmodule
