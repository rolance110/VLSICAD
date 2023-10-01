/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2023 Spring ---------------------- //
// ---------------------- Editor: Zhi-Yu Chen (Willy) ------------ //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2023.03    ---------------------- //
// ---------------------- pattern_gen       ---------------------- // 
/////////////////////////////////////////////////////////////////////


module pattern_gen(clk, rst, en, sel, pattern, valid);


input clk, rst;
input en;
input [1:0] sel;
output reg pattern;
output reg valid;


//finit state machine
reg [2:0] ns,cs;// ns:nextstate  cs:currentstate

parameter   s0=3'd0;
parameter   s1=3'd1;
parameter   s2=3'd2;
parameter   s3=3'd3;
parameter   INIT=3'd4;
//set currentstate
always@(posedge clk or posedge rst)
begin
    if(rst)
        cs <= INIT ;
    else
        cs <= ns ;
end

//set nextstate from currentstate
always@(*)
begin
    case(cs)
        INIT:   ns = en? s0: INIT;
        s0: ns = s1;
        s1: ns = s2;
        s2: ns = s3;
        s3: ns = INIT;
        default:
            ns = s0;
    endcase
end
//pattern
always@(cs or sel) begin
    case (cs)
            s2: pattern = sel[1];
            s3: pattern = sel[0]; 
        default:
            pattern = 1'd1;
    endcase
end
//valid
always@(cs or en) begin
    case (cs) 
        default:
            valid = en? 1'b1: 1'b0;
    endcase
end
endmodule
