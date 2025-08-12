module Krypton (
    input wire clk, // 100MHz input clock
    output logic [4:0] vga_red,
    output logic [5:0] vga_green,
    output logic [4:0] vga_blue,
    output logic vga_hsync,
    output logic vga_vsync
);

    // VGA 640x480@60Hz parameters scaled for 100MHz (x4 from 25MHz)
    parameter H_VISIBLE_AREA = 640 * 4;
    parameter H_FRONT_PORCH = 16 * 4;
    parameter H_SYNC_PULSE = 96 * 4;
    parameter H_BACK_PORCH = 48 * 4;
    parameter H_TOTAL = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    parameter V_VISIBLE_AREA = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_SYNC_PULSE = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_TOTAL = (V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH);

    // Counter registers
    logic [11:0] r_hsync_counter = 0; // 12 bits for 3200 cycles
    logic [9:0] r_vsync_counter = 0; // 10 bits for 525 cycles

    logic [9:0] pixel_x = 0;
    logic [8:0] pixel_y = 0;

    logic [9:0] scroll_x = 0;
    logic [8:0] scroll_y = 0;

    // Sync generation and registered color output
    always_ff @(posedge clk) begin
        // Horizontal counter
        if (r_hsync_counter == H_TOTAL - 1) begin
            r_hsync_counter <= 0;
            pixel_x <= scroll_x;
            // Vertical counter
            if (r_vsync_counter == V_TOTAL - 1) begin
                r_vsync_counter <= 0;
                pixel_y <= scroll_y;
                scroll_x <= scroll_x - 1 % 640;
                scroll_y <= scroll_x - 1 % 480;
            end else begin
                r_vsync_counter <= r_vsync_counter + 1;
                pixel_y <= pixel_y + 1;
            end
        end else begin
            r_hsync_counter <= r_hsync_counter + 1;
            if (r_hsync_counter[1:0] == 2'b11) pixel_x <= pixel_x + 1;
        end

        // Generate hsync and vsync (active low)
        vga_hsync <= ~(r_hsync_counter >= H_VISIBLE_AREA + H_FRONT_PORCH &&
                       r_hsync_counter < H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE);
        vga_vsync <= ~(r_vsync_counter >= V_VISIBLE_AREA + V_FRONT_PORCH &&
                       r_vsync_counter < V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE);

        // Registered color output (only active in visible area, mitigates glitches)
        if ((r_hsync_counter < H_VISIBLE_AREA) && (r_vsync_counter < V_VISIBLE_AREA)) begin
            if (r_hsync_counter[1:0] == 2'b00) begin
                if (~(|pixel_x[9:3]) && ~(|pixel_y[8:3])) begin
                    vga_red <= 5'h1F;
                    vga_green <= 6'h3F;
                    vga_blue <= 5'h1F;
                end else begin
                    vga_red   <= pixel_x[3] ^ pixel_y[3] ? ~pixel_x[7:3] : 0;
                    vga_green <= pixel_x[3] ^ pixel_y[3] ? {pixel_y[7:3], pixel_y[3]} : 0;
                    vga_blue  <= pixel_x[3] ^ pixel_y[3] ? pixel_x[7:3] : 0; 
                end
            end else begin
                vga_red <= vga_red;
                vga_green <= vga_green;
                vga_blue <= vga_blue;
            end
        end else begin
            vga_red   <= 5'b00000;
            vga_green <= 6'b000000;
            vga_blue  <= 5'b00000;
        end
    end

endmodule