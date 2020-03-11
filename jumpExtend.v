module jumpExtend( in , out);
    
    input  wire [25:0] in;
    output wire [31:0] out;
    
    assign out = {6'b000000, in};
endmodule
