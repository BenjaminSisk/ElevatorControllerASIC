`default_nettype none
module pixel_gen (
    input logic enable,
    input logic [1:0]sim_state,
    input logic [25:0]people_data,
    input logic [9:0]x_coord, [9:0]y_coord,
    output logic [3:0]R, [3:0]G, [3:0]B,
);

    localparam max_horiz = 640;
    localparam max_vert = 480;
    localparam side_buffer = 20;
    localparam top_bottom_buffer = 15;
    localparam floor_width = 75;
    localparam building_width = 200;
    localparam outline_width = 10;

    always_comb begin
        if (enable) begin
            // Always draw the static elements of the screen
            // Side sky
            if ((x_coord >= 0 && x_coord < side_buffer) || (x_coord >= max_horiz - side_buffer && x_coord < max_horiz) && (y_coord < max_vert - top_bottom_buffer)) begin
                R = 2;
                G = 15;
                B = 8;
            end

            // Top sky
            else if (y_coord < top_bottom_buffer) begin
                R = 2;
                G = 15;
                B = 8;
            end

            // Left side of the building (left side of elevator shafts)
            else if (x_coord >= side_buffer && x_coord < side_buffer + building_width - outline_width) begin
                // 6th Floor
                if ((y_coord >= top_bottom_buffer) && (y_coord < top_bottom_buffer + floor_width)) begin
                    R = 9;
                    G = 10;
                    B = 10;
                end
                
                // 5th Floor
                else if ((y_coord >= top_bottom_buffer + floor_width) && (y_coord < top_bottom_buffer + 2 * floor_width)) begin
                    R = 11;
                    G = 11;
                    B = 11;
                end

                // 4th Floor
                else if ((y_coord >= top_bottom_buffer + 2 * floor_width) && (y_coord < top_bottom_buffer + 3 * floor_width)) begin
                    R = 9;
                    G = 10;
                    B = 10;
                end

                // 3rd Floor
                else if ((y_coord >= top_bottom_buffer + 3 * floor_width) && (y_coord < top_bottom_buffer + 4 * floor_width)) begin
                    R = 11;
                    G = 11;
                    B = 11;
                end

                // 2nd Floor
                else if ((y_coord >= top_bottom_buffer + 4 * floor_width) && (y_coord < top_bottom_buffer + 5 * floor_width)) begin
                    R = 9;
                    G = 10;
                    B = 10;
                end

                // 1st Floor
                else begin
                    R = 11;
                    G = 11;
                    B = 11;
                end
            end

            // Left outline
            else if (x_coord >= 195 && x_coord < 205 && y_coord >= top_bottom_buffer & y_coord < max_vert - top_bottom_buffer) begin
                R = 0;
                G = 0;
                B = 0;
            end

            // Left elevator shaft
            else if (x_coord >= 205 && x_coord < 295 && y_coord >= top_bottom_buffer && y < max_vert - top_bottom_buffer) begin
                R = 8;
                G = 4;
                B = 1;
            end

            // Middle outline
            else if (x_coord >= 295 && x_coord< 305 && y_coord >= top_bottom_buffer && y_coord < max_vert - top_bottom_buffer) begin
                R = 0;
                G = 0;
                B = 0;
            end

            // Right elevator shaft
            else if (x_coord >= 305 && x_coord < 395 && y_coord >= top_bottom_buffer && y_coord < max_vert - top_bottom_buffer) begin
                R = 8;
                G = 4;
                B = 1;
            end

            // Right outline
            else if (x_coord >= 395 && x_coord < 405 && y_coord >= top_bottom_buffer && y < max_vert - top_bottom_buffer) begin
                R = 0;
                G = 0;
                B = 0; 
            end

            // Right building
            else if (x_coord >= 405 && x_coord < max_horiz - side_buffer) begin
                // 6th Floor
                if ((y_coord >= top_bottom_buffer) && (y_coord < top_bottom_buffer + floor_width)) begin
                    R = 9;
                    G = 10;
                    B = 10;
                end
                
                // 5th Floor
                else if ((y_coord >= top_bottom_buffer + floor_width) && (y_coord < top_bottom_buffer + 2 * floor_width)) begin
                    R = 11;
                    G = 11;
                    B = 11;
                end

                // 4th Floor
                else if ((y_coord >= top_bottom_buffer + 2 * floor_width) && (y_coord < top_bottom_buffer + 3 * floor_width)) begin
                    R = 9;
                    G = 10;
                    B = 10;
                end

                // 3rd Floor
                else if ((y_coord >= top_bottom_buffer + 3 * floor_width) && (y_coord < top_bottom_buffer + 4 * floor_width)) begin
                    R = 11;
                    G = 11;
                    B = 11;
                end

                // 2nd Floor
                else if ((y_coord >= top_bottom_buffer + 4 * floor_width) && (y_coord < top_bottom_buffer + 5 * floor_width)) begin
                    R = 9;
                    G = 10;
                    B = 10;
                end

                // 1st Floor
                else begin
                    R = 11;
                    G = 11;
                    B = 11;
                end
            end

            // Grass
            else begin
                R = 0;
                G = 15;
                B = 0;
            end
            

            // Elevator Draw States

            //Initial Draw State
            if (sim_state == 0) begin


            end

            // Normal Sim State
            else if (sim_state == 1) begin

            end

            // Stop state, needs to be reset with the async reset
            else begin

            end
        end

        // No output during the blanking interval
        else begin
            R = 4'b0000;
            G = 4'b0000;
            B = 4'b0000;
        end
    end 

endmodule