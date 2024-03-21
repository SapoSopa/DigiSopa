module lcdController(
	input clk,
	input [3:0] op,
	input  screen,
	input [8:0] numberA, input [8:0] numberB,
	output reg RS, RW, EN, 
	output reg [7:0] data
);

// macros
`define send(instr, rs) begin data <= instr; RS <= rs; end // para mandar sinais sem escrever tanto
`define sNum(num) `send({4'b0, num} + 8'd48, 1) // soma com 48 para chegar na representação de ascii dos numeros
`define space begin data <= 8'd32; RS <= 1; end // Espaço, 8'b00100000
`define move(pos) begin   data <= pos; RS <= 0;    end // move

initial begin
	data = 0; RS = 0; RW = 0; EN = 0;
end

// variaveis do contador
parameter WRITE = 0, WAIT = 1, MS = 50_000, OVER = 50; // talvez trocar para 25
reg [31:0] counter = 0;
reg [7:0] instu = 0;
reg init = 0;
reg [3:0] state = WRITE;
parameter soma = 3, sub = 2, multi = 1, start = 0;


// Digitos
// A
wire [3:0] centeA;
wire [3:0] dezeA;
wire [3:0] unidA;
numDig(numberA[7:0], centeA, dezeA, unidA);
// B
wire [3:0] centeB;
wire [3:0] dezeB;
wire [3:0] unidB;
numDig(numberB[7:0], centeB, dezeB, unidB);
// Resultado
reg [17:0] Result;
wire [3:0] dezeMR;
wire [3:0] unidMR;
wire [3:0] centeR;
wire [3:0] dezeR;
wire [3:0] unidR;
ResDig(Result[16:0], dezeMR, unidMR, centeR, dezeR, unidR);

wire [17:0] multiRes;
multi(numberA, numberB, multiRes);
wire [17:0] addRes;
add(numberA, numberB, addRes);
wire [17:0] subRes;
sub(numberA, numberB, subRes);

reg t = 0;

always @(posedge clk) begin

	case (state)
      WRITE: begin
            if (counter == MS - 1) begin
                state <= WAIT; counter <= 0;
            end else begin
                counter <= counter + 1;
            end
				EN <= 1;
      end
		
      WAIT: begin 
            if (counter == MS - 1) begin
                state <= WRITE; counter <= 0;
                if (instu < OVER) instu <= instu + 1; 
					 else instu <= 0; // talvez mudar isso
            end else begin
                counter <= counter + 1;
            end
				EN <= 0;
				
      end   
        
      default: begin end
   endcase
	
	case(op)
			start:  Result <= 18'b0;
			multi: Result <= multiRes;
			sub: Result <= subRes;
			soma: Result <= addRes;
	endcase
	
	if(screen) begin
		if(init) begin
			case (instu)
				0: begin data <= 8'h38; RS <= 0; end // Duas Linhas
				1: begin data <= 8'h01; RS <= 0; end // Limpar
				//2: begin data <= 8'h80; RS <= 0; end // Ir para 4
				2: begin data <= 8'h0C; RS <= 0; end // Configurar Cursor
			endcase
			init = 0;
			instu <= -1; // talvez isso buge
		end else begin
			case (instu)
				//0: begin data = 8'h01; RS = 0; end // Limpar
				0: `space
				1: `space
				2: begin 
						if(numberA[7:0] == 0) `space // se for zero ele nao mostra sinal
						else `send(numberA[8]? "-":"+", 1)
					end
				// A
				3: `sNum(centeA)
				4: `sNum(dezeA)
				5: `sNum(unidA)
				6: `space
				// sinal de op
				7: begin
						case(op)
							start: `send(" ", 1)
							multi: `send("x", 1)
							sub: `send("-", 1)
							soma: `send("+", 1)
						endcase
					end
				8: `move(8'h89)
				// sinal de B
				9: begin
						if(numberB[7:0] == 0) `space // se for zero ele nao mostra sinal
						else `send(numberB[8]? "-":"+", 1) 
					end
				10: `sNum(centeB)
				11: `sNum(dezeB)
				12: `sNum(unidB)
				13: `move(8'hC4) 
				14: begin 
						if(Result[16:0] == 0) `space // se for zero ele nao mostra sinal
						else `send(Result[17]? "-":"+", 1)	
					end
				15: `sNum(dezeMR)
				16: `sNum(unidMR)
				17: `sNum(centeR)
				18: `sNum(dezeR)
				19: `sNum(unidR)
				
				default: begin data <= 8'h80; RS <= 0; end // ir para o 4
			endcase
		end
	end else begin
		if(!init) init = 1;
		else begin
			case(instu)
				0: begin data = 8'h01; RS = 0; end // Limpar
				1: begin data <= 8'h82; RS <= 0; end // Ir para 4
				default: begin data = 8'h01; RS = 0; end // Limpar
				// vendo ele mais devagar observei que ele faz\ as coisas em ordem trocada
				// ele ta dando problema pois o instu ele fica indo ate o over e caindo no default, a instrução 01 manda para a posiação 0
				// ai quando liga ele em algumas ocasiões ele vai direto mandando as instruções de impressão antes de limpar e mudar a pos
			endcase
			
			instu <= -1; // talvez isso buge
		end
	end

end


endmodule
