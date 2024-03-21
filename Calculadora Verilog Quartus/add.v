module add(input [8:0] numberA, input [8:0] numberB, output reg [17:0] Result);
reg [7:0] absA;
reg [7:0] absB;


always @(*) begin
	if(numberA[7:0] > 0) absA = numberA[7:0];
	else absA = -numberA[7:0];
	
	if(numberB[7:0] > 0 ) absB = numberB[7:0];
	else absB = -numberB[7:0];
	
	// sinais iguais
	if(numberA[8] == numberB[8]) begin
		Result[16:0] = absA + absB;
		Result[17] = numberA[8];
	end else begin
	// sinais diferentes
		if(absA >= absB) begin 
			Result[16:0] = absA - absB;
			Result[17] = numberA[8];
		end else begin
			Result[16:0] = absB - absA;
			Result[17] = numberB[8];
		end
	end
end

endmodule
	