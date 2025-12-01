`timescale 1ns/1ps
`default_nettype none
module DirectionScoringSystem_tb();

    // DUT Inputs
    logic reset;
    logic [7:0] destination;
    logic [1:0] sim_state;

    // DUT Outputs
    logic hsync, vsync;
    logic [9:0] horiz_count, vert_count;
    logic [3:0] R, G, B;

    // Fake pixel clock (PLL substitute)
    logic clk;

    // Clock generation: 1 MHz (1000ns period)
    initial clk = 0;
    always #500 clk = ~clk; //flips every 500 ns

    // DUT instantiation
    logic clk, rst,
    logic [11:0] FloorDestinations, // bits 0-5 represent left elevator, floors 6-11 represent right elevator
    logic [11:0] FloorsRequested, 
    logic [7:0] half_elevatorPositions, // LSB 4 bits for left elevator, MSB 4 bits for right elevator
    logic [1:0] directions // MSB == right

    DirectionScoringSystem3 DUT (
        .clk(clk),
        .FloorDestinations(FloorDestinations),
        .FloorsRequested(FloorsRequested)
        .half_elevatorPositions(half_elevatorPositions)
        .directions(directions)
    );

    // Stimulus
    initial begin
        // VCD file for GTKWave
        $dumpfile("vga_test.vcd");
        $dumpvars(0, DirectionScoringSystem3_tb);

        // Initial conditions
        reset = 1;
        FloorDestinations = 12'b0;  // both elevators at 1st floor
        FloorsRequested = 12'b0; 

        #200;
        reset = 0;

        // Move left elevator floor-by-floor
        FloorDestinations = 12'b1;

        repeat (6) begin
            @(posedge clk);
            FloorDestinations >> 1;
            #50000; 
        end

        $display("Simulation finished.");
        $stop;
    end

endmodule