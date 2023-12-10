`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2023 05:49:13 PM
// Design Name: 
// Module Name: an_ctrl
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


// an control
module an_ctrl(
    input [2:0] rc_in,       // from refresh counter
    output reg [7:0] an_out
    );
    
    always@(rc_in)
    begin
        case(rc_in)
            3'd0:  an_out = 8'b11111110;   // an0 ON
            3'd1:  an_out = 8'b11111101;   // an1 ON
            3'd2:  an_out = 8'b11111011;   // an2 ON
            3'd3:  an_out = 8'b11110111;   // an3 ON
            3'd4:  an_out = 8'b11101111;   // an4 ON
            3'd5:  an_out = 8'b11011111;   // an5 ON
            3'd6:  an_out = 8'b10111111;   // an6 ON
            3'd7:  an_out = 8'b01111111;   // an7 ON
            
            default:    an_out = 8'hFF;
        endcase
    end
    
endmodule
