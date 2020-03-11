module comDecoder (comFormat,com, opcode, rs, rt, rd, shamt, funct, imm, address);
    
    input wire [1:0] comFormat;
    
    input [31:0] com;
    
    output [5:0] opcode;
    output [4:0] rs;
    output [4:0] rt;
    output [4:0] rd;
    output [4:0] shamt;
    output [5:0] funct;
    output [15:0] imm;
    output [25:0] address;
    
    
    assign opcode = com[31:26];
    
    assign rs = (comFormat!=2'b10)?com[25:21]:0;
    assign rt = (comFormat!=2'b10)?com[20:16]:0;
    assign rd = (comFormat==2'b00)?com[15:11]:0;
    assign shamt = (comFormat==2'b00)?com[10:6]:0;
    assign funct = (comFormat==2'b00)?com[5:0]:0;
    assign imm   = (comFormat==2'b01)?com[15:0]:0;
    assign address = (comFormat==2'b10)?com[25:0]:0;

endmodule