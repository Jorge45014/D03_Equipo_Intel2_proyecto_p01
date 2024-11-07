`timescale 1ps/1ps

// Unidad de control /////////////////////////
module U_control (
    input wire [5:0] opCode,     // Entrada: opcode de 6 bits
    output reg RegDst,           // Salida: Mux 3 <--
    //output reg Branch,           // Salida: Branch
    //output reg MemRead,          // Salida: Memoria datos leer
    output reg MemToReg,         // Salida: Mux 1 <--
    output reg [2:0] ALUOP,      // Salida: operacion de la ALu (3 bits) <--
    //output reg MemWrite,         // Salida: Memoria datos escribir
    output reg ALUsrc,           // Salida: Mux 4 <--
    output reg RegWrite          // Salida: Banco de registros <--
);

    parameter R_TYPE = 6'b000000; // Tipo R

    always @(*) begin
        RegDst = 0;
        //Branch = 0;
        //MemRead = 0;
        MemToReg = 0;
        ALUOP = 3'b000;
        //MemWrite = 0;
        ALUsrc = 0;
        RegWrite = 0;

        case (opCode)
            R_TYPE: begin
                RegDst = 1;
                RegWrite = 1;
                MemToReg = 0;
                ALUsrc = 0;
                ALUOP = 3'b000;
            end
        endcase
    end
endmodule

