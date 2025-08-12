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
    input [9:0] pixel_x,
    input [8:0] pixel_y,
    
);

    // wire setup
    logic tile_addr;
    assign tile_addr = {pixel_y[8:3], pixel_x[9:3]};

    logic [2:0] tile_x, tile_y;
    assign tile_x = pixel_x[2:0];
    assign tile_y = pixel_y[2:0];

    // palette init
    logic [15:0] color [0:1];
    initial begin
        color[0] = 16'h0000;
        color[1] = 16'hFFFF;
    end
    
endmodule