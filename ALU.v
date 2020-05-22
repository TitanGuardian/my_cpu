module ALU (in1,in2, aluControl,  out);

    input wire [31:0] in1; 
    input wire [31:0] in2;
    input wire [5:0] aluControl;

    
    input wire [ 5:0] opcode;

    output reg [31:0] out;
    
    wire signed [31:0] in1signed; 
    assign in1signed = in1;
    
    wire signed [31:0] in2signed; 
    assign in2signed = in2; 
    

    wire signed [31:0] in1prepared; 
    assign in1prepared = aluControl[0]?in1:in1signed;
    
    wire signed [31:0] in2prepared; 
    assign in2prepared = aluControl[0]?in2:in2signed; 

    wire [31:0] sum, sub;
    
    assign sub = in1prepared-in2prepared;
    assign sum = in1prepared+in2prepared;

    always @* begin
        if (aluControl[5])
            begin
                if (aluControl[1])
                    out = sub; // sub subu subi subiu
                else
                    out = sum; //addu addi addiu
            end
        else    
            begin
                case (aluControl[4:1]) 
                5'b0111: out = sum; //load
                5'b1111: out = sum; // save  
                5'b0000: out = sub; // beq 
                endcase
                
            end
    end	
endmodule