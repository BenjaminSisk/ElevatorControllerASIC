`default_nettype none
module DirectionScoringSystem(
    input logic clk, rst,
    input logic [1:0] simState,
    input logic [11:0] FloorDestinations, //bits 0-5 represent left elevator, floors 6-11 represent right elevator
    input logic [11:0] FloorsRequested,
    output logic [7:0] half_elevatorPositions, // LSB 4 bits for left elevator, MSB 4 bits for right elevator
    output logic [1:0] directions // MSB == right
);


    typedef enum logic [1:0] {
        START = 2'b0,
        SIM = 2'b1, 
        PAUSE = 2'b10,
        ENDING = 2'b11
    } STATE;


    logic en;
    logic [5:0] floors_triggered1, floors_triggered2;
    always_comb begin
        {floors_triggered1, floors_triggered2} = FloorDestinations | FloorsRequested;
        en = (simState == SIM);
    end

    elevatorController left (.clk(clk), .rst(rst), .floors_triggered(floors_triggered1), .floor(half_elevatorPositions[3:0]), .direction(directions[0]), .en(en));
    elevatorController right (.clk(clk), .rst(rst), .floors_triggered(floors_triggered2), .floor(half_elevatorPositions[7:4]), .direction(directions[1]), .en(en));

endmodule
