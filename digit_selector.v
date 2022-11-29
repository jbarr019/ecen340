`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2021 06:10:48 PM
// Design Name: 
// Module Name: digit_selector
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


module digit_selector(
    output reg [3:0] digit_sel,
    input clk, rst
    );
    
    reg [1:0] dig_cnt;      //Declaring the 2 bit digit counter
    
    initial dig_cnt = 0;    //Initializing counter to 0
    
    always @ (posedge clk, posedge rst)
    begin   
        if (rst == 1'b1)            //If rst button is pushed, counter will reset to 0
            dig_cnt = 0;
        else if (dig_cnt == 2'b11)  //Once the counter hits 4, it will restart from 0
            dig_cnt <= 0;
        else
            dig_cnt <= dig_cnt + 1; //Digit counter increment by 1 each clock cycle
                                    //resulting in the waveform shown in lab document
                                    //for dig_cnt[0] and dig_cnt[1]
     end
                           
    always @ (dig_cnt)
    begin
        case (dig_cnt)
            2'b00:      digit_sel = 4'b1110;
            2'b01:      digit_sel = 4'b1101;
            2'b10:      digit_sel = 4'b1011;
            2'b11:      digit_sel = 4'b0111;
            default:    digit_sel = 4'b1111;
        endcase
    end                                   

endmodule
