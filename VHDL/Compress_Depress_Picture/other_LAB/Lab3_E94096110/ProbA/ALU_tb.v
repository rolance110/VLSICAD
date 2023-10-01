`timescale 1ns/10ps

`include "ALU.v"

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

module ALU_tb;

// ----------------------   reg   ---------------------- //
reg   [`OP_SIZE-1:0]  alu_op;
reg   [`DATA_SIZE-1:0]   src1;
reg   [`DATA_SIZE-1:0]   src2;

// ----------------------   wire  ---------------------- //
wire   [`DATA_SIZE-1:0]  alu_out;
wire                    alu_overflow;

integer error;

ALU alu (
	.alu_op(alu_op),
	.src1(src1),
	.src2(src2),
    .alu_out(alu_out),
	.alu_overflow(alu_overflow)
);

initial begin
	$monitor($time, " opcode = %h, src1 = %h, src2 = %h, alu_out = %h, alu_overflow = %h", alu_op, src1, src2, alu_out, alu_overflow);
end

initial begin
	error=0;
	#5
	if(alu_out==32'h0000_0011 && alu_overflow==1'b0)begin//ADD1
		error = error;
	end
	else begin
		$display("there are some errors with ADD");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h0000_0001 && alu_overflow==1'b0)begin//ADD2
		error = error;
	end
	else begin
		$display("there are some errors with ADD");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h8000_0001 && alu_overflow==1'b1)begin//ADD3
		error = error;
	end
	else begin
		$display("there are some errors with ADD");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'hffff_ffff && alu_overflow==1'b0)begin//SUB
		error = error;
	end
	else begin
		$display("there are some errors with SUB");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'hffff_0000 && alu_overflow==1'b0)begin//OR
		error = error;
	end
	else begin
		$display("there are some errors with OR");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h00ff_0000 && alu_overflow==1'b0)begin//AND
		error = error;
	end
	else begin
		$display("there are some errors with AND");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'hff00_ff00 && alu_overflow==1'b0)begin//XOR
		error = error;
	end
	else begin
		$display("there are some errors with XOR");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'hffff_0000 && alu_overflow==1'b0)begin//NOT
		error = error;
	end
	else begin
		$display("there are some errors with NOT");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'hff00_ffff && alu_overflow==1'b0)begin//NAND
		error = error;
	end
	else begin
		$display("there are some errors with NAND");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h0000_ffff && alu_overflow==1'b0)begin//NOR
		error = error;
	end
	else begin
		$display("there are some errors with NOR");
		$finish;
		error = error +1;
	end
	
	//---------------------------------------------------------
	#10
	if(alu_out==32'h1234_5678 && alu_overflow==1'b0)begin//MAX
		error = error;
	end
	else begin
		$display("there are some errors with MAX");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'hffff_ffff && alu_overflow==1'b0)begin//MIN
		error = error;
	end
	else begin
		$display("there are some errors with MIN");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h0000_0001 && alu_overflow==1'b0)begin//ABS
		error = error;
	end
	else begin
		$display("there are some errors with ABS");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h0000_0000 && alu_overflow==1'b0)begin//SLT
		error = error;
	end
	else begin
		$display("there are some errors with SLT");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h0000_0001 && alu_overflow==1'b0)begin//SLTU
		error = error;
	end
	else begin
		$display("there are some errors with SLTU");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'hffff_0000 && alu_overflow==1'b0)begin//SRA
		error = error;
	end
	else begin
		$display("there are some errors with SRA");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h0000_ff00 && alu_overflow==1'b0)begin//SLA
		error = error;
	end
	else begin
		$display("there are some errors with SLA");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h00ff_0000 && alu_overflow==1'b0)begin//SRL
		error = error;
	end
	else begin
		$display("there are some errors with SRL");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h0000_ff00 && alu_overflow==1'b0)begin//SLL
		error = error;
	end
	else begin
		$display("there are some errors with SLL");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'hf0f0_f0f0 && alu_overflow==1'b0)begin//ROTR
		error = error;
	end
	else begin
		$display("there are some errors with ROTR");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'hf0f0_f0f0 && alu_overflow==1'b0)begin//ROTL
		error = error;
	end
	else begin
		$display("there are some errors with ROTL");
		$finish;
		error = error +1;
	end
	#10
	if(alu_out==32'h8000_0001 && alu_overflow==1'b0)begin//ADDU
		error = error;
	end
	else begin
		$display("there are some errors with ADDU");
		$finish;
		error = error +1;
	end
	#10
  
	if(error === 0)begin
        $display("\n");
        $display("\n");
        $display("        ****************************               ");
        $display("        **                        **       |\\__||  ");
        $display("        **  Congratulations !!    **      / O.O  | ");
        $display("        **                        **    /_____   | ");
        $display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w| ");
        $display("        ****************************   \\m___m__|_|");
        $display("\n");
	end
	/*else begin
        $display("\n");
        $display("\n");
        $display("        ****************************               ");
        $display("        **                        **       |\__||  ");
        $display("        **  OOPS!!                **      / X,X  | ");
        $display("        **                        **    /_____   | ");
        $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w| ");
        $display("        ****************************   \\m___m__|_|");
        $display("         There are %d errors                     ", error); 
        $display("\n");
    end*/
