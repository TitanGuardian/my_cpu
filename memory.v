module memory (clk, rst, addr, wdata, wenable, renable, rdata);

    input wire clk;
    input wire rst;
    input wire wenable, renable;
    input wire [31:0] wdata;
    input wire [31:0] addr;
    output reg [31:0] rdata;
    
    reg [7:0] mem [0:15];
        
    
    always @(posedge clk, posedge rst) begin
        if(rst) 
        begin
            mem[0]<=0;
            mem[1]<=0;
            mem[2]<=0;
            mem[3]<=0;
            mem[4]<=0;
            mem[5]<=0;
            mem[6]<=0;
            mem[7]<=0;
            mem[8]<=0;
            mem[9]<=0;
            mem[10]<=0;
            mem[11]<=0;
            mem[12]<=0;
            mem[13]<=0;
            mem[14]<=0;
            mem[15]<=0;
            rdata <= 0;
        end            
        else 
        begin
            if(wenable)
                {mem[addr],mem[addr+1],mem[addr+2],mem[addr+3]} <= wdata;
            if(renable)
                rdata <= {mem[addr],mem[addr+1],mem[addr+2],mem[addr+3]};
        end
    end
    
endmodule