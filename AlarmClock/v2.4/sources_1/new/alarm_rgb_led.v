`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 05:37:01 PM
// Design Name: 
// Module Name: alarm_rgb_led
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


module alarm_match_rgb_led(
    input clk, // Clock input
    input led_enable,
    output reg PWM_r, // Red LED
    output reg PWM_g, // Green LED
    output reg PWM_b // Blue LED
);

    reg [31:0] count; // Counter for toggling LEDs
    reg [7:0] pwm_counter_r; // PWM counter for red LED
    parameter PWM_WIDTH = 8; // PWM resolution 

    always @(posedge clk) begin
    if(led_enable)begin
        // Toggle the red LED every clock cycle
        PWM_r <= (pwm_counter_r < 8'hBF); // 75% duty cycle
        // can change to 8'hE6 for 90% or 8'hFC for 99% duty cycle

        if (count == 99999999) begin
            count <= 0;   // Reset count register
            
            // Increment PWM counter for red LED
            if (pwm_counter_r < (2 ** PWM_WIDTH - 1)) begin
                pwm_counter_r <= pwm_counter_r + 1;
            end else begin
                pwm_counter_r <= 0;
            end
            
            // Toggle the green and blue LEDs
            // Changes color from Red to White and vise versa
            PWM_g <= ~PWM_g;
            PWM_b <= ~PWM_b;
        end else begin
            count <= count + 1; // Counts 100MHz clock
            //try plus 11 
        end
    end
    else begin              // Turns of LED when alarm enable is off
    PWM_r <= 1'b0;      
    PWM_g <= 1'b0;
    PWM_b <= 1'b0;
    end
end
endmodule
