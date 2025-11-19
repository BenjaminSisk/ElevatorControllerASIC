module centralFSM
(
    input logic clk, rst,
    input logic [3:0] buttonBus,
    input logic pressed,
    output logic [1:0] simState, setting, //algorithm,
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
    
    logic [15:0] buttons;
    always_comb begin // We use priority encoder in synkey then a decoder in central fsm to only allow one button press at a time
        case(buttonBus) 
        4'hF: buttons = 16'b1000000000000000;
        4'hE: buttons = 16'b0100000000000000;
        4'hD: buttons = 16'b0010000000000000;
        4'hC: buttons = 16'b0001000000000000;
        4'hB: buttons = 16'b0000100000000000;
        4'hA: buttons = 16'b0000010000000000;
        4'h9: buttons = 16'b0000001000000000;
        4'h8: buttons = 16'b0000000100000000;
        4'h7: buttons = 16'b0000000010000000;
        4'h6: buttons = 16'b0000000001000000;
        4'h5: buttons = 16'b0000000000100000;
        4'h4: buttons = 16'b0000000000010000;
        4'h3: buttons = 16'b0000000000001000;
        4'h2: buttons = 16'b0000000000000100; 
        4'h1: buttons = 16'b0000000000000010;
        4'h0: buttons = 16'b0000000000000001;
        endcase
        if (!pressed) begin
            buttons = 16'b0;
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

    always_comb begin
        if (buttonBus == ENTER | buttonBus == ESCAPE | !(simState == START)) begin
            number_n = 0;
        end else if (|buttons[9:0]) begin
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