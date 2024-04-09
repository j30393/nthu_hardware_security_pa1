`timescale 1ns / 1ps
/*
* Create Date: 
* Design Name:
* Module Name: buffer
* Project Name: Delay-based Physical Unclonable Function Implementation
* Target Devices: Digilent S7-25, S7-50 (Xilinx Spartan 7)
* Tool Versions:
* Description: This buffer stores each bit from each race. It is also in
*              charge of reset logic.
*
* Dependencies:
*
* Revision:
* 
* Additional Comments:
*
*/

module buffer(clk, rst, winner, done, response, ready_to_read , counter_rst, scrambler_rst, arbiter_rst);
input clk, rst;
input winner;	 //output of race_arbiter
input done;	 //output of race_arbiter
output reg[7:0] response;
output ready_to_read;	//ready to read response

//reset signal:pay attention to the order of resetting of these three
output counter_rst;	//reset counter while generating response
output scrambler_rst;	//reset scrambler while generating response 
output arbiter_rst;	//reset arbiter while generating response 

reg [3:0] count = 0;
reg counter_rst_reg = 0;
reg scrambler_rst_reg = 0;
reg arbiter_rst_reg = 0;
reg ready_to_read_reg = 0;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        response <= 8'b0;
        ready_to_read_reg <= 1'b0;
        count <= 4'b0;
    end
    else begin
        counter_rst_reg <= 1'b0;
        arbiter_rst_reg <= 1'b0;
        scrambler_rst_reg <= 1'b0;
        if(done) begin
            counter_rst_reg <= 1'b1;
            arbiter_rst_reg <= 1'b1;
            if(count == 4'b1000) begin
                response <= response;
                ready_to_read_reg <= 1'b1;
                count <= 4'b0;
                scrambler_rst_reg <= 1'b1;
            end
            else begin
                response <= {response[6:0], winner};
                count <= count + 1;
            end
        end
    end
end

assign counter_rst = counter_rst_reg;
assign scrambler_rst = scrambler_rst_reg;
assign arbiter_rst = arbiter_rst_reg;
assign ready_to_read = ready_to_read_reg;

endmodule
