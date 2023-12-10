`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2023 04:49:49 PM
// Design Name: 
// Module Name: load_LR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module load_LR(
    input clk,
    input rst,
    input clock_load_en,
    input alarm_load_en,
    input left,
    input right,
    output reg [7:0] out,
    output reg [3:0] led
    );
    
    reg [2:0] cnt_tmp;
    
    always@(posedge clk)
    begin
        if(rst)
            cnt_tmp <= 0;
        else
        begin
            if(clock_load_en && (cnt_tmp < 4 || cnt_tmp > 7))
                cnt_tmp <= 4;
            else if(alarm_load_en && (cnt_tmp < 0 || cnt_tmp > 3))
                cnt_tmp <= 0;
            else
            begin
                if(left)
                    cnt_tmp <= cnt_tmp + 1;
                else if(right)
                    cnt_tmp <= cnt_tmp - 1;
            end
        end
    end
    
    always@(cnt_tmp)
    begin
        if(clock_load_en || alarm_load_en)
        begin
            case(cnt_tmp)
                3'd0:   out <= 8'b00000001;
                3'd1:   out <= 8'b00000010;
                3'd2:   out <= 8'b00000100;
                3'd3:   out <= 8'b00001000;
                3'd4:   out <= 8'b00010000;
                3'd5:   out <= 8'b00100000;
                3'd6:   out <= 8'b01000000;
                3'd7:   out <= 8'b10000000;
                
                default:    out <= 8'd0;
            endcase
            
            led <= clock_load_en ? out[7:4] : out[3:0];
        end
        else
            out <= 0;
    end
    
endmodule