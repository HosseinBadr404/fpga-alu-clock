`timescale 1ns / 1ps

module ALU_Main #(
    parameter N = 8
)(
    input clk,
    input rst,
    input start,
    input [3:0] op,
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    
    output reg ready,
    output reg signed [N-1:0] y,
    output reg [4:0] flags
);

    localparam S = $clog2(N);
    reg [N:0] tmp_arith;
    reg z, c, v, s, e;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 0;
            flags <= 0;
            ready <= 0;
            c = 0; v = 0; s = 0; z = 0; e = 0;
        end 
        else begin
            if (start) begin
                c = 0;
                v = 0;
                e = 0;
                
                case (op)
                    4'b0000: begin
                        tmp_arith = a + b;
                        y <= tmp_arith[N-1:0];
                        c = tmp_arith[N];
                        v = (a[N-1] & b[N-1] & ~tmp_arith[N-1]) | (~a[N-1] & ~b[N-1] & tmp_arith[N-1]);
                    end
                    4'b0001: begin
                        tmp_arith = a - b;
                        y <= tmp_arith[N-1:0];
                        c = tmp_arith[N];
                        v = (a[N-1] & ~b[N-1] & ~tmp_arith[N-1]) | (~a[N-1] & b[N-1] & tmp_arith[N-1]);
                    end
                    4'b0010: begin
                        tmp_arith = a * b;
                        y <= tmp_arith[N-1:0];
                    end
                    4'b0011: begin
                        if (b == 0) begin
                            y <= 0;
                            e = 1;
                        end else begin
                            y <= a / b;
                        end
                    end
                    4'b0100: begin
                        if (b == 0) begin
                            y <= 0;
                            e = 1;
                        end else begin
                            y <= a % b;
                        end
                    end
                    4'b0101: y <= a & b;
                    4'b0110: y <= a | b;
                    4'b0111: y <= a ^ b;
                    4'b1000: y <= ~a;
                    4'b1001: y <= a << b[S-1:0];
                    4'b1010: y <= a >> b[S-1:0];
                    4'b1011: y <= (a == b) ? 1 : 0;
                    4'b1100: y <= (a > b)  ? 1 : 0;
                    4'b1101: y <= (a < b)  ? 1 : 0;
                    default: begin
                        y <= 0;
                        e = 1;
                    end
                endcase

                ready <= 1;
            end 
            else begin
                if (ready) begin
                    z = (y == 0);
                    s = y[N-1];
                    flags <= {z, c, v, s, e};
                end
                ready <= 0;
            end
        end
    end
endmodule