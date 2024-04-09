`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: ring_osc_0, ring_osc_1, ring_osc_2 ...... ring_osc_i (i=15)
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: The ring_osc module is a ring oscillator with 14 inverters that loop
//              back into the Nand Gate effectively making 15 inverters in total.
//              Design 16 ring oscillators with different timing delay.
// 
// Dependencies: You can depend on varying inverters or NAND gates which you design
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ring_osc_i(enable, rst, delay , out);
input enable, rst;
input [5:0] delay;// Parameter for delay time between stages
output out;
reg [14:0] ring_osc; // 14 inverters

always @(posedge rst) begin
    if(rst) begin
        ring_osc = 15'b0;
    end
end

genvar gi;
generate
    for (gi=0; gi<15; gi=gi+1) begin : ring_osc_gen
        if(gi==0) // feedback to first stage
            always @(*) begin
                #(delay) ring_osc[gi] = ~ring_osc[14] & enable;
            end
        else begin
            always @(*) begin
                #(delay) ring_osc[gi] = ~ring_osc[gi-1];
            end
        end
    end
endgenerate


assign out = ring_osc[0];

endmodule
