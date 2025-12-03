`default_nettype none
module button_test(
    input  logic btn1,
    input  logic btn2,
    input  logic btn3,
    input  logic btn4,
    output logic led
);

    always_comb begin
        // LED turns on when *any* button is pressed
        led = btn1 | btn2 | btn3 | btn4;
    end

endmodule
