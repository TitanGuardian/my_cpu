module regWriteMUX (r2,r3, RegDst, wn);
    input [4:0] r2;
    input [4:0] r3;
    input [1:0]RegDst;
   
    output reg[4:0] wn;
    
    always @* begin
        wn = 5'd31;
        case (RegDst)
        2'b01: wn = r3;
        2'b10: wn = r2;
        endcase
    end
endmodule 