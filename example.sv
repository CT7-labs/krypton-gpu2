// Inferred BRAM

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