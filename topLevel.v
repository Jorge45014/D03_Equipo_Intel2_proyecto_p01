`timescale 1ps/1ps

// topLevel ///////////////////////////////
module topLevel (
    input wire clk,
    output reg [31:0] salida,
    output reg [4:0] pc
);

    // Salidas de: UNIDAD DE CONTROL (UC)
    wire UC_MUX_3;
    wire UC_MUX_1;
    wire [2:0] UC_AC;
    wire UC_MUX_4;
    wire UC_BR;

    // Salidas de: BANCO DE REGISTROS (BR)
    wire [31:0] BR_ALU_1;
    wire [31:0] BR_ALU_2;

    // Salidas de: MUX 1
    wire [31:0] MUX_1_BR;

    // Salidas de: ALU CONTROL (AC)
    wire [2:0] AC_ALU;

    // Salidas de: ALU (ALU)
    wire [31:0] ALU_MD_MUX;

    // Salidas de: MEMORIA DATOS (MD)
    //wire [31:0] MD_MUX;

    // Salidas de: MUX 2
    wire [4:0] MUX_2_PC;

    // Salidas de: PC
    wire [4:0] PC_MUX_2_RA;

    // Salidas de: Read Address (RA)
    wire [31:0] RA_;

    // Salidas de: MUX 2
    wire [4:0] MUX_3_BR;

    U_control iUnidadControl(
        .opCode(RA_[31:26]),
        .RegDst(UC_MUX_3),     
        .MemToReg(UC_MUX_1),   
        .ALUOP(UC_AC),
        .ALUsrc(UC_MUX_4),     
        .RegWrite(UC_BR)  
    );

    aluControl iAluControl(
        .UC_input(UC_AC),
        .funct(RA_[5:0]),
        .AC_output(AC_ALU)
    );

    alu iALU(
        .dataInput1(BR_ALU_1),
        .dataInput2(BR_ALU_2),
        .sel(AC_ALU),
        .dataOutput(ALU_MD_MUX)
    );

    Banco_registros iBancoRegistros(
        .AR1(RA_[25:21]),
        .AR2(RA_[20:16]),
        .AW(MUX_3_BR),
        .DW(MUX_1_BR),
        .EnW(UC_BR),
        .DR1(BR_ALU_1),
        .DR2(BR_ALU_2)
    );

    mux2_1_32bits iMUX_1(
        .sel(UC_MUX_1),
        .a(ALU_MD_MUX), // Coneccion temporal
        .b(ALU_MD_MUX),
        .c(MUX_1_BR)
    );

    /*Mem_datos iMemoriaDatos(
        .dataInput(ALU_MD_MUX),
        .EnW(),
        .EnR(),
        .dataOutput(MD_MUX)
    );*/

    mux2_1_5bits iMUX_2(
        .sel(0), // Coneccion temporal
        .a(PC_MUX_2_RA),
        .b(PC_MUX_2_RA), // Coneccion temporal
        .c(MUX_2_PC)
    );

    PC iPC(
        .clk(clk),
        .pc_in(MUX_2_PC),
        .pc_out(PC_MUX_2_RA)
    );

    readAddress iReadAddress(
        .i(PC_MUX_2_RA),
        .TB_out(RA_)
    );

    mux2_1_5bits iMUX_3(
        .sel(UC_MUX_3),
        .a(RA_[20:16]),
        .b(RA_[15:11]),
        .c(MUX_3_BR)
    );

    mux2_1_5bits iMUX_4(
        .sel(UC_MUX_4),
        .a(BR_ALU_2),
        .b(BR_ALU_2),  // Coneccion temporal
        .c(MUX_3_BR)
    );

    always @* begin
        assign salida = MUX_1_BR;
        assign pc = PC_MUX_2_RA;
    end

endmodule

// TB_topLevel ///////////////////////////////
module TB_topLevel;
    reg TB_clk;
    wire [31:0] TB_out;
    wire [4:0] TB_pc;

    topLevel uut(
        .clk(TB_clk),
        .salida(TB_out),
        .pc(TB_pc)
    );

    initial begin
        TB_clk = 0;
        forever #100 TB_clk = ~TB_clk;
    end
endmodule