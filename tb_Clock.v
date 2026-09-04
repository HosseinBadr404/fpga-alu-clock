`timescale 1ns / 1ps

module tb_Clock;

    reg clk;
    reg rst;
    reg tick;
    reg mode;
    reg [2:0] sel;
    reg inc;
    
    wire [5:0] ss, mm;
    wire [4:0] hh, dd;
    wire [3:0] mo;
    wire [11:0] yy;

    Clock uut (
        .clk(clk),
        .rst(rst),
        .tick_1s(tick),
        .set_mode(mode),
        .sel_field(sel),
        .inc_key(inc),
        .sec(ss), .min(mm), .hour(hh),
        .day(dd), .mon(mo), .year(yy)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; tick = 0; mode = 0; sel = 0; inc = 0;
        #20 rst = 0;

	repeat(70) begin
            #10 tick = 1;
            #10 tick = 0;
        end

	#50;
	mode = 1;
	sel = 1; 
        repeat(3) begin
            #20 inc = 1;
            #20 inc = 0; 
        end
	sel = 2;
        repeat(2) begin
            #20 inc = 1;
            #20 inc = 0;
        end
	sel = 3;
        repeat(2) begin
            #20 inc = 1;
            #20 inc = 0;
        end
	sel = 4;
        repeat(2) begin
            #20 inc = 1;
            #20 inc = 0;
        end
	sel = 5;
        repeat(4) begin
            #20 inc = 1;
            #20 inc = 0;
        end
        mode = 0;
	repeat(5) begin
            #10 tick = 1;
            #10 tick = 0;
        end
        #100 $stop;
    end

endmodule