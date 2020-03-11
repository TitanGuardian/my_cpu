module writeMUX (nextPC, outALU, memory, WBSrc, out);
    input [31:0] nextPC;
    input [31:0] outALU;
    input [31:0] memory;
    input [ 1:0] WBSrc;
    
    output reg [31:0] out;

    always @* begin
        case (WBSrc) 
            2'd0: out = nextPC; 
            2'd1: out = outALU;
            2'd2: out = memory;
            2'd3: out = 0;
        endcase
    end
endmodule 