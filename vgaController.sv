`default_nettype none
module vgaController(
    input logic enable, reset,
    output logic hsync, vsync, drawn,
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

    // Counter values and local enable for the pixel generator
    logic [9:0] horiz_count;
    logic [9:0] vert_count;
    logic display_enable;

    // Output RBG and sync values
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
            counterParametric #(.COUNT(800), .WIDTH(10)) horiz_counter (.clk(pixel_clk), .rst(reset), .counter(horiz_count))
            begin
                if (horiz_count > horiz_back_porch + horiz_front_porch + horiz_pixel + horz_sync_pulse - 1) begin
                    counterParametric #(.COUNT(525), .WIDTH(10) vert_counter (.clk(pixel_clk), .rst(reset), .counter(vert_count)))
                end
            end
        end
    end

    // Horizontal logic
    always_comb begin
        if ((horiz_count >= horiz_pixel + horiz_front_porch) && (horiz_count < horiz_pixel + horiz_front_porch + horz_sync_pulse)) begin
            hsync = 1'b0;
        end
        else begin
            hsync = 1'b1;
        end
    end

    // Vertical logic
    always_comb begin
        if ((vert_count >= vert_pixel + vert_front_porch) && (vert_count < vert_pixel + vert_front_porch + vert_sync_pulse)) begin
            vsync = 1'b0;
        end
        else begin
            vsync = 1'b1;
        end
    end

    // Display logic
    always_comb begin
        if (enable && horiz_count < horiz_pixel && vert_count < vert_pixel) begin
            display_enable = 1'b1;
        end
        else begin
            display_enable = 1'b0
        end
    end




endmodule