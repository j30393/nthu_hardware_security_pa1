`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: MUX_8to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: The MUX_8to1 is a multiplexer that selects between 8 inputs
//               and passes through only one. It follows that the select line
//               is a 4-bit bus.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module MUX_8to1(a,b,c,d,e,f,g,h,sel,mux_out);
input a,b,c,d,e,f,g,h;
input [2:0] sel;	//from the output of scrambler
output reg mux_out;
always @(*) begin
    case(sel)
        3'b000: mux_out = a;
        3'b001: mux_out = b;
        3'b010: mux_out = c;
        3'b011: mux_out = d;
        3'b100: mux_out = e;
        3'b101: mux_out = f;
        3'b110: mux_out = g;
        3'b011: mux_out = h;
        default: mux_out = a;
    endcase
end
endmodule
