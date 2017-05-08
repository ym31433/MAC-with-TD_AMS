`define DEL_UNIT 5

module mult_add_8b(rst, clk, in_a, in_b, out);
input  rst, clk;
input  [7:0] in_a, in_b;
output [7:0] out;

wire add, t;
wire offset[0:2];

assign offset[1] = ~offset[0];
assign offset[2] = ~offset[1];

parameter T_DEL = `DEL_UNIT;
parameter COEFF = 2; // coefficient

defparam DTC_A.T_DEL    = COEFF*T_DEL;
defparam DTC_B.T_DEL    = T_DEL;
defparam DTC_CLK.T_DEL  = T_DEL;
defparam TDC_DATA.T_DEL = T_DEL;

dtc_8b DTC_A(.clk(clk), .in(in_a), .out(add));
dtc_8b DTC_B(.clk(add), .in(in_b), .out(t));

dtc_8b DTC_CLK(.clk(clk), .in(8'd254), .out(offset[0]));

tdc_8b TDC_DATA(.rst(rst), .clk(offset[2]), .in(t), .out(out));

endmodule