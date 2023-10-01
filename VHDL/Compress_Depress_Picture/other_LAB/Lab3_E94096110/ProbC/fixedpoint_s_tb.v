`timescale 1ns/10ps

`ifdef syn
`include "/usr/cad/CBDK/SAED14_EDK_rvt/verilog/saed14nm_rvt.v"
`include "fixedpoint_s_syn.v"
`else
`include "fixedpoint_s.v"
`endif

module fixedpoint_s_tb;

reg [7:0] in1;
reg [7:0] in2;
wire [7:0] out;
integer error;

fixedpoint_s f0(
	.in1(in1),
	.in2(in2),
	.out(out)
);

initial begin
	$monitor(" in1 = %h, in2 = %h, out = %h", in1, in2, out);
end

initial begin
	error=0;
	#5
	if(out==8'h02)begin
		error = error;
	end
	else begin
		error = error +1;
	end
	#10
	if(out==8'hf7)begin
		error = error;
	end
	else begin
		error = error +1;
	end
	#10
	if(out==8'hf8)begin
		error = error;
	end
	else begin
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
	else begin
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
    end
end

initial begin
	#0		in1 = 8'hf0; in2 = 8'hf0; //-1 * -1 = 1, 0000_0010 
	#10		in1 = 8'he8; in2 = 8'h30; //-1.5 * 3 = -4.5, 1111_0111
	#10		in1 = 8'hec; in2 = 8'h30; //-1.25 * 3 = -3.75, 1111_1000
	#20		$finish ;
	
end

initial begin
	`ifdef FSDB
		$fsdbDumpfile("fixedpoint_s.fsdb") ;
		$fsdbDumpvars;
	`endif
end

`ifdef syn
	initial $sdf_annotate("fixedpoint_s_syn.sdf", f0);
`endif

endmodule
