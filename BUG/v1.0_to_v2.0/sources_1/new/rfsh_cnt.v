`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2023 05:53:55 PM
// Design Name: 
// Module Name: rfsh_cnt
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


// refresh counter
module rfsh_cnt(
    input rc_clk,
    output reg [2:0] rc_out = 0
    );
    
    always@(posedge rc_clk)
        rc_out <= rc_out + 1;
    
endmodule
