`default_nettype none
module vgaController(
    input logic enable, reset,
    output logic hsync, vsync,
    output logic [3:0]R, [3:0]G, [3:0]B
);
    // VGA timing specifications
    localparam horiz_pixel = 640;
    localparam vert_pixel = 480;
    localparam horiz_front_porch = 16;
    localparam vert_front_porch = 10;
    localparam horz_sync_pulse = 96;
    localparam vert_sync_pulse = 2;
    localparam horiz_back_porch = 48;
    localparam vert_back_porch = 33;

    // PLL Instantiation
    pixel_clk
    pll_clkGen u0 (.VGA_CLK(pixel_clk));

    // Counter values
    logic curr_horiz;
    logic curr_vert;

    // Flip-flop block
    always_ff @(posedge pixel_clk, posedge reset) begin
        if (reset) begin
            
        end
    end

endmodule