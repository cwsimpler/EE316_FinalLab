`timescale 1ns / 1ps

 module time_mux_state_machine(
    input clk,
    input reset,
    input [6:0] out0,
    input [6:0] out1,
    input [6:0] out2,
    input [6:0] out3,
    output reg [3:0] an,
    output reg [6:0] sseg
    );
    
    reg [1:0] state;
    reg [1:0] next_state;
    
    always @(*) begin
        case(state)         //State transition
            2'b00: next_state = 2'b01;
            2'b01: next_state = 2'b10;
            2'b10: next_state = 2'b11;
            2'b11: next_state = 2'b00;
        endcase
    end
    
    always @(*) begin
        case (state)        //Multiplexer
            2'b00: sseg = out0;
            2'b01: sseg = out1;
            2'b10: sseg = out2;
            2'b11: sseg = out3;
        endcase
    end
    
    always @(*) begin
        case (state)        //Decoder
            2'b00: an = 4'b1110;
            2'b01: an = 4'b1101;
            2'b10: an = 4'b1011;
            2'b11: an = 4'b0111;
        endcase
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= 2'b00;
        else
            state <= next_state;
    end
    
    
endmodule
