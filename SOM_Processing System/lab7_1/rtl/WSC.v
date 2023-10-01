module WSC(
	//{VEP63.manhattan_distance, VEP62.manhattan_distance, ... , VEP0.manhattan_distance}
	input  [10*64 - 1:0] VEPs_manhattan_distance,
	output wire [2:0] winner_x,
	output wire [2:0] winner_y
);

wire [5:0] min_1 [31:0]; //32mux
wire [5:0] min_2 [15:0];
wire [5:0] min_3 [7:0]; //8 mux
wire [5:0] min_4 [3:0]; //4 mux
wire [5:0] min_5 [1:0]; //2 mux
wire [9:0] seg [63:0];

genvar i,j,u,k,s,p;

//save seg
generate
	for(i=0; i<64; i=i+1)begin : generate_block_1
	    assign seg[i] =  VEPs_manhattan_distance[(10*i)+:10] ;
	end
endgenerate

//1
generate
	for(j=0; j<64; j=j+2)begin : generate_block_2
	    assign min_1[j/2]= seg[j] > seg[j+1]? j+1: j;
	end
endgenerate

//2
generate
	for(u=0; u<32; u=u+2)begin : generate_block_3
	    assign min_2[u/2]= seg[min_1[u]] > seg[min_1[u+1]]? min_1[u+1]: min_1[u];
	end
endgenerate

//3
generate
	for(k=0; k<16; k=k+2)begin : generate_block_4
	    assign min_3[k/2]= seg[min_2[k]] > seg[min_2[k+1]]? min_2[k+1]: min_2[k];
	end
endgenerate
//4
generate
	for(s=0; s<8; s=s+2)begin : generate_block_5
	    assign min_4[s/2]= seg[min_3[s]] > seg[min_3[s+1]]? min_3[s+1]: min_3[s];
	end
endgenerate
//5
generate
	for(p=0; p<4; p=p+2)begin : generate_block_6
	    assign min_5[p/2]= seg[min_4[p]] > seg[min_4[p+1]]? min_4[p+1]: min_4[p];
	end
endgenerate
//6
assign {winner_y,winner_x} = seg[min_5[0]] > seg[min_5[1]]? min_5[1]: min_5[0];


endmodule
