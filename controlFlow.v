module controlFlow (OpCode, zero, PCSrc, RegDst, RegWrite, ExtSel, OpSel, BSrc, MemWrite, WBSrc, comFormat) ;

    // mem access bit OpCode[5]
    // mem access format == 01
    // format with OpCode[5] || OpCode[3,2] || OpCode[1:0]==01 is 01

    // format with OpCode[5:1] == 00001 is 10
    
    //else format == 00;
    

    input wire[5:0] OpCode;
    input wire zero;

    output reg[1:0] PCSrc   ; 
    output reg      RegWrite;
    output reg      ExtSel  ;
    output reg[3:0] OpSel   ;
    output reg[1:0] RegDst   ;
    output reg      BSrc    ;   
    output reg      MemWrite;
    output reg[1:0] WBSrc;  
    output    [1:0] comFormat;  
    
    
    
    assign comFormat = (OpCode[5] || OpCode[3] || OpCode[2] || (OpCode[1:0]==2'b01))
        ?   
            2'b01
        :
            (OpCode[5:1] == 5'b00001 
            ?
                2'b10  
            :
                2'b00
            );
    

    // PCSrc
    always@* begin
        PCSrc = 2'b00;
        case (OpCode)
        6'b000010: PCSrc = 2'b01;
        6'b000100: if (zero) PCSrc = 2'b10; else PCSrc = 2'b00;
        endcase
    end
    
    // RegDst
    always@* begin
        RegDst = 2'b01;
        if (OpCode[3])
            RegDst = 2'b10;
        if (OpCode==6'b000001 || OpCode[5:1] == 5'b00001)
            RegDst = 2'b00;
    end


    // RegWrite
    always@* begin
        RegWrite = 1;
        case (OpCode)
        6'b101011: RegWrite = 0;
        6'b000010: RegWrite = 0;
        6'b000100: RegWrite = 0;
        endcase
    end


    // ExtSel
    always@* begin
        ExtSel = 0;
        case (OpCode)
        6'b001000: ExtSel = 1;	
        6'b001010: ExtSel = 1;
        endcase
    end


    // OpSel
    always@* begin
        OpSel = 4'b0000;
        if (comFormat==2'b01) OpSel = OpCode[3:0];
        case (OpCode)
        6'b101011: OpSel = 4'b1011;       
        6'b100011: OpSel = 4'b1010;       
        6'b000100: OpSel = 4'b0010;
        endcase
    end

    //BSrc
    always@* begin
        BSrc = OpCode[3];
        case (OpCode)
        6'b000100: BSrc = 0;        
        endcase
    end



    // MemWrite
    always@* begin
        MemWrite = 0;
        case (OpCode)
        6'b101011: MemWrite = 1;        
        endcase
    end


    // WBSrc
    always@* begin
        WBSrc = 2'd1;
        case (OpCode)
        6'b100011: WBSrc = 2'd2;
        endcase
    end

endmodule
