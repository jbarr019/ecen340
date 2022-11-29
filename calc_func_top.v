//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2021 10:18:02 PM
// Design Name: 
// Module Name: calc_func_top
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

module calc_func_top(
    input clk,          //100Mhz clock
    input [15:0] sw,    //Data for calculator operations
    input btnC,         //Execute button, used with other buttons
    input btnU,         //Add operation
    input btnD,         //Subtract operation
    input btnR,         //Multiplication operation
    input btnL,         //Division operation
    output [3:0] an,    //Anode drivers for 7 segment display
    output [6:0] seg,   //7 segments to display data
    output dp,          //Decimal place on 7 segment display
    output [15:0] led   //LEDs to display address and mode information
    );
    
    wire [15:0] data_out;                       //Data from memory to be displayed
    wire clk_deb;                               //Debounced clock
    wire [2:0] sel_func;                        //Indicator of which function is to be performed
    wire add_in, mult_in, sub_in, div_in;       //Switch to add, mult, sub, or div mode
    wire execute;                               //Execute, combined with other buttons to perform tasks
    
    reg [15:0] data_in;                         //Data to be stored in memory
    reg [15:0] disp_data;                       //Data that will be displayed to 7 segment
    reg [1:0] addr;                             //Address for data locations
    reg add_tml, mult_tml, sub_tml, div_tml;    //Temporary function registers for pulse generation
    reg sel_add, sel_sub, sel_mult, sel_div;    //Indicator of which operator is being performed
    reg en_add, en_mult, en_sub, en_div;        //When the function is enabled, by pressing func button and execute at same time
    reg add_p, mult_p, sub_p, div_p;            //Registers for function pulse
    
    sseg_disp   disp    (.sw(disp_data), .clk(clk), .btnC(1'b0), .seg(seg), .an(an), .dp(dp));                  //Instantiating the 7 segment display
    mem_calc    mem     (.clk(clk), .data_in(data_in), .addr(addr), .sel_func(sel_func), .data_out(data_out));  //Instantiating the memory
    debounce_div div1   (.clk(clk), .clk_deb(clk_deb));                                                         //Instantiating the debounced clock
    btn_debounce up     (.clk(clk_deb), .btn_in(btnU), .btn_status(add_in));                                    //Instantiating the add function button
    btn_debounce down   (.clk(clk_deb), .btn_in(btnD), .btn_status(sub_in));                                    //Instantiating the subtract function button
    btn_debounce left   (.clk(clk_deb), .btn_in(btnL), .btn_status(div_in));                                    //Instantiating the divide function button
    btn_debounce right  (.clk(clk_deb), .btn_in(btnR), .btn_status(mult_in));                                   //Instantiating the multiplication function button
    btn_debounce center (.clk(clk_deb), .btn_in(btnC), .btn_status(execute));                                   //Instantiating the execute button
    
    //Instantiation to change function (FSM)
    func_sel    f1      (.clk(clk), .sel_add(sel_add), .sel_mult(sel_mult), .sel_sub(sel_sub), .sel_div(sel_div), .sel_func(sel_func));
    
    //LEDs to show address, function executed, and function input 
    assign led[15:12] = {!sel_add, !sel_mult, !sel_sub, !sel_div};  //4 leftmost LEDs, indicate if we are trying to do an add, mult, sub, or div
    assign led[6:4] = sel_func;                                     //3 inner LEDs that show which function was actually executed
    assign led[1:0] = addr;                                         //2 rightmost LEDs that show the current address
    assign led[3:2] = 0;                                            //Making sure extra LEDs are off
    assign led[11:7] = 0;
    
    //Operation performers
    always @ (sel_func)                     //Whenever there is a function to be performed
    begin
        if (sel_func == 3'b001)             //Add function is selected
            data_in = sw[15:8] + sw[7:0];   //Adds upper 8 bits and lower 8 bits together
        else if (sel_func == 3'b010)        //Multiplication function is selected
            data_in = sw[15:8] * sw[7:0];   //Multiplies upper 8 bits and lower 8 bits together
        else if (sel_func == 3'b011)        //Subtract function is selected
            data_in = sw[15:8] - sw[7:0];   //Subtracts lower 8 bits from upper 8 bits
        else if (sel_func == 3'b100)        //Division function is selected
            data_in = sw[15:8] / sw[7:0];   //Divides upper 8 bits by lower 8 bits
        else
            data_in = 16'hzzzz;             //No valid function selected, sets data_in to Z
    end
    
    //Selecting the right data to display
    always @ (addr)                 //Whenever the address changes either by function or just selection
    begin
        disp_data <= data_out;      //Displays the data on 7 segment board that is stored in that address from memory module
    end
    
    //Configuring when a function is to be performed
    always @ (execute, add_in, mult_in, sub_in, div_in)     //When either of the buttons are pressed 
    begin
        en_add = execute && add_in;                         //Add function enabled when execute & add button are pressed
        en_mult = execute && mult_in;                       //Mult function enabled when execute & mult button are pressed
        en_sub = execute && sub_in;                         //Sub function enabled when execute & sub button are pressed
        en_div = execute && div_in;                         //Div function enabled when execute & div button are pressed
        
        //Configures select signals based on which function is enabled
        if (en_add)                 //Add function is enabled
        begin
            sel_add = 1;            //Sets add bit to high while setting other function bits to low
            sel_mult = 0;
            sel_sub = 0;
            sel_div = 0;
        end
        else if (en_mult)           //Mult function is enabled
        begin
            sel_add = 0;            //Sets mult bit to high while setting other function bits to low
            sel_mult = 1;
            sel_sub = 0;
            sel_div = 0;
        end
        else if (en_sub)            //Sub function is enabled
        begin
            sel_add = 0;            //Sets sub bit to hight while setting other function bits to low
            sel_mult = 0;
            sel_sub = 1;
            sel_div = 0;
        end
        else if (en_div)            //Div function is enabled
        begin
            sel_add = 0;            //Sets div bit to high while setting other function bits to low
            sel_mult = 0;
            sel_sub = 0;
            sel_div = 1;
        end
        else
        begin                       //Sets all bits to low if a valid function is not detected
            sel_add = 0;
            sel_mult = 0;
            sel_sub = 0;
            sel_div = 0;
        end     
    end
    
    //Using pulses to remember address of selected operation/function even when button is released
     always @ (posedge clk)          
    begin
        add_tml <= add_in;                  //Delayed add_in for add pulse
        mult_tml <= mult_in;                //Delayed mult_in for mult pulse
        sub_tml <= sub_in;                  //Delayed sub_in for sub pulse
        div_tml <= div_in;                  //Delayed div_in for div pulse
    end
    
    always @ (execute, add_in, add_tml, mult_in, mult_tml, sub_in, sub_tml, div_in, div_tml)
    begin                                   
        add_p = add_in && !add_tml;         //Generate single add pulse
        mult_p = mult_in && !mult_tml;      //Generate single mult pulse
        sub_p = sub_in && !sub_tml;         //Generate single sub pulse
        div_p = div_in && !div_tml;         //Generate single div pulse
    end
    
    //Address generator depended on which operation/function is selected based on pressed buttons
    always @ (posedge clk)
    begin
        if (add_p)                  
            addr <= 2'b00;          //Add address is selected
        else if (mult_p)
            addr <= 2'b01;          //Mult address is selected
        else if (sub_p)
            addr <= 2'b10;          //Sub address is selected
        else if (div_p)
            addr <= 2'b11;          //Div address is selected
    end
 
    //Sets calculator to initially start at add operator/function
    initial addr <= 2'b00;
endmodule
