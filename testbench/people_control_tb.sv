`timescale 1ns/1ps
`default_nettype none
module people_control_tb ();

    // Input and Output Signals
    logic clk, rst,
    logic [1:0] sim_state;
    logic [2:0] sim_speed;
    logic [5:0] people, people_generated;
    logic [9:0] rand;
    logic [11:0] requested, destination;
    logic [629:0] xpos;
    logic [251:0] ypos;


    // Module Instantiation
    peopleController #(.PEOPLE(63), .WIDTH(6)) DUT (
        .clk(clk),
        .rst(rst),
        .sim_state(sim_state),
        .sim_speed(sim_speed),
        .people (people),
        .people_generated(peopleGenerated)
        .xposCFF(xpos),
        .yposCFF(ypos),
        .floorDestinations(destination),
        .floorsRequested(requested),
        .randy(rand)
    );

    // Clock, roughly 750 kHz
    initial clock = 0;
    always #1333 clk = ~clk;

    // Stimulus
    initial begin
        reset = 1;
        rand = 0;
        


    end


endmodule