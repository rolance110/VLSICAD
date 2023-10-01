module fixedpoint(
	input [7:0] in1,// integer[7:5], decimal[4:0]
	input [7:0] in2,// integer[7:5], decimal[4:0]
	output reg [7:0] out// integer[7:2], decimal[1:0]
);
wire [15:0] all_out;
assign all_out = in1*in2;

always@(*)begin
	if(all_out[7])
		out = all_out[15:8] + 8'd1;
	else
		out = all_out[15:8];	
end



endmodule

