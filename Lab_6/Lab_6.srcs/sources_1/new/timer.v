`timescale 1ns / 1ps

module timer(
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
    initial L_sec_0 = 0;
    initial L_sec_1 = 0;
    initial L_sec_2 = 0;
    initial L_sec_3 = 0;
            
    reg toggle_follow;
    
    //Handles counting of time
    always @ (posedge clk)
    begin
        toggle_follow <= toggle;
        if(mode_select == 2 || mode_select == 3)    //If user selects stopwatch (either from 0 or loaded value)
        begin
            if(toggle && !toggle_follow)  //Handles the toggling of button
                on <= ~on;
                
            if(reset) begin
                tick <= 0;
                on <= 0;
            end    
            else if(tick == 1000000)
                tick <= 0;
            else if(on)
                tick <= tick + 1;
                
        end       
    end
    
    //1 hundredth of a second has passed
    assign hs = (tick == 1000000) ? 1'b1 : 1'b0;
    
    always @ (posedge clk)
    begin
        if(mode_select == 2 || mode_select == 3) begin
            if(reset) begin  //Sets all digits back to start value 
                    
                if(mode_select == 2) begin               
                    L_sec_0 <= 4'd9;
                    L_sec_1 <= 4'd9;
                    L_sec_2 <= 4'd9;
                    L_sec_3 <= 4'd9;
                end
                else begin    
                    L_sec_0 <= 4'd0;
                    L_sec_1 <= 4'd0;
                    L_sec_2 <= start_ones;
                    L_sec_3 <= start_tens;
                end
            end
            
            else if(hs) begin //increment timer
 
                if(L_sec_0 == 0) begin
                    //L_sec_0 <= 0; //xx.x0 -> xx.x9
                    if(L_sec_1 == 0) begin
                        //L_sec_1 <= 0; //xx.99 overflows
                        if(L_sec_2 == 0) begin
                            //L_sec_2 <= 0; //x9.99 overflows
                            if(L_sec_3 == 0)
                                L_sec_3 <= 0; //stay at 00.00
                            else begin
                                    L_sec_3 = L_sec_3 - 1;
                                    L_sec_2 = 4'd9;
                                    L_sec_1 = 4'd9;
                                    L_sec_0 = 4'd9; 
                            end
                        end
                        else begin
                            L_sec_2 = L_sec_2 - 1;
                            L_sec_1 = 4'd9;
                            L_sec_0 = 4'd9;
                         end
                     end
                    
                    else begin
                        L_sec_1 = L_sec_1 - 1;
                        L_sec_0 = 4'd9;                        
                     end
                end
                else
                    L_sec_0 = L_sec_0 - 1;
           end
        sec_0 <= L_sec_0;
        sec_1 <= L_sec_1;
        sec_2 <= L_sec_2;
        sec_3 <= L_sec_3;  
        
        end 
          
    end
    
endmodule