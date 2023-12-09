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
    input load_LR_clk,
    input load_LR_rst,
    input load_LR_en,
    input load_LR_left,
    input load_LR_right,
    output reg [7:0] load_LR_out
    );
    
    reg [2:0] tmp;
    
    always@(posedge load_LR_clk)
    begin
        if(load_LR_rst)
            tmp <= 0;
        else if(load_LR_en)
        begin
            if(load_LR_left)
                tmp <= tmp + 1;
            else if(load_LR_right)
                tmp <= tmp - 1;
        end
    end
    
    always@(tmp)
    begin
        if(load_LR_en)
        begin
            case(tmp)
                3'd0:   load_LR_out = 8'b00000001;
                3'd1:   load_LR_out = 8'b00000010;
                3'd2:   load_LR_out = 8'b00000100;
                3'd3:   load_LR_out = 8'b00001000;
                3'd4:   load_LR_out = 8'b00010000;
                3'd5:   load_LR_out = 8'b00100000;
                3'd6:   load_LR_out = 8'b01000000;
                3'd7:   load_LR_out = 8'b10000000;
                
                default:    load_LR_out = 8'd0;
            endcase
        end
        else
            load_LR_out <= 0;
    end
    
endmodule