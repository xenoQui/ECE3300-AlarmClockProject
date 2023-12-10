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


module alarm_rgb_led(
    input clk, // Clock input
    input led_enable,
    output reg PWM_r, // Red LED
    output reg PWM_g, // Green LED
    output reg PWM_b // Blue LED
);

    reg [31:0] count; // Counter for toggling LEDs
    reg [7:0] pwm_counter_r; // PWM counter for red LED
    parameter PWM_WIDTH = 8; // PWM resolution (adjust as needed)

    always @(posedge clk) begin
    if(led_enable)begin
        // Toggle the red LED every clock cycle
        PWM_r <= (pwm_counter_r < 8'h7F); // Example 50% duty cycle

        if (count == 99999999) begin
            count <= 0;   // Reset count register
            
            // Increment PWM counter for red LED
            if (pwm_counter_r < (2 ** PWM_WIDTH - 1)) begin
                pwm_counter_r <= pwm_counter_r + 1;
            end else begin
                pwm_counter_r <= 0;
            end
            
            // Toggle the green and blue LEDs when count reaches its maximum
            PWM_g <= ~PWM_g;
            PWM_b <= ~PWM_b;
        end else begin
            count <= count + 1; // Counts 100MHz clock
            // Try plus 11 lmao
        end
    end
    else begin
    PWM_r <= 1'b0;
    PWM_g <= 1'b0;
    PWM_b <= 1'b0;
    end
end
endmodule