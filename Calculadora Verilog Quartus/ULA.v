module ULA(
	input clk, 
	input [8:0] numberA, input [8:0] numberB,
	input B0, B1, B2, B3,
	output RS, RW, EN, 
	output [7:0] data,
	output L0_0, L1_2, L2_4, L3_6
	
);

assign L0_0 = ~B0;
assign L1_2 = ~B1;
assign L2_4 = ~B2;
assign L3_6 = ~B3;


// logica das ops e da tela on/off(organizar as ordens
parameter soma = 3, sub = 2, multi = 1, start = 0;
reg [3:0] op = start;
parameter ON = 1, OFF = 0;
reg screen = ON;
reg bldstd;
reg bldstd1;
reg bldstd2;
reg bldstd3;


lcdController(clk, op, screen, numberA, numberB, RS, RW, EN, data);

always @(posedge clk) begin
	bldstd <= B0;
	bldstd1 <= B1;
	bldstd2 <= B2;
	bldstd3 <= B3;
	
	if (B0 && ~bldstd) begin
		if(screen) screen <= OFF;
		else screen <= ON; op <= start;
	end
	
	if (B1 && ~bldstd1) op <= multi;
	
	if (B2 && ~bldstd2) op <= sub;
	
	if (B3 && ~bldstd3) op <= soma;
end


endmodule
