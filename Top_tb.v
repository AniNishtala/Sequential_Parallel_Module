`timescale 1ns / 1ps

module Top_tb;

    // Inputs to the DUT (Device Under Test)
    reg clock;              // Clock input
    reg [1:0] control;      // Control input
    reg [5:0] A;            // 6-bit input A
    reg [5:0] B;            // 6-bit input B
    reg [11:0] C;           // 12-bit input C
    wire [23:0] out;        // 24-bit output

    // Instantiate Top module
    Top uut (
        .clock(clock),
        .control(control),
        .A(A),
        .B(B),
        .C(C),
        .out(out)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;  // Clock period of 10 ns
    end

    // Wave generation
    initial begin
        // Initialize all inputs to 0
        A = 6'b0;
        B = 6'b0;
        C = 12'b0;
        control = 2'b00;
        
        // 10ns delay
        #10;

        // Test default case (Control = 2'b00, Output 0s)
        control = 2'b00;  // Control value not matching any case
        #20;  // Wait for 2 clock cycles
        $display("Control = 00, A = %d, B = %d, C = %d, Out = %b (Expected: 0)", A, B, C, out);

        // Test control = 2'b01 (6x6 multiplication)
        A = 6'd10;  // A = 10
        B = 6'd3;   // B = 3
        control = 2'b01;
        #20;  // Wait for 2 clock cycles
        $display("Control = 01, A = %d, B = %d, Out = %b (Expected: 30)", A, B, out);

        // Test control = 2'b10 (12x12 multiplication)
        A = 6'd5;   // A = 5
        C = 12'd7;  // C = 7
        control = 2'b10;
        #20;  // Wait for 2 clock cycles
        $display("Control = 10, A = %d, C = %d, Out = %b (Expected: 35)", A, C, out);

        // Test control = 2'b11 (Addition of A, B, and C)
        A = 6'd1;   // A = 1
        B = 6'd2;   // B = 2
        C = 12'd3;  // C = 3
        control = 2'b11;
        #20;  // Wait for 2 clock cycles
        $display("Control = 11, A = %d, B = %d, C = %d, Out = %b (Expected: 6)", A, B, C, out);

        // End wave form generation
        $stop;
    end

endmodule
