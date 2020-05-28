module memory (clk, rst, addr, wdata, wenable, renable, rdata);

    input wire clk;
    input wire rst;
    input wire wenable, renable;
    input wire [31:0] wdata;
    input wire [31:0] addr;
    output reg [31:0] rdata;
    
    reg [7:0] mem [0:63];
        
    
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
            mem[7]<=1;
            mem[8]<=0;
            mem[9]<=0;
            mem[10]<=0;
            mem[11]<=2;
            mem[12]<=0;
            mem[13]<=0;
            mem[14]<=0;
            mem[15]<=3;
            mem[16]<=0;
            mem[17]<=0;
            mem[18]<=0;
            mem[19]<=4;
            mem[20]<=0;
            mem[21]<=0;
            mem[22]<=0;
            mem[23]<=5;
            mem[24]<=0;
            mem[25]<=0;
            mem[26]<=0;
            mem[27]<=6;
            mem[28]<=0;
            mem[29]<=0;
            mem[30]<=0;
            mem[31]<=7;
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