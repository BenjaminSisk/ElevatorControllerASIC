`timescale 1ns/1ps
`default_nettype none
module vgaController_tb();

    // DUT Inputs
    logic reset;
    logic [7:0] destination;
    logic [1:0] sim_state;

    // DUT Outputs
    logic hsync, vsync;
    logic [9:0] horiz_count, vert_count;
    logic [3:0] R, G, B;

    // Fake pixel clock (PLL substitute)
    logic pixel_clk;

    // Clock generation: 25 MHz (40ns period)
    initial pixel_clk = 0;
    always #20 pixel_clk = ~pixel_clk; //flips every 20ns

    // DUT instantiation
    vgaController DUT (
        .reset(reset),
        .destination(destination),
        .sim_state(sim_state),
        .hsync(hsync),
        .vsync(vsync),
        .horiz_count(horiz_count),
        .vert_count(vert_count),
        .R(R), .G(G), .B(B)
    );

    // Override PLL output of DUT
    initial begin
        force DUT.pixel_clk = pixel_clk; //force is continuous assignment that overrides
    end

    // Stimulus
    initial begin
        // VCD file for GTKWave
        $dumpfile("vga_test.vcd");
        $dumpvars(0, vgaController_tb);

        // Initial conditions
        reset = 1;
        destination = 8'h00;  // both elevators at 1st floor
        sim_state = 2'b01;

        #200;
        reset = 0;

        // Move left elevator floor-by-floor
        repeat (6) begin
            @(posedge pixel_clk);
            destination[7:4] = destination[7:4] + 1;
            $display("[LEFT ELEVATOR] floor=%0d  time=%0t", destination[7:4], $time);
            #50000; // allow time to scan screen
        end

        // Move right elevator floor-by-floor
        repeat (6) begin
            @(posedge pixel_clk);
            destination[3:0] = destination[3:0] + 1;
            $display("[RIGHT ELEVATOR] floor=%0d  time=%0t", destination[3:0], $time);
            #50000;
        end

        // Test STOP mode
        sim_state = 2'b10;
        $display("[STOP MODE TEST] time=%0t", $time);
        #50000;

        $display("Simulation finished.");
        $stop;
    end

endmodule

