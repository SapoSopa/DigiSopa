module multi(input [8:0] numberA, input [8:0] numberB, output reg [17:0] Result);
reg [16:0] temp;
reg [7:0] absA;
reg [7:0] absB;
reg [7:0] i;
always @(*) 
begin
	if(numberA[7:0] > 0) absA = numberA[7:0];
	else absA = -numberA[7:0];
	
	if(numberB[7:0] > 0 ) absB = numberB[7:0];
	else absB = -numberB[7:0]; 
	
	temp = 0;
	for(i = 0; i < 8; i = i + 1) 
	begin
		if(absA[i] == 1) 
		begin
			temp = temp + (absB << i);
		end
	end
	Result[16:0]  <= temp;
	if(numberA[8] != numberB[8]) Result[17] = 1;
	else Result[17] = 0;
end
	
endmodule
