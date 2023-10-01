module LFSR(
	input clk,
	input rst,
	input seed_val,
	input [7:0] seed,//if rst=1, d=8'd0
	output reg [7:0] d// d[0] = (d[7]^~d[5]) ^ (d[4] ^ ~d[3])
);
wire random_bit;
wire [7:0] n_LFSR;
reg [7:0] r_LFSR;
integer i;

assign n_LFSR = {r_LFSR[6:0], random_bit};
assign random_bit = (r_LFSR[7]^~r_LFSR[5]) ^ (r_LFSR[4] ^ ~r_LFSR[3]);

always@(posedge rst or posedge clk) begin
	if (rst)begin
		r_LFSR <= 8'd0;
	end
	else if(seed_val)begin
		r_LFSR <= seed;
	end
	else begin
		r_LFSR <= n_LFSR;
	end
end
always@(*) begin
	d = r_LFSR;
end



endmodule
