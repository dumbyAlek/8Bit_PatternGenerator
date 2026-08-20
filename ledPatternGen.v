`timescale 1ns / 1ps

module led_pattern #(
    // Assuming a 50 MHz clock: 50,000,000 Hz * 0.5s = 25,000,000 cycles.
    // We subtract 1 because the counter starts at 0.
    parameter MAX_COUNT = 24999999 
)(
    input wire clk,      // System clock
    input wire rst,      // Synchronous reset
    output reg [7:0] led // 8-bit LED pattern output
);

    // 25 bits is enough to store up to 33,554,431 (covers our 25M requirement)
    reg [24:0] counter; 
    
    // Internal signal that pulses high for one clock cycle every 0.5 seconds
    wire tick; 

    // --------------------------------------------------------
    // Block 1: Clock Divider / Counter
    // Generates the 0.5-second timing interval
    // --------------------------------------------------------
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

    // --------------------------------------------------------
    // Block 2: Synchronous Sequential Logic (Shift Register)
    // Controls the LED movement and wrapping
    // --------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            // Requirement 5: Reset state must be 10000000
            led <= 8'b10000000;
        end else if (tick) begin
            // Requirement 3 & 4: Shift right by 1 and wrap LSB to MSB
            // This is achieved via concatenation
            led <= {led[0], led[7:1]};
        end
    end

endmodule