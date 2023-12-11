`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 06:44:36 PM
// Design Name: 
// Module Name: alarm_sound
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


module alarm_sound(
                    input [9:0] number,
                    output reg [19:0] note,
                    output reg [4:0] duration
                   );
                   
    parameter SIXTEEN = 0.5;          //timing parameters
    parameter EIGHTH = 1;
    parameter QUARTER = 2;
    parameter HALF = 4;
    parameter ONE = 8;
    parameter TWO = 16;
    parameter FOUR = 32;
    
    parameter C4 = 50000000/261.63;    //note frequency parameters
    parameter Bb4 = 50000000/466.16;
    parameter G4 = 50000000/392;
    parameter C5 = 50000000/523.25;
    parameter Bb3 = 50000000/233.08;
    parameter F4 = 50000000/349.23;
    parameter SP = 1;
    
  always@(number)                        //default alarm sound
    begin
        case(number)                      
        0: begin note = C4; duration = EIGHTH; end
        1: begin note = Bb4; duration = EIGHTH; end
        2: begin note = G4; duration = QUARTER; end
        3: begin note = C5; duration = QUARTER; end
        4: begin note = Bb3; duration = QUARTER; end 
        5: begin note = C5; duration = QUARTER; end
        6: begin note = Bb4; duration = QUARTER; end
        7: begin note = C5; duration = QUARTER; end
        8: begin note = F4; duration = QUARTER; end
        9: begin note = SP; duration = HALF; end
        10: begin note = SP; duration = QUARTER; end
        11: begin note = G4; duration = QUARTER; end
        12: begin note = SP; duration = QUARTER; end
        13: begin note = G4; duration = QUARTER; end
        14: begin note = Bb4; duration = QUARTER; end
        15: begin note = C5; duration = QUARTER; end
        16: begin note = C5; duration = EIGHTH; end
        17: begin note = Bb4; duration = EIGHTH; end
        18: begin note = G4; duration = QUARTER; end
        19: begin note = C5; duration = QUARTER; end
        20: begin note = F4; duration = QUARTER; end
        21: begin note = C5; duration = QUARTER; end
        22: begin note = Bb4; duration = QUARTER; end
        23: begin note = C5; duration = QUARTER; end
        24: begin note = F4; duration = QUARTER; end
        25: begin note = SP; duration = ONE; end

        default: begin note = C4; duration = FOUR; end
        endcase
    end

endmodule
