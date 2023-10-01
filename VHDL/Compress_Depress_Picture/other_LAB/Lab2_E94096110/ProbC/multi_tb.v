/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen -------------------- //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.02    ---------------------- //
// ---------------------- Multiplier        ---------------------- //
/////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps
`define CYCLE 10

`include "multi.v"

module multi_tb;

	reg [3:0] A_in;
	reg [3:0] B_in;
	wire [7:0] Result_o;
	
	integer test_pattern;
	integer i, j;
	integer err;
	
	
	multi multi0(.A_in(A_in), .B_in(B_in), .Result_o(Result_o));
	
	initial begin
		$monitor($time,"ns, A=%d, B=%d, Result=%d", A_in, B_in, Result_o);
	end
	
	
	initial begin
		`ifdef FSDB
			$fsdbDumpfile("multi.fsdb");
			$fsdbDumpvars(0, multi0); 
		`endif
	end
	
	initial begin
		err = 0; test_pattern = 0;
		# (`CYCLE);
		for(i = 0; i < 16; i = i+1)begin
			A_in = i;
			for(j = 0; j < 16; j = j + 1)begin
				B_in = j;
				# (`CYCLE/2);
				test_pattern = i*j;
				if(test_pattern !== Result_o)begin
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