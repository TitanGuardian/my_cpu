module EXMEM(clock, rst, WB, RegWrite, RegWritereg,MRead, MWrite,ALUOut,RegRD,WriteDataIn,MWritereg,MReadreg,WBreg,ALUreg,RegRDreg,WriteDataOut, EXMEMWrite); 
    input clock, rst, EXMEMWrite; 
    input WB, RegWrite; 
    input MRead, MWrite; 
    input [4:0] RegRD; 
    input [31:0] ALUOut,WriteDataIn; 
    
    output reg WBreg,RegWritereg; 
    output reg MWritereg, MReadreg ; 
    output reg[31:0] ALUreg,WriteDataOut; 
    output reg[4:0] RegRDreg; 

    always@(posedge clock, posedge rst) 
    if (rst)
    begin
        WBreg <= 0; 
        RegWritereg <= 0;         
        MReadreg <= 0;
        MWritereg <= 0;
        ALUreg <= 0; 
        RegRDreg <= 0; 
        WriteDataOut <= 0; 
    end
    else
    if (EXMEMWrite)
    begin 
        WBreg <= WB; 
        RegWritereg <= RegWrite;
        MReadreg <= MRead;
        MWritereg <= MWrite;
        ALUreg <= ALUOut; 
        RegRDreg <= RegRD; 
        WriteDataOut <= WriteDataIn; 
    end 
 
endmodule 