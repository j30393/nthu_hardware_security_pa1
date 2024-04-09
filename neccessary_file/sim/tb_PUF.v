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
always #(1) clk = ~clk;

initial begin
    // Initialize inputs
    #2
    clk = 0;
    #2;
    en = 1; // Assuming enable is always high
    rst = 1; // Reset initially asserted
    chall_in = 8'b00000001;
    #2;
    rst = 0; // De-assert reset

    // Wait for PUF to be ready
    while (!ready) begin
        #1;
    end
    $display("chanllenge %d with response: %b",chall_in ,response);
    // Loop through all challenges
    while (chall_in != 8'b11111111) begin
        // Assert reset
        rst = 0;
        #1;
        rst = 1;
        chall_in = chall_in + 1;
        #1;  
        rst = 0;
        // Provide challenge input
        #1;
        // Wait for PUF to be ready for the next challenge
        while (!ready) begin
            #1;
        end
        $display("chanllenge %d with response: %b",chall_in ,response);
    end

    // Final test
    // Assert reset
    rst = 0;
    #1;
    rst = 1;

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
