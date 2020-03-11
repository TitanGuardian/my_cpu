module dataFlow (clk, rst, comFormat, PCSrc, RegWrite, MemWrite, RegDst, ExtSel, OpSel, BSrc, WBSrc, OpCode, zero);

    input clk;
    input rst;
    input [1:0] PCSrc;
    input RegWrite;
    input MemWrite;
    input [1:0] RegDst;
    input ExtSel;
    input [3:0]OpSel;
    input BSrc;
    input [1:0] WBSrc;
    input [1:0] comFormat;

    output [5:0] OpCode;
    output zero;
    

    wire [31:0]pc_next;
    wire [31:0]pc_curr;
    
    PC pc_block(.clk(clk), .rst(rst), .newPC(pc_next), .pc(pc_curr));
    
    wire [31:0]command;
    
    instructionFlow instruction_block(.addr(pc_curr), .com(command));
    
    wire [5:0] opcode;
    assign OpCode = opcode;
    
    
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;

    wire [4:0] shamt;
    wire [5:0] funct;
    wire [15:0] imm;
    wire [25:0] address;
    
    comDecoder decoder_block(.com(command), .comFormat(comFormat), .opcode(opcode), .rs(rs), .rd(rd) 
                    , .rt(rt), .shamt(shamt), .funct(funct), .imm(imm), .address(address));

    wire [31:0] pc4;

    PCinc4 pc4_block(.in(pc_curr), .out(pc4)); 
    
    wire [31:0] branching;
    wire [31:0] jumping;
   

    jumpExtend jumpExtend_block(.in(address), .out(jumping));
   
    PCmux pcmux_block(.br(branching), .jump(jumping), .pc4(pc4), .PCSrc(PCSrc), .out(pc_next));
    
    
    wire [31:0] write_data;
    wire [31:0] rsdata;
    wire [31:0] rtdata;
    
    wire [31:0] imm_extended;
    
    immExtend extend_block(.imm(imm), .ExtSel(ExtSel), .out(imm_extended));
    
    wire [4:0] wdest;
    
    regWriteMUX regWriteMUX_block (.r2(rt), .r3(rd), .RegDst(RegDst), .wn(wdest));
    
    
    registerBlock register_block(.clk(clk), .rst(rst), .r1(rs), .r2(rt), .wdest(wdest), .write(RegWrite),
                                .wdata(write_data), .r1value(rsdata), .r2value(rtdata));
    wire[31:0] alu_in1;
    
    wire[31:0] alu_in2;
    
    assign alu_in1 = rsdata;
    
    
    regImmMUX regimmChoose_block(.r2(rtdata), .imm(imm_extended), .BSrc(BSrc), .out(alu_in2));
    
    wire [5:0] aluControl;
    
    ALUdecoder alu_dec_block (.funct(funct), .OpSel(OpSel), .aluControl(aluControl));
    
    
    wire[31:0] alu_out; 
    
    ALU ALU_block(.in1(alu_in1), .in2(alu_in2), .aluControl(aluControl), .isZero(zero), .out(alu_out));
    
    
    PCImm PCImm_block(.pc(pc_curr), .imm(imm_extended), .out(branching));
    
    wire [31:0] read_data;
    
    memory memory_block(.clk(clk), .rst(rst), .addr(alu_out), .wdata(rtdata), .wenable(MemWrite), .rdata(read_data));
    
    writeMUX write_mux_block (.nextPC(pc4), .outALU(alu_out), .memory(read_data), .WBSrc(WBSrc), .out(write_data));
    
endmodule