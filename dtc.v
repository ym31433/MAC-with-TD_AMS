`timescale 1ns/100ps
`define DEL_UNIT 4


module dtc_1b #(parameter T_DEL = `DEL_UNIT) (clk, in, out);
input  clk;
input  in;
output out;

wire a;
wire #(T_DEL) b;

assign a = ~(clk | 1'b0);
assign b = ~(clk | (~in));
assign out = ~(a | b);

endmodule



module dtc #(
parameter T_DEL = `DEL_UNIT,
parameter N_BIT = 2) (
input  [N_BIT-1:0] in,
input  clk,
output out
//debug
//output [N_BIT:0] inner_out
);

wire [N_BIT:0] inner_tout;

//debug
//assign inner_out = inner_tout;

assign inner_tout[N_BIT] = clk;
assign out = inner_tout[0];

genvar i;
generate
for(i = 0; i != N_BIT; i = i+1) begin: dtc
	dtc_1b #(.T_DEL((1<<i)*T_DEL)) BIT (.clk(inner_tout[i+1]), .in(in[i]), .out(inner_tout[i]));
end
endgenerate


endmodule
