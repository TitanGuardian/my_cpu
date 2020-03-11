module instructionFlow (addr, com);
    
    input wire [31:0] addr;
    output reg [31:0] com;
    
    always @*
        case(addr)


		32'h00000000: com = 32'b100011_00000_00000_0000000000000000; //load: a0 to r0
		32'h00000004: com = 32'b001000_00000_00001_0000000000000101; //addi: r1=r0+5
		32'h00000008: com = 32'b001000_00000_00010_0000000000000101; //addi: r2=r0+5
		32'h0000000c: com = 32'b000100_00001_00010_0000000000000001; //beq: r1==r2?  
		32'h00000010: com = 32'b000010_00000000000000000000000110; //jump
		32'h00000014: com = 32'b000000_00000_00001_00010_00011_100000; //add r3 = r1 + r2;
		32'h00000018: com = 32'b101011_00000_00011_0000000000000000; //store to a1

		default: com <= 0;
	endcase 




endmodule