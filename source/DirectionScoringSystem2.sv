`default_nettype none
module DirectionScoringSystem2(
    input logic clk, rst,
    input logic [11:0] FloorDestinations, //floors 0-5 represent left elevator, floors 6-11 represent right elevator
    input logic [11:0] FloorsRequested,
    output logic [7:0] half_elevatorPositions //4 bits for left elevator, 4 bits for right elevator
    output logic [1:0] directions // MSB == right
);

    assign half_elevatorPositions = {floor1, floor2};

    logic [5:0] floors_triggered1, floors_triggered2;
    always_comb begin
      {floors_triggered1, floors_triggered2} = FloorDestinations | FloorsRequested;
    end

    logic [2:0] top_floor1, top_floor2, bottom_floor1, bottom_floor2;

    always_comb begin
    //priority encoder to get the left elevator top floor
    casez(floors_triggered1) 
        6'b00_0001: top_floor1 = 0;
        6'b00_001?: top_floor1 = 1;
        6'b00_01??: top_floor1 = 2;
        6'b00_1???: top_floor1 = 3;
        6'b01_????: top_floor1 = 4;
        6'b1?_????: top_floor1 = 5;
        default: top_floor1 = 7; //no floors triggered
    endcase

        //priority encoder to get the left elevator top floor
    casez(floors_triggered2) 
        6'b00_0001: top_floor2 = 0;
        6'b00_001?: top_floor2 = 1;
        6'b00_01??: top_floor2 = 2;
        6'b00_1???: top_floor2= 3;
        6'b01_????: top_floor2= 4;
        6'b1?_????: top_floor2= 5;
        default: top_floor2 = 7; //no floors triggered
    endcase
    
    //priority encoder to get the left elevator bottom floor
    casez(floors_triggered1)
        6'b00_0001: bottom_floor1 = 0;
        6'b00_001?: bottom_floor1 = 1; 
        6'b00_01??: bottom_floor1 = 2;
        6'b00_1???: bottom_floor1 = 3;
        6'b01_????: bottom_floor1 = 4;
        6'b1?_????: bottom_floor1 = 5;
        default: bottom_floor1 = 7; //no floors triggered
    endcase

    //priority encoder to get the right elevator bottom floor
    casez(floors_triggered2)
        6'b00_0001: bottom_floor2 = 0;
        6'b00_001?: bottom_floor2 = 1; 
        6'b00_01??: bottom_floor2 = 2;
        6'b00_1???: bottom_floor2 = 3;
        6'b01_????: bottom_floor2 = 4;
        6'b1?_????: bottom_floor2 = 5;
        default: bottom_floor2 = 7; //no floors triggered
    endcase
end

logic stop_f_counter1, continue_f_counter1;
counterParametric #(.COUNT(1), .WIDTH(5)) stop_f1 (
    .clk(clk), .rst(rst), .en(en_stop1), .syncRst(~en_stop1),
    .counter(stop_f_counter1)
    );

counterParametric #(.COUNT(60), .WIDTH(5)) continue_f1 (
    .clk(clk), .rst(rst), .en(en_continue1), .syncRst(~en_continue1),
    .counter(continue_f_counter1)
    );


always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        en_stop1 <= 0;
        en_continue1 <= 1'b1;
        floor1 <= 0;
        direction1 <= 1'b1;
    end else begin
        en_stop1 <= en_stop1_next;
        en_continue1 <= en_continue1_next;
        floor1 <= floor1_next;
        direction1 <= direction1_next;
    end
end

logic en_stop1, en_continue1, direction1;
logic en_stop1_next, en_continue1_next, direction1_next;
logic [3:0] floor1, floor1_next;

always_comb begin
    //floor 1 movement/timer logic

    en_stop1_next = en_stop1;
    en_continue1_next = en_continue1;
    floor1_next = floor1; 
    direction1_next = direction1;

    if (!stop_f_counter1 == 5 || continue_f_counter1 == 60) begin
        //counter states
        //at each state, call timer, and update half state
        if (floor1[0] == 1) begin //if on a half floor
            en_continue1_next = 1;
            en_stop1_next = 0;
        end else if (floor1[0] == 0 && floors_triggered1[floor1]) begin //if on a whole floor and need to stop
            en_stop1_next = 1;
            en_continue1_next = 0;
        end else if (floor1[0] == 0 && !floors_triggered1[floor1]) begin  //if on a whole floor and do not need to stop
            en_continue1_next = 1;
            en_stop1_next = 0;
        end

        //floor1 movement logic        
        if (top_floor1 == floor1) begin
            direction1_next = ~direction1; 
            floor1_next = top_floor1 - 1;
        end else if (bottom_floor1 == floor1) begin
            direction1_next = ~direction1; 
            floor1_next = top_floor1 + 1;
        end else begin
            floor1_next = direction1 ? floor1 + 1 : floor1 - 1;
        end
    end
end


always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        en_stop2 <= 0;
        en_continue2 <= 1'b1;
        floor2 <= 0;
        direction2 <= 1'b1;
    end else begin
        en_stop2 <= en_stop2_next;
        en_continue2 <= en_continue2_next;
        floor2 <= floor2_next;
        direction2 <= direction2_next;
    end
end

logic en_stop2, en_continue2, direction2;
logic en_stop2_next, en_continue2_next, direction2_next;
logic [3:0] floor2, floor2_next;

always_comb begin
    //floor 2 movement/timer logic

    en_stop2_next = en_stop2;
    en_continue2_next = en_continue2;
    floor2_next = floor2; 
    direction2_next = direction2;

    if (!stop_f_counter2 == 5 || continue_f_counter2 == 60) begin
        //counter states
        //at each state, call timer, and update half state
        if (floor2[0] == 1) begin //if on a half floor
            en_continue2_next = 1;
            en_stop2_next = 0;
        end else if (floor2[0] == 0 && floors_triggered2[floor2]) begin //if on a whole floor and need to stop
            en_stop2_next = 1;
            en_continue2_next = 0;
        end else if (floor2[0] == 0 && !floors_triggered2[floor2]) begin  //if on a whole floor and do not need to stop
            en_continue2_next = 1;
            en_stop2_next = 0;
        end

        //floor2 movement logic        
        if (top_floor2 == floor2) begin
            direction2_next = ~direction2; 
            floor2_next = top_floor2 - 1;
        end else if (bottom_floor2 == floor2) begin
            direction2_next = ~direction2; 
            floor2_next = top_floor2 + 1;
        end else begin
            floor2_next = direction2 ? floor2 + 1 : floor2 - 1;
        end
    end
end

endmodule
