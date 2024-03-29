module ring_osc_tb;

    // Define parameters
    parameter DELAY = 6; // Set delay time between stages to 6

    // Inputs
    reg enable;
    reg rst;
    reg [5:0] delay;
    // Output
    wire out;

    // Instantiate the module
    ring_osc_i uut(
        .enable(enable),
        .rst(rst),
        .delay(delay),
        .out(out)
    );


    // Stimulus
    initial begin
        enable = 1'b0; // Enable the oscillator
        #50;
        enable = 1'b1; // Enable the oscillator
        rst = 0; // No reset initially
        delay = DELAY; // Set delay time
        // Apply stimulus
        #10; // Wait for some time
        // Toggle reset to start oscillation
        rst = 1;
        #10;
        rst = 0;
        // Wait for some time to observe oscillation
        #1000;
        // Stop the simulation
        $finish;
    end

endmodule