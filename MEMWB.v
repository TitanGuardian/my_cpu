module MEMWB(clock,rst,WB,RegWrite, RegWritereg,Memout,ALUOut,RegRD,WBreg,Memreg,ALUreg,RegRDreg, MEMWBWrite); 
    input clock,rst,MEMWBWrite; 
    input WB, RegWrite; 
    input [4:0] RegRD; 
    input [31:0] Memout,ALUOut; 
    output reg WBreg, RegWritereg; 
    output reg [31:0] Memreg,ALUreg; 
    output reg [4:0] RegRDreg; 

    always@(posedge clock,posedge rst)
    if (rst)
    begin
        WBreg <= 0; 
        RegWritereg <= 0; 
        Memreg <= 0; 
        ALUreg <= 0; 
        RegRDreg <= 0; 
    end
    else
    if (MEMWBWrite)
    begin 
        WBreg <= WB; 
        RegWritereg <= RegWrite;
        Memreg <= Memout; 
        ALUreg <= ALUOut; 
        RegRDreg <= RegRD; 
    end 
    
endmodule 