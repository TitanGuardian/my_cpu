module writeMUX (outALU, memory, WBSrc, out);
    input [31:0] outALU;
    input [31:0] memory;
    input WBSrc;
    
    output reg [31:0] out;

    always @* begin
        case (WBSrc) 
            2'd0: out = outALU;
            2'd1: out = memory;
        endcase
    end
endmodule 