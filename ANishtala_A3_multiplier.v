module multiplier #(parameter WIDTH = 6)(
    input signed [WIDTH-1:0] a,  // First input to multiplier
    input signed [WIDTH-1:0] b,  // Second input to multiplier
    output reg signed [2*WIDTH-1:0] product  // Product output
);

    always @(*) begin
        product = a * b;  // Perform multiplication
    end
endmodule
