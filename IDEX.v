module IDEX(clock, rst, WB, RegWrite, RegWritereg,MRead,MWrite,OPSEL, BSRC, RegDst,DataA,DataB,imm_value, aluControl,RegRs,RegRt,RegRd,WBreg,MReadreg, MWritereg,OPSELreg, BSRCreg, RegDstreg
        ,DataAreg, DataBreg,imm_valuereg,RegRsreg,RegRtreg,RegRdreg, aluControlreg, IDEXWrite); 
    input clock, rst, IDEXWrite; 
    input WB, RegWrite; 
    input MRead, MWrite; 
    input [3:0] OPSEL; 
    input BSRC; 
    input [5:0]aluControl; 
    input [1:0] RegDst; 
    input [4:0] RegRs,RegRt,RegRd; 
    input [31:0] DataA,DataB,imm_value; 
    output reg WBreg,RegWritereg; 
    output reg MReadreg, MWritereg; 
    output reg [3:0] OPSELreg;
    output reg BSRCreg;
    output reg [5:0]aluControlreg;
    output reg [1:0]RegDstreg;   
    output reg [4:0] RegRsreg,RegRtreg,RegRdreg; 
    output reg [31:0] DataAreg,DataBreg,imm_valuereg; 
    
    always@(posedge clock, posedge rst) 
    if (rst)
    begin
        WBreg <= 0; 
        RegWritereg <= 0; 
        MWritereg <= 0; 
        MReadreg <= 0; 
        BSRCreg <= 0;
        OPSELreg <= 0;
        RegDstreg <= 0;
        DataAreg <= 0; 
        DataBreg <= 0; 
        imm_valuereg <= 0; 
        RegRsreg <= 0; 
        RegRtreg <= 0; 
        RegRdreg <= 0; 
        aluControlreg <= 0;
    end
    else
    if (IDEXWrite)
    begin 
        WBreg <= WB; 
        RegWritereg <= RegWrite; 
        MWritereg <= MWrite; 
        MReadreg <= MRead; 
        BSRCreg <= BSRC;
        OPSELreg <= OPSEL;
        RegDstreg <= RegDst;
        DataAreg <= DataA; 
        DataBreg <= DataB; 
        imm_valuereg <= imm_value; 
        RegRsreg <= RegRs; 
        RegRtreg <= RegRt; 
        RegRdreg <= RegRd; 
        aluControlreg <= aluControl;
    end 
     
endmodule
    