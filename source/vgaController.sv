`default_nettype none
module vgaController(
    input logic reset,
    input logic [7:0]destination,
    //input logic [25:0]people_data,
    input logic [1:0]sim_state,
    output logic hsync, vsync,
    output logic [9:0]horiz_count, vert_count,
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
    logic pixel_clk;
    pll_clkGen pll_u0 (.VGA_CLK(pixel_clk));

    // Counter values and local enable for the pixel generator
    logic [9:0] next_horiz_count;
    logic [9:0] next_vert_count;
    logic enable;

    // Counter values
    always_ff @(posedge pixel_clk, posedge reset) begin
        if (reset) begin
            horiz_count <= 0;
            vert_count <= 0;
            enable <= 0;
            // Hsync and Vsync are active low signals
            hsync <= 1'b1;
            vsync <= 1'b1;
        end
        else begin
            horiz_count <= next_horiz_count;
            vert_count <= next_vert_count;
        end
    end

    // Horizontal logic
    always_comb begin
        // Counter logic
        if (horiz_count < horiz_pixel) begin
            next_horiz_count = next_horiz_count + 1;
        end
        else begin 
            next_horiz_count = 0;
        end

        // Sync signal logic
        if ((horiz_count > horiz_pixel + horiz_front_porch) && (horiz_count < horiz_pixel + horiz_front_porch + horz_sync_pulse)) begin
            hsync = 1'b0;
        end
        else begin
            hsync = 1'b1;
        end
    end

    // Vertical logic
    always_comb begin 
        // Counter logic
        if ((horiz_count == 0) && (vert_count < vert_pixel + vert_back_porch + vert_front_porch + vert_sync_pulse)) begin
            next_vert_count = next_vert_count + 1;
        end
        else begin
            next_vert_count = 0;
        end

        // Sync signal logic
        if ((vert_count > vert_pixel + vert_front_porch) && (vert_count < vert_pixel + vert_front_porch + vert_sync_pulse)) begin
            vsync = 1'b0;
        end
        else begin
            vsync = 1'b1;
        end
    end

    // Display logic
    always_comb begin
        if (horiz_count < horiz_pixel && vert_count < vert_pixel) begin
            enable = 1'b1;
        end
        else begin
            enable = 1'b0;
        end
    end

    // RGB Output and pixel generation
    pixel_gen pixelu0 (.enable(enable), .sim_state(sim_state), .x_coord(horiz_count), .y_coord(vert_count), .destination(destination), .R(R), .B(B), .G(G), .people_data(people_data));

endmodule
