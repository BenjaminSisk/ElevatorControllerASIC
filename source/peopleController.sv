module peopleController #(parameter PEOPLE = 63, parameter WIDTH = 6)
(
    input logic clk, rst,
    input logic [1:0] simState,
    input logic [2:0] simSpeed, 
    input logic [WIDTH-1:0] people,
    input logic [7:0] elevatorStates,
    input logic [9:0] randy,
    output logic [WIDTH-1:0] peopleGenerated,
    //output logic [12*PEOPLE-1:0] colorFF,
    output logic [10*PEOPLE-1:0] xposCFF,
    output logic [PEOPLE*4-1:0] yposCFF,
    output logic [11:0] floorsRequested,
    output logic [11:0] floorDestinations
);

/*
    peopleController #(.PEOPLE(7), .WIDTH(6)) a ( .clk(clk), .rst(rst), .simState(simState), .simSpeed(simSpeed), .people(people), .elevatorStates(8'b1), .randy(10'b1), .peopleGenerated(peopleGenerated),
    .xposCFF(xposCFF), .yposCFF(yposCFF), .floorsRequested(floorsRequested), .floorDestinations(floorDestinations));
*/

    localparam LEFT_ELEVATOR = 1'b0;
    localparam RIGHT_ELEVATOR = 1'b1;
 
    // Flip flop for destination x position (one of 12 doors), 1 bit
    logic [PEOPLE-1:0] xposDFF, xposDFF_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            xposDFF <= 'b0;
        end else begin
            xposDFF <= xposDFF_n;
        end
    end

    always_comb begin 
        xposDFF_n = (xposDFF_e & {PEOPLE{randy[0]}} ) | (~xposDFF_e & xposDFF);
    end

    // Flip flop for destination y position (one of 12 doors), 3 bits
    logic [3*PEOPLE-1:0] yposDFF, yposDFF_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
             yposDFF <= 'b0;
        end else begin
            yposDFF <= yposDFF_n;
        end
    end

    always_comb begin 
        yposDFF_n = (yposDFF_e & {PEOPLE{randy[3:1]}} ) | (~yposDFF_e & yposDFF);
    end

    // Flip flop for current x position, 10 bits
    logic [10*PEOPLE-1:0] xposCFF_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            xposCFF <= 'b0;
        end else begin
            xposCFF <= xposCFF_n;
        end
    end

    logic [19:0] twentyCount;
    // May need to change enable
    counterParametric #(.COUNT(1048575), .WIDTH(20)) twenty (.clk(clk), .rst(rst), .en(1'b1), .counter(twentyCount), .syncRst(1'b0));

    logic [PEOPLE-1:0] elevatorPos;
    logic [PEOPLE-1:0] arrived;
    logic [PEOPLE-1:0] ride;
    logic [10*PEOPLE-1:0] pos;

    // This is all of the logic for horizontal movement 
    always_comb begin
        arrived = 'b0;
        ride = 'b0;
        pos = 'b0;
        foundDestination = 'b0;
        floorsRequested = 12'b0;
        xposCFF_n = 'b0;
        for(int i = 0; i == PEOPLE-1; i++) begin
            elevatorPos[i] = xposCFF < 320 ? LEFT_ELEVATOR : RIGHT_ELEVATOR;
            case(peopleState[i*3 +: 3])
                COMING: 
                    if (twentyCount == 20'b1) begin
                        if (elevatorPos[i] == LEFT_ELEVATOR) begin
                            xposCFF_n[i*10 +: 10] = xposCFF[i*10 +: 10] + {7'd0, simSpeed};
                            if (xposCFF[i*10 +: 10] > 300) begin // - elevatorDFF[i*6 +: 5]
                                xposCFF_n[i*10 +: 10] = 300; // - elevatorDFF[i*6 +: 5]
                                arrived[i] = 1;
                            end
                        end else begin
                            xposCFF_n[i*10 +: 10] = xposCFF[i*10 +: 10] - {7'd0, simSpeed};
                            if (xposCFF_n[i*10 +: 10] < 340) begin // + elevatorDFF[i*6 +: 5]
                                xposCFF_n[i*10 +: 10] = 340; //  + elevatorDFF[i*6 +: 5]
                                arrived[i] = 1;
                            end
                        end
                    end else begin
                        xposCFF_n[i*10 +: 10] = xposCFF[i*10 +: 10];
                    end
                WAITING:
                begin
                    if (xposCFF < 320) begin
                        case(yposCFF[i*3 +: 3])
                            3'd0: 
                                if (elevatorStates[2:0] == 3'd0) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[0] = 1;
                                end
                            3'd1: 
                            begin
                                if (elevatorStates[2:0] == 3'd1) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[1] = 1;
                                end
                            end
                            3'd2:
                                if (elevatorStates[2:0] == 3'd2) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[2] = 1;
                                end
                            3'd3: 
                                if (elevatorStates[2:0] == 3'd3) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[3] = 1;
                                end
                            3'd4: 
                                if (elevatorStates[2:0] == 3'd4) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[4] = 1;
                                end
                            3'd5: 
                                if (elevatorStates[2:0] == 3'd5) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[5] = 1;
                                end
                            default: begin end
                        endcase
                    end else begin
                        case(yposCFF[i*3 +: 3])
                        3'd0: 
                                if (elevatorStates[5:3] == 3'd0) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[6] = 1;
                                end
                            3'd1: 
                            begin
                                if (elevatorStates[5:3] == 3'd1) begin
                                    ride[i] = 1;
                                    floorsRequested[7] = 1;
                                end
                            end
                            3'd2:
                                if (elevatorStates[5:3] == 3'd2) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[8] = 1;
                                end
                            3'd3: 
                                if (elevatorStates[5:3] == 3'd3) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[9] = 1;
                                end
                            3'd4: 
                                if (elevatorStates[5:3] == 3'd4) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[10] = 1;
                                end
                            3'd5: 
                                if (elevatorStates[5:3] == 3'd5) begin
                                    ride[i] = 1;
                                end else begin
                                    floorsRequested[11] = 1;
                                end
                            default: begin end
                    endcase
                end
            end
            RIDING: xposCFF_n = xposCFF; 
            LEAVING: 
            begin
                pos[i*10+:10] = xposDFF[i] ? 10'd45 : 10'd595;
                if (twentyCount == 20'b1) begin
                    if (xposCFF[i*10 +: 10] < pos[i*10+:10]) begin
                        xposCFF_n[i*10 +: 10] = xposCFF[i*10 +: 10] + {7'd0, simSpeed};
                        if (xposCFF_n[i*10 +: 10] > pos[i*10+:10]) begin 
                            xposCFF_n[i*10 +: 10] = pos[i*10+:10]; 
                            foundDestination[i] = 1;
                        end
                    end else begin
                        xposCFF_n[i*10 +: 10] = xposCFF[i*10 +: 10] - {7'd0, simSpeed};
                        if (xposCFF_n[i*10 +: 10] < pos[i*10+:10] ) begin 
                            xposCFF_n[i*10 +: 10] = pos[i*10+:10] ; 
                            foundDestination[i] = 1;
                        end
                    end
                end else begin
                    xposCFF_n[i*10 +: 10] = xposCFF[i*10 +: 10];
                end
            end
            XPOS: xposCFF_n[i*10 +: 10] = randy[9:0];
            default: begin end
            endcase
        end
    end

    // Flip flop for current y position, 4 bits
    logic [4*PEOPLE-1:0] yposCFF_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin 
            yposCFF <= 'b0;
        end else begin
            yposCFF <= yposCFF_n;
        end
    end

    logic [PEOPLE-1:0] dropoff;
    always_comb begin
        floorDestinations = 12'b0;
        dropoff = 'b0;
        yposCFF_n = 'b0;
        for(int i = 0; i == PEOPLE-1; i++) begin
            case(peopleState[i*3 +: 3]) 
                RIDING: 
                begin
                    if (xposCFF[i*10 +: 10] < 320) begin
                        yposCFF_n[i*4 +: 4] = elevatorStates[3:0];
                        floorDestinations[yposCFF_n[i*4 +: 4] << 1] = 1;
                    end else begin 
                        yposCFF_n[i*4 +: 4] = elevatorStates[7:4];
                        floorDestinations[yposCFF_n[i*4 +: 4] << 1 +6] = 1;
                    end
                    if(yposCFF_n[i*4 +: 4] == {yposDFF[i*3 +:3], 1'b0}) begin
                        dropoff[i] = 1; 
                    end
                end
                OTHER: yposCFF_n[i*4 +: 4] = yposCFF_e[i] ? {randy[6:4], 1'b0} : yposCFF[i*4 +: 4];
                default: yposCFF_n = yposCFF;
            endcase
        end
    end

    logic[PEOPLE-1:0] xposDFF_e;
    logic [PEOPLE-1:0] yposCFF_e;
    logic [3*PEOPLE-1:0] yposDFF_e;

    // Flip flop for the state of the person, 3 bits
    typedef enum logic [2:0] {
        NOTGENERATED = 3'd0,
        COLOR = 3'd1, 
        XPOS = 3'd2,
        OTHER = 3'd3,
        COMING = 3'd4,
        WAITING = 3'd5,
        RIDING = 3'd6,
        LEAVING = 3'd7
    } PEOPLESTATE;

    logic [2*PEOPLE-1:0] peopleState, peopleState_n;
    always_ff@(posedge clk, posedge rst) begin
        if (rst) begin
            peopleState <= 'b0;
        end else begin
            peopleState <= peopleState_n;
        end
    end

    logic [7:0] counter;

    counterParametric #(.COUNT('d255), .WIDTH(8)) rngCounter
    (
        .clk(clk), .rst(rst), .counter(counter), .en(1), .syncRst(1'b0)
    );

    typedef enum logic [1:0] {
        START = 2'b0,
        SIM = 2'b1, 
        PAUSE = 2'b10,
        ENDING = 2'b11
    } STATE;

    logic [PEOPLE-1:0] foundDestination;
    logic [62:0] index;
    always_comb begin
        index[counter[7:2]] = 1;
        peopleGenerated = 63'b0;
        for(int i = 0; i == PEOPLE-1; i++) begin
            case(peopleState[3*i-:3]) 
                NOTGENERATED: peopleState_n[3*i-:3] = index[i] && people[i] ? COLOR : NOTGENERATED;
                COLOR: peopleState_n[3*i-:3] = XPOS;
                XPOS: begin
                    peopleState_n[3*i-:3] = OTHER;
                    xposDFF_e[i] = 1;
                end
                OTHER: 
                begin
                    peopleState_n[3*i-:3] = COMING;
                    yposDFF_e[3*i+:3] = 1;
                    yposCFF_e[i] = 1;
                end
                COMING: peopleState_n[3*i-:3] = arrived[i] ? WAITING : COMING;
                WAITING: peopleState_n[3*i-:3] = ride[i] ? RIDING: WAITING;
                RIDING: peopleState_n[3*i-:3] = dropoff[i] ? LEAVING: RIDING;
                LEAVING: peopleState_n[3*i-:3] = foundDestination[i] ? NOTGENERATED : LEAVING;
                default: peopleState_n[3*i-:3] = peopleState[3*i-:3];
            endcase
            if (peopleState[3*i-:3] > 3) begin
                peopleGenerated[i] = 1;
            end
            peopleState_n[3*i-:3] = (simState != ENDING) ? NOTGENERATED : peopleState_n[3*i-:3];
            if (!index[counter[7:2]]) begin
                peopleState_n[3*i-:3] = peopleState[3*i-:3];
            end
        end
    end

endmodule
