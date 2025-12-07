`timescale 1ns/1ps
`default_nettype none

module debouncing_tb();

    // DUT Inputs
    logic clk;
    logic rst;
    logic en;
    logic [3:0] row;

    // DUT Outputs
    logic [3:0] buttonMux;

    // Clock generation: 10ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk; //flip clock every 1/2 period

    // DUT instantiation
    debouncing DUT(
        .clk(clk),
        .rst(rst),
        .en(en),
        .row(row),
        .buttonMux(buttonMux)
    );

    // Simple printing utility
    task show(input string msg);
        $display("[%0t] %s | en=%b row=%b -> buttonMux=%b",
                 $time, msg, en, row, buttonMux);
    endtask


    initial begin
        $dumpfile("debouncing.vcd");
        $dumpvars(0, debouncing_tb);
        // INITIAL RESET
        rst = 1;
        en  = 0;
        row = 4'b0000;
        repeat(3) @(posedge clk);
        rst = 0;

        show("After reset");

        // Flush pipeline AFTER reset so Test 1 starts clean
        @(negedge clk); row = 4'b0000;
        @(negedge clk); row = 4'b0000;

        // TEST 1: No enable, output must be zero
        repeat(5) begin
            @(negedge clk);
            row = $urandom % 16;
            show("EN=0: Output must remain zero"); //outputs should be 0 due to enable being low active
        end


        // TEST 2: Rising edge on row[0]
        $display("\n TEST 2: Rising edge on row[0] -- ");
        @(negedge clk); en = 1;

        //flush pipeline (because pipeline is 3 stages deep)
        @(negedge clk); row = 4'b0000; show("Pipeline flush 1");
        @(negedge clk); row = 4'b0000; show("Pipeline flush 2"); 

        //make sure to change on negedge of the clock to avoid race conditions
        @(negedge clk); row = 4'b0000; show("Start: no key");
        @(negedge clk); row = 4'b0001; show("Row0 rises - expect buttonMux = 0001");
        @(negedge clk); row = 4'b0001; show("Hold → expect buttonMux = 0000");


        // TEST 3: Rising edge on row[3]
        $display("\n TEST 3: Rising edge on row[3] -- ");

        @(negedge clk); row = 4'b0000; show("Reset rows");

        //flush pipeline
        @(negedge clk); row = 4'b0000; show("Pipeline flush 3");
        @(negedge clk); row = 4'b0000; show("Pipeline flush 4");

        @(negedge clk); row = 4'b1000; show("Row3 rises - expect buttonMux = 1000");
        @(negedge clk); row = 4'b1000; show("Hold → expect buttonMux = 0000");


        // TEST 4: Simulate button bounce
        $display("\n TEST 4: Bounce simulation -- ");
        @(negedge clk); row = 4'b0000; show("Idle");
        @(negedge clk); row = 4'b0100; show("Bounce high");
        @(negedge clk); row = 4'b0000; show("Bounce low");
        @(negedge clk); row = 4'b0100; show("Final high - expect buttonMux = 0100");


        // TEST 5: Disable during activity
        $display("\n TEST 5: Disable during row change -- ");

        @(negedge clk); en = 0; row = 4'b1111; show("EN=0: Output forced to 0");
        @(negedge clk); row = 4'b0001; show("Still EN=0: Output forced to 0");


        // End simulation
        $display("\nSimulation complete.");
        $finish;
    end

endmodule
