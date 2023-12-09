`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2023 06:02:23 PM
// Design Name: 
// Module Name: bcd_ctrl
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


// bcd control
module bcd_ctrl(
    input [2:0] rc_in,        // from refresh counter
    input [15:0] clock_in,
    input [15:0] alarm_in,
    output reg [3:0] bcd_out
    );
    
    always@(rc_in)
    begin
        case(rc_in)
            3'd0:  bcd_out = alarm_in[3:0]; 
            3'd1:  bcd_out = alarm_in[7:4];
            3'd2:  bcd_out = alarm_in[11:8];
            3'd3:  bcd_out = alarm_in[15:12];
            3'd4:  bcd_out = clock_in[3:0];
            3'd5:  bcd_out = clock_in[7:4];
            3'd6:  bcd_out = clock_in[11:8];
            3'd7:  bcd_out = clock_in[15:12];
            
            default:    bcd_out = 4'd0;
        endcase
    end
    
endmodule
