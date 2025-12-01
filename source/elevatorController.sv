module elevatorController
(
    input logic clk, rst, en,
    input logic [5:0] floors_triggered,
    output logic [3:0] floor,
    output logic direction
);


logic [5:0] stop_f_counter, continue_f_counter;
counterParametric #(.COUNT(5), .WIDTH(6)) stop_f1 (
    .clk(clk), .rst(rst), .en(en_stop), .syncRst(~en_stop),
    .counter(stop_f_counter)
    );

counterParametric #(.COUNT(60), .WIDTH(6)) continue_f1 (
    .clk(clk), .rst(rst), .en(en_continue), .syncRst(~en_continue),
    .counter(continue_f_counter)
    );

logic [3:0] top_floor, bottom_floor;
always_comb begin
        //priority encoder to get the left elevator top floor
    casez(floors_triggered) 
        6'b00_0001: top_floor = 0;
        6'b00_001?: top_floor = 1;
        6'b00_01??: top_floor = 2;
        6'b00_1???: top_floor= 3;
        6'b01_????: top_floor= 4;
        6'b1?_????: top_floor= 5;
        default: top_floor = 7; //no floors triggered
    endcase

    //priority encoder to get the right elevator bottom floor
    casez(floors_triggered)
        6'b00_0001: bottom_floor = 0;
        6'b00_001?: bottom_floor = 1; 
        6'b00_01??: bottom_floor = 2;
        6'b00_1???: bottom_floor = 3;
        6'b01_????: bottom_floor = 4;
        6'b1?_????: bottom_floor = 5;
        default: bottom_floor = 7; //no floors triggered
    endcase
end

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        en_stop <= 0;
        en_continue <= 1'b1;
        floor <= 0;
        direction <= 1'b1;
    end else begin
        en_stop <= en_stop_next;
        en_continue <= en_continue_next;
        floor <= floor_next;
        direction <= direction_next;
    end
end

logic en_stop, en_continue;
logic en_stop_next, en_continue_next, direction_next;
logic [3:0] floor_next;

always_comb begin
    //floor  movement/timer logic

    en_stop_next = en_stop;
    en_continue_next = en_continue;
    floor_next = floor; 
    direction_next = direction;

    if ((stop_f_counter == 5 || continue_f_counter == 60) && en) begin
        //counter states
        //at each state, call timer, and update half state
        if (floor[0] == 1) begin //if on a half floor
            en_continue_next = 1;
            en_stop_next = 0;
        end else if (floor[0] == 0 && floors_triggered[floor[3:1]]) begin //if on a whole floor and need to stop
            en_stop_next = 1;
            en_continue_next = 0;
        end else if (floor[0] == 0 && !floors_triggered[floor[3:1]]) begin  //if on a whole floor and do not need to stop
            en_continue_next = 1;
            en_stop_next = 0;
        end

        //floor movement logic        
        if (top_floor == floor) begin
            direction_next = ~direction; 
            floor_next = top_floor - 1;
        end else if (bottom_floor == floor) begin
            direction_next = ~direction; 
            floor_next = top_floor + 1;
        end else begin
            floor_next = direction ? floor + 1 : floor - 1;
        end
    end
end

endmodule
