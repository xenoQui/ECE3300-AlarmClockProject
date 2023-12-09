`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 07:47:16 PM
// Design Name: 
// Module Name: alarm_player
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


module alarm_player(
                    input clk,
                    input rst,
                    input stop,
                    input player_en,              
                    output reg audio_out, aud_sd             
                    );
    reg first;
    reg [19:0] counter;
    reg [31:0] time1, noteTime;
    reg [9:0] number;
    wire [4:0] note, duration;
    wire [19:0] notePeriod;
    parameter clockFrequency = 100_000_000;
    
    alarm_sound aud(
                    .number(number),
                    .note(notePeriod),
                    .duration(duration)
                    );
    
    
    
    always @ (posedge clk) 
      begin
        if (~player_en | rst)
            begin

                counter <= 0;
                time1 <= 0;
                audio_out<=1;
            end

        if(stop == 1) 
                aud_sd = 0;
        else 
            aud_sd = 1;
            
        counter <= counter + 1; 
        time1<= time1+1;
        
        if( counter >= notePeriod) 
           begin
                counter <=0;
                audio_out <= ~audio_out ; 
           end //toggle audio output 
        if( time1 >= noteTime) 
            begin
                time1 <=0;
                number <= number + 1; 
            end  //play next note

      end

      always @(duration)
      begin
       noteTime = (duration * clockFrequency/8);  //number of   FPGA clock periods in one note.
       end
      
endmodule
