`timescale 1ns/1ps
`default_nettype none
module peopleControl_tb ();

    // Input and Output Signals
    logic clk, rst,
    logic [1:0] sim_state;
    logic [2:0] sim_speed;
    logic [5:0] people, people_generated;
    logic [9:0] rand;
    logic [11:0] requested, destination;
    logic [629:0] xpos;
    logic [251:0] ypos;
    logic [7:0] elevator_states;


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
        .elevatorStates(elevator_states)
    );

    // Clock, roughly 750 kHz
    initial begin
        clk = 1'b0;
        forever begin
            #1333 clk = ~clk
        end
    end

    // Stimulus
    initial begin
        reset = 0;
        rand = 0;
        sim_speed = 3'b001;
        sim_state = 2'b01;
        people = 63;

        #1333000;
        rand = 10'b1;
        elevator_states = 8'b1111_1111;

        #1333000;
        rand = 10'b111;
        elevator_states = 8'0000_0001;


    end

    initial begin
        $dumpfile("peopleControl_tb.vcd");
        $dumpvars(0, peopleControl_tb);
    end



endmodule