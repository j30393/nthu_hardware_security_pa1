`timescale 1ns / 1ps
module tb_scrambler;

// testbench refer to https://blog.csdn.net/wuzhikaidetb/article/details/136287042
// Inputs
reg clk, rst;
reg [7:0] input_challenge;
reg	[7:0] cnt; // the counter
// Outputs
wire [7:0] output_challenge;

// Instantiate the module under test
scrambler dut (
    .input_challenge(input_challenge),
    .clk(clk),
    .rst(rst),
    .output_challenge(output_challenge)
);

// Clock generation
always #2 clk = ~clk; // Assuming 10ns clock period, 50% duty cycle

// Reset generation
initial begin
    clk = 0;
    rst = 1;
    input_challenge = 8'b00000001; // Initialize input challenge
    // Apply reset
    #1 rst = 0;
    // Apply input challenges
    repeat (256) begin // Iterate over all possible 8-bit inputs
        #1 rst = 1;
        #1 rst = 0;
        input_challenge = input_challenge + 1; // Increment input challenge
        wait(cnt == 255);
        #10; // Wait a few cycles
        // Display output challenge and input challenge for verification
        //$display("Input: %h, Output: %h", input_challenge, output_challenge);
    end
    
    // End simulation
    $finish;
end

always@(posedge clk)begin
	if(rst)
		cnt <= 8'd0;
	else begin
		cnt <= cnt + 1'd1;
	end
end

endmodule