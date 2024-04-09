`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: The counter module counts to a predetermined goal and
//              once reached, drives the finished signal to 1. The finished signal is 0 all
//              other times (even after the cycle after reaching the goal).
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module counter(clk, rst, global_rst , signal, finished);
input signal;		//signal is the output from ring_osc_i
input clk, rst;
input global_rst;
output reg finished;    //counts to a predetermined goal you set

reg [7:0] count;
always @(posedge clk or posedge rst or posedge global_rst) begin
    if(rst || global_rst) begin
        count <= 8'b0;
        finished <= 1'b0;
    end
    else begin
        if(signal) begin
            if(count == 8'd37) begin
                count <= 8'b0;
                finished <= 1'b1;
            end
            else begin
                count <= count + 1;
                finished <= 1'b0;
            end
        end
    end
end

endmodule

