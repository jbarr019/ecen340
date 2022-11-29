`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2021 10:38:32 PM
// Design Name: 
// Module Name: clk_gen
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


module clk_gen(
    output reg clk_div,
    input clk, rst);
    
    reg [26:0] cnt;     //Declaring a counter
    
    initial begin
        cnt = 0;        //Initializing the counter and divided clock to 0
        clk_div = 0;
    end    
    
    always @ (posedge clk, posedge rst)     //The bit location to monitor is cnt[18] which would be 000000001000000000000000000, or 262144
                                            //which will result in a clkd frequency of 190.74 Hz
    begin
        if (rst == 1'b1)                    //If reset button pushed, counter will be reset to 0
            cnt <= 0;
        else if (cnt[18] == 1'b1) begin     //When the counter's 21st bit is 1 (cnt[20])
            clk_div = ~clk_div;             //the divided clock will toggle
            cnt <= 0;                       //and the counter will go to 0 for the next clock toggle
            end
        else
            cnt <= cnt + 1;                 //The counter will increment as long as it has not reached cnt[20] = 1
    end
endmodule
