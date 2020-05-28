module cache (clk, rst, addr, wdata, wenable, renable, rdata, hit, mem_wenable, mem_renable, mem_wdata, mem_rdata, mem_addr, stall,stallL2, l1block) ;

input wire clk;
input wire rst;
input wire wenable, renable;
input wire [31:0] wdata, mem_rdata;
input wire [31:0] addr;
input wire [0:127] l1block; 
input stallL2;
output reg [31:0] rdata;
output reg [31:0] mem_wdata, mem_addr;
output hit, stall;
output reg mem_renable, mem_wenable;

wire index;
wire tag;
wire block;
wire hitl2;

assign hitl2 = !stallL2;

localparam stride = (1+26+4*32);

reg [0:stride-1]cacheBlock[0:3];

wire [25:0] t;
wire [1:0] k;
wire [1:0] b;

assign t = addr[31:6];
assign k = addr[5:4];
assign b = addr[3:2];

wire [0:stride-1] curRow;

assign curRow = cacheBlock[k];

wire [25:0] t_cur;
wire v_cur;
wire [31:0] D0,D1,D2,D3;

assign t_cur = curRow[1:26];
assign v_cur = curRow[0];

assign D0 = curRow[27:(27+31)];
assign D1 = curRow[(27+32):(27+32+31)];
assign D2 = curRow[(27+64):(27+64+31)];
assign D3 = curRow[(27+96):(27+96+31)];

wire tag_cmp;

assign tag_cmp = (t_cur==t);

assign hit = v_cur & tag_cmp;
assign stall = stallL2;

always @*
case (b)
    2'b00: rdata = D0;
    2'b01: rdata = D1;
    2'b10: rdata = D2;
    2'b11: rdata = D3;
endcase

wire [31:0]mask4, read_addr, r0,r1,r2,r3;
reg [2:0] counter;

assign mask4 = 32'b1111_1111_1111_1111_1111_1111_1111_0000;
assign read_addr = addr&mask4;

assign r0 = read_addr + 0;
assign r1 = read_addr + 4;
assign r2 = read_addr + 8;
assign r3 = read_addr + 12;

always @(posedge clk, posedge rst)
begin
if (rst)
    begin
        counter <= 4;
        cacheBlock[0] <=0;
        cacheBlock[1] <=0;
        cacheBlock[2] <=0;
        cacheBlock[3] <=0;
        mem_wdata <=0;
        mem_addr <=0;
        mem_renable<=0;
        mem_wenable<=0;
    end
end

always @*
if (!hit&renable)
    if (!hitl2)
    begin
        cacheBlock[k][0] = 0;
    end
    else 
    begin
        cacheBlock[k][0]=1;
        cacheBlock[k][1:26]=t_cur;
        cacheBlock[k][27:stride-1]=l1block;
    end

always @*
if (renable&!hit)
    begin
        mem_addr = addr;
        mem_wdata = wdata;
        mem_renable = 1;
        mem_wenable = 0;
    end
else if (renable&!hit)
    begin
        mem_addr = addr;
        mem_wdata = wdata;
        mem_renable = 0;
        mem_wenable = 0;
    end
else if (wenable&!hit)
    begin
        mem_addr = addr;
        mem_wdata = wdata;
        mem_renable = 0;
        mem_wenable = 1;
    end
else if (wenable&hit)       
    begin
        mem_addr = addr;
        mem_wdata = wdata;
        mem_renable = 0;
        mem_wenable = 1;
        case (b)
            2'b00: cacheBlock[k][27:(27+31)] = wdata;
            2'b01: cacheBlock[k][(27+32):(27+32+31)] = wdata;
            2'b10: cacheBlock[k][(27+64):(27+64+31)] = wdata;
            2'b11: cacheBlock[k][(27+96):(27+96+31)] = wdata;
        endcase
    end

endmodule
