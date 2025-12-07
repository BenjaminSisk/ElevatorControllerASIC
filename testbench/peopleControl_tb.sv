`timescale 1ns/1ps
`default_nettype none
module peopleControl_tb ();

    // Input and Output Signals
    logic clk, rst;
    logic [1:0] sim_state;
    logic [2:0] sim_speed;
    logic [5:0] people, people_generated;
    logic [9:0] random;
    logic [11:0] requested, destination;
    logic [629:0] xpos;
    logic [251:0] ypos;
    logic [7:0] elevator_states;


    // Module Instantiation
    // People will always be the same value 
    assign people = 63;
    peopleController #(.PEOPLE(63), .WIDTH(6)) DUT (
        .clk(clk),
        .rst(rst),
        .simState(sim_state),
        .simSpeed(sim_speed),
        .people (people),
        .peopleGenerated(people_generated),
        .xposCFF(xpos),
        .yposCFF(ypos),
        .floorDestinations(destination),
        .floorsRequested(requested),
        .randy(random),
        .elevatorStates(elevator_states)
    );
    // RNG has been proven to work so its rand output can be utilized
    rng rng_out (.clk(clk), .rst(rst), .randy(random));

    // Clock, roughly 750 kHz
    initial begin
        clk = 1'b0;
        forever begin
            #1333 clk = ~clk;
        end
    end


    initial begin
        $dumpfile("peopleControl_tb.vcd");
        $dumpvars(0, peopleControl_tb);
    end

    // Stimulus
    initial begin
        rst = 1;
        #1333;
        rst = 0;
        sim_speed = 3'b001;
        sim_state = 2'b01;
        elevator_states = 8'b0;
        #1333;

        elevator_states = 8'b1111_1111;
        #1333;

        elevator_states = 8'b0000_0001;
        #1333;

        $finish; 
    end
endmodule
