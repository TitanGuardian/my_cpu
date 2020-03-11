module regImmMUX (r2, imm, BSrc , out);
    input [31:0] r2;
    input [31:0] imm;
    input BSrc;
    output [31:0] out;
    
    assign out = BSrc? imm : r2;

endmodule 