`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2023 04:05:00 PM
// Design Name: 
// Module Name: load_ud
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


module load_ud
    #(parameter MAX = 9)
    (
    input load_ud_clk,
    input load_ud_rst,
    input load_ud_up,
    input load_ud_down,
    output reg [3:0] load_ud_out
    );
    
    always@(posedge load_ud_clk)
    begin
        if(load_ud_rst)
            load_ud_out <= 0;
        else
        begin
            if(load_ud_up)
            begin
                if(load_ud_out >= MAX)
                    load_ud_out <= 0;
                else
                    load_ud_out <= load_ud_out + 1;
            end
            else if(load_ud_down)
            begin
                if(load_ud_out <= 0)
                    load_ud_out <= MAX;
                else
                    load_ud_out <= load_ud_out - 1;
            end
        end
    end
    
endmodule