`timescale 1ns / 1ps

module tb_led_pattern;

    // Inputs
    reg clk;
    reg rst;

    // Output
    wire [7:0] led;

    // Instantiate the Pattern Generator Module
    led_PatternGen lpg (clk,rst,led);

    // Generate a 50 MHz clock (20ns period -> toggle every 10ns)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Apply reset to initialize the system
        rst = 1;
       
        // Hold reset
        #100;
       
        // Release reset and let the pattern run
        rst = 0;
       
        // Wait long enough to see a full rotation.
        // Instead of #4000000000 which will break the 32 bit limit, we use #500000000 8 times
        #500000000;
        #500000000;
        #500000000;
        #500000000;
        #500000000;
        #500000000;
        #500000000;
        #500000000;
        #500000000;
        #500000000;
       
        // Test if the reset immediately returns the state to 10000000
        rst = 1;
        #500000000;
       
        // Pause the simulation
        $stop;
    end

    // Print changes to the console
    initial begin
        $monitor("Time: %0t ns | Reset: %b | LED Pattern: %b", $time, rst, led);
    end

endmodule