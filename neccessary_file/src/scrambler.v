`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: scrambler
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: scrambler_lfsr builds on top of the existing LFSR module and adds
//             an element on nonlinearity to it making it harder to predict.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module scrambler(input_challenge, clk, global_rst ,rst, output_challenge);
    input [7:0] input_challenge;
    input clk, rst;
    input global_rst;
    output reg [7:0] output_challenge;

    reg [7:0] lfsr_out;
    reg xnor_value;

    always @(posedge clk or posedge rst or posedge global_rst) begin
        if (rst || global_rst) begin
            lfsr_out <= input_challenge;
        end
        else begin
            lfsr_out <= {lfsr_out[6:0], xnor_value} ^ input_challenge;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst || global_rst) begin
            xnor_value <= 1'b0; // Changed <= instead of =
        end
        else begin
            xnor_value <= lfsr_out[7] ^ ~lfsr_out[5] ^ ~lfsr_out[4] ^ ~lfsr_out[3];
        end
    end

    always @(*) begin
        output_challenge = lfsr_out;
    end

endmodule
