`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2023 07:01:08 PM
// Design Name: 
// Module Name: PWN_CORE
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


module PWM_CORE #(parameter R_SIZE = 8)(
        input clk,
        input rst,
        input en,
        input load,
        input[R_SIZE -1:0] Duty,
        output reg PWM

    );
    
    reg [R_SIZE-1:0] r_count;
    reg [R_SIZE-1:0] duty_load;
    
    always@(posedge clk or posedge rst)
    if(en)
        begin:R_COUNTER
            if(rst)
                r_count <=0;
            else
                r_count <= r_count + 1;
        end        
    always@(posedge clk or posedge rst)
    if(en)
        begin: COMPARATOR
            if(rst)
                PWM <= 1'b0;
            else
                if(r_count < duty_load)
                    PWM <= 1'b1;
                else 
                    PWM <= 1'b0;
        end  
     
     always@(posedge clk or posedge rst)
     if(en)
        begin: DUTY
            if(rst)
                duty_load <= 0;
            else
                begin
                    if(load)
                        duty_load <= Duty;
                    else 
                        duty_load <= duty_load + 1;
                end
        end    
             
endmodule
