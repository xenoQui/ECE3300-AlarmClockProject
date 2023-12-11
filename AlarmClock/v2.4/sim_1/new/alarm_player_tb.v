`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 02:06:34 PM
// Design Name: 
// Module Name: alarm_player_tb
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
`define clock_period 10

module alarm_player_tb();   //to see waveforms with alarm_player module 
                            //change clockFrequency parameter to 100_000
                            //change alarm_sound module notes clock frequency
                            //to 50000 and put increments in else
reg clk_tb;
reg rst_tb;
reg player_en_tb;

wire audio_out_tb;
wire aud_sd_tb;
wire counter_tb;
wire notePeriod_tb;

initial begin
    clk_tb = 0;
    forever #1 clk_tb = ~clk_tb;
  end

alarm_player TB(
                .clk(clk_tb),
                .rst(rst_tb),
                .player_en(player_en_tb),
                .audio_out(audio_out_tb),
                .aud_sd(aud_sd_tb)
                );
                
initial
begin
    rst_tb = 0;
    player_en_tb = 0;
    #(`clock_period)
    rst_tb = 1;
    #(`clock_period)
    rst_tb = 0;
    #(`clock_period)
    player_en_tb = 1;
    #1_000_000_000;
    $finish;
end

endmodule
