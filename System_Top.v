`timescale 1ns / 1ps

module System_Top(
    input clk,
    input rst,
    input btn_mode,
    input btn_action,
    input btn_set,
    input [3:0] sw_op,
    input [7:0] sw_a,
    input [7:0] sw_b,
    input [2:0] sw_sel,
    
    output [6:0] seg_out,
    output [3:0] an_out,
    output [3:0] led_state
);
    localparam ST_IDLE       = 3'd0;
    localparam ST_CLOCK_SHOW = 3'd1;
    localparam ST_CLOCK_SET  = 3'd2;
    localparam ST_CALC_INPUT = 3'd3;
    localparam ST_CALC_EXEC  = 3'd4;
    localparam ST_CALC_SHOW  = 3'd5;
    localparam ST_ERR        = 3'd6;

    reg [2:0] current_state, next_state;

    wire alu_rdy;
    wire [7:0] alu_out_8bit;
    wire [15:0] alu_res_16bit;
    wire [4:0] alu_f;
    reg alu_start_sig;

    wire [5:0] w_sec, w_min;
    wire [4:0] w_hour, w_day;
    wire [3:0] w_mon;
    wire [11:0] w_year;
    
    reg clk_set_en;
    reg clk_inc_sig;
    reg tick_gen;
    reg [25:0] cnt_1s;

    reg [1:0] disp_mode_sig;

    // اتصال ALU
    ALU_Main #(.N(8)) unit_alu (
        .clk(clk),
        .rst(rst),
        .start(alu_start_sig),
        .op(sw_op),
        .a(sw_a),
        .b(sw_b),
        .ready(alu_rdy),
        .y(alu_out_8bit),
        .flags(alu_f)
    );

    assign alu_res_16bit = {{8{alu_out_8bit[7]}}, alu_out_8bit};

    Clock unit_clk (
        .clk(clk),
        .rst(rst),
        .tick_1s(tick_gen),
        .set_mode(clk_set_en),
        .sel_field(sw_sel),
        .inc_key(clk_inc_sig),
        .sec(w_sec),
        .min(w_min),
        .hour(w_hour),
        .day(w_day),
        .mon(w_mon),
        .year(w_year)
    );

    Display unit_disp (
        .clk(clk),
        .rst(rst),
        .sys_mode(disp_mode_sig),
        .alu_data(alu_res_16bit),
        .alu_flags(alu_f),
        .t_sec(w_sec),
        .t_min(w_min),
        .t_hour(w_hour),
        .an(an_out),
        .seg(seg_out)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_1s <= 0;
            tick_gen <= 0;
        end else begin
            if (cnt_1s >= 5) begin 
                cnt_1s <= 0;
                tick_gen <= 1;
            end else begin
                cnt_1s <= cnt_1s + 1;
                tick_gen <= 0;
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= ST_IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        alu_start_sig = 0;
        clk_set_en = 0;
        clk_inc_sig = 0;
        disp_mode_sig = 0;

        case (current_state)
            ST_IDLE: begin
                next_state = ST_CLOCK_SHOW;
            end

            ST_CLOCK_SHOW: begin
                disp_mode_sig = 2'b01;
                if (btn_mode) next_state = ST_CALC_INPUT;
                else if (btn_set) next_state = ST_CLOCK_SET;
            end

            ST_CLOCK_SET: begin
                disp_mode_sig = 2'b10;
                clk_set_en = 1;
                if (btn_action) clk_inc_sig = 1;
                if (btn_set) next_state = ST_CLOCK_SHOW;
            end

            ST_CALC_INPUT: begin
                disp_mode_sig = 2'b00;
                if (btn_action) next_state = ST_CALC_EXEC;
                else if (btn_mode) next_state = ST_CLOCK_SHOW;
            end

            ST_CALC_EXEC: begin
                disp_mode_sig = 2'b00;
                alu_start_sig = 1;
                if (alu_rdy) begin
                    if (alu_f[0])
                        next_state = ST_ERR;
                    else
                        next_state = ST_CALC_SHOW;
                end
            end

            ST_CALC_SHOW: begin
                disp_mode_sig = 2'b00;
                if (btn_action) next_state = ST_CALC_INPUT;
                else if (btn_mode) next_state = ST_CLOCK_SHOW;
            end

            ST_ERR: begin
                disp_mode_sig = 2'b00;
                if (btn_action) next_state = ST_CALC_INPUT;
                else if (btn_mode) next_state = ST_CLOCK_SHOW;
            end
            
            default: next_state = ST_IDLE;
        endcase
    end
    
    assign led_state = {1'b0, current_state};

endmodule