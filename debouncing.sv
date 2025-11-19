module debouncing (
input logic clk, rst,
input logic en,
input logic [3:0] row, 
output logic [3:0] buttonMux
);

logic [3:0] newRow, newRow_n, oldRow, oldRow_n, oldestRow, oldestRow_n;
logic [1:0] columnDebounce;
always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        newRow <= 4'b0;
    end else begin
        newRow <= newRow_n;
    end
end

always_comb begin 
    if (en) begin 
        newRow_n = row;
    end else begin
        newRow_n = 0;
    end
end

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        oldRow <= 4'b0;
    end else begin
        oldRow <= oldRow_n;
    end
end

always_comb begin 
    if (en) begin 
        oldRow_n = row;
    end else begin
        oldRow_n = 0;
    end
end

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        oldestRow <= 4'b0;
    end else begin
        oldestRow <= oldestRow_n;
    end
end

always_comb begin
    if (columnDebounce == 2 && en) begin 
        oldestRow_n = oldRow;
    end else begin
        oldestRow_n = 0;
    end
end

assign buttonMux =(~oldestRow & oldRow);

endmodule