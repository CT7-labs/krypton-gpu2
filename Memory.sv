module memory8k (
    input wire i_clk,
    input logic wen, 
    input logic ren, 
    input [12:0] waddr, raddr,
    input [7:0] wdata,
    output logic [7:0] rdata
);
    logic [7:0] mem [0:8191];

    initial begin
        for (integer i = 0; i < 8192; i = i + 1) begin
            mem <= i[7:0];
        end
    end

    always @(posedge clk) begin
        if (wen)
            mem[waddr] <= wdata;
        if (ren)
            rdata <= mem[raddr];
    end
endmodule