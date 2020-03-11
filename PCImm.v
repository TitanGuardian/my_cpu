module PCImm (pc, imm, out);
    input signed [31:0] pc;
    input signed [31:0] imm;
    output [31:0] out;

    assign out = pc + imm*4;

    
endmodule 