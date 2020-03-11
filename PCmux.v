module PCmux (br, jump, pc4, PCSrc, out);
    input [31:0] br;
    input [31:0] jump;
    input [31:0] pc4;
    input [ 1:0] PCSrc;
    
    output reg [31:0] out;

    always @* begin
        case (PCSrc) 
            2'd0: out = pc4; 
            2'd1: out = jump<<2;
            2'd2: out = br;
            2'd3: out = 0;
        endcase
    end
endmodule 