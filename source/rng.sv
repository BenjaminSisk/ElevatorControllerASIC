module rng 
(
    input logic clk, rst,
    output logic [11:0] randy
);

    logic [11:0] memory [0:255]; // 256 lines, 12 bits each
    initial begin 
        $readmemh("press.mem", memory); // This is totally stolen from STARS
    end

    logic [7:0] pointer;
    counterParametric #(.COUNT(8'd255), .WIDTH(8)) rngCounter
    (
        .clk(clk), .rst(rst), .counter(pointer), .en(1)
    );

    always_comb begin
        randy = memory[pointer];
    end

endmodule
