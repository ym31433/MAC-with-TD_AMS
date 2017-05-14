`timescale 1ns/100ps
`define CYCLE 100 //50MHz
`define DEL_UNIT 4
`define N_BIT 4

module multiplier_tb();
reg  clk, rst;
reg  [`N_BIT-1:0] din;
wire [`N_BIT-1:0] dout;
//debug

wire t;
wire offset0;
wire offset1;
wire offset2;
wire [`N_BIT-1:0] inner_clk;
wire [`N_BIT-1:0] inner_in;


//multiplier #(.T_DEL(`DEL_UNIT), .COEFF(1), .N_BIT(`N_BIT)) MULT(.rst(rst), .clk(clk), .in(din), .out(dout));
multiplier #(.T_DEL(`DEL_UNIT), .COEFF(1), .N_BIT(`N_BIT)) MULT(.rst(rst), .clk(clk), .in(din), .out(dout),
.t(t), .offset0_out(offset0), .offset1_out(offset1), .offset2_out(offset2), .inner_clk(inner_clk), .inner_in(inner_in));

always begin
    #(`CYCLE/2) clk = ~clk;
end

initial begin
    #0;
    clk = 1'b0;
    din = 4'b0100;
	 rst = 1'b1;
	 
	 #(1);
	 rst = 1'b0;
	 
	 #(1);
	 rst = 1'b1;
	 
	 #(`CYCLE-2);
/*
	 din = 4'b0001;

	 #(`CYCLE);
	 din = 4'b0010;
	 
	 #(`CYCLE);
	 din = 4'b0100;
	 
	 #(`CYCLE);
	 din = 4'b1100;
	 */
	 #(`CYCLE*2);
    $finish;
end
endmodule
