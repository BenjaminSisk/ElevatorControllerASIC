`timescale 1ns/1ps
`default_nettype none

module top_tb();

    // DUT Inputs  (driven by testbench)
    logic ICE_31, ICE_34, ICE_38, ICE_43;

    // DUT Outputs (driven by DUT, read-only here)
    logic ICE_28, ICE_32, ICE_36, ICE_42;

    // DUT instantiation
    top DUT(
        .ICE_28(ICE_28),
        .ICE_32(ICE_32),
        .ICE_36(ICE_36), 
        .ICE_42(ICE_42),
        .ICE_31(ICE_31),
        .ICE_34(ICE_34),
        .ICE_38(ICE_38),
        .ICE_43(ICE_43)
    );

    // Printing utility
    task show(input string msg);
        $display("[%0t] %s | IN: 31=%b 34=%b 38=%b 43=%b | OUT: 28=%b 32=%b 36=%b 42=%b",
                 $time, msg, ICE_31, ICE_34, ICE_38, ICE_43,
                 ICE_28, ICE_32, ICE_36, ICE_42);
    endtask

    // Test sequence
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        // Initialize inputs
        ICE_31 = 0;
        ICE_34 = 0;
        ICE_38 = 0;
        ICE_43 = 0;

        show("Initial");

        #10;
        ICE_31 = 1;
        ICE_34 = 1;
        ICE_38 = 1;
        ICE_43 = 1;
        show("All inputs high");

        #10;
        ICE_31 = 0;
        ICE_34 = 1;
        ICE_38 = 0;
        ICE_43 = 1;
        show("Mixed inputs");

        #100;
        $finish;
    end

endmodule
