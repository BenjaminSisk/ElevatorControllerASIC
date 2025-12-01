module centralFSM
(
    input logic clk, rst,
    input logic [3:0] buttonBus,
    input logic pressed,
    output logic [1:0] simState, setting, //algorithm, we can add later if we want
    output logic [2:0] simSpeed, 
    output logic [5:0] people
);

    typedef enum logic [1:0] {
        START = 2'b0,
        SIM = 2'b1, 
        PAUSE = 2'b10,
        ENDING = 2'b11
    } STATE;

    typedef enum logic [1:0] {
        PEOPLE = 2'b0,
        ALGORITHM = 2'b1, 
        SIMSPEED = 2'b10,
        SETTINGINVALID = 2'b11
    } SETTING;

    typedef enum logic [3:0] {
        STOP = 4'hA,
        RESUME = 4'hB,
        UP = 4'hC,
        DOWN = 4'hD,
        ESCAPE = 4'hE,
        ENTER = 4'hF
    } BUTTON;

    STATE simState_n; 
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            simState <= START;
        end else begin
            simState <= simState_n;
        end
    end

    // Se simState state machine
    always_comb begin
        case (simState)
            START: simState_n = (buttonBus == RESUME) ? SIM : START;
            SIM: simState_n = (buttonBus == STOP) ? PAUSE : SIM;
            PAUSE: 
            begin
            if (buttonBus == RESUME) simState_n = SIM;
            else if (buttonBus == STOP) simState_n = ENDING;
            else simState_n = PAUSE; 
            end
            ENDING: simState_n = (buttonBus == RESUME) ? START : ENDING;
            default: simState_n = START;
        endcase
        
    end
    
    logic [9:0] buttonNumber;
    always_comb begin // We use priority encoder in synkey then a decoder in central fsm to only allow one button press at a time
        case(buttonBus) 
        //4'hF: buttonNumber = 10'b1000000000000000;
        //4'hE: buttonNumber = 10'b0100000000000000;
        //4'hD: buttonNumber = 10'b0010000000000000;
        //4'hC: buttonNumber = 10'b0001000000000000;
        //4'hB: buttonNumber = 10'b0000100000000000;
        //4'hA: buttonNumber = 10'b0000010000000000;
        4'h9: buttonNumber = 10'b1000000000;
        4'h8: buttonNumber = 10'b0100000000;
        4'h7: buttonNumber = 10'b0010000000;
        4'h6: buttonNumber = 10'b0001000000;
        4'h5: buttonNumber = 10'b0000100000;
        4'h4: buttonNumber = 10'b0000010000;
        4'h3: buttonNumber = 10'b0000001000;
        4'h2: buttonNumber = 10'b0000000100; 
        4'h1: buttonNumber = 10'b0000000010;
        4'h0: buttonNumber = 10'b0000000001;
        default: buttonNumber = 10'b0;
        endcase
        if (!pressed) begin
            buttonNumber = 10'b0;
        end
    end

    logic [5:0] number, number_n;
    always_ff@(posedge clk, posedge rst) begin
        if (rst) begin 
            number <= 0;
        end else begin
            number <= number_n;
        end
    end

    // This is used to determine the number stored in our number register (for selecting the value of a setting)
    always_comb begin
        if (buttonBus == ENTER | buttonBus == ESCAPE | !(simState == START)) begin
            number_n = 0;
        end else if (|buttonNumber[9:0]) begin
            number_n = number * 10 + {2'b0, buttonBus};
            number_n = (number > number_n) ? number: number_n;
        end else begin
            number_n = number;
        end
    end 

    logic [1:0] setting_n;
    always_ff@(posedge clk, posedge rst) begin
        if (rst) begin 
            setting <= 0;
        end else begin
            setting <= setting_n;
        end
    end

    // See setting state machine
    always_comb begin
        if (buttonBus == UP) begin
            case(setting)
            PEOPLE: setting_n = ALGORITHM;
            ALGORITHM: setting_n = SIMSPEED;
            SIMSPEED: setting_n = PEOPLE;
            SETTINGINVALID: setting_n = PEOPLE;
            endcase
        end else if (buttonBus == DOWN) begin
            case(setting)
            PEOPLE: setting_n = SIMSPEED;
            ALGORITHM: setting_n = PEOPLE;
            SIMSPEED: setting_n = ALGORITHM;
            SETTINGINVALID: setting_n = PEOPLE;
            endcase
        end else begin
            setting_n = (setting == SETTINGINVALID) ? PEOPLE : setting;
        end
    end

    logic [2:0] simSpeed_n;
    always_ff@(posedge clk, posedge rst)
    if (rst) begin 
        simSpeed <= 0;
    end else begin
        simSpeed <= simSpeed_n;
    end

    // This sets the simspeed if entered, can be 7 max
    always_comb begin
        simSpeed_n = simSpeed;
        if(buttonBus == ENTER && setting == SIMSPEED) begin 
            if (number < 7) begin
                simSpeed_n = number[2:0];
            end else begin
                simSpeed_n = 7;
            end
        end
    end

    logic [5:0] people_n;
    always_ff@(posedge clk, posedge rst) begin
        if (rst) begin 
            people <= 0;
        end else begin
            people <= people_n;
        end
    end

     // This sets the number of people if entered, can be 63 max
    always_comb begin
        people_n = people;
        if (buttonBus == ENTER && setting == PEOPLE) begin
            if (number < 63) begin
                people_n = number;
            end else begin
                people_n = 63;
            end
        end
    end

endmodule
