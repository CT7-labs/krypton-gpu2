module KryptonVideoGen (
    input wire i_clk,
    input logic [9:0] i_x_pixel,  // Pixel X-coordinate (0 to 639)
    input logic [8:0] i_y_pixel,  // Pixel Y-coordinate (0 to 479)
    input logic i_video_en,       // High during visible area
    output logic [12:0] w_tilemap_addr,  // Tilemap address (0 to 4799 for 80x60 tiles)
    output logic [15:0] o_color   // 16-bit color output (e.g., RGB565)
);

    /*
    // Compute tile coordinates
    logic [6:0] tile_x;
    logic [5:0] tile_y;
    assign tile_x = i_x_pixel >> 3;  // 0 to 79
    assign tile_y = i_y_pixel >> 3;  // 0 to 59

    // Tilemap address (unchanged)
    assign w_tilemap_addr = (tile_y * 80) + tile_x;

    // Checkerboard pattern: white (FFFF) if tile_x[0] ^ tile_y[0] = 0, black (0000) if 1
    */

    assign o_color = i_video_en ? 16'h0000 : 16'hFFFF;

endmodule