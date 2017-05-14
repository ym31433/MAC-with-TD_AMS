`timescale 1ns/100ps
`define T_WAIT 6 //compensate the delay of the FF
`define DEL_UNIT 4


module tdc_1b(
input  rst, clk, in,
output reg out
//debug
//output out_w
);

wire out_w;
//reg  out_r;

//assign out = out_r;

assign out_w = ~in;

always@(posedge clk or negedge rst) begin
	if(!rst) begin
		//out_r <= 1'b0;
		out <= 1'b0;
	end
	else begin
		//out_r <= out_w;
		out <= out_w;
	end
end

endmodule



module tdc_cascade #(parameter T_DEL = `DEL_UNIT) (in, clk, data, in_out, clk_out);
input  in, clk, data;
output in_out, clk_out;

wire #`T_WAIT dtc_in;
wire #`T_WAIT dtc_clk;

assign dtc_in  = in;
assign dtc_clk = clk;

dtc_1b #(.T_DEL(T_DEL)) DTC_IN(.clk(dtc_in), .in(~data), .out(in_out));
dtc_1b #(.T_DEL(T_DEL)) DTC_CLK(.clk(dtc_clk), .in(data), .out(clk_out));

endmodule


module tdc #(
parameter T_DEL = `DEL_UNIT,
parameter N_BIT = 2) (
input  rst, clk, in,
output [N_BIT-1:0] out,
//debug

output [N_BIT-1:0] inner_clk_out,
output [N_BIT-1:0] inner_in_out

);

wire [N_BIT-1:0] inner_clk, inner_in;

//debug

assign inner_clk_out = inner_clk;
assign inner_in_out = ~inner_in;


assign inner_clk[N_BIT-1] = clk;
assign inner_in[N_BIT-1] = in;

genvar i;
generate
for(i = 0; i != N_BIT; i = i+1) begin: tdc
	tdc_1b BIT(.rst(rst), .clk(inner_clk[i]), .in(inner_in[i]), .out(out[i]));
end
endgenerate

generate
for(i = 0; i != N_BIT-1; i = i+1) begin: cascade
	tdc_cascade #(.T_DEL((1<<i)*T_DEL)) CAS (.in(inner_in[i+1]), .clk(inner_clk[i+1]), .data(out[i+1]),
	.in_out(inner_in[i]), .clk_out(inner_clk[i]));
end
endgenerate

endmodule
