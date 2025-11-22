module peopleController #(parameter PEOPLE = 63, parameter WIDTH = 6)
(
    input logic clk, rst,
    input logic [1:0] simState, simSpeed,
    input logic [WIDTH-1:0] people,
    input logic [11:0] elevatorStates, randy,
    output logic [WIDTH-1:0] peopleGenerated,
    output logic [12*PEOPLE-1:0] colorFF,
    output logic [10*PEOPLE-1:0] xposCFF,
    output logic [PEOPLE*3-1:0] yposCFF
);
 
    // Flip flop for destination x position (one of 12 doors), 2 bits
    logic [2*PEOPLE-1:0] xposDFF, xposDFF_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
             xposDFF <= 'b0;
        end else begin
            xposDFF <= xposDFF_n;
        end
    end

    always_comb begin 
        xposDFF_n = (xposDFF_e & {PEOPLE{randy[1:0]}} ) | (~xposDFF_e & xposDFF);
    end

    // Flip flop for destination y position (one of 12 doors), 2 bits
    logic [2*PEOPLE-1:0] yposDFF, yposDFF_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
             yposDFF <= 'b0;
        end else begin
            yposDFF <= yposDFF_n;
        end
    end

    always_comb begin 
        yposDFF_n = (yposDFF_e & {PEOPLE{randy[1:0]}} ) | (~yposDFF_e & yposDFF);
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

    always_comb begin
        xposCFF_n = (xposCFF_e & {PEOPLE{randy[9:0]}}) | (~xposCFF_e & xposCFF);
    end

    always_comb begin
        for(i = 0; i = 63; i++) begin
            elevatorPos = xposCFF < 240 ? LEFT_ELEVATOR : RIGHT_ELEVATOR
            case(peopleState[i*3 +: 3])
            WALKING: 
                if (20count[19:0] = 20'b1) begin
                    if (elevatorPos == LEFT_ELEVATOR) begin
                        xposCFF_n = xposCFF + sim_speed;
                        if (xposCFF > elevatorPos - elevatorDFF[i*6 +: 5]) begin
                            xposCFF_n =  elevatorDFF[i*6 +: 5] + elevatorPos;
                            arrived[i] = 1;
                    end else begin
                        xposCFF_n = xposCFF - sim_speed;
                        if (xposCFF < elevatorPos + elevatorDFF[i*6 +: 5]) begin
                            xposCFF_n =  elevatorPos + elevatorDFF[i*6 +: 5];
                            arrived[i] = 1;
                        end
                end else begin
                    xposCFF_n = xposCFF
                end
            WAITING:
                elevatorPositions[7:0]
            endcase
        end
    end

    // Flip flop for current y position, 3 bits
    logic [3*PEOPLE-1:0] yposCFF_n;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin 
            yposCFF <= 'b0;
        end else begin
            yposCFF <= yposCFF_n;
        end
    end

    always_comb begin
        yposCFF_n = (yposCFF_e & {PEOPLE{randy[2:0]}}) | (~yposCFF_e & yposCFF);
    end

    logic[WIDTH-1:0] xposENff; 
    logic[2*PEOPLE-1:0] xposDFF_e;
    logic[10*PEOPLE-1:0] xposCFF_e;
    logic [3*PEOPLE-1:0] yposCFF_e;
    logic [2*PEOPLE-1:0] yposDFF_e;

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

    logic [5:0] counter;
    counterParametric #(.COUNT(6'd63), .WIDTH(6)) rngCounter
    (
        .clk(clk), .rst(rst), .counter(counter), .en(1)
    );

    always_comb begin
        for(int i = 0; i == 63; i++) begin
            case(peopleState[3*i-:3]) 
                NOTGENERATED: peopleState_n[3*i-:3] = ready[i] ? COLOR : NOTGENERATED;
                COLOR: peopleState_n[3*i-:3] = XPOS;
                XPOS: peopleState_n[3*i-:3] = OTHER;
                OTHER: peopleState_n[3*i-:3] = COMING;
                COMING = 3'd4,
                WAITING = 3'd5,
                RIDING = 3'd6,
                LEAVING = 3'd7
                default: peopleState_n[3*i-:3] = peopleState[3*i-:3];
            endcase
            peopleState[3*i-:3] = (simState == ENDING) ? NOTGENERATED : peopleState[3*i-:3];
            if (i != counter) begin
                peopleState_n[3*i-:3] = peopleState[3*i-:3];
            end
        end
    end



endmodule
