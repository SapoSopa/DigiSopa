module ResDig(
    input wire [16:0] Result,
    output reg [3:0] dMR,
    output reg [3:0] uMR,
    output reg [3:0] cR,
    output reg [3:0] dR,
    output reg [3:0] uR
);

always @(*) begin
    uR = Result % 10;
    dR = (Result / 10) % 10;
    cR = (Result / 100) % 10;
    uMR = (Result / 1000) % 10;
    dMR = (Result / 10000) % 10;
end

endmodule