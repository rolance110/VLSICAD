`timescale 1ns/10ps

`ifdef syn
`include "/usr/cad/CBDK/SAED14_EDK_rvt/verilog/saed14nm_rvt.v"
`include "fixedpoint_syn.v"
`else
`include "fixedpoint.v"
`endif

module fixedpoint_tb;

reg [7:0] in1;
reg [7:0] in2;
wire [7:0] out;
integer error;

fixedpoint f0(
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
	if(out==8'hc4)begin
		error = error;
	end
	else begin
		error = error +1;
	end
	#10
	if(out==8'h0f)begin
		error = error;
	end
	else begin
		error = error +1;
	end
	#10
	if(out==8'h03)begin
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
	#0		in1 = 8'he0; in2 = 8'he0; //7 * 7 = 49, 1100_0100, 
	#10		in1 = 8'h28; in2 = 8'h60; //1.25 * 3 = 3.75, 0000_1111
	#10		in1 = 8'h28; in2 = 8'h10; //1.25 * 0.5 = 0.625, 0000_0011
	#20		$finish ;
end

initial begin
	`ifdef FSDB
		$fsdbDumpfile("fixedpoint.fsdb") ;
		$fsdbDumpvars;
	`endif
end

`ifdef syn
	initial $sdf_annotate("fixedpoint_syn.sdf", f0);
`endif

endmodule
