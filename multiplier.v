`define DEL_UNIT 5

module multiplier_8b(rst, clk, in, out);
input  [7:0] in;
input  rst, clk;
output [7:0] out;

wire t;
wire offset[0:2];

assign offset[1] = ~offset[0];
assign offset[2] = ~offset[1];

parameter T_DEL = `DEL_UNIT;
parameter COEFF = 2; // coefficient

defparam DTC_DATA.T_DEL = COEFF*T_DEL;
defparam DTC_CLK.T_DEL  = T_DEL;
defparam TDC_DATA.T_DEL = T_DEL;

dtc_8b DTC_DATA(.clk(clk), .in(in), .out(t));

dtc_8b DTC_CLK(.clk(clk), .in(8'd127), .out(offset[0]));

tdc_8b TDC_DATA(.rst(rst), .clk(offset[2]), .in(t), .out(out));

endmodule