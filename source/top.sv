module top (
    // VGA Pins
    output logic ICE_44_G6, ICE_45, ICE_46, ICE_47, ICE_48, ICE_2, ICE_3, ICE_4,
    ICE_28, ICE_31, ICE_32, ICE_34, ICE_36, ICE_38);


    logic [7:0] output_dest;
    logic CLK;

    pll_clkGen u2 (.VGA_CLK(CLK));

    counterParametric #(.COUNT(8'b1010_1010), .WIDTH(8)) output_stuff
    (
        .counter(output_dest), .clk(CLK), .rst(1'b0), .en(1'b1), .syncRst(1'b0)
    );


    vgaController vgacon(.reset(1'b0), .hsync(ICE_36), .vsync(ICE_38),
        .R({ICE_44_G6, ICE_45, ICE_46, ICE_47}), .B({ICE_48, ICE_2, ICE_3, ICE_4}), 
        .G({ICE_28,ICE_31,ICE_32,ICE_34}), .sim_state(2'b01), .destination(output_dest), .(CLK)
    );



endmodule
