`timescale 1ns / 1ps

module main(
    input clk,
    input reset,
    input toggle,
    input [9:0] sw, //[9:8] which mode, [7:4] tens digit, [3:0] ones digit
    output [6:0] sseg,
    output [3:0] an
    );
    
    reg [3:0] in0, in1, in2, in3;
    wire [3:0] s_in0, s_in1, s_in2, s_in3;
    wire [3:0] t_in0, t_in1, t_in2, t_in3;
    wire [6:0] out0, out1, out2, out3;
    wire slow_clk;
    wire button;
    
    initial in0 = 0;
    initial in0 = 1;
    initial in0 = 2;
    initial in0 = 3;
    
    //Module instantiation of clock divider
    clkdiv c5 (.clk(clk), .reset(rest), .clk_out(slow_clk));
    
    //Rising edge for button
    //rise_edge r0 (.clk(slow_clk), .signal(toggle), .reset(reset), .outedge(button));
    
    stopwatch s0 (.clk(clk), .reset(reset), .toggle(toggle), .mode_select(sw[9:8]), .start_tens(sw[7:4]), .start_ones(sw[3:0]), 
                        .sec_0(s_in0), .sec_1(s_in1), .sec_2(s_in2), .sec_3(s_in3));
    
    timer t0 (.clk(clk), .reset(reset), .toggle(toggle), .mode_select(sw[9:8]), .start_tens(sw[7:4]), .start_ones(sw[3:0]), 
                        .sec_0(t_in0), .sec_1(t_in1), .sec_2(t_in2), .sec_3(t_in3));
                        
    always @(*) begin
    case(sw[9:8])
        2'b00: begin
               in0 = s_in0;
               in1 = s_in1;
               in2 = s_in2;
               in3 = s_in3;
               end
        2'b01: begin
               in0 = s_in0;
               in1 = s_in1;
               in2 = s_in2;
               in3 = s_in3;
               end     
        2'b10: begin
               in0 = t_in0;
               in1 = t_in1;
               in2 = t_in2;
               in3 = t_in3;
               end
        2'b11: begin
               in0 = t_in0;
               in1 = t_in1;
               in2 = t_in2;
               in3 = t_in3;
               end
        endcase
        
    end
                
                     
    //Converts numbers calculated in timer or stopwatch to 7seg output
    hexto7segment c0 (.x(in0), .r(out0));
    hexto7segment c1 (.x(in1), .r(out1));
    hexto7segment c2 (.x(in2), .r(out2));
    hexto7segment c3 (.x(in3), .r(out3));
    
    
    
    time_mux_state_machine c6(
        .clk(slow_clk), 
        .reset(reset), 
        .out0(out0), 
        .out1(out1),
        .out2(out2), 
        .out3(out3), 
        .an(an), 
        .sseg(sseg));
    
endmodule
