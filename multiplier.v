`timescale 1ns/100ps
`define DEL_UNIT 4


module multiplier_1b #(
parameter T_DEL = `DEL_UNIT,
parameter COEFF = 1)(
input  in,
input  rst, clk,
output out
//debug
/*
output t,
output offset0_out,
output offset1_out,
output offset2_out
*/
);

wire t;
wire offset0;
wire #(T_DEL/4) offset1;
wire #(T_DEL/4) offset2;

//debug
/*
//assign offset_out = offset[2];
assign offset0_out = offset0;
assign offset1_out = offset1;
assign offset2_out = offset2;
*/

assign offset1 = ~offset0;
assign offset2 = ~offset1;

dtc_1b #(.T_DEL(COEFF*T_DEL)) DTC_DATA(.clk(clk), .in(in), .out(t));

assign offset0 = clk;

tdc_1b TDC_DATA(.rst(rst), .clk(offset2), .in(t), .out(out));

endmodule



module multiplier #(
parameter T_DEL = `DEL_UNIT,
parameter COEFF = 1,
parameter N_BIT = 2) (
input  rst, clk,
input  [N_BIT-1:0] in,
output [N_BIT-1:0] out,
//debug

output t,
output offset0_out,
output offset1_out,
output offset2_out,
output [N_BIT-1:0] inner_clk,
output [N_BIT-1:0] inner_in

);

//wire t;
wire offset0;
wire #(T_DEL/4) offset1;
wire #(T_DEL/4) offset2;

//debug

assign offset0_out = offset0;
assign offset1_out = offset1;
assign offset2_out = offset2;


assign offset1 = ~offset0;
assign offset2 = ~offset1;

dtc #(.T_DEL(COEFF*T_DEL), .N_BIT(N_BIT)) DTC_DATA (.clk(clk), .in(in), .out(t));

dtc #(.T_DEL(T_DEL), .N_BIT(N_BIT))       DTC_CLK  (.clk(clk), .in((1<<(N_BIT-1))-1), .out(offset0));

//tdc #(.T_DEL(T_DEL), .N_BIT(N_BIT))       TDC_DATA (.rst(rst), .clk(offset2), .in(t), .out(out));
tdc #(.T_DEL(T_DEL), .N_BIT(N_BIT))       TDC_DATA (.rst(rst), .clk(offset2), .in(t), .out(out), .inner_clk_out(inner_clk), .inner_in_out(inner_in));

endmodule
