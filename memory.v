module memory (clk, rst, addr, wdata, wenable, rdata);

    input wire clk;
    input wire rst;
    input wire wenable;
    input wire [31:0] wdata;
    input wire [31:0] addr;
    output wire [31:0] rdata;
    
    reg [31:0] mem [127:0];
    
    assign rdata = mem[addr];
    
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            mem[0]=0;
            mem[1]=0;
            mem[2]=0;
        end            
        else 
            if(wenable) 
                mem[addr] = wdata; 
    end
    
endmodule