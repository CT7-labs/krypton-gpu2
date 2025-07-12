module KryptonSyncGen (
    input wire i_clk, // 25 MHz
    output logic o_hsync,
    output logic o_vsync,
    output logic [9:0] o_hsync_counter,
    output logic [9:0] o_vsync_counter,
    output logic o_hblank,
    output logic o_vblank,
    output logic o_video_en
);

    // VGA timing parameters
    parameter H_VISIBLE_AREA = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_SYNC_PULSE = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_TOTAL = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH; // 800
    parameter V_VISIBLE_AREA = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_SYNC_PULSE = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_TOTAL = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH; // 525

    // Registers
    logic r_hsync, r_vsync, r_hblank, r_vblank, r_video_en;
    logic [9:0] r_hsync_counter, r_vsync_counter, r_x_pixel;
    logic [8:0] r_y_pixel;

    // Output assignments
    assign o_hsync = r_hsync;
    assign o_vsync = r_vsync;
    assign o_hsync_counter = r_hsync_counter;
    assign o_vsync_counter = r_vsync_counter;
    assign o_video_en = (r_hsync_counter < H_VISIBLE_AREA) && (r_vsync_counter < V_VISIBLE_AREA);
    
    always_ff @(posedge i_clk) begin
        // Horizontal counter
        if (r_hsync_counter == H_TOTAL - 1) begin
            r_hsync_counter <= 0;
            // Vertial counter
            if (r_vsync_counter == V_TOTAL - 1) begin
                r_vsync_counter <= 0;
            end else begin
                r_vsync_counter <= r_vsync_counter + 1;
            end
        end else begin
            r_hsync_counter <= r_hsync_counter + 1;
        end

        r_hsync <= ~(r_hsync_counter >= (H_VISIBLE_AREA + H_FRONT_PORCH) && r_hsync_counter < (H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE));
        r_vsync <= ~(r_vsync_counter >= (V_VISIBLE_AREA + V_FRONT_PORCH) && r_vsync_counter < (V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE));
    end

endmodule