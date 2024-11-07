`timescale 1ps/1ps

// Add ///////////////////////////////
module ADD (
    input [4:0] A_ADD,
    input [4:0] B_ADD,
    output [4:0] C_ADD
);
assign C_ADD = A_ADD + B_ADD;
endmodule

// PC ///////////////////////////////
module PC (
    input wire clk,
    input wire [4:0] pc_in,
    output reg [4:0] pc_out
);

    wire [4:0] increment;

    ADD iADD(
        .A_ADD(pc_out),
        .B_ADD(5'd4),
        .C_ADD(increment)
    );

    initial begin
        pc_out = 0;
    end

    always @(posedge clk) begin
        if (pc_out == 5'd31)
            pc_out <= 0;
        else
            pc_out <= increment;
    end

endmodule