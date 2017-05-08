`define T_WAIT 3
`define DEL_UNIT 5

module tdc_1b(rst, clk, in, out);
input  rst, clk, in;
output out;

wire out_w;
reg  out_r;

assign out = out_r;

assign out_w = ~in;

always@(posedge clk or negedge rst) begin
	if(!rst) begin
		out_r <= 1'b0;
	end
	else begin
		out_r <= out_w;
	end
end

endmodule



module tdc_cascade(in, clk, data, in_out, clk_out);
input  in, clk, data;
output in_out, clk_out;

wire dtc_in, dtc_clk;

assign dtc_in  = #`T_WAIT in;
assign dtc_clk = #`T_WAIT clk;

parameter T_DEL = `DEL_UNIT;
defparam DTC_IN.T_DEL = T_DEL;
defparam DTC_CLK.T_DEL = T_DEL;

dtc_1b DTC_IN(.clk(dtc_in), .in(data), .out(in_out));
dtc_1b DTC_CLK(.clk(dtc_clk), .in(~data), .out(clk_out));

endmodule



module tdc_8b(rst, clk, in, out);
input  rst, clk, in;
output [7:0] out;

wire [6:0] inner_clk, inner_in;
integer i;

parameter T_DEL = `DEL_UNIT;

for(i = 7; i >=0; i = i-1) begin
	defparam BIT[i].T_DEL = T_DEL;
end

tdc_1b BIT[7](.rst(rst), .clk(clk), .in(in), .out(out[7]));
for(i = 6; i >= 0, i = i-1) begin //7
	tdc_1b BIT[i] (.rst(rst), .clk(inner_clk[i]), .in(inner_in[i]), .out(out[i]));
end

for(i = (1<<6); i >= 1; i = (i>>1)) begin //7
	defparam CAS[i].T_DEL = i*`DEL_UNIT;
end

tdc_cascade CAS[6](.in(in), .clk(clk), .data(out[7]), .in_out(inner_in[6]), .clk_out(inner_clk[6]));
for(i = 5; i >= 0, i = i-1) begin //6
	tdc_cascade CAS[i](.in(inner_in[i+1]), .clk(inner_clk[i+1]), .data(out[i+1]),
		.in_out(inner_in[i]), .clk_out(inner_clk[i]));
end

endmodule



module tdc_32b(rst, clk, in, out);
input  rst, clk, in;
output [31:0] out;

wire [30:0] inner_clk, inner_in;
integer i;

parameter T_DEL = `DEL_UNIT;

for(i = 31; i >=0; i = i-1) begin
	defparam BIT[i].T_DEL = T_DEL;
end

tdc_1b BIT[31](.rst(rst), .clk(clk), .in(in), .out(out[31]));
for(i = 30; i >= 0, i = i-1) begin //31
	tdc_1b BIT[i] (.rst(rst), .clk(inner_clk[i]), .in(inner_in[i]), .out(out[i]));
end

for(i = (1<<30); i >= 1; i = (i>>1)) begin //31
	defparam CAS[i].T_DEL = i*`DEL_UNIT;
end

tdc_cascade CAS[30](.in(in), .clk(clk), .data(out[31]), .in_out(inner_in[30]), .clk_out(inner_clk[30]));
for(i = 29; i >= 0, i = i-1) begin //30
	tdc_cascade CAS[i](.in(inner_in[i+1]), .clk(inner_clk[i+1]), .data(out[i+1]),
		.in_out(inner_in[i]), .clk_out(inner_clk[i]));
end

endmodule



/*
module tdc_2b(rst, clk, in, out);
input  rst, clk, in;
output [1:0] out;

parameter T_WAIT = `T_WAIT;

wire dtc_in, dtc_clk;
wire dtc_in_out, dtc_clk_out;

assign dtc_in  = #T_WAIT in;
assign dtc_clk = #T_WAIT clk;

tdc_1b BIT1(.rst(rst), .clk(clk), .in(in), .out(out[1]));
tdc_1b BIT2(.rst(rst), .clk(dtc_clk_out), .in(dtc_in_out), .out(out[0]));

dtc_1b DTC_IN(.clk(dtc_in), .in(out[1]), .out(dtc_in_out));
dtc_1b DTC_CLK(.clk(dtc_clk), .in(~out[1]), .out(dtc_clk_out));

endmodule

module tdc_4b(rst, clk, in, out);
input  rst, clk, in;
output [3:0] out;

parameter T_WAIT = `T_WAIT;
*/