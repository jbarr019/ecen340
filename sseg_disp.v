`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2021 10:36:11 PM
// Design Name: 
// Module Name: sseg_disp
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


module sseg_disp(
    output [6:0] seg,
    output [3:0] an,
    output dp, clkd,
    input [15:0] sw,
    input btnC,
    input clk
    );
    
    wire [3:0] not_used;        //Declaring the wire for lab3's "an" because we are not using it
    wire [3:0] hex_num;         //Declaring the wire for hex_num that is the 4bit value of the switches
    
                                    //Switched to new instantiation model
    clk_gen U1(                     //Instantiating the clock generator module
        .clk_div (clkd),
        .clk (clk),
        .rst (btnC)
    );
    digit_selector U2(              //Instantiating the digit selector module
        .digit_sel (an),
        .clk (clkd),
        .rst (btnC)
    );
    hex_num_gen U3(                 //Instantiating the hex number generator module
        .hex_num (hex_num),
        .digit_sel (an),
        .sw (sw)
    );
    sseg_digit U4(                //Instantiating the 7 segment display module from lab 3
        .seg (seg),
        .an (not_used),
        .dp (dp),
        .sw (hex_num)
    );
    
endmodule
