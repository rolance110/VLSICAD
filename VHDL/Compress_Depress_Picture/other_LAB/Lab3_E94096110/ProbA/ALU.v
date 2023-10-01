`define DATA_SIZE  32
`define OP_SIZE  5

`define ADD    5'b00000
`define SUB    5'b00001
`define OR     5'b00010
`define AND    5'b00011
`define XOR    5'b00100
`define NOT    5'b00101
`define NAND   5'b00110
`define NOR    5'b00111

`define MAX    5'b01000
`define MIN    5'b01001
`define ABS    5'b01010
`define SLT    5'b01011
`define SLTU   5'b01100
`define SRA    5'b01101
`define SLA    5'b01110
`define SRL    5'b01111
`define SLL    5'b10000
`define ROTR   5'b10001
`define ROTL   5'b10010
`define ADDU   5'b10011

module ALU (
	input [`OP_SIZE-1:0] alu_op,
	input [`DATA_SIZE-1:0] src1,
	input [`DATA_SIZE-1:0] src2,
	output reg [`DATA_SIZE-1:0] alu_out,
	output reg alu_overflow
);


wire signed [`DATA_SIZE-1:0] ssrc1;
assign ssrc1 = $signed(src1);
wire signed [`DATA_SIZE-1:0] ssrc2;
assign ssrc2 = $signed(src2);
reg [`DATA_SIZE+1:0] alu_out_max;



always@(*)begin
	case(alu_op)
		`ADD:	begin
				alu_out = ssrc1 + ssrc2;				
			end
		`SUB:	begin
				alu_out = ssrc1 - ssrc2;
			end
		`OR:	begin
				alu_out = src1 | src2;
			end
		`AND:	begin
				alu_out = src1 & src2;
			end
		`XOR:	begin
				alu_out = src1 ^ src2;
			end
		`NOT:	begin
				alu_out = ~src1;
			end
		`NAND: begin
				alu_out = ~(src1 & src2);
			end
		`NOR:	begin 
				alu_out = ~(src1 | src2);
			end
		`MAX:	begin
				if(ssrc1>ssrc2)
					alu_out = src1;
				else
					alu_out = src2;
			end
		`MIN:	begin
				if(ssrc1<ssrc2)
					alu_out = src1;
				else
					alu_out = src2;
			end
		`ABS:	begin
				if(ssrc1>0)
					alu_out = src1;
				else
					alu_out = ~src1 + 1;
			end
		`SLT:	begin
				alu_out = (ssrc1 < ssrc2) ? 32'd1 : 32'd0;
			end
		`SLTU: begin
				alu_out = (src1 < src2) ? 32'd1 : 32'd0; 
			end
		`SRA:	begin
				alu_out = ssrc1 >>> src2; 
			end
		`SLA:	begin
				alu_out = ssrc1 <<< src2; 
			end
		`SRL:	begin
				alu_out = src1 >> src2;  
			end
		`SLL:	begin
				alu_out = src1 << src2;
			end
		`ROTR: begin
				alu_out = (src1>>src2) | (src1<<(32-src2));
			end
		`ROTL: begin
				alu_out = (src1<<src2) | (src1>>(32-src2));
			end
		`ADDU: begin
				alu_out = src1 + src2;
			end
		default:begin
			alu_out = 32'd0;
		end
	endcase
end
always@(*)begin
	case(alu_op)
		`ADD:	begin
				if(src1[31]==1'b0 && src2[31]==1'b0 && alu_out[31]==1'b1)
                    		alu_overflow = 1'b1;
                		else if(src1[31]==1'b1 && src2[31]==1'b1 && alu_out[31]==1'b0)
                    		alu_overflow = 1'b1;
                		else
                    		alu_overflow = 1'b0;				
			end
		`SUB:	begin
				if(src1 > src2 && alu_out[31]==1'b1)
                    		alu_overflow = 1'b1;
                		else if(src1 < src1 && alu_out[31]==1'b0)   
                    		alu_overflow = 1'b1;
                		else
                    		alu_overflow = 1'b0;
			end
		`OR:	begin
				alu_overflow = 1'b0;
			end
		`AND:	begin
				alu_overflow = 1'b0;
			end
		`XOR:	begin
				alu_overflow = 1'b0;
			end
		`NOT:	begin
				alu_overflow = 1'b0;
			end
		`NAND: begin
				alu_overflow = 1'b0;
			end
		`NOR:	begin 
				alu_overflow = 1'b0;
			end
		`MAX:	begin
				alu_overflow = 1'b0;
			end
		`MIN:	begin
				alu_overflow = 1'b0;
			end
		`ABS:	begin
				alu_overflow = 1'b0;
			end
		`SLT:	begin
				alu_overflow = 1'b0;
			end
		`SLTU: begin
				alu_overflow = 1'b0; 
			end
		`SRA:	begin
				alu_overflow = 1'b0; 
			end
		`SLA:	begin
				alu_overflow = 1'b0;
			end
		`SRL:	begin
				alu_overflow = 1'b0;  
			end
		`SLL:	begin
				alu_overflow = 1'b0;
			end
		`ROTR: begin
				alu_overflow = 1'b0;
			end
		`ROTL: begin
				alu_overflow = 1'b0;
			end
		`ADDU: begin
				if(src1[31]==1'b1 && src2[31]==1'b1 && alu_out[31]==1'b0)
                    		alu_overflow = 1'b1;
                    	else if(src1[31]==1'b1 && src2[31]==1'b0 && alu_out[31]==1'b0)
                    		alu_overflow = 1'b1;
                    	else if(src1[31]==1'b0 && src2[31]==1'b1 && alu_out[31]==1'b0)
                    		alu_overflow = 1'b1;
                    		
                		else
                    		alu_overflow = 1'b0;					
			end
		default:begin
			alu_overflow = 1'b0;
		end
	endcase
end


























endmodule
