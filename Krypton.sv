module Krypton (
    input wire i_clk,
    output logic [15:0] o_color,
    output logic o_hsync,
    output logic o_vsync,
    output logic [9:0] o_hsync_counter /* synthesis dont_touch */,
    output logic [9:0] o_vsync_counter /* synthesis dont_touch */,
    output logic [9:0] o_x_pixel /* synthesis dont_touch */,
    output logic [8:0] o_y_pixel /* synthesis dont_touch */,
    output logic o_hblank /* synthesis dont_touch */,
    output logic o_vblank /* synthesis dont_touch */,
    output logic o_video_en /* synthesis dont_touch */
);

    logic [12:0] w_tilemap_addr /* synthesis dont_touch */;
    KryptonSyncGen syncgen_inst (
        .i_clk(i_clk),
        .r_hsync(o_hsync),
        .r_vsync(o_vsync),
        .r_hsync_counter(o_hsync_counter),
        .r_vsync_counter(o_vsync_counter),
        .r_x_pixel(o_x_pixel),
        .r_y_pixel(o_y_pixel),
        .r_hblank(o_hblank),
        .r_vblank(o_vblank),
        .r_video_en(o_video_en)
    );
    KryptonVideoGen videogen_inst (
        .i_clk(i_clk),
        .i_x_pixel(o_x_pixel),
        .i_y_pixel(o_y_pixel),
        .i_video_en(o_video_en),
        .w_tilemap_addr(w_tilemap_addr),
        .o_color(o_color)
    );

endmodule
