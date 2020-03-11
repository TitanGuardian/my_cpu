module ALUdecoder (funct, OpSel, aluControl);

    input wire [5:0] funct; 
    input wire [3:0] OpSel;
    
    output reg [5:0] aluControl;

    always @* begin
        case(OpSel)
            4'b0000: aluControl = funct; // signed bin operations with funct
            4'b1010: aluControl = 6'b001110; // load
            4'b1011: aluControl = 6'b011110; //save
            4'b1100: aluControl = 6'b000000; //beq
            default: aluControl = {3'b100, OpSel[2:0]}; // arifm operations without funct
        endcase
    end	
    
endmodule
