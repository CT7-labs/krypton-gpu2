module KryptonTop (
    input wire clk,
    output wire vga_hsync,
    output wire vga_vsync,
    output wire [4:0] vga_red,
    output wire [5:0] vga_green,
    output wire [4:0] vga_blue
);

    // 100MHz / 4 = 25MHz
    logic [1:0] clk_div = 0;
    logic video_clk;
    assign video_clk = clk_div[1];

    always_ff @(posedge clk) begin
        clk_div <= clk_div + 1;
    end

    // Sync pulse generation
    logic w_video_en, w_hblank, w_vblank;
    logic [9:0] w_hsync_counter, w_vsync_counter;
    KryptonSyncGen syncgen_inst (
        .i_clk(video_clk),
        .o_hsync(vga_hsync),
        .o_vsync(vga_vsync),
        .o_hsync_counter(w_hsync_counter),
        .o_vsync_counter(w_vsync_counter),
        .o_hblank(w_hblank),
        .o_vblank(w_vblank),
        .o_video_en(w_video_en),
    );

    // assign vga_hsync = r_hsync;
    // assign vga_vsync = r_vsync;
    assign vga_red = (w_video_en) ? 5'b11111 : 0;
    assign vga_green = (w_video_en) ? 6'b111111 : 0;
    assign vga_blue = (w_video_en) ? 5'b11111 : 0;

endmodule
