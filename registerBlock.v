module registerBlock ( clk, rst, r1, r2, write, wdest, wdata , r1value, r2value);
    
    localparam regBits = 5;
    localparam regCount = 2**regBits;
    localparam regWidth = 32;
    
    input wire clk;
    input wire rst;
    input wire [regBits-1:0] r1, r2;
    input wire write;
    input wire [regBits-1:0] wdest;
    input wire [regWidth-1:0] wdata;
    
    output reg [regWidth-1:0] r1value;
    output reg [regWidth-1:0] r2value;
    
    /* regFile */
    reg[regWidth-1:0] registers[0:regCount-1];    
    
    always @* begin
        r1value = registers[r1];
        r2value = registers[r2];
    end
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            registers[0] = 0;
            registers[1] = 0;
            registers[2] = 0;
            registers[3] = 0;
            registers[4] = 0;
            registers[5] = 0;
            registers[6] = 0;
            registers[7] = 0;
            registers[8] = 0;
            registers[9] = 0;
            registers[10] = 0;
            registers[11] = 0;
            registers[12] = 0;
            registers[13] = 0;
            registers[14] = 0;
            registers[15] = 0;
            registers[16] = 0;
            registers[17] = 0;
            registers[18] = 0;
            registers[19] = 0;
            registers[20] = 0;
            registers[21] = 0;
            registers[22] = 0;
            registers[23] = 0;
            registers[24] = 0;
            registers[25] = 0;
            registers[26] = 0;
            registers[27] = 0;
            registers[28] = 0;
            registers[29] = 0;
            registers[30] = 0;
            registers[31] = 0;
        end
        else
        if (write) begin
            registers[wdest] <= wdata;
        end
    end
    
endmodule
    