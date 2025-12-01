`timescale 1ns/1ps
`default_nettype none
module DirectionScoringSystem_tb();

    // Fake pixel clock (PLL substitute)
    logic clk;

    // Clock generation: 1 MHz (1000ns period)
    initial clk = 0;
    always #500 clk = ~clk; //flips every 500 ns

    // DUT instantiation
    logic rst;
    logic [1:0] simState;
    logic [11:0] FloorDestinations; // bits 0-5 represent left elevator, floors 6-11 represent right elevator
    logic [11:0] FloorsRequested; 
    logic [7:0] half_elevatorPositions; // LSB 4 bits for left elevator, MSB 4 bits for right elevator
    logic [1:0] directions; // MSB == right

    DirectionScoringSystem DUT (
        .clk(clk),
        .rst(rst),
        .simState(simState),
        .FloorDestinations(FloorDestinations),
        .FloorsRequested(FloorsRequested),
        .half_elevatorPositions(half_elevatorPositions),
        .directions(directions)
    );

    // Stimulus
    initial begin
        // VCD file for GTKWave
        $dumpfile("DirectionScoringSystem.vcd");
        $dumpvars(0, DirectionScoringSystem_tb);

        // Initial conditions
        rst = 1;
        FloorDestinations = 12'b0;  // both elevators at 1st floor
        FloorsRequested = 12'b0; 
        simState = 2'b01;

        #2000000;
        rst = 0;

        // Move left elevator floor-by-floor
        FloorDestinations = 12'd1;
        #2000000;
        FloorDestinations = 12'd2;
        #2000000;
        FloorDestinations = 12'd4;
        #2000000;
        FloorDestinations = 12'd8;
        #2000000;
        FloorDestinations = 12'd16;
        #2000000;
        FloorDestinations = 12'd32;
        #2000000;
        FloorDestinations = 12'd64;
        #2000000;
        FloorDestinations = 12'd128;
        #2000000;

        $display("Simulation finished.");
        $finish;
        //$stop;
    end

endmodule