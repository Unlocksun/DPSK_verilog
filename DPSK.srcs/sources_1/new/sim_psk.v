`timescale 1ns / 1ps


module sim_psk(

    );
	
	reg rst;
    initial begin    
       rst = 1;    
       #2000 rst = 0;        
    end
	
	reg clk_100M = 0;
    always #5 clk_100M <= ~clk_100M;    
    
    wire clk128M, clk200M,clk32d768M, clk8d192M,clk1d024M,clk16d384M;

  
	clock128M inst_clk128M
   (
    // Clock out ports
    .clock128M(clk128M),     // output clk_out_128M
    .clock200M(clk200M),     // output clk_out_200M
   	// Clock in ports
    .clk_in_100M(clk_100M));      // input clk_in_100M
	
	 
 
	clock32d768M inst_32d768M
   (
    // Clock out ports
    .clock32d768M(clk32d768M),     // output clk_out_32M768
    .clock24d576M(),     // output clk_out_24M576
   // Clock in ports
    .clk_in_128M(clk128M));      // input clk_in_128M 


	divClk32d768M inst_divClk32d768M
	(
		.clk32d768M(clk32d768M),
		.clk16d384M(clk16d384M),
		.clk8d192M(clk8d192M),
		.clk4d096M(),
		.clk2d048M(),
		.clk1d024M(clk1d024M),
		.clk512K(),
		.clk256K(),
		.clk128K(),
		.clk64K(),
		.clk32K(),
		.clk16K(),
		.clk8K(),
		.clk4K(),
		.clk2K(),
		.clk1K()
	);

	wire pn;
	PN_Gen inst_PN
	(
		.clk(clk1d024M),
		.pn(pn)
	);
	
	wire [11:0] psk_data;
	wire diff_data;
	pskmod my_psk_mod
	(
		.rst(rst),
	 	.clkHi(clk32d768M),
	 	.clkd(clk1d024M),
	 	.din(pn),
	 	.dout(psk_data),
		.diff_data(diff_data)
	);

	wire psk_data_out;
	wire decision;
	wire [23:0]data_i, data_q, df, abs_data;
	pskDemod inst_pskDemod(
		.rst(rst),
		.clkHi(clk32d768M),
		.clkd(clk8d192M),
		.din(psk_data),
		.psk_demod(psk_data_out),
		.decision(decision),
		.data_i(data_i),
		.data_q(data_q),
		.df(df),
		.abs_data(abs_data)
	);
endmodule
