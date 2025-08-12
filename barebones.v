module vga_sync (
    input wire clk,          // 25MHz input clock
    input wire rst_n,        // Active-low reset
    output reg hsync,        // Horizontal sync pulse
    output reg vsync,        // Vertical sync pulse
    output reg video_active, // Active video region indicator
    output reg [9:0] pixel_x,// Current X pixel coordinate
    output reg [9:0] pixel_y // Current Y pixel coordinate
);

// VGA 640x480@60Hz timing parameters (25MHz clock, 40ns/pixel)
localparam H_ACTIVE      = 640; // Active pixels
localparam H_FRONT_PORCH = 16;  // Front porch pixels
localparam H_SYNC        = 96;  // Sync pulse pixels
localparam H_BACK_PORCH  = 48;  // Back porch pixels
localparam H_TOTAL       = 800; // Total pixels per line

localparam V_ACTIVE      = 480; // Active lines
localparam V_FRONT_PORCH = 10;  // Front porch lines
localparam V_SYNC        = 2;   // Sync pulse lines
localparam V_BACK_PORCH  = 33;  // Back porch lines
localparam V_TOTAL       = 525; // Total lines per frame

// Internal counters
reg [9:0] h_count;
reg [9:0] v_count;

// Horizontal counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        h_count <= 10'd0;
    end
    else begin
        if (h_count == H_TOTAL - 1)
            h_count <= 10'd0;
        else
            h_count <= h_count + 10'd1;
    end
end

// Vertical counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        v_count <= 10'd0;
    end
    else begin
        if (h_count == H_TOTAL - 1) begin
            if (v_count == V_TOTAL - 1)
                v_count <= 10'd0;
            else
                v_count <= v_count + 10'd1;
        end
    end
end

// Generate sync signals and video active region
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        hsync <= 1'b1;
        vsync <= 1'b1;
        video_active <= 1'b0;
        pixel_x <= 10'd0;
        pixel_y <= 10'd0;
    end
    else begin
        // Horizontal sync (active low)
        hsync <= ~((h_count >= (H_ACTIVE + H_FRONT_PORCH)) &&
                  (h_count < (H_ACTIVE + H_FRONT_PORCH + H_SYNC)));
                  
        // Vertical sync (active low)
        vsync <= ~((v_count >= (V_ACTIVE + V_FRONT_PORCH)) &&
                  (v_count < (V_ACTIVE + V_FRONT_PORCH + V_SYNC)));
                  
        // Video active region
        video_active <= (h_count < H_ACTIVE) && (v_count < V_ACTIVE);
        
        // Pixel coordinates
        pixel_x <= (h_count < H_ACTIVE) ? h_count : 10'd0;
        pixel_y <= (v_count < V_ACTIVE) ? v_count : 10'd0;
    end
end

endmodulemodule vga_sync (
    input wire clk,          // 25MHz input clock
    input wire rst_n,        // Active-low reset
    output reg hsync,        // Horizontal sync pulse
    output reg vsync,        // Vertical sync pulse
    output reg video_active, // Active video region indicator
    output reg [9:0] pixel_x,// Current X pixel coordinate
    output reg [9:0] pixel_y // Current Y pixel coordinate
);

// VGA 640x480@60Hz timing parameters (25MHz clock, 40ns/pixel)
localparam H_ACTIVE      = 640; // Active pixels
localparam H_FRONT_PORCH = 16;  // Front porch pixels
localparam H_SYNC        = 96;  // Sync pulse pixels
localparam H_BACK_PORCH  = 48;  // Back porch pixels
localparam H_TOTAL       = 800; // Total pixels per line

localparam V_ACTIVE      = 480; // Active lines
localparam V_FRONT_PORCH = 10;  // Front porch lines
localparam V_SYNC        = 2;   // Sync pulse lines
localparam V_BACK_PORCH  = 33;  // Back porch lines
localparam V_TOTAL       = 525; // Total lines per frame

// Internal counters
reg [9:0] h_count;
reg [9:0] v_count;

// Horizontal counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        h_count <= 10'd0;
    end
    else begin
        if (h_count == H_TOTAL - 1)
            h_count <= 10'd0;
        else
            h_count <= h_count + 10'd1;
    end
end

// Vertical counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        v_count <= 10'd0;
    end
    else begin
        if (h_count == H_TOTAL - 1) begin
            if (v_count == V_TOTAL - 1)
                v_count <= 10'd0;
            else
                v_count <= v_count + 10'd1;
        end
    end
end

// Generate sync signals and video active region
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        hsync <= 1'b1;
        vsync <= 1'b1;
        video_active <= 1'b0;
        pixel_x <= 10'd0;
        pixel_y <= 10'd0;
    end
    else begin
        // Horizontal sync (active low)
        hsync <= ~((h_count >= (H_ACTIVE + H_FRONT_PORCH)) &&
                  (h_count < (H_ACTIVE + H_FRONT_PORCH + H_SYNC)));
                  
        // Vertical sync (active low)
        vsync <= ~((v_count >= (V_ACTIVE + V_FRONT_PORCH)) &&
                  (v_count < (V_ACTIVE + V_FRONT_PORCH + V_SYNC)));
                  
        // Video active region
        video_active <= (h_count < H_ACTIVE) && (v_count < V_ACTIVE);
        
        // Pixel coordinates
        pixel_x <= (h_count < H_ACTIVE) ? h_count : 10'd0;
        pixel_y <= (v_count < V_ACTIVE) ? v_count : 10'd0;
    end
end

endmodule