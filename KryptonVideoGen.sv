module KryptonVideoGen (
    input wire i_clk,
    input logic [9:0] i_hsync_counter,  // Pixel X-coordinate (0 to 639)
    input logic [9:0] i_vsync_counter,  // Pixel Y-coordinate (0 to 479)
    input logic i_video_en,       // High during visible area
    output logic [12:0] w_tilemap_addr,  // Tilemap address (0 to 4799 for 80x60 tiles)
    output logic [15:0] o_color   // 16-bit color output (e.g., RGB565)
);

    // Compute tile coordinates
    logic [6:0] tile_row;
    logic [5:0] tile_col;
    logic [2:0] tile_x, tile_y;
    assign tile_row = i_hsync_counter >> 7;  // >> 3 for normal 80 columns
    assign tile_col = i_vsync_counter >> 7;  // >> 3 for normal 60 rows
    assign tile_x = i_hsync_counter[6:4]; // 2:0 for normal 8 px wide tiles
    assign tile_y = i_vsync_counter[6:4]; // 2:0 for normal 8 px tall tiles

    // Tilemap address (unchanged)
    assign w_tilemap_addr = (tile_col * 80) + tile_row;

    logic [15:0] w_color;
    assign w_color = ~(tile_row[0] ^ tile_col[0]) ? {tile_x, 2'b00, 6'b000000, tile_y, 2'b00} : 16'hFFFF;
    // safe color for VGA output
    assign o_color = (i_video_en) ? w_color : 16'h0000;

endmodule