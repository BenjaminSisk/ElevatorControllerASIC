`default_nettype none
module vgaController(
    input logic enable, reset,
    output logic hsync, vsync, drawn,
    output logic [3:0]R, [3:0]G, [3:0]B,
    output logic [9:0]x_coord, y_coord
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
    logic pixel_clk;
    pll_clkGen pll_u0 (.VGA_CLK(pixel_clk));

    // Counter values and enable 
    logic [9:0] horiz_count;
    logic [9:0] vert_count;
    logic enable;

    // Output RBG and sync values
    always_ff @(posedge pixel_clk, posedge reset) begin
        if (reset) begin
            horiz_count <= 0;
            vert_count <= 0;
            enable <= 0;
            hsync <= 1'b1;
            vsync <= 1'b1;
            R <= 4'b0000;
            G <= 4'b0000;
            B <= 4'b0000;
        end
    end

    // Horizontal logic
    always_comb begin
        
    end

    // Vertical logic
    always_comb begin

    end
    

endmodule