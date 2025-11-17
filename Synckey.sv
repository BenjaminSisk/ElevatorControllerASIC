module Synckey
(
    input logic [3:0] row,
    output logic [3:0] buttonBus,
    output logic pressed
);


    counterParametric #(.COUNT(64), .WIDTH(6)) a
    (
        .clk(clk), .rst(rst), .counter(columnTimer)
    );

    always_comb begin

    end

endmodule