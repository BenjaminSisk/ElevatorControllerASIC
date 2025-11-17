module counterParametric #(parameter COUNT = 1, parameter WIDTH = 1) (
    input logic clk, rst,
    output logic [WIDTH-1:0] counter
);

    logic [WIDTH-1:0] counter_n;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            counter <= '0;
        end
        else begin
            counter <= counter_n;
        end
    end

    always_comb begin
        if(counter == COUNT) begin
            counter_n = 0;
        end else begin
            counter_n = counter + 1;
        end
    end
endmodule
