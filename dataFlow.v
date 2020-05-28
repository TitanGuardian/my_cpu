module dataFlow (clk, rst, comFormat, PCSrc, RegWrite, MemWrite, MemRead, RegDst, ExtSel, OpSel, BSrc, WBSrc, OpCode, zero);

    input clk;
    input rst;
    input [1:0] PCSrc;
    input RegWrite;
    input MemWrite;
    input MemRead;
    input [1:0] RegDst;
    input ExtSel;
    input [3:0]OpSel;
    input BSrc;
    input WBSrc;
    input [1:0] comFormat;

    output [5:0] OpCode;
    output zero;
    
    wire [31:0]pc_next;
    wire [31:0]pc_curr;
    wire [31:0]command, InstReg;
    wire [5:0] opcode;  
    wire [31:0] pc4, PC_Plus4Reg;
    wire [4:0] rs, EXRs ;
    wire [4:0] rt, EXRt ;
    wire [4:0] rd, EXRd ;
    wire [4:0] shamt;
    wire [5:0] funct;
    wire [15:0] imm;
    wire [25:0] address;
    wire [31:0] branching;
    wire [31:0] jumping;
    wire [31:0] write_data;
    wire [31:0] rsdata, DataAreg;
    wire [31:0] rtdata, DataBreg, DataBnew;
    wire [31:0] imm_extended, imm_valuereg;
    wire [4:0] wdest;
    wire [5:0] aluControl, EX_aluControl;
    wire [10:0]control, haz_control;
    wire EXBSrc;
    wire [1:0]EXRegDst;
    wire [3:0]EXOpSel;
    wire[31:0] alu_in1;
    wire[31:0] alu_in2;
    wire[31:0] alu_out, MEM_alu_out, MEM_write_data, WB_alu_out;
    wire  [4:0] MEM_rd, WB_rd;
    wire [31:0] read_data, WB_mem_out;
    wire [31:0] muxout;
    wire mem_wenable, mem_renable;
    wire [31:0] mem_wdata, mem_rdata, mem_addr;
    wire stall, hit;
    wire [1:0] ForwardA,ForwardB;
    wire HazMuxCon, PCWrite, IFIDWrite, IDEXWrite, EXMEMWrite, MEMWBWrite;
    
    
    assign OpCode = opcode;
    assign IFFlush = (PCSrc!=2'b00); 
    assign control[0] = RegWrite;
    assign control[1] = MemWrite;
    assign control[2] = MemRead;
    assign control[6:3] = OpSel;
    assign control[7] = BSrc;
    assign control[9:8] = RegDst;
    assign control[10] = WBSrc;
    assign haz_control = HazMuxCon? control : 0;    
    assign zero = (rsdata==rtdata);
    
    PC pc_block(.clk(clk), 
                .rst(rst), 
                .newPC(pc_next), 
                .pc(pc_curr), 
                .PCWrite(PCWrite)
                );
    //FIRST STAGE
    
    instructionFlow instruction_block(  .addr(pc_curr), 
                                        .com(command)
                                        );
    
    PCinc4 pc4_block(.in(pc_curr), 
                     .out(pc4)
                     ); 

    IFID ifid ( .rst(rst), 
                .flush(IFFlush), 
                .clock(clk), 
                .IFIDWrite(IFIDWrite), 
                .PC_Plus4(pc4), 
                .Inst(command), 
                .InstReg(InstReg),
                .PC_Plus4Reg(PC_Plus4Reg)
                );
    
    //SECOND STAGE
    comDecoder decoder_block(.com(InstReg), 
                             .comFormat(comFormat), 
                             .opcode(opcode), 
                             .rs(rs), 
                             .rd(rd), 
                             .rt(rt), 
                             .shamt(shamt), 
                             .funct(funct), 
                             .imm(imm), 
                             .address(address)
                             );
    
    jumpExtend jumpExtend_block(.in(address), 
                                .out(jumping)
                                );
    
    PCmux pcmux_block(.br(branching), 
                      .jump(jumping), 
                      .pc4(pc4), 
                      .PCSrc(PCSrc), 
                      .out(pc_next)
                      );
    
    immExtend extend_block(.imm(imm), 
                           .ExtSel(ExtSel), 
                           .out(imm_extended)
                           );
                           
    ALUdecoder alu_dec_block (.funct(funct), 
                              .OpSel(OpSel), 
                              .aluControl(aluControl)
                              );
    
    registerBlock register_block(.clk(clk), 
                                 .rst(rst), 
                                 .r1(rs), 
                                 .r2(rt), 
                                 .wdest(WB_rd), 
                                 .write(WB_RegWrite),
                                 .wdata(muxout), 
                                 .r1value(rsdata), 
                                 .r2value(rtdata)
                                 );
                        
    IDEX idex(  .clock(clk),
                .rst(rst), 
                .WB(haz_control[10]), 
                .RegWrite(haz_control[0]), 
                .MWrite(haz_control[1]), 
                .MRead(haz_control[2]),
                .OPSEL(haz_control[6:3]), 
                .BSRC(haz_control[7]), 
                .RegDst(haz_control[9:8]),
                .DataA(rsdata),
                .DataB(rtdata),
                .imm_value(imm_extended), 
                .RegRs(rs),
                .RegRt(rt),
                .RegRd(rd), 
                .aluControl(aluControl), 
                .WBreg(EX_WB),
                .MWritereg(EX_MWrite), 
                .MReadreg(EXMRead), 
                .OPSELreg(EXOpSel), 
                .BSRCreg(EXBSrc),
                .RegDstreg(EXRegDst), 
                .DataAreg(DataAreg), 
                .DataBreg(DataBreg), 
                .imm_valuereg(imm_valuereg), 
                .RegRsreg(EXRs), 
                .RegWritereg(EX_RegWrite), 
                .RegRtreg(EXRt), 
                .RegRdreg(EXRd), 
                .aluControlreg(EX_aluControl),
                .IDEXWrite(IDEXWrite)
                );
    
    //THIRD STAGE                            

    regWriteMUX regWriteMUX_block (.r2(EXRt), 
                                   .r3(EXRd), 
                                   .RegDst(EXRegDst), 
                                   .wn(wdest)
                                   );
    
    regImmMUX regimmChoose_block (.r2(DataBnew), 
                                  .imm(imm_valuereg), 
                                  .BSrc(EXBSrc), 
                                  .out(alu_in2)
                                  );

    ALU ALU_block(.in1(alu_in1), 
                  .in2(alu_in2), 
                  .aluControl(EX_aluControl), 
                  .out(alu_out)
                  );
    
    PCImm PCImm_block(.pc(pc_curr), 
                      .imm(imm_extended), 
                      .out(branching)
                      );
    
    EXMEM exmem (.clock(clk), 
                 .rst(rst),  
                 .WB(EX_WB), 
                 .RegWrite(EX_RegWrite), 
                 .MWrite(EX_MWrite), 
                 .MRead(EXMRead), 
                 .ALUOut(alu_out),
                 .RegRD(wdest), 
                 .WriteDataIn(DataBnew), 
                 .MWritereg(MEM_MWrite), 
                 .MReadreg(MEM_MRead), 
                 .WBreg(MEM_WB), 
                 .ALUreg(MEM_alu_out), 
                 .RegRDreg(MEM_rd), 
                 .WriteDataOut(MEM_write_data), 
                 .RegWritereg(MEM_RegWrite),
                 .EXMEMWrite(EXMEMWrite)
                 );
    
    // 4th stage
    
    cache cacheBlock(.clk(clk), 
                     .rst(rst), 
                     .addr(MEM_alu_out), 
                     .wdata(MEM_write_data), 
                     .wenable(MEM_MWrite), 
                     .renable(MEM_MRead), 
                     .rdata(read_data),
                     .stall(stall),
                     .hit(hit),
                     .mem_wenable(mem_wenable), 
                     .mem_renable(mem_renable), 
                     .mem_wdata(mem_wdata), 
                     .mem_rdata(mem_rdata), 
                     .mem_addr(mem_addr)
                     );
    
    memory memory_block( .clk(clk), 
                         .rst(rst), 
                         .addr(mem_addr), 
                         .wdata(mem_wdata), 
                         .wenable(mem_wenable), 
                         .renable(mem_renable), 
                         .rdata(mem_rdata)
                         );
    
    MEMWB memwb( .clock(clk),
                 .rst(rst),
                 .WB(MEM_WB), 
                 .RegWrite(MEM_RegWrite), 
                 .Memout(read_data), 
                 .ALUOut(MEM_alu_out), 
                 .RegRD(MEM_rd), 
                 .WBreg(WB_WB),
                 .RegWritereg(WB_RegWrite),
                 .Memreg(WB_mem_out), 
                 .ALUreg(WB_alu_out), 
                 .RegRDreg(WB_rd),
                 .MEMWBWrite(MEMWBWrite)
                 ); 
    
    // 5th stage
    
    writeMUX write_mux_block ( .outALU(WB_alu_out), 
                               .memory(WB_mem_out), 
                               .WBSrc(WB_WB), 
                               .out(muxout)
                               );
    
    // hazard unit
    HazardUnit HU(  .IDRegRs(rs),
                    .IDRegRt(rt),
                    .EXRegRt(EXRt), 
                    .EXMemRead(EXMRead), 
                    .stall(stall),
                    .PCWrite(PCWrite), 
                    .IFIDWrite(IFIDWrite), 
                    .IDEXWrite(IDEXWrite), 
                    .EXMEMWrite(EXMEMWrite), 
                    .MEMWBWrite(MEMWBWrite), 
                    .HazMuxCon(HazMuxCon)
                    );
   
    //forwarding unit
    
    BIGMUX2 MUX0(ForwardA,DataAreg,muxout,MEM_alu_out,0,alu_in1); 
    BIGMUX2 MUX1(ForwardB,DataBreg,muxout,MEM_alu_out,0,DataBnew);

    Forward forwarding_unit (.MEMRegRd(MEM_rd),
                             .WBRegRd(WB_rd),
                             .EXRegRs(EXRs), 
                             .EXRegRt(EXRt), 
                             .MEM_RegWrite(MEM_RegWrite), 
                             .WB_RegWrite(WB_RegWrite), 
                             .ForwardA(ForwardA), 
                             .ForwardB(ForwardB)
                             ) ;

endmodule