end

initial begin
	#0	alu_op = `ADD;  src1 = 32'h0000_000f; src2 = 32'h0000_0002;// 15 + 2, 0000_0011
	#10	alu_op = `ADD;  src1 = 32'hffff_ffff; src2 = 32'h0000_0002;// -1 + 2, 0000_0001
	#10	alu_op = `ADD;  src1 = 32'h7fff_ffff; src2 = 32'h0000_0002;// overflow, 8000_0001
	#10	alu_op = `SUB;  src1 = 32'h0000_0001; src2 = 32'h0000_0002;// 1 - 2, ffff_ffff
	#10	alu_op = `OR;	src1 = 32'hffff_0000; src2 = 32'h0000_0000;// ffff_0000
	#10	alu_op = `AND;  src1 = 32'hffff_0000; src2 = 32'h00ff_0000;// 00ff_0000
	#10	alu_op = `XOR;  src1 = 32'hffff_0000; src2 = 32'h00ff_ff00;// ff00_ff00
	#10 alu_op = `NOT;  src1 = 32'h0000_ffff; src2 = 32'h0000_0000;// ffff_0000
	#10 alu_op = `NAND; src1 = 32'hffff_0000; src2 = 32'h00ff_0000;// ff00_ffff
	#10 alu_op = `NOR;  src1 = 32'hffff_0000; src2 = 32'h0000_0000;// 0000_ffff
	
	#10	alu_op = `MAX;  src1 = 32'h1234_5678; src2 = 32'hffff_ffff;// 1234_5678
	#10	alu_op = `MIN;  src1 = 32'h1234_5678; src2 = 32'hffff_ffff;// ffff_ffff
	#10	alu_op = `ABS;  src1 = 32'hffff_ffff; src2 = 32'h0000_0000;// 0000_0001
	#10	alu_op = `SLT;  src1 = 32'h1234_5678; src2 = 32'hffff_ffff;// 0000_0000
	#10	alu_op = `SLTU; src1 = 32'h1234_5678; src2 = 32'hffff_ffff;// 0000_0001
	#10	alu_op = `SRA;  src1 = 32'hff00_00ff; src2 = 32'h0000_0008;// ffff_0000
	#10	alu_op = `SLA;  src1 = 32'hff00_00ff; src2 = 32'h0000_0008;// 0000_ff00
	#10	alu_op = `SRL;  src1 = 32'hff00_00ff; src2 = 32'h0000_0008;// 00ff_0000
	#10	alu_op = `SLL;  src1 = 32'hff00_00ff; src2 = 32'h0000_0008;// 0000_ff00
	#10	alu_op = `ROTR; src1 = 32'h0f0f_0f0f; src2 = 32'h0000_0004;// f0f0_f0f0
	#10	alu_op = `ROTL; src1 = 32'h0f0f_0f0f; src2 = 32'h0000_0004;// f0f0_f0f0
	#10	alu_op = `ADDU; src1 = 32'h7fff_ffff; src2 = 32'h0000_0002;// 8000_0001
	#100  $finish;
end

initial begin
	`ifdef FSDB
		$fsdbDumpfile("ALU.fsdb");
		$fsdbDumpvars;
	`endif
end

endmodule
