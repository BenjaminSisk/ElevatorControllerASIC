`default_nettype none
module DirectionScoringSystem(
    input logic [11:0] FloorDestinations, //floors 0-5 represent left elevator, floors 6-11 represent right elevator
    input logic [11:0] FloorsRequested,
    input logic clk, rst,
    output logic [7:0] new_elevatorPosition 
);

//clock frequency: 1MHz

//wires within module
logic [5:0] floors_triggered1, floors_triggered2; //represents all of the floors triggered (combined destinations and requested positions)
logic new_direction;
logic [7:0] elevatorPosition; //current position of the elevator (7-4) for left elevator, (3-0) for right elevator
logic direction; //1 for up, 0 for down
logic [4:0] floor1, floor2; //current floor of the elevator (0-11), including half floors
logic [4:0] top_floor1, top_floor2, bottom_floor1, bottom_floor2; //highest and lowest floor triggered
logic en_continue;
logic en_stop;
logic count;


people_control_system inst(
    .FloorDestinations(FloorDestinations), .FloorsRequested(FloorsRequested), .elevatorPositions(new_elevatorPosition) 
    );

counterParametric #(.COUNT(1), .WIDTH(5)) stop_f (
    .clk(clk), .rst(rst), .en(en_stop), .syncRst(~en_stop),
    .counter(5)
    );

counterParametric #(.COUNT(60), .WIDTH(5)) continue_f (
    .clk(clk), .rst(rst), .en(en_continue), .syncRst(~en_continue),
    .counter(5)
    );

always_comb begin
    {floor1, floor2} = elevatorPosition;
    {floors_triggered1, floors_triggered2} = FloorDestinations | FloorsRequested;
    //priority encoder to get the left elevator top floor
    case (floors_triggered1) 
        6'b00_0001: top_floor1 = 0;
        6'b00_001x: top_floor1 = 1;
        6'b00_01xx: top_floor1 = 2;
        6'b00_1xxx: top_floor1 = 3;
        6'b01_xxxx: top_floor1 = 4;
        6'b1x_xxxx: top_floor1 = 5;
        default: top_floor1 = -1; //no floors triggered
    endcase

    //priority encoder to get the left elevator top floor
    case (floors_triggered2) 
        6'b00_0001: top_floor2 = 0;
        6'b00_001x: top_floor2 = 1;
        6'b00_01xx: top_floor2 = 2;
        6'b00_1xxx: top_floor2= 3;
        6'b01_xxxx: top_floor2= 4;
        6'b1x_xxxx: top_floor2= 5;
        default: top_floor2 = -1; //no floors triggered
    endcase
    
    //priority encoder to get the left elevator bottom floor
    case (floors_triggered1)
        6'b00_0001: bottom_floor1 = 0;
        6'b00_001x: bottom_floor1 = 1; 
        6'b00_01xx: bottom_floor1 = 2;
        6'b00_1xxx: bottom_floor1 = 3;
        6'b01_xxxx: bottom_floor1 = 4;
        6'b1x_xxxx: bottom_floor1 = 5;
        default: bottom_floor1 = -1; //no floors triggered
    endcase

    //priority encoder to get the right elevator bottom floor
    case (floors_triggered2)
        6'b00_0001: bottom_floor2 = 0;
        6'b00_001x: bottom_floor2 = 1; 
        6'b00_01xx: bottom_floor2 = 2;
        6'b00_1xxx: bottom_floor2 = 3;
        6'b01_xxxx: bottom_floor2 = 4;
        6'b1x_xxxx: bottom_floor2 = 5;
        default: bottom_floor2 = -1; //no floors triggered
    endcase
    
    //floor1 movement logic
    if (top_floor1 == bottom_floor1) begin
        floor1 = floor1; //stay on the same floor
    end
    else if (top_floor1 == floor1 || bottom_floor1 == floor1) begin
        direction = ~direction; 
        floor1 = direction ? floor1 + 1 : floor1 - 1;
    end
    else begin
        floor1 = direction ? floor1 + 1 : floor1 - 1;
    end

    //floor2 movement logic
    if (top_floor2 == bottom_floor2) begin
        floor2 = floor2; //stay on the same floor
    end
    else if (top_floor2 == floor2 || bottom_floor2 == floor2) begin
        direction = ~direction; 
        floor2 = direction ? floor2 + 1 : floor2 - 1;
    end
    else begin
        floor2 = direction ? floor2 + 1 : floor2 - 1;
    end

    //call continue counter
    
    new_elevatorPosition = {floor1, floor2};
end



always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        elevatorPosition <= 8'b0000_0000; //reset to ground floor
    end else begin
        elevatorPosition <= new_elevatorPosition;
    end
end



endmodule
