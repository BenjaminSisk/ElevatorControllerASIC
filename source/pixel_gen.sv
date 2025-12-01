`default_nettype none
module pixel_gen (
    input logic enable,
    input logic [7:0] destination,
    input logic [1:0]sim_state,
    input logic [25:0]people_data,
    input logic [9:0] x_coord,
    input logic [9:0] y_coord,
    output logic [3:0] R,
    output logic [3:0] G,
    output logic [3:0] B
);
    // Constant drawing parameters
    localparam max_horiz = 640;
    localparam max_vert = 480;
    localparam side_buffer = 20;
    localparam top_bottom_buffer = 15;
    localparam floor_width = 75;
    localparam building_width = 200;
    localparam outline_width = 10;
    localparam elevator_height = 70;

    always_comb begin
        if (enable) begin
            // Always draw the static elements of the screen
            // Side sky (side buffers)
            if ((x_coord < side_buffer) || (x_coord >= max_horiz - side_buffer && x_coord < max_horiz) && (y_coord < max_vert - top_bottom_buffer)) begin
                R = 2;
                G = 8;
                B = 15;
            end

            // Top sky (top buffer)
            else if (y_coord < top_bottom_buffer) begin
                R = 2;
                G = 8;
                B = 15;
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
            else if (
                (x_coord >= 195) &&
                (x_coord < 205) &&
                (y_coord >= top_bottom_buffer) &&
                (y_coord <  max_vert - top_bottom_buffer)
            ) begin
                //added logical and to fix synthesis error
                R = 0;
                G = 0;
                B = 0;
            end

            // Left elevator shaft
            else if (x_coord >= 205 && x_coord < 295 && y_coord >= top_bottom_buffer && y_coord < max_vert - top_bottom_buffer) begin
                // Elevator at the bottom in the initial state
                if (sim_state == 0) begin
                    if (y_coord < max_vert - top_bottom_buffer - elevator_height) begin
                        R = 8;
                        G = 4; 
                        B = 1;
                    end
                    else begin
                        R = 4;
                        G = 4;
                        B = 4;
                    end
                end

                else if (sim_state == 1) begin
                    // 1st floor elevator
                    if (destination[7:4] == 0) begin
                        if (y_coord >= 390 && y_coord < 465) begin
                            R = 4;
                            G = 4; 
                            B = 4;
                        end
                        else begin
                            R = 8;
                            G = 4;
                            B = 1;
                        end
                    end

                    // Half-floor 1-2
                    else if (destination[7:4] == 1) begin
                        if (y_coord >= 353 && y_coord < 428) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end
                    end
                    // 2nd floor elevator
                    else if (destination[7:4] == 2) begin
                        if (y_coord >= 315 && y_coord < 390) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end 

                    end
                    // Half-floor 2-3
                    else if (destination[7:4] == 3) begin 
                        if (y_coord >= 278 && y_coord < 353) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end

                    end
                    // 3rd floor elevator
                    else if (destination[7:4] == 4) begin
                        if (y_coord >= 240 && y_coord < 315) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end 

                    end
                    // Half-floor 3-4
                    else if (destination[7:4] == 5) begin
                        if (y_coord >= 203 && y_coord < 278) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end 

                    end
                    // 4th floor elevator
                    else if (destination[7:4] == 6) begin 
                        if (y_coord >= 165 && y_coord < 240) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end 

                    end
                    // Half-floor 4-5
                    else if (destination[7:4] == 7) begin
                        if (y_coord >= 128 && y_coord < 203) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end  

                    end
                    // 5th floor
                    else if (destination[7:4] == 8) begin
                        if (y_coord >= 90 && y_coord < 165) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end 

                    end
                    // Half-floor 5-6
                    else if (destination[7:4] == 9) begin
                        if (y_coord >= 53 && y_coord < 128) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end  

                    end
                    // 6th floor elevator
                    else begin
                        if (y_coord >= 15 && y_coord < 90) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin
                            R = 8;
                            G = 4;
                            B = 1;
                        end
                    end
                end
                
                // Stop state
                else begin
                    if (x_coord >= 300 && x_coord < 340 && y_coord >= 200 && y_coord < 260) begin
                        R = 15;
                        G = 0;
                        B = 0;
                    end

                    else begin
                        R = 0;
                        G = 0;
                        B = 0;
                    end
                end

            end

            // Middle outline
            else if (x_coord >= 295 && x_coord< 305 && y_coord >= top_bottom_buffer && y_coord < max_vert - top_bottom_buffer) begin
                R = 0;
                G = 0;
                B = 0;
            end

            // Right elevator shaft
            else if (x_coord >= 305 && x_coord < 395 && y_coord >= top_bottom_buffer && y_coord < max_vert - top_bottom_buffer) begin
                if (sim_state == 0) begin
                    if (y_coord < max_vert - top_bottom_buffer - elevator_height) begin
                        R = 8;
                        G = 4; 
                        B = 1;
                    end
                    else begin
                        R = 4;
                        G = 4;
                        B = 4;
                    end
                end

                else if (sim_state == 1) begin
                    // 1st floor elevator
                    if (destination[3:0] == 0) begin
                        if (y_coord >= 390 && y_coord < 465) begin
                            R = 4;
                            G = 4; 
                            B = 4;
                        end
                        else begin
                            R = 8;
                            G = 4;
                            B = 1;
                        end
                    end

                    // Half-floor 1-2
                    else if (destination[3:0] == 1) begin
                        if (y_coord >= 353 && y_coord < 428) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end
                    end
                    // 2nd floor elevator
                    else if (destination[3:0] == 2) begin
                        if (y_coord >= 315 && y_coord < 390) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end 

                    end
                    // Half-floor 2-3
                    else if (destination[3:0] == 3) begin 
                        if (y_coord >= 278 && y_coord < 353) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end

                    end
                    // 3rd floor elevator
                    else if (destination[3:0] == 4) begin
                        if (y_coord >= 240 && y_coord < 315) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end 

                    end
                    // Half-floor 3-4
                    else if (destination[3:0] == 5) begin
                        if (y_coord >= 203 && y_coord < 278) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end 

                    end
                    // 4th floor elevator
                    else if (destination[3:0] == 6) begin 
                        if (y_coord >= 165 && y_coord < 240) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end 

                    end
                    // Half-floor 4-5
                    else if (destination[3:0] == 7) begin
                        if (y_coord >= 128 && y_coord < 203) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end  

                    end
                    // 5th floor
                    else if (destination[3:0] == 8) begin
                        if (y_coord >= 90 && y_coord < 165) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end 

                    end
                    // Half-floor 5-6
                    else if (destination[3:0] == 9) begin
                        if (y_coord >= 53 && y_coord < 128) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin 
                            R = 8;
                            G = 4;
                            B = 1;
                        end  

                    end
                    // 6th floor elevator
                    else begin
                        if (y_coord >= 15 && y_coord < 90) begin 
                            R = 4;
                            G = 4;
                            B = 4;
                        end
                        else begin
                            R = 8;
                            G = 4;
                            B = 1;
                        end
                    end
                end
                
                // Stop state
                else begin
                    if (x_coord >= 300 && x_coord < 340 && y_coord >= 200 && y_coord < 260) begin
                        R = 15;
                        G = 0;
                        B = 0;
                    end

                    else begin
                        R = 0;
                        G = 0;
                        B = 0;
                    end
                end


            end

            // Right outline
            else if (x_coord >= 395 && x_coord < 405 && y_coord >= top_bottom_buffer && y_coord < max_vert - top_bottom_buffer) begin
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
        end

        // No output during the blanking interval
        else begin
            R = 4'b0000;
            G = 4'b0000;
            B = 4'b0000;
        end
    end 

endmodule
