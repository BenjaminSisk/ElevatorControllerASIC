`default_nettype none
module vgaController_tb();
    // Inputs
    logic reset;
    logic [7:0] destination;
    //logic [25:0] people_data;
    logic [1:0] sim_state;
    // Outputs
    logic hsync;
    logic vsync;
    logic [9:0] horiz_count;
    logic [9:0] vert_count;
    logic [3:0] R;
    logic [3:0] G;
    logic [3:0] B;

    // Instantiate the Unit Under Test (UUT)
    vgaController uut (
        .reset(reset),
        .destination(destination),
        //.people_data(people_data),
        .sim_state(sim_state),
        .hsync(hsync),
        .vsync(vsync),
        .horiz_count(horiz_count),
        .vert_count(vert_count),
        .R(R),
        .G(G),
        .B(B)
    );

    initial begin
        // Initialize Inputs
        reset = 1;
        destination = 8'b00000000;
        //people_data = 26'b00000000000000000000000000;
        sim_state = 2'b00;

        // Wait 100 ns for global reset to finish
        #100;
        reset = 0;

        // Add stimulus here
        #1000;
        destination = 8'b11111111;
        sim_state = 2'b01;

        #5000;
        sim_state = 2'b10;

        #5000;
        $stop;
    end