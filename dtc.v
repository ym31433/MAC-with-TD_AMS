`define DEL_UNIT 5

module dtc_1b(clk, in, out);
input  clk;
input  in;
output out;

parameter T_DEL = `DEL_UNIT; // to be redefined

wire a, b;

assign a = ~(clk | 1'b0);
assign b = #T_DEL ~(clk | (~in));
assign out = ~(a | b);

endmodule



module dtc_2b(clk, in, out);
input  [1:0] in;
input  clk;
output out;

wire clk_del;

parameter T_DEL = `DEL_UNIT; // to be redefined
defparam BIT1.T_DEL = 2*T_DEL;
defparam BIT0.T_DEL = T_DEL;

dtc_1b BIT1(.clk(clk), .in(in[1]), .out(clk_del));
dtc_1b BIT0(.clk(clk_del), .in(in[0]), .out(out));

endmodule



module dtc_4b(clk, in, out);
input  [3:0] in;
input  clk;
output out;

wire clk_del;

parameter T_DEL = `DEL_UNIT;
defparam BIT1.T_DEL = 4*T_DEL;
defparam BIT0.T_DEL = T_DEL;

dtc_2b BIT1(.clk(clk), .in(in[3-:2]), .out(clk_del));
dtc_2b BIT0(.clk(clk_del), .in(in[1-:2]), .out(out));

endmodule



module dtc_8b(clk, in, out);
input  [7:0] in;
input  clk;
output out;

wire clk_del;

parameter T_DEL = `DEL_UNIT;
defparam BIT1.T_DEL = 8*T_DEL;
defparam BIT0.T_DEL = T_DEL;

dtc_4b BIT1(.clk(clk), .in(in[7-:4]), .out(clk_del));
dtc_4b BIT0(.clk(clk_del), .in(in[3-:4]), .out(out));

endmodule



module dtc_16b(clk, in, out);
input  [15:0] in;
input  clk;
output out;

wire clk_del;

parameter T_DEL = `DEL_UNIT;
defparam BIT1.T_DEL = 16*T_DEL;
defparam BIT0.T_DEL = T_DEL;

dtc_8b BIT1(.clk(clk), .in(in[15-:8]), .out(clk_del));
dtc_8b BIT0(.clk(clk_del), .in(in[7-:8]), .out(out));

endmodule



module dtc_32b(clk, in, out);
input  [31:0] in;
input  clk;
output out;

wire clk_del;

parameter T_DEL = `DEL_UNIT;
defparam BIT1.T_DEL = 32*T_DEL;
defparam BIT0.T_DEL = T_DEL;

dtc_16b BIT1(.clk(clk), .in(in[31-:16]), .out(clk_del));
dtc_16b BIT0(.clk(clk_del), .in(in[15-:16]), .out(out));

endmodule