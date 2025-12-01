module peopleControllerEasy
(

    input logic [1:0] simState, simSpeed, 
    input logic [1:0] people,
    input logic [7:0] elevatorStates,
    input logic [9:0] randy,
    output logic [1:0] peopleGenerated,
    //output logic [23:0] colorFF,
    output logic [19:0] xposCFF,
    output logic [7:0] yposCFF,
    output logic [11:0] floorsRequested,
    output logic [11:0] floorDestinations
);

    typedef enum logic [1:0] {
        START = 2'b0,
        SIM = 2'b1, 
        PAUSE = 2'b10,
        ENDING = 2'b11
    } STATE;

    always_comb begin
        floorsRequested = 12'b0;
        floorDestinations = 12'b0;
        yposCFF = 8'b0;
        xposCFF = 20'b0;
        peopleGenerated = 2'd0;

        if (simState == SIM) begin
            peopleGenerated = 2'd2;
            xposCFF[9:0] = 160;
            xposCFF[19:10] = 480;
            yposCFF[3:0] = 0;
            yposCFF[7:4] = 10;
            floorsRequested[0] = 1;
            floorsRequested[5] = 1;
            floorsRequested[8] = 1;
            floorsRequested[9] = 1;
        end
    end


endmodule
