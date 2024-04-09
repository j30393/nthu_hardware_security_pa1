`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: top_PUF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Serialized PUF scheme. It takes in an 8-bit input, scrambles it giving
//              two random ring oscillators to compare outputting a bit. The bit is
//              stored into a buffer. When this is repeated 7 more times. An 8-bit
//              bus is ready to be read.
// 
// Dependencies: scrambler_lfsr, ring_osc, mux_8to1, counter, race_arbiter, buffer
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module top_PUF(clk, en, rst, chall_in, response, ready);
input clk, en, rst;
input[7:0] chall_in;
output[7:0] response;
output ready;

wire scrambler_rst , counter_rst , race_arbiter_rst;
wire [7:0] scerambler_out;
wire first_mux_out , second_mux_out;
wire [7:0] ro_g1_out;
wire [7:0] ro_g2_out;
wire g1_finished, g2_finished;
wire ra_done , ra_out;

scrambler sa(.input_challenge(chall_in), .clk(clk), .rst(scrambler_rst), .global_rst(rst), .output_challenge(scerambler_out));

ring_osc_i ro_1(.enable(en), .rst(rst), .delay(6'd1) , .out(ro_g1_out[0]));
ring_osc_i ro_2(.enable(en), .rst(rst), .delay(6'd2) , .out(ro_g1_out[1]));
ring_osc_i ro_3(.enable(en), .rst(rst), .delay(6'd3) , .out(ro_g1_out[2]));
ring_osc_i ro_4(.enable(en), .rst(rst), .delay(6'd4) , .out(ro_g1_out[3]));
ring_osc_i ro_5(.enable(en), .rst(rst), .delay(6'd5) , .out(ro_g1_out[4]));
ring_osc_i ro_6(.enable(en), .rst(rst), .delay(6'd6) , .out(ro_g1_out[5]));
ring_osc_i ro_7(.enable(en), .rst(rst), .delay(6'd7) , .out(ro_g1_out[6]));
ring_osc_i ro_8(.enable(en), .rst(rst), .delay(6'd8) , .out(ro_g1_out[7]));
ring_osc_i ro_9(.enable(en), .rst(rst), .delay(6'd9) , .out(ro_g2_out[0]));
ring_osc_i ro_10(.enable(en), .rst(rst), .delay(6'd10) , .out(ro_g2_out[1]));
ring_osc_i ro_11(.enable(en), .rst(rst), .delay(6'd11) , .out(ro_g2_out[2]));
ring_osc_i ro_12(.enable(en), .rst(rst), .delay(6'd12) , .out(ro_g2_out[3]));
ring_osc_i ro_13(.enable(en), .rst(rst), .delay(6'd13) , .out(ro_g2_out[4]));
ring_osc_i ro_14(.enable(en), .rst(rst), .delay(6'd14) , .out(ro_g2_out[5]));
ring_osc_i ro_15(.enable(en), .rst(rst), .delay(6'd15) , .out(ro_g2_out[6]));
ring_osc_i ro_16(.enable(en), .rst(rst), .delay(6'd16) , .out(ro_g2_out[7]));

MUX_8to1 first_Mux(.a(ro_g1_out[0]), .b(ro_g1_out[1]), .c(ro_g1_out[2]), .d(ro_g1_out[3]),.e(ro_g1_out[4]),.f(ro_g1_out[5]),.g(ro_g1_out[6]),.h(ro_g1_out[7]),.sel(scerambler_out[2:0]),.mux_out(first_mux_out));
MUX_8to1 second_Mux(.a(ro_g2_out[0]), .b(ro_g2_out[1]), .c(ro_g2_out[2]), .d(ro_g2_out[3]),.e(ro_g2_out[4]),.f(ro_g2_out[5]),.g(ro_g2_out[6]),.h(ro_g2_out[7]),.sel(scerambler_out[7:5]),.mux_out(second_mux_out));
counter g1_counter(.clk(clk), .rst(counter_rst), .global_rst(rst), .signal(first_mux_out), .finished(g1_finished));
counter g2_counter(.clk(clk), .rst(counter_rst), .global_rst(rst), .signal(second_mux_out), .finished(g2_finished));
race_arbiter ra(.finished1(g1_finished), .finished2(g2_finished), .global_rst(rst), .rst(race_arbiter_rst), .done(ra_done) , .out(ra_out));
buffer buff(.clk(clk), .rst(rst), .winner(ra_out), .done(ra_done), .response(response), .ready_to_read(ready) , .counter_rst(counter_rst), .scrambler_rst(scrambler_rst), .arbiter_rst(race_arbiter_rst));


endmodule
