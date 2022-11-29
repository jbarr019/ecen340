//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2021 11:15:29 PM
// Design Name: 
// Module Name: func_sel
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

module func_sel(
    input clk,                                  //Clock signal
    input sel_add, sel_sub, sel_mult, sel_div,  //Input signals from button presses
    output reg [2:0] sel_func                   //Output of the function to be performed based on
    );                                          //input signals
    
    //State assignments   
    parameter [2:0]
        wait2strt   = 3'b000,       //When calculator first starts, waits for function
        add_func    = 3'b001,       //Add function
        mult_func   = 3'b010,       //Multiply function
        sub_func    = 3'b011,       //Subtract function
        div_func    = 3'b100;       //Divide function
        
    reg [2:0] curr_state, next_state;   //State registers
    
    wire [3:0] sel;                                     //Sel signal made from input signals - easier for case statements
    assign sel = {sel_add, sel_mult, sel_sub, sel_div}; //Concatenating the 4 input signals to make the sel signal
    
    //IFL
    always @ (curr_state, sel) begin                    //Whenever the current state changes or an input is detected
        case (curr_state)
            wait2strt   :   if      (sel == 4'b1000)    //Add signal is high
                                next_state = add_func;  //Go to add function state
                            else if (sel == 4'b0100)    //Mult signal is high
                                next_state = mult_func; //Go to mult function state
                            else if (sel == 4'b0010)    //Sub signal is high
                                next_state = sub_func;  //Go to sub function state
                            else if (sel == 4'b0001)    //Div signal is high
                                next_state = div_func;  //Go to div function state
                            else                        //No input received
                                next_state = wait2strt; //Remain in wait2strt
                                
            add_func    :   if      (sel == 4'b0100)    //Mult signal is high
                                next_state = mult_func; //Go to mult function state
                            else if (sel == 4'b0010)    //Sub signal is high
                                next_state = sub_func;  //Go to sub function state
                            else if (sel == 4'b0001)    //Div signal is high
                                next_state = div_func;  //Go to div function state
                            else if (sel == 4'b1000)    //Add signal still high
                                next_state = add_func;  //Remain in add function state
                            else                        //Function performed
                                next_state = wait2strt; //Go back to wait2strt
                                
            mult_func   :   if      (sel == 4'b0010)    //Sub signal is high
                                next_state = sub_func;  //Go to sub function state
                            else if (sel == 4'b0001)    //Div signal is high
                                next_state = div_func;  //Go to div function state
                            else if (sel == 4'b1000)    //Add signal is high
                                next_state = add_func;  //Go to add function state
                            else if (sel == 4'b0100)    //Mult signal still high
                                next_state = mult_func; //Remain in mult function state
                            else                        //Function performed
                                next_state = wait2strt; //Go back to wait2strt
                                
            sub_func    :   if      (sel == 4'b0001)    //Div signal is high
                                next_state = div_func;  //Go to div function state
                            else if (sel == 4'b1000)    //Add signal is high 
                                next_state = add_func;  //Go to add function state
                            else if (sel == 4'b0100)    //Mult signal is high
                                next_state = mult_func; //Go to mult function state
                            else if (sel == 4'b0010)    //Sub signal still high
                                next_state = sub_func;  //Remain in sub function state
                            else                        //Function performed
                                next_state = wait2strt; //Go back to wait2strt
                                
            div_func    :   if      (sel == 4'b1000)    //Add signal is high
                                next_state = add_func;  //Go to add function state
                            else if (sel == 4'b0100)    //Mult signal is high
                                next_state = mult_func; //Go to mult function state
                            else if (sel == 4'b0010)    //Sub signal is high
                                next_state = sub_func;  //Go to sub function state
                            else if (sel == 4'b0001)    //Div signal stil high
                                next_state = div_func;  //Remain in div function state
                            else                        //Function performed
                                next_state = wait2strt; //Go back to wait2strt
        endcase
    end
    
    //OFL
    always @ (curr_state)                       //Moore outputs
    begin
        case (curr_state)
            add_func    :   sel_func = 3'b001;  //Add function is to be performed
            mult_func   :   sel_func = 3'b010;  //Mult function is to be performed
            sub_func    :   sel_func = 3'b011;  //Sub function is to be performed
            div_func    :   sel_func = 3'b100;  //Div function is to be performed
            default     :   sel_func = 3'b000;  //Waiting for inputs            
        endcase
    end
    
    //FF
    initial curr_state = 3'b000;    //Calculator initially starts in wait2strt state
    
    always @ (posedge clk)
    begin
        curr_state <= next_state;   //Goes to next state at every rising edge of the clock
    end    
endmodule
