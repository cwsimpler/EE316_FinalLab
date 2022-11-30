`timescale 1ns / 1ps
module TB_main;

reg clk;
reg reset;
reg toggle;
reg [9:0] sw;
wire [6:0] sseg;
wire [3:0] an;

main u1 (
    .clk(clk),
    .reset(reset),
    .toggle(toggle),
    .sw(sw),
    .sseg(sseg),
    .an(an));

initial begin
clk = 0;
sw = 0;
reset = 1;

#10

reset = 0;

#10

toggle = 1;

end

always
#5 clk = ~clk;

endmodule
