`default
module DirectionScoringSystem(
    input logic [11:0] FloorDestinations; //floors 0-5 represent left elevator, floors 6-11 represent right elevator
    input logic [11:0] FloorsRequested;
    output logic [7:0] new_elevatorPosition; 
);

//wires within module
logic [11:0] floors_triggered; //represents all of the floors triggered (combined destinations and requested positions)
logic new_direction;
logic [7:0] elevatorPosition; //current position of the elevator (7-4) for left elevator, (3-0) for right elevator
logic direction; //1 for up, 0 for down
logic [4:0] floor1, floor2; //current floor of the elevator (0-11), including half floors

people_control_system inst(
    .FloorDestinations(FloorDestinations), .FloorsRequested(FloorsRequested), .elevatorPositions(new_elevatorPosition) 
    );

assign floors_triggered = FloorDestinations | FloorsRequested;

always_comb begin
    {floor1, floor2} = elevatorPosition;

    //priority encoder to get the top floor
    
    case (floors_triggered) begin
        12'b0000_0000_0001: top_floor = 0;
        12'b0000_0000_001x: top_floor = 1;
        12'b0000_0000_01xx: top_floor = 2;
        12'b0000_0000_1xxx: top_floor = 3;
        12'b0000_0001_xxxx: top_floor = 4;
        12'b0000_001x_xxxx: top_floor = 5;
        12'b0000_01xx_xxxx: top_floor = 6;
        12'b0000_1xxx_xxxx: top_floor = 7;
        12'b0001_xxxx_xxxx: top_floor = 8;
        12'b001x_xxxx_xxxx: top_floor = 9;
        12'b01xx_xxxx_xxxx: top_floor = 10;
        12'b1xxx_xxxx_xxxx: top_floor = 11;
        default: top_floor = -1; //no floors triggered
    endcase
    
    //priority encoder to get the bottom floor
    case (floors_triggered) begin
        12'b1xxx_xxxx_xxxx: bottom_floor = 11;
        12'b01xx_xxxx_xxxx: bottom_floor = 10;
        12'b001x_xxxx_xxxx: bottom_floor = 9;
        12'b0001_xxxx_xxxx: bottom_floor = 8;
        12'b0000_1xxx_xxxx: bottom_floor = 7;
        12'b0000_01xx_xxxx: bottom_floor = 6;
        12'b0000_001x_xxxx: bottom_floor = 5;
        12'b0000_0001_xxxx: bottom_floor = 4;
        12'b0000_0000_1xxx: bottom_floor = 3;
        12'b0000_0000_01xx: bottom_floor = 2;
        12'b0000_0000_001x: bottom_floor = 1;
        12'b0000_0000_0001: bottom_floor = 0;
        default: bottom_floor = -1; //no floors triggered
    endcase

    if (top_floor == bottom_floor)
        new_elevatorPosition = elevatorPosition; //stay on the same floor
    else if (top_floor == floor || bottom_floor == floor) 
        direction = ~direction; 
        new_floor = direction ? floor + 1 : floor - 1;
    else
        new_floor = direction ? floor + direction : floor - 1;
    end
    always_ff() begin
        if(floors_triggered[floor]) begin
        //call stop counter
    end 
    else 
    //call continue counter
    
    new_elevatorPosition = {floor1, floor2};
end

endmodule