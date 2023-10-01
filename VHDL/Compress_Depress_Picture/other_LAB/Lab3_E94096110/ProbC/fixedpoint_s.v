module fixedpoint_s(
	input [7:0] in1,// sign[7], integer[6:4], decimal[3:0]
	input [7:0] in2,// sign[7], integer[6:4], decimal[3:0]
	output reg [7:0] out// sign[7], integer[6:1], decimal[0]
);
wire [15:0] max_out;


reg [7:0] p_in1; //change to positive number
reg [7:0] p_in2;
always@(*)begin
	if(in1[7])
		p_in1 = ~(in1-8'd1);
	else
		p_in1 = in1;
end 
always@(*)begin
	if(in2[7])
		p_in2 = ~(in2-8'd1);
	else
		p_in2 = in2;
end  
assign max_out = p_in1*p_in2;
wire [7:0] t_out;
assign t_out = max_out[14:7];

reg [7:0] roundf;
always@(*) begin
	if (max_out[6])
		roundf = t_out + 8'd1;
	else begin
		roundf = t_out;
	end
end

always@(*)begin
	if(in1[7]^in2[7])begin
		out = ~roundf + 8'd1;                   //round,-
 	end
	else 
		out = roundf;	
end
endmodule
  
