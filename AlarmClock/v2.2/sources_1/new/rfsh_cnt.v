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
    input clk,
    output reg [2:0] rc = 0
    );
    
    always@(posedge clk)
        rc <= rc + 1;
    
endmodule
