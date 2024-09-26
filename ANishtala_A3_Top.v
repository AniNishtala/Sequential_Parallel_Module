module Top(
    input clock,        // Clock input to module
    input [1:0] control, // 2-bit vector bus defined as control
    input [5:0] A,      // First input A is a 6-bit vector bus
    input [5:0] B,      // Second input B is a 6-bit vector bus
    input [11:0] C,     // Third input C is a 12-bit vector bus
    output reg [23:0] out // Output 'out' is a 24-bit vector bus
);

// Registered inputs
reg [5:0] regA;
reg [5:0] regB;
reg [11:0] regC;

// Wires for multiplication results
wire [11:0] mul6_result;
wire [23:0] mul12_result;

// Instantiate 6-bit multiplier
multiplier #(.WIDTH(6)) mul6 (
    .a(regA),
    .b(regB),
    .product(mul6_result)
);

// Instantiate 12-bit multiplier
multiplier #(.WIDTH(12)) mul12 (
    .a({{6{regA[5]}}, regA}),  // Sign-extend A to 12 bits
    .b(regC),
    .product(mul12_result)
);

// Input registration
always @(posedge clock) begin
    regA <= A;
    regB <= B;
    regC <= C;
end

// Output logic
always @(posedge clock) begin
    case (control)
        2'b01: out <= {{12{mul6_result[11]}}, mul6_result};  // Sign-extend to 24 bits
        2'b10: out <= mul12_result;
        2'b11: out <= {{18{regA[5]}}, regA} + {{18{regB[5]}}, regB} + {{12{regC[11]}}, regC};  // Sign-extend A, B, C to 24 bits and add
        default: out <= 24'b0;
    endcase
end

endmodule
