module VGA (
    input clk,  // 100 MHz input clock

    // Color output (RGB565 format)
    output [4:0] vga_red,    // 5 bits
    output [5:0] vga_green,  // 6 bits
    output [4:0] vga_blue,   // 5 bits

    // Sync signals for timing
    output reg vga_hsync,
    output reg vga_vsync
);

    // Clock divider: 100 MHz -> ~25 MHz (divide by 4)
    reg [1:0] clk_div = 0;
    wire vga_clk = clk_div[1];  // 25 MHz clock

    always @(posedge clk) begin
        clk_div <= clk_div + 1;
    end

    // VGA timing parameters (640x480@60 Hz)
    parameter H_VISIBLE    = 640;
    parameter H_FRONTPORCH = 16;
    parameter H_SYNCPULSE  = 96;
    parameter H_BACKPORCH  = 48;
    parameter H_TOTAL      = H_VISIBLE + H_FRONTPORCH + H_SYNCPULSE + H_BACKPORCH;  // 800

    parameter V_VISIBLE    = 480;
    parameter V_FRONTPORCH = 10;
    parameter V_SYNCPULSE  = 2;
    parameter V_BACKPORCH  = 33;
    parameter V_TOTAL      = V_VISIBLE + V_FRONTPORCH + V_SYNCPULSE + V_BACKPORCH;  // 525

    // Counters
    reg [9:0] h_counter = 0;  // 0-799
    reg [9:0] v_counter = 0;  // 0-524
    reg [4:0] red_counter = 0;
    reg [5:0] green_counter = 0;
    reg [4:0] blue_counter = 0;
    reg count_up = 1;         // 1 = increment, 0 = decrement
    reg [1:0] frame_count = 0;// Counts frames for 2-frame updates

    // VGA timing and color logic
    always @(posedge vga_clk) begin
        // Horizontal counter
        if (h_counter == H_TOTAL - 1) begin
            h_counter <= 0;
            // Vertical counter
            if (v_counter == V_TOTAL - 1) begin
                v_counter <= 0;
                frame_count <= frame_count + 1;  // Increment every frame

                // Update colors every 2 frames (when frame_count == 2)
                if (1) begin
                    frame_count <= 0;  // Reset frame counter
                    if (count_up) begin
                        if (red_counter < 31) begin
                            red_counter <= red_counter + 1;
                        end else if (green_counter < 63) begin
                            green_counter <= green_counter + 1;
                        end else if (blue_counter < 31) begin
                            blue_counter <= blue_counter + 1;
                        end else begin
                            count_up <= 0;  // Switch to decrement
                        end
                    end else begin
                        if (red_counter > 0) begin
                            red_counter <= red_counter - 1;
                        end else if (green_counter > 0) begin
                            green_counter <= green_counter - 1;
                        end else if (blue_counter > 0) begin
                            blue_counter <= blue_counter - 1;
                        end else begin
                            count_up <= 1;  // Switch back to increment
                        end
                    end
                end
            end else begin
                v_counter <= v_counter + 1;
            end
        end else begin
            h_counter <= h_counter + 1;
        end

        // Sync signals (active low)
        vga_hsync <= ~(h_counter >= (H_VISIBLE + H_FRONTPORCH) && h_counter < (H_VISIBLE + H_FRONTPORCH + H_SYNCPULSE));
        vga_vsync <= ~(v_counter >= (V_VISIBLE + V_FRONTPORCH) && v_counter < (V_VISIBLE + V_FRONTPORCH + V_SYNCPULSE));
    end

    begin : color_output
        // Color output (uniform across entire screen during visible area)
        wire active_video = (h_counter < H_VISIBLE) && (v_counter < V_VISIBLE);
        assign vga_red   = active_video ? red_counter : 5'b0;
        assign vga_green = active_video ? green_counter : 6'b0;
        assign vga_blue  = active_video ? blue_counter : 5'b0;
    end

endmodule