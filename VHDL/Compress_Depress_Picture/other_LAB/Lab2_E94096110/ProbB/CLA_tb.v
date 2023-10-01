/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen (Willy) ------------ //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.02    ---------------------- //
// ---------------------- Carry LookAhead Adder------------------- // 
/////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps
`define CYCLE 10

`include "CLA.v"

module CLA_tb;
	
	reg [3:0] A_in, B_in;
	reg C_in;
	wire [3:0] Sum_o;
	wire C_out;
	
	integer test_pattern;
	integer result;
	integer i, j, k;
	integer err;
	
	CLA CLA0(.A_in(A_in), 
			 .B_in(B_in),  
			 .Sum_o(Sum_o),
			 .C_out(C_out) );
	
	
	initial begin
		`ifdef FSDB
			$fsdbDumpfile("CLA.fsdb");
			$fsdbDumpvars(0, CLA0);
		`endif
	end
	
	initial begin
		$monitor($time,"ns, A=%d, B=%d, S=%d, Cout=%d", A_in, B_in, Sum_o, C_out);
	end
	
	initial begin
		err = 0; test_pattern = 0; result = 0;
		# (`CYCLE);
		for(i = 0; i < 16; i = i+1)begin
			A_in = i;
			for(j = 0; j < 16; j = j + 1)begin
				B_in = j;
					
				# (`CYCLE/2);
				test_pattern = i + j;
				result = {C_out, Sum_o};
				if(test_pattern !== result)begin
					err = err + 1;
				end
				else begin
					err = err;
				end
				# (`CYCLE/2);
			end
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