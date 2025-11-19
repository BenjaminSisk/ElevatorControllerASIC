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
logic [4:0] top_floor1, top_floor2; //highest floor triggered
logic en_continue;
logic en_stop;
logic count;


people_control_system inst(
    .FloorDestinations(FloorDestinations), .FloorsRequested(FloorsRequested), .elevatorPositions(new_elevatorPosition) 
    );

counterParametric stop_f #(.COUNT(1), .WIDTH(5)) (
    .clk(clk), .rst(rst), .en(en_stop), .syncRst(~en_stop),
    count;
    );

counterParametric continue_f #(.COUNT(60), .WIDTH(5)) (
    .clk(clk), .rst(rst), .en(en_continue), .syncRst(~en_continue),
    count;
    );

always_comb begin
    {floor1, floor2} = elevatorPosition;
    {floors_triggered1, floors_triggered2} = FloorDestinations | FloorsRequested;
    //priority encoder to get the left elevator top floor
    case (floors_triggered1) 
        6'b0000_0001: top_floor1 = 0;
        6'b0000_001x: top_floor1 = 1;
        6'b0000_01xx: top_floor1 = 2;
        6'b0000_1xxx: top_floor1 = 3;
        6'b0001_xxxx: top_floor1 = 4;
        6'b001x_xxxx: top_floor1 = 5;
        6'b01xx_xxxx: top_floor1 = 6;
        default: top_floor1 = -1; //no floors triggered
    endcase

    //priority encoder to get the left elevator top floor
    case (floors_triggered2) 
        6'b0000_0001: top_floor2 = 0;
        6'b0000_001x: top_floor2 = 1;
        6'b0000_01xx: top_floor2 = 2;
        6'b0000_1xxx: top_floor2= 3;
        6'b0001_xxxx: top_floor2= 4;
        6'b001x_xxxx: top_floor2= 5;
        6'b01xx_xxxx: top_floor2 = ;
        default: top_floor = -1; //no floors triggered
    endcase
    
    //priority encoder to get the left elevator bottom floor
    case (floors_triggered1)
        12'b0000_0001: bottom_floor = 0;
        12'b0000_001x: bottom_floor = 1; 
        12'b0000_01xx: bottom_floor = 2;
        12'b0000_1xxx: bottom_floor = 3;
        12'b0001_xxxx: bottom_floor = 4;
        12'b001x_xxxx: bottom_floor = 5;
        12'b01xx_xxxx: bottom_floor = 6;
        default: top_floor = -1; //no floors triggered
    endcase

    //priority encoder to get the right elevator bottom floor
    case (floors_triggered2)
        12'b0000_0001: bottom_floor = 0;
        12'b0000_001x: bottom_floor = 1; 
        12'b0000_01xx: bottom_floor = 2;
        12'b0000_1xxx: bottom_floor = 3;
        12'b0001_xxxx: bottom_floor = 4;
        12'b001x_xxxx: bottom_floor = 5;
        12'b01xx_xxxx: bottom_floor = 6;
        default: top_floor = -1; //no floors triggered
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
