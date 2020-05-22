module cpu (input clk, input rst);
    
    wire [1:0] PCSrc;
    wire RegWrite;
    wire MemWrite;
    wire MemRead;
    wire [1:0] RegDst;
    wire ExtSel;
    wire [3:0]OpSel;
    wire BSrc;
    wire WBSrc;
    wire [1:0] comFormat;  
    wire [5:0] OpCode;
    wire zero;
 
    controlFlow control_flow_block(OpCode, zero, PCSrc, RegDst, RegWrite, ExtSel, OpSel, BSrc, MemWrite, MemRead, WBSrc, comFormat);
    dataFlow data_flow_block (clk, rst, comFormat, PCSrc, RegWrite, MemWrite, MemRead, RegDst, ExtSel, OpSel, BSrc, WBSrc, OpCode, zero);
endmodule
    