`timescale 1ns/100ps
`define CYCLE 4

module tdc_1b_tb();
reg  rst, clk, tin;
wire dout;
//debug
wire out_w;

//tdc TDC(.rst(rst), .clk(clk), .in(tin), .out(dout));
tdc TDC(.rst(rst), .clk(clk), .in(tin), .out(dout), .out_w(out_w));


always begin
   #(`CYCLE/2) clk = ~clk; 
end

initial begin
    #0;
    clk = 1'b0;
    tin = 1'b1;
    rst = 1'b1;

    #(`CYCLE/2);
    rst = 1'b0;

    #(`CYCLE/2);
    rst = 1'b1;
    #(`CYCLE/2);
    //#1;
    //tin = 1'b0;

    #(`CYCLE*2);
    $finish;

end

endmodule
