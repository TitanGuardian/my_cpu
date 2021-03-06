module PC (clk, rst, newPC, pc, PCWrite);
    
    localparam counterWidth = 32;
     
    input wire clk;
    input wire rst;
    input wire PCWrite;
    input wire[counterWidth-1:0] newPC;
    
    output wire[counterWidth-1:0] pc;
    
   
    reg[counterWidth-1:0]  programCounter;
    
    assign pc = programCounter;
    
    always @(posedge clk, posedge rst) begin
    if (rst) 
        programCounter <= 0;
    else 
        if (PCWrite)
            programCounter <= newPC;
    end
    
    
endmodule
    