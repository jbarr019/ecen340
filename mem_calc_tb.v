`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2021 05:52:06 PM
// Design Name: 
// Module Name: mem_calc_tb
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


module mem_calc_tb(
    );
    
    reg [15:0] data_in;
    reg clk;
    reg [2:0] sel_func;
    reg [1:0] addr;
    wire [15:0] data_out;
    
    parameter period = 10;
    
    reg [15:0] data_temp;
    
    mem_calc m2 (.data_out(data_out), .data_in(data_in), .clk(clk), .sel_func(sel_func), .addr(addr));
    
    always #(period/2) clk = ~clk;
    
    wire test;
    assign test = |sel_func;
    
    initial begin
        clk = 0;
        
        #period sel_func = 3'b100; addr = 2'b11; data_in = 16'h2222;
        #period sel_func = 0;
        #period data_in = 16'h5555;
        #(3*period) sel_func = 3'b001; addr = 2'b00;
        #period sel_func = 0;
        #(3*period) addr = 2'b11;
        #(3*period) addr = 2'b00;
        
    end
endmodule
