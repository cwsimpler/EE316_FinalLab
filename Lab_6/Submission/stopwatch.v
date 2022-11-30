`timescale 1ns / 1ps

module stopwatch(
    input clk,
    input reset,
    input toggle,
    input [1:0] mode_select,
    input [3:0] start_tens, start_ones,
    output reg [3:0] sec_0, sec_1, sec_2, sec_3
    );
    
    reg [3:0] L_sec_0, L_sec_1, L_sec_2, L_sec_3;
    reg [23:0] tick;
    wire hs;
    reg on;
    
    //Initializing values
    initial on = 0;
    initial tick = 0;
    initial L_sec_0 = 4'b0000;
    initial L_sec_1 = 4'b0000;
    initial L_sec_2 = 4'b0000;
    initial L_sec_3 = 4'b0000;
    
   reg toggle_follow;
    
    //Handles counting of time
    always @ (posedge clk) begin
        toggle_follow <= toggle;
        if(mode_select == 0 || mode_select == 1) begin   //If user selects stopwatch (either from 0 or loaded value)
            
            if(toggle && !toggle_follow)  //Handles the toggling of button
                on <= ~on;
            //Turn off counting and reset tick value
            if(reset) begin
                on <= 0;
                tick <= 0;
            end
            //If tick reaches value, 1 hundredth of a second has passed
            else if(tick == 1000000)
                tick <= 0;
            //If on, we should count    
            else if(on)
                tick <= tick + 1;
        end       
    end
    
    //1 hundredth of a second has passed
    assign hs = (tick == 1000000) ? 1'b1 : 1'b0;
    
    always @ (posedge clk) begin
    
        if(mode_select == 0 || mode_select == 1) begin
            if(reset) begin   //Sets all digits back to start value
                
                if(mode_select == 0) begin
                    L_sec_0 <= 4'b0000;
                    L_sec_1 <= 4'b0000;
                    L_sec_2 <= 4'b0000;
                    L_sec_3 <= 4'b0000;
                end
                else begin
                    L_sec_0 <= 4'b0000;
                    L_sec_1 <= 4'b0000;
                    L_sec_2 <= start_ones;
                    L_sec_3 <= start_tens;
                end    
            end
            
//            else if(~on) begin    //While stopwatch not running, update values to reflect what user is choosing            
//                if(mode_select == 1) begin   //Mode 0 so starts from 0 
//                    L_sec_0 <= 4'b0000;
//                    L_sec_1 <= 4'b0000;
//                    L_sec_2 <= start_ones;
//                    L_sec_3 <= start_tens;
//                end
//            end
            
            else if(hs) begin //increment timer
                if(L_sec_0 == 9) begin    
                    L_sec_0 <= 4'b0000; //xx.x9  overflows
                    if(L_sec_1 == 9) begin
                        L_sec_1 <= 4'b0000; //xx.99 overflows
                        if(L_sec_2 == 9) begin        
                            L_sec_2 <= 4'b0000; //x9.99 overflows
                            if(L_sec_3 == 9) begin
                                L_sec_3 <= 9; //stay at 99.99
                                L_sec_2 <= 9;
                                L_sec_1 <= 9;
                                L_sec_0 <= 9;
                            end
                            else
                                L_sec_3 <= L_sec_3 + 1;  //Not an overflow, add one as normal
                        end                        
                        else
                            L_sec_2 <= L_sec_2 + 1;  //Not an overflow, add one as normal
                    end                 
                    else
                        L_sec_1 <= L_sec_1 + 1;   //Not an overflow, add one as normal                     
                end                
                else
                    L_sec_0 <= L_sec_0 + 1;  //Not an overflow, add one as normal
            end
             
           sec_0 <= L_sec_0;
           sec_1 <= L_sec_1;
           sec_2 <= L_sec_2;
           sec_3 <= L_sec_3; //Write values to output 
        end  
    end
    
    
    
endmodule
