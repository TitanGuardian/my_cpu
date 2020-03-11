module immExtend (imm, ExtSel, out);
    input [15:0] imm;
    input ExtSel;
    output [31:0] out;
    assign out = ExtSel?{{16{imm[15]}},imm[15:0]}:{{16{1'b0}},imm[15:0]};
endmodule 