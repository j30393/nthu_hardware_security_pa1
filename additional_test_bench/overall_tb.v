`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: tb_PUF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_PUF();
parameter CLK_PERIOD = 2; // Clock period in time units
// Inputs
reg clk, en, rst;
reg [7:0] chall_in;

// Outputs
wire [7:0] response;
wire ready;

// Instantiate the module under test
top_PUF dut (
    .clk(clk),
    .en(en),
    .rst(rst),
    .chall_in(chall_in),
    .response(response),
    .ready(ready)
);

// Clock generation
always #((CLK_PERIOD/2)) clk = ~clk;

// Test bench logic
reg [7:0] test_chall;
reg test_rst;

initial begin
    // Initialize inputs
    clk = 0;
    en = 1; // Assuming enable is always high
    rst = 1; // Reset initially asserted
    test_chall = 8'b00000001;
    test_rst = 1;

    // Wait for PUF to be ready
    while (!ready) begin
        #1;
    end

    // Loop through all challenges
    while (test_chall != 8'b00000011) begin
        // Assert reset
        rst = 0;
        #1;
        rst = 1;

        // Provide challenge input
        chall_in = test_chall;
        #1;

        // Wait for PUF to be ready for the next challenge
        while (!ready) begin
            #1;
        end

        // Increment challenge
        test_chall = test_chall + 1;
    end

    // Final test
    // Assert reset
    rst = 0;
    #1;
    rst = 1;

    // Provide final challenge input
    chall_in = test_chall;
    #1;

    // Wait for PUF to be ready for the final challenge
    while (!ready) begin
        #1;
    end

    // Display response
    $display("Final response: %h", response);
    
    // End simulation
    $finish;
end

endmodule
