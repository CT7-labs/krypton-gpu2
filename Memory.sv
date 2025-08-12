module memory8k (
    input wire i_clk,
    input logic wen, 
    input logic ren, 
    input [12:0] waddr, raddr,
    input [7:0] wdata,
    output logic [7:0] rdata
);
    reg [7:0] mem [0:8191];

    initial begin
        $readmemh("tilemap.hex", mem);
    end

    always_ff @(posedge i_clk) begin
        if (wen)
            mem[waddr] <= wdata;
        if (ren)
            rdata <= mem[raddr];
    end
endmodule

module memory2k (
    input wire i_clk,
    input logic wen, 
    input logic ren, 
    input [10:0] waddr, raddr,
    input [7:0] wdata,
    output logic [7:0] rdata
);
    reg [7:0] mem [0:2047];

    initial begin
        $readmemh("tilerom.hex", mem);
    end

    always_ff @(posedge i_clk) begin
        if (wen)
            mem[waddr] <= wdata;
        if (ren)
            rdata <= mem[raddr];
    end
endmodule