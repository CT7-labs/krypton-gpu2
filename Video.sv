module Video (
    input i_clk,
    input logic [9:0] i_pixel_x,
    input logic [8:0] i_pixel_y,
    output logic [15:0] o_color
);

    // wire setup
    logic [12:0] w_tile_addr;
    assign w_tile_addr = {i_pixel_y[8:3], i_pixel_x[9:3]};

    logic [2:0] w_tile_x, w_tile_y;
    assign w_tile_x = i_pixel_x[2:0];
    assign w_tile_y = i_pixel_y[2:0];

    // palette init
    logic [15:0] color [0:7];
    initial begin
        color[0] <= 16'h20e4;
        color[1] <= 16'hFFFF;
        color[2] <= 16'h20e4;
        color[3] <= 16'h659f;
        color[4] <= 16'h20e4;
        color[5] <= 16'hfb2c;
        color[6] <= 16'h20e4;
        color[7] <= 16'h9ff3;
    end

    // Tile index memory
    logic [7:0] w_tile_index;
    mem_tilemap tilemap_inst (
        .i_clk(i_clk),
        .wen(1'b0),
        .ren(1'b1),
        .waddr(13'b0),
        .raddr(w_tile_addr),
        .wdata(8'b0),
        .rdata(w_tile_index)
    );

    logic [1:0] w_tile_palette;
    mem_palette palette_inst (
        .i_clk(i_clk),
        .wen(1'b0),
        .ren(1'b1),
        .waddr(13'b0),
        .raddr(w_tile_addr),
        .wdata(8'b0),
        .rdata(w_tile_palette)
    );

    logic [10:0] w_rom_addr;
    assign w_rom_addr = {w_tile_index, i_pixel_y[2:0]};
    logic [7:0] current_line;
    mem_tilerom tilerom_inst (
        .i_clk(i_clk),
        .wen(1'b0),
        .ren(1'b1),
        .waddr(11'b0),
        .raddr(w_rom_addr),
        .wdata(8'b0),
        .rdata(current_line)
    );

    always_ff @(posedge i_clk) begin
       o_color <= color[{w_tile_palette, current_line[~i_pixel_x[2:0]]}];
    end
    
endmodule