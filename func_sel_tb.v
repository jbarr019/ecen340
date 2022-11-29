`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2021 10:42:52 AM
// Design Name: 
// Module Name: func_sel_tb
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


module func_sel_tb(
    );
    reg clk;
    reg sel_add, sel_mult, sel_sub, sel_div;
    wire [2:0] sel_func;
    
    parameter period = 10;
    
    func_sel    f2      (.clk(clk), .sel_add(sel_add), .sel_mult(sel_mult), .sel_sub(sel_sub), .sel_div(sel_div), .sel_func(sel_func));
    
    always #(period/2) clk = ~clk;
    
    initial begin
        clk = 0;
        sel_add = 0;
        sel_mult = 0;
        sel_sub = 0;
        sel_div = 0;
        
        #(4*period) sel_add = 1;
        #period sel_mult = 1;
        #period sel_add = 0;
        #period sel_div = 1;
        #period sel_mult = 0;
        
    end
    
endmodule
