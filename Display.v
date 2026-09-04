`timescale 1ns / 1ps

module Display(
    input clk,
    input rst,
    input [1:0] sys_mode, 
    input [15:0] alu_data,
    input [4:0] alu_flags,
    input [5:0] t_sec,
    input [5:0] t_min,
    input [4:0] t_hour,
    
    output reg [3:0] an,
    output reg [6:0] seg
);
    reg [19:0] refresh_counter;
    wire [1:0] active_digit;
    reg [3:0] hex_val;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end

    assign active_digit = refresh_counter[1:0]; 

    always @(*) begin
        case (active_digit)
            2'b00: an = 4'b1110; 
            2'b01: an = 4'b1101;
            2'b10: an = 4'b1011;
            2'b11: an = 4'b0111;
            default: an = 4'b1111;
        endcase
    end

    always @(*) begin
        hex_val = 0;
        if (alu_flags[0]) begin
            case (active_digit)
                2'b00: hex_val = 4'd14; 
                2'b01: hex_val = 4'd14; 
                2'b10: hex_val = 4'd13; 
                2'b11: hex_val = 4'd15; 
            endcase
        end
        else begin
            case (sys_mode)
                2'b00: begin
                    case (active_digit)
                        2'b00: hex_val = alu_data[3:0];
                        2'b01: hex_val = alu_data[7:4];
                        2'b10: hex_val = alu_data[11:8];
                        2'b11: hex_val = alu_data[15:12];
                    endcase
                end
                
                2'b01: begin
                    case (active_digit)
                        2'b00: hex_val = t_sec % 10;
                        2'b01: hex_val = t_sec / 10;
                        2'b10: hex_val = t_min % 10;
                        2'b11: hex_val = t_min / 10;
                    endcase
                end
                
                2'b10: begin
                     case (active_digit)
                        2'b00: hex_val = t_hour % 10;
                        2'b01: hex_val = t_hour / 10;
                        2'b10: hex_val = 4'd15; 
                        2'b11: hex_val = 4'd11;
                    endcase
                end
                
                default: hex_val = 0;
            endcase
        end
    end

    always @(*) begin
        case (hex_val)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001; 
            4'h2: seg = 7'b0100100; 
            4'h3: seg = 7'b0110000; 
            4'h4: seg = 7'b0011001; 
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010; 
            4'h7: seg = 7'b1111000; 
            4'h8: seg = 7'b0000000; 
            4'h9: seg = 7'b0010000; 
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011; 
            4'hC: seg = 7'b1000110; 
            4'hD: seg = 7'b0100001; 
            4'hE: seg = 7'b0000110; 
            4'hF: seg = 7'b0111111;
            
            4'd10: seg = 7'b0111111;
            4'd11: seg = 7'b0001100;
            4'd13: seg = 7'b0000110;
            4'd14: seg = 7'b0101111;
            
            default: seg = 7'b1111111;
        endcase
    end
endmodule