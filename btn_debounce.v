`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2021 10:22:12 PM
// Design Name: 
// Module Name: btn_debounce
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


module btn_debounce(
    input clk,              //Clock signal
    input btn_in,           //Input signal from button press
    output wire btn_status  //Output of debounced button
    );
    reg [19:0] btn_shift;   //Shift register for button
        
    always @ (posedge clk)
        btn_shift <= {btn_shift[18:0], btn_in}; //Shift register takes in concatenation of 0s and
                                                //button input, shifting left by 1 bit every clock cycle
    assign btn_status = &btn_shift;             //Output is only high when all 20 bits are high
    
endmodule
