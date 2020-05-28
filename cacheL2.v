module cacheL2 (clk, rst, addr, wdata, wenable, renable, mem_wenable, mem_renable, mem_wdata, mem_rdata, mem_addr, stall, l1block) ;

input wire clk;
input wire rst;
input wire wenable, renable;
input wire [31:0] wdata, mem_rdata;
input wire [31:0] addr;
output reg [31:0] mem_wdata, mem_addr;
output stall;
output reg mem_renable, mem_wenable;
output [0:127] l1block;

wire index;
wire tag;
wire block;

localparam stride = (1+24+8*32); // 8 words per block

reg [0:stride-1]cacheBlock[0:7]; // 8 blocks 

wire [23:0] t;
wire [2:0] k;
wire [2:0] b;
wire hit;
assign t = addr[31:8];
assign k = addr[7:5];
assign b = addr[4:2];

wire [0:stride-1] curRow;

assign curRow = cacheBlock[k];

wire [25:0] t_cur;
wire v_cur;
//wire [31:0] D0,D1,D2,D3,D4,D5,D6,D7;

assign t_cur = curRow[1:24];
assign v_cur = curRow[0];

//assign D0 = curRow[25:(25+31)];
//assign D1 = curRow[(25+32):(25+32+31)];
//assign D2 = curRow[(25+64):(25+64+31)];
//assign D3 = curRow[(25+96):(25+96+31)];
//assign D4 = curRow[(25+128):(25+128+31)];
//assign D5 = curRow[(25+160):(25+160+31)];
//assign D6 = curRow[(25+192):(25+192+31)];
//assign D7 = curRow[(25+224):(25+224+31)];
//always @*
//case (b)
//    3'b000: rdata = D0;
//    3'b001: rdata = D1;
//    3'b010: rdata = D2;
//    3'b011: rdata = D3;
//    3'b100: rdata = D4;
//    3'b101: rdata = D5;
//    3'b110: rdata = D6;
//    3'b111: rdata = D7;
//endcase

wire tag_cmp;

assign tag_cmp = (t_cur==t);

assign hit = v_cur & tag_cmp;
assign stall = renable&!hit;

assign l1block = b[2]?curRow[stride-1 - 127:stride-1]:curRow[stride-1 - 255:stride-1-128];



wire [31:0]mask5, read_addr, r0,r1,r2,r3,r4,r5,r6,r7;
reg [4:0] counter;

assign mask5 = 32'b1111_1111_1111_1111_1111_1111_1110_0000;
assign read_addr = addr&mask5;

assign r0 = read_addr + 0;
assign r1 = read_addr + 4;
assign r2 = read_addr + 8;
assign r3 = read_addr + 12;
assign r4 = read_addr + 16;
assign r5 = read_addr + 20;
assign r6 = read_addr + 24;
assign r7 = read_addr + 28;

always @(posedge clk, posedge rst)
begin
if (rst)
    begin
        counter <= 8;
        cacheBlock[0] <=0;
        cacheBlock[1] <=0;
        cacheBlock[2] <=0;
        cacheBlock[3] <=0;
        cacheBlock[4] <=0;
        cacheBlock[5] <=0;
        cacheBlock[6] <=0;
        cacheBlock[7] <=0;
        mem_wdata <=0;
        mem_addr <=0;
        mem_renable<=0;
        mem_wenable<=0;
    end
    else if (renable&!hit)
    begin
        case (counter)
            8:begin 
                    cacheBlock[k][0]<=0;
                    counter<= counter - 1;
               end
            7: begin 
                    cacheBlock[k][27:(27+31)]<=mem_rdata;
                    cacheBlock[k][0]<=0;
                    counter<= counter - 1;
               end
            6:  begin 
                    cacheBlock[k][27+32:(27+32+31)]<=mem_rdata;
                    cacheBlock[k][0]<=0;
                    counter<= counter - 1;
                end
            5:  begin 
                    cacheBlock[k][27+64:(27+64+31)]<=mem_rdata;
                    cacheBlock[k][0]<=0;
                    counter<= counter - 1;
                end
            4:  begin 
                    cacheBlock[k][27+96:(27+96+31)]<=mem_rdata;
                    cacheBlock[k][0]<=0;
                    counter<= counter - 1;
                end
            3:  begin 
                    cacheBlock[k][27+96:(27+96+31)]<=mem_rdata;
                    cacheBlock[k][0]<=0;
                    counter<= counter - 1;
                end    
            2:  begin 
                    cacheBlock[k][27+96:(27+96+31)]<=mem_rdata;
                    cacheBlock[k][0]<=0;
                    counter<= counter - 1;
                end   
            1:  begin 
                    cacheBlock[k][27+96:(27+96+31)]<=mem_rdata;
                    cacheBlock[k][0]<=0;
                    counter<= counter - 1;
                end       
            0:  begin 
                    cacheBlock[k][27+96:(27+96+31)]<=mem_rdata;
                    cacheBlock[k][1:1+25]<=t_cur;
                    cacheBlock[k][0]<=1;
                    counter<= 8;
                end                     
        endcase
    end
    else
        counter <=8;
end

always @*
if (renable&!hit)
    begin
        mem_wdata = 0;
        mem_addr = 0;
        mem_renable = 0;
        mem_wenable = 0;
        case (counter)
            8: begin 
                mem_addr = r0; 
                mem_renable = 1;
                mem_wenable = 0;
               end
            7:  begin 
                mem_addr = r1; 
                mem_renable = 1;
                mem_wenable = 0;
                end
            6:  begin 
                mem_addr = r2; 
                mem_renable = 1;
                mem_wenable = 0;
                end
            5:  begin 
                mem_addr = r3; 
                mem_renable = 1;
                mem_wenable = 0;
                end
            4:  begin 
                mem_addr = r4; 
                mem_renable = 1;
                mem_wenable = 0;
                end
            3:  begin 
                mem_addr = r5; 
                mem_renable = 1;
                mem_wenable = 0;
                end
            2:  begin 
                mem_addr = r6; 
                mem_renable = 1;
                mem_wenable = 0;
                end
            1:  begin 
                mem_addr = r7; 
                mem_renable = 1;
                mem_wenable = 0;
                end               
        endcase
    end
else if(renable&hit)
    begin
        mem_wdata = 0;
        mem_renable = 0;
        mem_addr = 0;
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
            3'b000: cacheBlock[k][25:(25+31)] = wdata;
            3'b001: cacheBlock[k][(25+32):(25+32+31)] = wdata;
            3'b010: cacheBlock[k][(25+64):(25+64+31)] = wdata;
            3'b011: cacheBlock[k][(25+96):(25+96+31)] = wdata;
            3'b100: cacheBlock[k][(25+128):(25+128+31)] = wdata;
            3'b101: cacheBlock[k][(25+160):(25+160+31)] = wdata;
            3'b110: cacheBlock[k][(25+192):(25+192+31)] = wdata;
            3'b111: cacheBlock[k][(25+224):(25+224+31)] = wdata;            
        endcase
    end
    
    

endmodule
