`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////
// Authored by David J. Marion aka FPGA Dude
// Created on 4/11/2022
//
// Purpose: receive clock BCD values, write clock on VGA screen
///////////////////////////////////////////////////////////////////////

module pixel_clk_gen(
    input clk,
    input video_on,
    input alarm_status,
    input [9:0] x, y,
    input [3:0] min_1s, min_10s,
    input [3:0] hr_1s, hr_10s,
    input [3:0] alarm_min_1s, alarm_min_10s,
    input [3:0] alarm_hr_1s, alarm_hr_10s,
    output reg [11:0] time_rgb
    );
  
    // *** Constant Declarations ***
    // Hour 10s Digit section = 32 x 64
    localparam H10_X_L = 224;
    localparam H10_X_R = 255;
    localparam H10_Y_T = 192;
    localparam H10_Y_B = 256;
    
    // Hour 1s Digit section = 32 x 64
    localparam H1_X_L = 256;
    localparam H1_X_R = 287;
    localparam H1_Y_T = 192;
    localparam H1_Y_B = 256;
    
    // Colon 1 section = 32 x 64
    localparam C1_X_L = 288;
    localparam C1_X_R = 319;
    localparam C1_Y_T = 192;
    localparam C1_Y_B = 256;
    
    // Minute 10s Digit section = 32 x 64
    localparam M10_X_L = 320;
    localparam M10_X_R = 351;
    localparam M10_Y_T = 192;
    localparam M10_Y_B = 256;
    
    // Minute 1s Digit section = 32 x 64
    localparam M1_X_L = 352;
    localparam M1_X_R = 383;
    localparam M1_Y_T = 192;
    localparam M1_Y_B = 256;
    
    // Hour 10s Digit section = 32 x 64
    localparam A_H10_X_L = 224;
    localparam A_H10_X_R = 255;
    localparam A_H10_Y_T = 320;
    localparam A_H10_Y_B = 384;
    
    // Hour 1s Digit section = 32 x 64
    localparam A_H1_X_L = 256;
    localparam A_H1_X_R = 287;
    localparam A_H1_Y_T = 320;
    localparam A_H1_Y_B = 384;
    
    // Colon 1 section = 32 x 64
    localparam A_C1_X_L = 288;
    localparam A_C1_X_R = 319;
    localparam A_C1_Y_T = 320;
    localparam A_C1_Y_B = 384;
    
    // Minute 10s Digit section = 32 x 64
    localparam A_M10_X_L = 320;
    localparam A_M10_X_R = 351;
    localparam A_M10_Y_T = 320;
    localparam A_M10_Y_B = 384;
    
    // Minute 1s Digit section = 32 x 64
    localparam A_M1_X_L = 352;
    localparam A_M1_X_R = 383;
    localparam A_M1_Y_T = 320;
    localparam A_M1_Y_B = 384;
    
    // Object Status Signals
    wire H10_on, H1_on, C1_on, M10_on, M1_on;
    wire A_H10_on, A_H1_on, A_C1_on, A_M10_on, A_M1_on;
    
    // ROM Interface Signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr;   // 3'b011 + BCD value of time component
    wire [6:0] char_addr_h10, char_addr_h1, char_addr_m10, char_addr_m1, char_addr_c1;
    wire [6:0] char_addr_h10_A, char_addr_h1_A, char_addr_m10_A, char_addr_m1_A, char_addr_c1_A;
    reg [3:0] row_addr;    // row address of digit
    wire [3:0] row_addr_h10, row_addr_h1, row_addr_m10, row_addr_m1, row_addr_c1;
    wire [3:0] row_addr_h10_A, row_addr_h1_A, row_addr_m10_A, row_addr_m1_A, row_addr_c1_A;
    reg [2:0] bit_addr;    // column address of rom data
    wire [2:0] bit_addr_h10, bit_addr_h1, bit_addr_m10, bit_addr_m1, bit_addr_c1;
    wire [2:0] bit_addr_h10_A, bit_addr_h1_A, bit_addr_m10_A, bit_addr_m1_A, bit_addr_c1_A;
    wire [7:0] digit_word;  // data from rom
    wire digit_bit;
    
    
    assign char_addr_h10 = {3'b011, hr_10s};
    assign row_addr_h10 = y[5:2];   // scaling to 32x64
    assign bit_addr_h10 = x[4:2];   // scaling to 32x64
    
    assign char_addr_h1 = {3'b011, hr_1s};
    assign row_addr_h1 = y[5:2];   // scaling to 32x64
    assign bit_addr_h1 = x[4:2];   // scaling to 32x64
    
    assign char_addr_c1 = 7'h3a;
    assign row_addr_c1 = y[5:2];    // scaling to 32x64
    assign bit_addr_c1 = x[4:2];    // scaling to 32x64
    
    assign char_addr_m10 = {3'b011, min_10s};
    assign row_addr_m10 = y[5:2];   // scaling to 32x64
    assign bit_addr_m10 = x[4:2];   // scaling to 32x64
    
    assign char_addr_m1 = {3'b011, min_1s};
    assign row_addr_m1 = y[5:2];   // scaling to 32x64
    assign bit_addr_m1 = x[4:2];   // scaling to 32x64
    
    assign char_addr_h10_A = {3'b011, alarm_hr_10s};
    assign row_addr_h10_A = y[5:2];   // scaling to 32x64
    assign bit_addr_h10_A = x[4:2];   // scaling to 32x64
    
    assign char_addr_h1_A = {3'b011, alarm_hr_1s};
    assign row_addr_h1_A = y[5:2];   // scaling to 32x64
    assign bit_addr_h1_A = x[4:2];   // scaling to 32x64
    
    assign char_addr_c1_A = 7'h3a;
    assign row_addr_c1_A = y[5:2];    // scaling to 32x64
    assign bit_addr_c1_A = x[4:2];    // scaling to 32x64
    
    assign char_addr_m10_A = {3'b011, alarm_min_10s};
    assign row_addr_m10_A = y[5:2];   // scaling to 32x64
    assign bit_addr_m10_A = x[4:2];   // scaling to 32x64
    
    assign char_addr_m1_A = {3'b011, alarm_min_1s};
    assign row_addr_m1_A = y[5:2];   // scaling to 32x64
    assign bit_addr_m1_A = x[4:2];   // scaling to 32x64
    
    // Instantiate digit rom
    clock_digit_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));
    
    // For clock:
    // Hour sections assert signals
    assign H10_on = (H10_X_L <= x) && (x <= H10_X_R) &&
                    (H10_Y_T <= y) && (y <= H10_Y_B) && (hr_10s != 0); // turn off digit if hours 10s = 1-9
    assign H1_on =  (H1_X_L <= x) && (x <= H1_X_R) &&
                    (H1_Y_T <= y) && (y <= H1_Y_B);
    
    // Colon 1 ROM assert signals
    assign C1_on = (C1_X_L <= x) && (x <= C1_X_R) &&
                   (C1_Y_T <= y) && (y <= C1_Y_B);
                               
    // Minute sections assert signals
    assign M10_on = (M10_X_L <= x) && (x <= M10_X_R) &&
                    (M10_Y_T <= y) && (y <= M10_Y_B);
    assign M1_on =  (M1_X_L <= x) && (x <= M1_X_R) &&
                    (M1_Y_T <= y) && (y <= M1_Y_B);                             
    
    
    // For Alarm:
    // Hour sections assert signals
    assign A_H10_on = (A_H10_X_L <= x) && (x <= A_H10_X_R) &&
                    (A_H10_Y_T <= y) && (y <= A_H10_Y_B) && (alarm_hr_10s != 0); // turn off digit if hours 10s = 1-9
    assign A_H1_on =  (A_H1_X_L <= x) && (x <= A_H1_X_R) &&
                    (A_H1_Y_T <= y) && (y <= A_H1_Y_B);
    
    // Colon 1 ROM assert signals
    assign A_C1_on = (A_C1_X_L <= x) && (x <= A_C1_X_R) &&
                   (A_C1_Y_T <= y) && (y <= A_C1_Y_B);
                               
    // Minute sections assert signals
    assign A_M10_on = (A_M10_X_L <= x) && (x <= A_M10_X_R) &&
                    (A_M10_Y_T <= y) && (y <= A_M10_Y_B);
    assign A_M1_on =  (A_M1_X_L <= x) && (x <= A_M1_X_R) &&
                    (A_M1_Y_T <= y) && (y <= A_M1_Y_B);  
                          
        
    // Mux for ROM Addresses and RGB    
    always @* begin
            time_rgb = 12'h222;             // black background
            if(H10_on) begin
                char_addr = char_addr_h10;
                row_addr = row_addr_h10;
                bit_addr = bit_addr_h10;
                if(digit_bit) 
                    if(alarm_status)
                        time_rgb = 12'h0F0;     // green
                    else
                        time_rgb = 12'hF00;     // red
            end
            else if(H1_on) begin
                char_addr = char_addr_h1;
                row_addr = row_addr_h1;
                bit_addr = bit_addr_h1;
                if(digit_bit) 
                    if(alarm_status)
                        time_rgb = 12'h0F0;     // green
                    else
                        time_rgb = 12'hF00;     // red
            end
            else if(C1_on) begin
                char_addr = char_addr_c1;
                row_addr = row_addr_c1;
                bit_addr = bit_addr_c1;
                if(digit_bit) 
                    if(alarm_status)
                        time_rgb = 12'h0F0;     // green
                    else
                        time_rgb = 12'hF00;     // red
            end
            else if(M10_on) begin
                char_addr = char_addr_m10;
                row_addr = row_addr_m10;
                bit_addr = bit_addr_m10;
                if(digit_bit) 
                    if(alarm_status)
                        time_rgb = 12'h0F0;     // green
                    else
                        time_rgb = 12'hF00;     // red
            end
            else if(M1_on) begin
                char_addr = char_addr_m1;
                row_addr = row_addr_m1;
                bit_addr = bit_addr_m1;
                if(digit_bit) 
                    if(alarm_status)
                        time_rgb = 12'h0F0;     // green
                    else
                        time_rgb = 12'hF00;     // red
            end
            else if(A_H10_on) begin
                char_addr = char_addr_h10_A;
                row_addr = row_addr_h10_A;
                bit_addr = bit_addr_h10_A;
                if(digit_bit) 
                    if(alarm_status)
                        time_rgb = 12'h0F0;     // green
                    else
                        time_rgb = 12'hF00;     // red
            end
            else if(A_H1_on) begin
                char_addr = char_addr_h1_A;
                row_addr = row_addr_h1_A;
                bit_addr = bit_addr_h1_A;
                if(digit_bit) 
                    if(alarm_status)
                        time_rgb = 12'h0F0;     // green
                    else
                        time_rgb = 12'hF00;     // red
            end
            else if(A_C1_on) begin
                char_addr = char_addr_c1_A;
                row_addr = row_addr_c1_A;
                bit_addr = bit_addr_c1_A;
                if(digit_bit) 
                    if(alarm_status)
                        time_rgb = 12'h0F0;     // green
                    else
                        time_rgb = 12'hF00;     // red
            end
            else if(A_M10_on) begin
                char_addr = char_addr_m10_A;
                row_addr = row_addr_m10_A;
                bit_addr = bit_addr_m10_A;
                if(digit_bit) 
                    if(alarm_status)
                        time_rgb = 12'h0F0;     // green
                    else
                        time_rgb = 12'hF00;     // red
            end
            else if(A_M1_on) begin
                char_addr = char_addr_m1_A;
                row_addr = row_addr_m1_A;
                bit_addr = bit_addr_m1_A;
                if(digit_bit) 
                    if(alarm_status)
                        time_rgb = 12'h0F0;     // green
                    else
                        time_rgb = 12'hF00;     // red
            end
        end         
    
    // ROM Interface    
    assign rom_addr = {char_addr, row_addr};
    assign digit_bit = digit_word[~bit_addr];    
                          
endmodule