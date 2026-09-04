`timescale 1ns / 1ps

module tb_System;

    reg clk, rst;
    reg b_mode, b_act, b_set;
    reg [3:0] s_op;
    reg [7:0] s_a, s_b;
    reg [2:0] s_sel;
    
    wire [6:0] seg;
    wire [3:0] an;
    wire [3:0] leds;

    System_Top uut (
        .clk(clk), .rst(rst),
        .btn_mode(b_mode), .btn_action(b_act), .btn_set(b_set),
        .sw_op(s_op), .sw_a(s_a), .sw_b(s_b), .sw_sel(s_sel),
        .seg_out(seg), .an_out(an), .led_state(leds)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; 
        b_mode = 0; b_act = 0; b_set = 0; 
        s_a = 0; s_b = 0; s_op = 0; s_sel = 0;
        #20 rst = 0;

        #50;

        b_mode = 1; #20 b_mode = 0;
        #20;

        s_a = 15; 
        s_b = 5;
        s_op = 4'b0000;
        #20;

        b_act = 1; #20 b_act = 0;
        
        #200;

        b_act = 1; #20 b_act = 0;
        #20;

        s_a = 20;
        s_b = 0;
        s_op = 4'b0011;
        #20;

        b_act = 1; #20 b_act = 0;
        
        #200;
        
        b_mode = 1; #20 b_mode = 0; 

        #100 $stop;
    end

endmodule