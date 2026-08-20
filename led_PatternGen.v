`timescale 1ns / 1ps

module led_PatternGen (clk,rst,led);
    parameter MAX_COUNT = 24999999;     // Assuming a 50 MHz clock: 50,000,000 Hz * 0.5s = 25,000,000 cycles. We subtract 1 because the counter starts at 0.
    input wire clk;      // System clock
    input wire rst;      // Synchronous reset
    output reg [7:0] led; // 8-bit LED pattern output

    // 25 bits to store up to 33,554,431 (covers our 25M requirement)
    reg [24:0] counter; 
    
    // Internal signal that pulses high for one clock cycle every 0.5 seconds
    wire tick; 

    // Clock Divider / Counter: Generates the 0.5-second timing interval
    always @(posedge clk) begin
        if (rst) begin
            counter <= 25'd0;
        end else if (counter == MAX_COUNT) begin
            counter <= 25'd0;   
        end else begin
            counter <= counter + 1'b1;
        end
    end

    // Tick evaluates to 1 only when the counter hits the max value
    assign tick = (counter == MAX_COUNT);

    // Synchronous Sequential Logic (Shift Register): Controls the LED movement and wrapping
    always @(posedge clk) begin
        if (rst) begin
            // Reset state is 10000000
            led <= 8'b10000000;
        end 
        else if (tick) begin
            // Shift right by 1
            led <= {led[0], led[7:1]};
        end
    end

endmodule

/*
Concatenation works because everytime we bring the LSB to the front (MSB), the entire thing is autimatically shifted right.
10000000
01000000
00100000
00010000
00001000
00000100
00000010
00000001
10000000
*/