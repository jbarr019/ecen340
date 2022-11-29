//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2021 10:56:15 PM
// Design Name: 
// Module Name: mem_calc
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
`timescale 1ns / 1ps

module mem_calc(
    input wire [15:0] data_in,      //Input data which is result of performed function
    input wire clk,                 //Clock signal
    input [2:0] sel_func,           //Bits of the function that was performed
    input wire [1:0] addr,          //Address of memory location to use
    output [15:0] data_out          //Output data from the memory location
    );
    
    reg [15:0] data_temp;           //Temporary register for data_out
    reg [15:0] mem [0:3];           //Declaring the 4x16 memory block
                                    //4 blocks (for 4 functions) that are each 16 bits wide
    
    assign data_out = data_temp;    //Assigning data_out to value from data_temp
    
    always @ (posedge clk)
    begin
        if (|sel_func)              //OR-ing the sel_func bits, meaning to execute the write to mem
                                    //if a function was performed
            mem[addr] <= data_in;   //Writing value of performed function to corresponding address in mem
        else
            data_temp <= mem[addr]; //Reading value from corresponding address in mem
    end
endmodule
