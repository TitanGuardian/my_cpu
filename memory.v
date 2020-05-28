module memory (clk, rst, addr, wdata, wenable, renable, rdata);

    input wire clk;
    input wire rst;
    input wire wenable, renable;
    input wire [31:0] wdata;
    input wire [31:0] addr;
    output reg [31:0] rdata;
    
    reg [7:0] mem [0:1023];
    
    integer i;
    
    always @(posedge clk, posedge rst) begin
        if(rst) 
        begin
            for (i=0;i<1024;i = i +4) 
            begin
                mem[i+0]<=0;
                mem[i+1]<=0;
                mem[i+2]<=0;
                mem[i+3]<=i;
            end
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