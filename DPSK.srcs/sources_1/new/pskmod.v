`timescale 1ns / 1ps

module pskmod(
	rst,
    clkHi,
	clkd,
	din,
	dout,
	diff_data
);
	input	 rst;
	input	 clkHi;   				//DDS时钟:8.192MHz
	input	 clkd;   				//基带数据时钟:1.024MHz
	input	 din;        			//基带输入数据
	
	output signed [11:0]	dout; 	//psk输出数据
	output	diff_data;				//差分输出
	
	reg [1:0]	din_reg = 2'b0;
	assign diff_data = !(din_reg[1] == din_reg[0]);
	always @(posedge clkd) begin
		if(rst)
			din_reg <= 2'b0;
		else
			din_reg <= {din_reg[0],din};
	end

	//实例化NCO/DDS核,产生2.048MHz载波
	wire signed [11:0]sine;

	dds_compiler_0 your_instance_name (
		.aclk(clkHi),                              // input wire aclk
		.m_axis_data_tvalid(),  					// output wire m_axis_data_tvalid
		.m_axis_data_tdata(sine)    // output wire [15 : 0] m_axis_data_tdata
	);

	reg [11:0] psk;

	always @(posedge clkHi)
		case(diff_data)
			1'd0:
			   	psk <= -sine[11:0];
			1'd1:
			   	psk <= sine[11:0];
			default:
				psk <= 11'b0;
		endcase
		
	assign dout = psk;
endmodule
