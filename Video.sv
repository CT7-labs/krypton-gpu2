module ram_256x16 (din, addr, write_en, clk, dout);
    parameter addr_width = 8;
    parameter data_width = 16;
    input [addr_width-1:0] addr;
    input [data_width-1:0] din;
    input write_en, clk;
    output [data_width-1:0] dout;
    logic [data_width-1:0] dout; // Register for output.
    logic [data_width-1:0] mem [(1<<addr_width)-1:0];

    always_ff @(posedge clk) begin
        if (write_en) mem[(addr)] <= din;
        dout <= mem[addr]; // Output register controlled by clock.
    end
endmodule

module Video (
    input i_clk,
    input logic [9:0] i_pixel_x,
    input logic [8:0] i_pixel_y,
    input logic [1:0] i_state,
    output logic [15:0] o_color
);

    // wire setup
    logic w_tile_addr;
    assign w_tile_addr = {i_pixel_y[8:3], i_pixel_x[9:3]};

    logic [2:0] w_tile_x, w_tile_y;
    assign w_tile_x = i_pixel_x[2:0];
    assign w_tile_y = i_pixel_y[2:0];

    // palette init
    logic [15:0] color [0:1];
    initial begin
        color[0] = 16'h0000;
        color[1] = 16'hFFFF;
    end

    // Tile index memory
    logic [7:0] w_tile_index;
    memory8k tilemap_inst (
        .i_clk(i_clk),
        .wen(1'b0),
        .re(1'b1),
        .waddr(13'b0),
        .raddr(w_tile_addr),
        .wdata(8'b0),
        .rdata(w_tile_index)
    )

    always_ff @(posedge i_clk) begin
       o_color <= {2{w_tile_index}};
    end
    
endmodule