module numDig(
    // recebe so o modulo de 8 de tamanho
    input [7:0] number,
    output reg [3:0] cente,
    output reg [3:0] deze,
    output reg [3:0] unid
);

always @(*) begin
    unid = number % 10;
    deze = (number / 10) % 10;
    cente = (number / 100) % 10;
end

endmodule
