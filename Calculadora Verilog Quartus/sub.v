module sub(input [8:0] numberA, input [8:0] numberB, output reg [17:0] Result);
reg [7:0] absA;
reg [7:0] absB;

always @(*) begin
        if (numberA[8] == numberB[8]) begin // Mesmo sinal
            if (numberA[7:0] >= numberB[7:0]) begin
                Result[16:0] = numberA[7:0] - numberB[7:0];
                Result[17] = numberA[8]; // O resultado tem o mesmo sinal que A
            end else begin
                Result[16:0] = numberB[7:0] - numberA[7:0];
                Result[17] = !numberA[8]; // O resultado tem o sinal oposto, pois B > A
            end
        end else if (numberA[8] == 0) begin // A positivo, B negativo
            Result[16:0] = numberA[7:0] + numberB[7:0];
            Result[17] = 0; // Resultado positivo
        end else begin // A negativo, B positivo
            Result[16:0] = numberA[7:0] + numberB[7:0];
            Result[17] = 1; // Resultado negativo
        end
    end

endmodule
	