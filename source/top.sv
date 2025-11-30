module top (
    output logic ICE_44_G6, ICE_45, ICE_46, ICE_47, ICE_48, ICE_2, ICE_3, ICE_4,
    ICE_28, ICE_31, ICE_32, ICE_34, ICE_36, ICE_38
);

    vgaController vgacon(.reset(1'b0), .hsync(ICE_36), .vsync(ICE_38),
        .R({ICE_44_G6, ICE_45, ICE_46, ICE_47}), .B({ICE_48, ICE_2, ICE_3, ICE_4}), 
        .G({ICE_28,ICE_31,ICE_32,ICE_34})
    );

endmodule
