`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: race_arbiter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: The race_arbiter determines which signal finished first. If
//              finished1 is asserted first, then the output is 1. If finished2 is asserted
//              first, then output is 0. 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module race_arbiter(finished1, finished2, rst , global_rst , done , out);
input rst, finished1, finished2;
input global_rst;
output out;
output done;

reg out_reg;
reg done_reg;

always @* begin
    if(rst || global_rst) begin
        out_reg = 1'b0;
        done_reg = 1'b0;
    end
    else begin
        if(finished1) begin
            out_reg = 1'b1;
            done_reg = 1'b1;
        end
        else if(finished2) begin
            out_reg = 1'b0;
            done_reg = 1'b1;
        end
    end
end

assign out = out_reg;
assign done = done_reg;

endmodule