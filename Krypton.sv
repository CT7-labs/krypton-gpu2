module Krypton (
    input wire clk, // 100MHz input clock
    output logic [4:0] vga_red,
    output logic [5:0] vga_green,
    output logic [4:0] vga_blue,
    output logic vga_hsync,
    output logic vga_vsync
);

    // VGA 640x480@60Hz parameters
    localparam H_ACTIVE = 640;
    localparam H_FRONT_PORCH = 16;
    localparam H_SYNC = 96;
    localparam H_BACK_PORCH = 48;
    localparam H_TOTAL = H_ACTIVE + H_FRONT_PORCH + H_SYNC + H_BACK_PORCH;

    localparam V_ACTIVE = 480;
    localparam V_FRONT_PORCH = 10;
    localparam V_SYNC = 2;
    localparam V_BACK_PORCH = 33;
    localparam V_TOTAL = (V_ACTIVE + V_FRONT_PORCH + V_SYNC + V_BACK_PORCH);

    // State parameters
    localparam STATE_XY_LOAD = 2'b00;
    localparam STATE_TILE_LOAD = 2'b01;
    localparam STATE_ROM_LOAD = 2'b10;
    localparam STATE_COLOR_LOAD = 2'b11;

    // Counter registers
    logic [9:0] h_count = 0; // 10 bits for 800 cycles
    logic [9:0] v_count = 0; // 10 bits for 525 cycles
    logic video_active = 1;

    // horizontal counter
    always_ff @(posedge clk) begin
        if (state == STATE_COLOR_LOAD) begin
            if (h_count == H_TOTAL - 1)
                h_count <= 10'd0;
            else
                h_count <= h_count + 10'd1;
        end
    end

    // vertical counter
    always_ff @(posedge clk) begin
        if (state == STATE_COLOR_LOAD) begin
            if (h_count == H_TOTAL - 1) begin
                if (v_count == V_TOTAL - 1) begin
                    v_count <= 10'd0;

                    scroll_x <= scroll_x + 0; 
                    scroll_y <= scroll_y + 0;
                end
                else
                    v_count <= v_count + 10'd1;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (state == STATE_XY_LOAD) begin
            pixel_x <= (h_count < H_ACTIVE) ? h_count + scroll_x : scroll_x;
            pixel_y <= (v_count < V_ACTIVE) ? v_count + scroll_y : scroll_y;
        end
        
        if (state == STATE_COLOR_LOAD) begin
            // Horizontal sync (active low)
            vga_hsync <= ~((h_count >= (H_ACTIVE + H_FRONT_PORCH)) &&
                    (h_count < (H_ACTIVE + H_FRONT_PORCH + H_SYNC)));
                    
            // Vertical sync (active low)
            vga_vsync <= ~((v_count >= (V_ACTIVE + V_FRONT_PORCH)) &&
                    (v_count < (V_ACTIVE + V_FRONT_PORCH + V_SYNC)));
            
            // video active region
            video_active <= (h_count < H_ACTIVE) && (v_count < V_ACTIVE);
        end
    end

    logic [9:0] pixel_x = 0;
    logic [8:0] pixel_y = 0;
    logic [9:0] scroll_x = 0;
    logic [8:0] scroll_y = 0;

    logic [1:0] state = STATE_XY_LOAD;

    // Color output
    logic [15:0] color_out;
    always_ff @(posedge clk) begin
        if (video_active) begin
            vga_red <= color_out[15:11];
            vga_green <= color_out[10:5];
            vga_blue <= color_out[4:0];
        end else begin
            vga_red <= 0;
            vga_green <= 0;
            vga_blue <= 0;
        end
    end

    // Video
    Video video_inst (
        .i_clk(clk),
        .i_pixel_x(pixel_x),
        .i_pixel_y(pixel_y),
        .o_color(color_out)
    );

    // State incrementing
    always_ff @(posedge clk) begin
        state <= state + 1;
    end

endmodule