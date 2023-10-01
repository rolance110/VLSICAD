/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen -------------------- //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.02    ---------------------- //
// ---------------------- K-map simplifier  ---------------------- // 
/////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps
`define CYCLE 10

`include "kmap.v"
module kmap_tb;
	
	reg A, B, C, D;
	wire Out;
	
	
	reg result;
	integer i, err;
	
	kmap kmap0(.A(A), .B(B), .C(C), .D(D), .Out(Out));
	
	initial begin
		$monitor($time, "ns, A=%b,B=%b,C=%b,D=%b,Out=%b",A,B,C,D,Out);
	end
	
	initial begin
		`ifdef FSDB
			$fsdbDumpfile("kmap.fsdb");
			$fsdbDumpvars(0, kmap0);
		`endif
	end
	
	initial begin
		err=0; result=0;
		# (`CYCLE);
		for(i=0; i<16; i=i+1)begin
			{A,B,C,D}=i;
			result = (~A & ~C) | (A & C) | (~B & ~D);
			# (`CYCLE/2);
			if(result !== Out)begin
				err = err + 1;
			end
			else begin
				err = err;
			end
			#(`CYCLE/2);
		end		
		if (err === 0) begin
			$display("\n");
			$display("\n");
			$display("        **************************               ");
			$display("        *                        *       |\__||  ");
			$display("        *  Congratulations !!    *      / O.O  | ");
			$display("        *                        *    /_____   | ");
			$display("        *  Simulation PASS!!     *   /^ ^ ^ \\  |");
			$display("        *                        *  |^ ^ ^ ^ |w| ");
			$display("        **************************   \\m___m__|_|");
			$display("\n");
		end
		else begin
			$display("\n");
			$display("\n");
			$display("        **************************               ");
			$display("        *                        *       |\__||  ");
			$display("        *  OOPS!!                *      / X,X  | ");
			$display("        *                        *    /_____   | ");
			$display("        *  Simulation Failed!!   *   /^ ^ ^ \\  |");
			$display("        *                        *  |^ ^ ^ ^ |w| ");
			$display("        **************************   \\m___m__|_|");
			$display("         Totally has %d errors                     ", err); 
			$display("\n");
		end
		$finish;	
	end		
	
endmodule