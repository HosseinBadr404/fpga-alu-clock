`timescale 1ns / 1ps

module tb_ALU;

    reg clk, rst, start;
    reg [3:0] op;
    reg signed [7:0] a, b;
    
    wire ready;
    wire signed [7:0] y;
    wire [4:0] flags;

    ALU_Main #(.N(8)) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .op(op),
        .a(a),
        .b(b),
        .ready(ready),
        .y(y),
        .flags(flags)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; start = 0; a = 0; b = 0; op = 0;
        #15 rst = 0;

        #10 a = 20; b = 30; op = 4'b0000; start = 1; 
        #10 start = 0; wait(ready);
        
        #10 a = 100; b = 30; op = 4'b0000; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 50; b = 60; op = 4'b0001; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 10; b = 5; op = 4'b0010; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 100; b = 5; op = 4'b0011; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 50; b = 0; op = 4'b0011; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 100; b = 6; op = 4'b0100; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 8'b10101010; b = 8'b00001111; op = 4'b0101; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 8'b10101010; b = 8'b00001111; op = 4'b0110; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 8'b10101010; b = 8'b00001111; op = 4'b0111; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 8'b10101010; b = 0; op = 4'b1000; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 8'b00000011; b = 2; op = 4'b1001; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 8'b11000000; b = 2; op = 4'b1010; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 15; b = 15; op = 4'b1011; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 20; b = 10; op = 4'b1100; start = 1; 
        #10 start = 0; wait(ready);

        #10 a = 20; b = 10; op = 4'b1101; start = 1; 
        #10 start = 0; wait(ready);

        #100 $stop;
    end

endmodule