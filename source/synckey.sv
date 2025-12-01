module synckey
(
    input logic clk, rst,
    input logic [3:0] row,
    output logic [3:0] buttonBus,
    output logic pressed,
    output logic [3:0] columns
);

    logic [5:0] columnTimer; //bits 0-3 previously unused
    logic [1:0] columnDemux;
    logic [15:0] encoderIn;


    counterParametric #(.COUNT(6'd63), .WIDTH(6)) a
    (
        .clk(clk), .rst(rst), .counter(columnTimer), .en(1)
    );

    // For 16 clock cycles, the button matrix will search for a positive edge for a column, then switch
    // to a different column (may need to be increased significantly)
    always_comb begin
        columnDemux = columnTimer[5:4];
        case(columnDemux)
            0: columns = 4'b0001;
            1: columns = 4'b0010;
            2: columns = 4'b0100;
            3: columns = 4'b1000;
            default: columns = 4'b1111;
        endcase
    end
    //each debouncer module is enabled when its column is selected (3-0)
    debouncing d0
    (
        .clk(clk), .rst(rst), .en(columnDemux[0] && columnDemux[1]), .row(row), .buttonMux(encoderIn[3:0])
    );
    debouncing d1
    (
        .clk(clk), .rst(rst), .en(columnDemux[0] && !columnDemux[1]), .row(row), .buttonMux(encoderIn[7:4])
    );
    debouncing d2
    (
        .clk(clk), .rst(rst), .en(!columnDemux[0] && columnDemux[1]), .row(row), .buttonMux(encoderIn[11:8])
    );
    debouncing d3
    (
        .clk(clk), .rst(rst), .en(!columnDemux[0] && !columnDemux[1]), .row(row), .buttonMux(encoderIn[15:12])
    );

    always_comb begin
        casez(encoderIn)
        16'b1???????????????: buttonBus = 4'hF;
        16'b01??????????????: buttonBus = 4'hE;
        16'b001?????????????: buttonBus = 4'hD;
        16'b0001????????????: buttonBus = 4'hC;
        16'b00001???????????: buttonBus = 4'hB;
        16'b000001??????????: buttonBus = 4'hA;
        16'b0000001?????????: buttonBus = 4'h9;
        16'b00000001????????: buttonBus = 4'h8;
        16'b000000001???????: buttonBus = 4'h7;
        16'b0000000001??????: buttonBus = 4'h6;
        16'b00000000001?????: buttonBus = 4'h5;
        16'b000000000001????: buttonBus = 4'h4;
        16'b0000000000001???: buttonBus = 4'h3;
        16'b00000000000001??: buttonBus = 4'h2;
        16'b000000000000001?: buttonBus = 4'h1;
        16'b0000000000000001: buttonBus = 4'h0;
        default: buttonBus = 4'h0;
        endcase
        if (encoderIn == 16'b0) begin
            pressed = 1'b1;
        end else begin
            pressed = 1'b0;
        end
    end

endmodule
