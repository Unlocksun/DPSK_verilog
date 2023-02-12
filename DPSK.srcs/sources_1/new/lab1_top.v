`timescale 1ns / 1ps
module top_wrapper
(
    // PS 端口-----start
    inout [14:0]DDR_addr,
    inout [2:0]DDR_ba,
    inout DDR_cas_n,
    inout DDR_ck_n,
    inout DDR_ck_p,
    inout DDR_cke,
    inout DDR_cs_n,
    inout [3:0]DDR_dm,
    inout [31:0]DDR_dq,
    inout [3:0]DDR_dqs_n,
    inout [3:0]DDR_dqs_p,
    inout DDR_odt,
    inout DDR_ras_n,
    inout DDR_reset_n,
    inout DDR_we_n,

    inout FIXED_IO_ddr_vrn,
    inout FIXED_IO_ddr_vrp,
    inout [53:0]FIXED_IO_mio,
    inout FIXED_IO_ps_clk,
    inout FIXED_IO_ps_porb,
    inout FIXED_IO_ps_srstb,
    // PS 端口-----end

    input PL_CLK_100MHz,                                 // 时钟输入
    input clk_prog_clk0, clk_prog_clk1, clk_prog_clk2,   // 备用时钟

    // LS-ADC  PINS
    input [13:0] LS_ADC2_DB, LS_ADC1_DB,           // AD 采样数据输入，目前是用的12bit AD，所以低两位没用到。
	input  LS_ADC2_OTR, LS_ADC1_OTR,               // AD 采样溢出指示（最大输入幅度2V）
	output LS_ADC2_CLK, LS_ADC1_CLK,               // AD 采样时钟 （20MHz 以下）

    // LS_DAC  PINS
    output [13:0] LS_DAC2_DB, LS_DAC1_DB,          // DA 数据
    output LS_DAC2_CLK, LS_DAC1_CLK,               // DA 时钟 (125MHz 以下)
	output LS_DAC2_WRT, LS_DAC1_WRT,               // DA 输出写信号，同时钟信号
	output LS_DAC_MODE,                            // DA 工作模式。1，输出数据端口分开;0，输出数据共用一组端口，数据按插值方式输出。这里，一般采用 mode 1。
	

    // audio AD & DA
    input Audio_AD_SDOUT,                          // 音频 AD 数据端口
    output Audio_AD_SCLK,                          // 音频 AD 数据时钟端口
    output Audio_AD_LRCK,                          // 音频 AD 左右声道时钟端口
    output Audio_AD_MCLK,                          // 音频 AD 主时钟端口
    output Audio_AD_nRST,                          // 音频 AD 复位端口，低电平复位
    output Audio_AD_M1,Audio_AD_M0,                // 工作模式选择, 两位一般都设置高

    output Audio_DA_SDIN,                          // 音频 DA 数据端口
    output Audio_DA_SCLK,                          // 音频 DA 数据时钟端口
    output Audio_DA_LRCL,                          // 音频 DA 左右声道时钟端口
    output Audio_DA_MCLK,                          // 音频 DA 主时钟端口

    // PL ETH----start
    input [3:0] ETH_PL_RXD,
    output [3:0] ETH_PL_TXD,

    output ETH_PL_TXCTL, ETH_PL_TXCK,
    input ETH_PL_RXCTL, ETH_PL_RXCK,

    inout ETH_PL_MDIO,
    output ETH_PL_MDC,
    output ETH_PL_nRST,

    input SFP_TX_Fault,
    inout SFP_SDA,
    input SFP_PRESENT,
    input SFP_LOS,
    output SFP_TX_DIS,
    output SFP_SCL,
    output SFP_Rate_Select,
    // PL ETH----end
    
    // GPIOS 数字 IO 端口
    output GPIO_TH1, GPIO_TH2, GPIO_TH3, GPIO_TH4, GPIO_TH5,
    output GPIO_TH6, GPIO_TH7, GPIO_TH8, GPIO_TH9, GPIO_TH10,

    // AD9361 pins
    input  [11:0] AD9361_P0_D,      // AD9361 射频接收数据输出
    input  AD9361_DATACLK,          // AD9361 射频接收时钟信号
    input  AD9361_RX_FRAME,         // AD9361 射频接收帧信号，指示I Q两路
    
    output [11:0] AD9361_P1_D,      // AD9361 射频发送数据输出
    output AD9361_FBCLK,            // AD9361 射频发送时钟信号
    output AD9361_TX_FRAME,         // AD9361 射频发送帧信号，指示I Q两路

    output AD9361_rst,              // AD9361 复位端口，    

    input  AD9361_SPI_DO,           // AD9361 SPI 控制端口
    output AD9361_SPI_CLK,
    output AD9361_SPI_DI,
    output AD9361_SPI_ENB,
    output AD9361_SPI_SEL,

    output AD9361_ENABLE,           // AD9361 使能口
    output AD9361_SYNC_IN,          // AD9361 同步控制口
    output AD9361_EN_AGC,           // AD9361 AGCZ控制端口
    output AD9361_TXNRX,            // AD9361 收发切换端口
	
    input AD9361_PLLT_CLK_OUT,      // AD9361 备用时钟端口
    input AD9361_PLL_B_OUT_P,
    input AD9361_PLL_B_OUT_N,

    // other pins
    input McBSP0_CLKS0,             // 其他端口，暂时没有用到
    input McBSP0_CLKX0,
    input McBSP0_FSX0,
    input McBSP0_DX0,
    input McBSP0_FSR0,
    input McBSP0_DR0,
    input McBSP0_DX1,
    input McBSP1_CLKS0,
    input McBSP1_CLKX0,
    input McBSP1_FSX0,
    input McBSP1_DX0,
    input McBSP1_FSR0,
    input McBSP1_DR0,
    input McBSP1_DX1,
	
	output AD9361_10M_OUT,
	input AD9361_10M_IN
    
);

wire clk128M, clk32d768M, clk1d024M, clk16d384M, clk8d192M, clk200M;

// 时钟分频及信号源产生
clock128M inst_clk128M
   (
    // Clock out ports
    .clock128M(clk128M),     // output clk_out_128M
    .clock200M(clk200M),     // output clk_out_200M
   // Clock in ports
    .clk_in_100M(PL_CLK_100MHz));      // input clk_in_100M
	
 
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

// PN generate
wire pn;
PN_Gen inst_PN
(
    .clk(clk1d024M),
    .pn(pn)
);

// psk mod
wire [11:0]psk_data;
wire diff_data; // 差分二进制数据
pskmod my_psk_mod
(
    .rst(1'd0),
    .clkHi(clk32d768M),
    .clkd(clk1d024M),
    .din(pn),
    .dout(psk_data),
    .diff_data(diff_data)
);

// psk demod
	wire psk_data_out;
	wire decision;
	wire [23:0]data_i, data_q,df, abs_data;
	wire sync;
	pskDemod inst_pskDemod(
		.rst(1'd0),
		.clkHi(clk32d768M),
		.clkd(AD9361_RX_CLK),
		.din(revdata),
		.psk_demod(psk_data_out), //demoded binary data
		.decision(decision),      //differential data after decision
		.data_i(data_i),
		.data_q(data_q),
		.df(df),
		.abs_data(abs_data),
		.sync(sync)
	);

// 天线收发
wire [11:0]revdata,revQ;
AD9361_1RT_FDD inst_AD9361
(
    .clk200M(clk200M),
    .AD9361_P0_D(AD9361_P0_D),                  // AD9361 射频接收数据输出
    .AD9361_DATACLK(AD9361_DATACLK),            // AD9361 射频接收时钟信号
    .AD9361_RX_FRAME(AD9361_RX_FRAME),          // AD9361 射频接收帧信号，指示I Q两路
    .AD9361_RX_DAT_I(revdata),                  // AD9361 接收I路
    .AD9361_RX_DAT_Q(revQ),                     // AD9361 接收Q路
    .AD9361_RX_CLK(AD9361_RX_CLK),
    
    .AD9361_TX_DAT_I(psk_data),                 // AD9361 发I路
    .AD9361_TX_DAT_Q(),                         // AD9361 发Q路
    .AD9361_TX_CLK(AD9361_RX_CLK),
    .AD9361_P1_D(AD9361_P1_D),                  // AD9361 射频发送数据输出
    .AD9361_FBCLK(AD9361_FBCLK),                // AD9361 射频发送时钟信号
    .AD9361_TX_FRAME(AD9361_TX_FRAME)           // AD9361 射频发送帧信号，指示I Q两路
);

ila_0 your_instance_name (
	.clk(clk32d768M), // input wire clk


	.probe0(psk_data[11:0]),    // input wire [11:0]  probe0  
	.probe1(df[11:0]),         // input wire [11:0]  probe1 
	.probe2(data_i[23:0]),      // input wire [11:0]  probe2 
	.probe3(data_q[23:0]),      // input wire [13:0]  probe3 
	.probe4(revdata[11:0]),    // input wire [13:0]  probe4 
	.probe5(clk1d024M),         // input wire [0:0]  probe5 
	.probe6(pn),                // input wire [0:0]  probe6 
	.probe7(psk_data_out),      // input wire [0:0]  probe7
	.probe8(sync)          // input wire [0:0]  probe8
);


// 端口固定设置
assign LS_DAC_MODE = 1;
// DA out
assign LS_DAC1_DB = {pn,13'd0} + 14'h2000; // 加入直流偏置
assign LS_DAC1_CLK = clk32d768M;
assign LS_DAC1_WRT = ~LS_DAC1_CLK;

assign LS_DAC2_DB = {psk_data_out,13'd0} + 14'h2000; // 加入直流偏置
assign LS_DAC2_CLK = clk32d768M;
assign LS_DAC2_WRT = LS_DAC1_CLK;

// io test
assign GPIO_TH1 = clk1d024M;    
assign GPIO_TH2 = pn;   
   
endmodule
