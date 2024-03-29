`timescale 1ns / 1ps

module counter_tb;

    // Parameters
    parameter CLK_PERIOD = 2; // Clock period in ns
    
    // Signals
    reg clk;
    reg rst;
    reg signal;
    wire finished;

    // Instantiate the counter module
    counter counter_inst (
        .clk(clk),
        .rst(rst),
        .signal(signal),
        .finished(finished)
    );

    // Clock generation
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Initial stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        signal = 0;

        // Wait for a few clock cycles
        #10;

        // De-assert reset
        rst = 0;

        // Apply some signal pulses
        #20 signal = 1;
        #20 signal = 0;
        #20 signal = 1;

        // Wait for the simulation to finish
        #100 $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("Time=%0t: Count=%d, Finished=%b", $time, counter_inst.count, finished);
    end

endmodule