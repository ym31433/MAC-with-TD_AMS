`timescale 1ns/100ps
`define CYCLE 20
`define DEL_UNIT 4

module dtc_1b_tb();
reg clk, din;
wire tout;

dtc DTC(.clk(clk), .in(din), .out(tout));

always begin
    #(`CYCLE/2) clk = ~clk;
end

initial begin
    #0;
    clk = 1'b0;
    din = 1'b0;

    #(`CYCLE);
    din = 1'b1;

    #(`CYCLE*2);
    $finish;
end
endmodule




module dtc_2b_tb();
reg  clk;
reg  [1:0] din;
wire tout;
//debug
//wire [2:0] inner_out;

dtc #(.T_DEL(`DEL_UNIT), .N_BIT(2)) DTC (.clk(clk), .in(din), .out(tout));
//dtc #(.T_DEL(`DEL_UNIT), .N_BIT(2)) DTC (.clk(clk), .in(din), .out(tout), .inner_out(inner_out));

always begin
    #(`CYCLE/2) clk = ~clk;
end

initial begin
    #0;
    clk = 1'b0;
    din = 2'b00;

    #(`CYCLE);
    din = 2'b01;

    #(`CYCLE);
    din = 2'b10;

    #(`CYCLE);
    din = 2'b11;

    #(`CYCLE);
    $finish;
end
endmodule

module dtc_4b_tb();
reg  clk;
reg  [3:0] din;
wire tout;

dtc DTC(.clk(clk), .in(din), .out(tout));

always begin
    #(`CYCLE/2) clk = ~clk;
end

initial begin
    #0;
    clk = 1'b0;
    din = 4'b0000;

    #(`CYCLE);
    din = 4'b0001;

    #(`CYCLE);
    din = 4'b0010;

    #(`CYCLE);
    din = 4'b0011;

    #(`CYCLE);
    din = 4'b0100;

    #(`CYCLE);
    din = 4'b0101;

    #(`CYCLE);
    $finish;
end
endmodule
