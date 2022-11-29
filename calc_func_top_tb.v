`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2021 11:08:54 AM
// Design Name: 
// Module Name: calc_func_top_tb
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


module calc_func_top_tb(
    );
        
    reg clk, btnC, btnU, btnD, btnR, btnL;
    reg [15:0] sw;
    wire [3:0] an;
    wire [6:0] seg;
    wire dp;
    wire [15:0] led;
    
    parameter period = 10;
    
    calc_func_top t1 (.clk(clk), .sw(sw), .btnC(btnC), .btnU(btnU), .btnD(btnD), .btnR(btnR), .btnL(btnL), .an(an), .seg(seg), .dp(dp), .led(led));
    
    always #(period/2) clk = ~clk;
    
    initial begin
    clk = 0;
    
    #period btnC = 1; btnU = 1;
    end
    
endmodule
