module testbanch();
    reg clk, rst;
    
    initial clk = 0;
    initial rst = 1;
    initial #2 rst = 0;

    initial #120 $finish;
    always #1 clk = !clk;
    
    cpu cpu_block(clk, rst);
    
    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
    end

endmodule