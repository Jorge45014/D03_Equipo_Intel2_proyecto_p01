`timescale 1ps/1ps

// Mux 2 a 1 /////////////////////////
module mux2_1_32bits (
    input sel,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

always @* begin
    if (sel) begin
        c = b;
    end
    else begin
        c = a;
    end    
end
endmodule