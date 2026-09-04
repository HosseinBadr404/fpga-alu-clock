`timescale 1ns / 1ps

module Clock(
    input clk,
    input rst,
    input tick_1s,
    
    input set_mode,
    input [2:0] sel_field,
    input inc_key,
    
    output reg [5:0] sec,
    output reg [5:0] min,
    output reg [4:0] hour,
    output reg [4:0] day,
    output reg [3:0] mon,
    output reg [11:0] year
);
    localparam SEL_SEC = 0;
    localparam SEL_MIN = 1;
    localparam SEL_HOUR = 2;
    localparam SEL_DAY = 3;
    localparam SEL_MON = 4;
    localparam SEL_YEAR = 5;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sec <= 0;
            min <= 0;
            hour <= 12;
            day <= 1;
            mon <= 1;
            year <= 1404;
        end
        else begin
            if (set_mode) begin
                if (inc_key) begin
                    case (sel_field)
                        SEL_SEC: begin
                            if (sec == 59) sec <= 0;
                            else sec <= sec + 1;
                        end
                        SEL_MIN: begin
                            if (min == 59) min <= 0;
                            else min <= min + 1;
                        end
                        SEL_HOUR: begin
                            if (hour == 23) hour <= 0;
                            else hour <= hour + 1;
                        end
                        SEL_DAY: begin
                            if (day == 30) day <= 1;
                            else day <= day + 1;
                        end
                        SEL_MON: begin
                            if (mon == 12) mon <= 1;
                            else mon <= mon + 1;
                        end
                        SEL_YEAR: begin
                            year <= year + 1;
                        end
                    endcase
                end
            end
            
            else if (tick_1s) begin
                if (sec == 59) begin
                    sec <= 0;
                    if (min == 59) begin
                        min <= 0;
                        if (hour == 23) begin
                            hour <= 0;
                            if (day == 30) begin
                                day <= 1;
                                if (mon == 12) begin
                                    mon <= 1;
                                    year <= year + 1;
                                end
                                else begin
                                    mon <= mon + 1;
                                end
                            end
                            else begin
                                day <= day + 1;
                            end
                        end
                        else begin
                            hour <= hour + 1;
                        end
                    end
                    else begin
                        min <= min + 1;
                    end
                end
                else begin
                    sec <= sec + 1;
                end
            end
        end
    end

endmodule