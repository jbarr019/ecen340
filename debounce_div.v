`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2021 10:21:26 PM
// Design Name: 
// Module Name: debounce_div
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


module debounce_div(
    input clk,                  //Clock signal
    output clk_deb              //Output debounced clock
    );
    reg [15:0] cnt;             //Count register
    
    assign clk_deb = cnt[15];   //Debounced clock toggles when bit 15 is high
    
    initial cnt = 0;            //Count starts at 0
    always @(posedge clk)
        cnt <= cnt + 1;         //Count increments every clock cycle
        
endmodule
