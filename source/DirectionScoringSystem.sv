`default_nettype none
module DirectionScoringSystem(
    input logic [11:0] FloorDestinations, //floors 0-5 represent right elevator, floors 6-11 represent left elevator
    input logic [11:0] FloorsRequested,
    input logic clk, rst,
    output logic [7:0] half_elevatorPositions //4 bits for left elevator, 4 bits for right elevator
);

//clock frequency: 1MHz

//wires within module
logic [5:0] floors_triggered1, floors_triggered2; //represents all of the floors triggered (combined destinations and requested positions)
logic [7:0] elevatorPosition; //current position of the elevator (7-4) for left elevator, (3-0) for right elevator
logic direction1,direction2; //1 for up, 0 for down
logic [3:0] floor1, floor2; //current floor of the elevator (0-6), excluding half floors
logic [3:0] top_floor1, top_floor2, bottom_floor1, bottom_floor2; //highest and lowest floor triggered
logic [5:0] stop_f_counter1, continue_f_counter1, stop_f_counter2, continue_f_counter2; // output for counters for stopping and continuing
//need to change count variables to appropriate size
logic en_continue1, en_continue2; //use as enable for continue counter (similar to method call)
logic en_stop1, en_stop2;
logic [3:0] half_floor1, half_floor2; //half floor of elevator
logic continue_tick1, stop_tick1, continue_tick2, stop_tick2;
logic counting_1;
logic counting_2;
logic [7:0] new_elevatorPosition; //next position of the elevator


assign stop_tick1 = (stop_f_counter1 == 5);  // COUNT = 5
assign continue_tick1 = (continue_f_counter1 == 60); // COUNT = 60
assign stop_tick2 = (stop_f_counter2 == 5);  // COUNT = 5
assign continue_tick2 = (continue_f_counter2 == 60); // COUNT = 60



counterParametric #(.COUNT(1), .WIDTH(5)) stop_f1 (
    .clk(clk), .rst(rst), .en(en_stop1), .syncRst(~en_stop1),
    .counter(stop_f_counter1)
    );

counterParametric #(.COUNT(60), .WIDTH(5)) continue_f1 (
    .clk(clk), .rst(rst), .en(en_continue1), .syncRst(~en_continue1),
    .counter(continue_f_counter1)
    );

counterParametric #(.COUNT(1), .WIDTH(5)) stop_f2 (
    .clk(clk), .rst(rst), .en(en_stop2), .syncRst(~en_stop2),
    .counter(stop_f_counter2)
    );

counterParametric #(.COUNT(60), .WIDTH(5)) continue_f2 (
    .clk(clk), .rst(rst), .en(en_continue2), .syncRst(~en_continue2),
    .counter(continue_f_counter2)
    );

always_comb begin
    en_stop1      = 0;
    en_continue1  = 0;
    counting_1    = counting_1; // or better: use counting_1_next


    {floors_triggered1, floors_triggered2} = FloorDestinations | FloorsRequested;

    half_floor1 = floor1 << 1; //multiply by 2 to get half floor representation
    half_floor2 = floor2 << 1; //multiply by 2 to get half

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

    

    //floor 1 movement/timer logic
    if (!counting_1) begin
        //counter states
        //at each state, call timer, and update half state
        if (half_floor1 != floor1 << 1) begin //if on a half floor
            en_continue1 = 1;
            en_stop1 = 0;
            counting_1 = 1;
            floor1 = direction1 ? floor1 + 1 : floor1 - 1;
        end else if (half_floor1 == floor1 << 1 && floors_triggered1[floor1]) begin //if on a whole floor and need to stop
            en_stop1 = 1;
            en_continue1 = 0;
            counting_1 = 1;
            half_floor1 = direction1 ? floor1 + 1 : floor1 - 1;
        end else if (half_floor1 == floor1 << 1 && !floors_triggered1[floor1]) begin  //if on a whole floor and do not need to stop
            en_continue1 = 1;
            en_stop1 = 0;
            counting_1 = 1;
            half_floor1 = direction1 ? floor1 + 1 : floor1 - 1;
        end

        //floor1 movement logic            
        
        if (top_floor1 == bottom_floor1) begin
            floor1 = floor1; //stay on the same floor
        end
        else if (top_floor1 == floor1 || bottom_floor1 == floor1) begin
            direction1 = ~direction1; 
            floor1 = direction1 ? floor1 + 1 : floor1 - 1;
        end
        else begin
            floor1 = direction1 ? floor1 + 1 : floor1 - 1;
        end

    end else if (stop_tick1) begin
        en_stop1 = 0;
        counting_1 = 0;
    end else if (continue_tick1) begin
        en_continue1 = 0;
        counting_1 = 0;
    end

    if (!counting_2) begin
        //counter states
        //at each state, call timer, and update half state
        if (half_floor2 != floor2 << 1) begin //if on a half floor
            en_continue2 = 1;
            en_stop2 = 0;
            counting_2 = 1;
            floor2 = direction2 ? floor2 + 1 : floor2 - 1;
        end else if (half_floor2 == floor2 << 1 && floors_triggered2[floor2]) begin //if on a whole floor and need to stop
            en_stop2 = 1;
            en_continue2 = 0;
            counting_2 = 1;
            half_floor2 = direction2 ? floor2 + 1 : floor2 - 1;
        end else if (half_floor2 == floor2 << 1 && !floors_triggered2[floor2]) begin  //if on a whole floor and do not need to stop
            en_continue2 = 1;
            en_stop2 = 0;
            counting_2 = 1;
            half_floor2 = direction2 ? floor2 + 1 : floor2 - 1;
        end


        //floor2 movement logic
        if (top_floor2 == bottom_floor2) begin
            floor2 = floor2; //stay on the same floor, pause elevator
        end
        else if (top_floor2 == floor2 || bottom_floor2 == floor2) begin
            direction2 = ~direction2; 
            floor2 = direction2 ? floor2 + 1 : floor2 - 1;
        end
        else begin
            floor2 = direction2 ? floor2 + 1 : floor2 - 1;
        end

    end else if (stop_tick2) begin
        en_stop2 = 0;
        counting_2 = 0;
    end else if (continue_tick2) begin
        en_continue2 = 0;
        counting_2 = 0;
    end

    new_elevatorPosition = {floor1, floor2};
    half_elevatorPositions = {half_floor1[3:0], half_floor2[3:0]};
end




always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        elevatorPosition <= 8'b0000_0000; //reset to ground floor
        floor1 <= 0;
        floor2 <= 0;
        direction1 <= 1'b1; //start by going up
        direction2 <= 1'b1; //start by going up
        half_elevatorPositions <= 8'b0000_0000;
        

    end else begin
        elevatorPosition <= new_elevatorPosition;
    end
end
    
endmodule
