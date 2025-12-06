`timescale 1ns/1ps

module centralFSM_tb;

    logic clk, rst;
    logic [3:0] buttonBus;
    logic pressed;

    logic [1:0] simState, setting;
    logic [2:0] simSpeed;
    logic [5:0] people;
    //instantiation of source file
    centralFSM DUT(
        .clk(clk),
        .rst(rst),
        .buttonBus(buttonBus),
        .pressed(pressed),
        .simState(simState),
        .setting(setting),
        .simSpeed(simSpeed),
        .people(people)
    );

    initial clk = 0;
    //clock period is 10ns
    always #5 clk = ~clk;

    //task for pressing the button
    task press_button(input [3:0] b);
        begin
            buttonBus = b;
            pressed = 1;
            #20;
            pressed = 0;
            buttonBus = 0;
            #20;
        end
    endtask

    //states
    localparam STOP    = 4'hA;
    localparam RESUME  = 4'hB;
    localparam UP      = 4'hC;
    localparam DOWN    = 4'hD;
    localparam ESCAPE  = 4'hE;
    localparam ENTER   = 4'hF;

    
    task press_numeric(input int num);
        begin
            press_button(num[3:0]);
        end
    endtask

    task setting_force_people();
        begin
            while (setting != 0)
                press_button(DOWN);
        end
    endtask

    initial begin
        $dumpfile("centralFSM_tb.vcd");
        $dumpvars(0, centralFSM_tb);

        rst = 1;
        buttonBus = 0;
        pressed = 0;

        #30 rst = 0;
        #20;

        press_button(RESUME);
        #20;
        press_button(STOP);
        #20;
        press_button(RESUME);
        #20;
        press_button(STOP);
        #20;
        press_button(STOP);
        #20;
        press_button(RESUME);
        #20;

        press_button(UP);
        press_button(UP);
        press_button(UP);

        setting_force_people();
        press_numeric(4);
        press_numeric(5);
        press_button(ENTER);

        press_button(UP);
        press_button(UP);

        press_numeric(9);
        press_button(ENTER);

        #40;
        $finish;
    end

endmodule
