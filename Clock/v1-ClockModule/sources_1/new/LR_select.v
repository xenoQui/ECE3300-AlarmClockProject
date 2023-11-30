`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2023 11:15:24 AM
// Design Name: 
// Module Name: LR_select
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

// left/right select for clock load
module LR_select(
    input [1:0] LR_select_in,
    output reg [3:0] LR_select_out
    );
    
    always@(LR_select_in)
    begin
        case(LR_select_in)
            2'd0:   LR_select_out = 4'b0001;
            2'd1:   LR_select_out = 4'b0010;
            2'd2:   LR_select_out = 4'b0100;
            2'd3:   LR_select_out = 4'b1000;
            
            default:    LR_select_out = 4'd0;
        endcase
    end
    
endmodule
