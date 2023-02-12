`timescale 1ns / 1ps
module top_wrapper
(
    // PS �˿�-----start
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
    // PS �˿�-----end

    input PL_CLK_100MHz,                                 // ʱ������
    input clk_prog_clk0, clk_prog_clk1, clk_prog_clk2,   // ����ʱ��

    // LS-ADC  PINS
    input [13:0] LS_ADC2_DB, LS_ADC1_DB,           // AD �����������룬Ŀǰ���õ�12bit AD�����Ե���λû�õ���
	input  LS_ADC2_OTR, LS_ADC1_OTR,               // AD �������ָʾ������������2V��
	output LS_ADC2_CLK, LS_ADC1_CLK,               // AD ����ʱ�� ��20MHz ���£�

    // LS_DAC  PINS
    output [13:0] LS_DAC2_DB, LS_DAC1_DB,          // DA ����
    output LS_DAC2_CLK, LS_DAC1_CLK,               // DA ʱ�� (125MHz ����)
	output LS_DAC2_WRT, LS_DAC1_WRT,               // DA ���д�źţ�ͬʱ���ź�
	output LS_DAC_MODE,                            // DA ����ģʽ��1��������ݶ˿ڷֿ�;0��������ݹ���һ��˿ڣ����ݰ���ֵ��ʽ��������һ����� mode 1��
	

    // audio AD & DA
    input Audio_AD_SDOUT,                          // ��Ƶ AD ���ݶ˿�
    output Audio_AD_SCLK,                          // ��Ƶ AD ����ʱ�Ӷ˿�
    output Audio_AD_LRCK,                          // ��Ƶ AD ��������ʱ�Ӷ˿�
    output Audio_AD_MCLK,                          // ��Ƶ AD ��ʱ�Ӷ˿�
    output Audio_AD_nRST,                          // ��Ƶ AD ��λ�˿ڣ��͵�ƽ��λ
    output Audio_AD_M1,Audio_AD_M0,                // ����ģʽѡ��, ��λһ�㶼���ø�

    output Audio_DA_SDIN,                          // ��Ƶ DA ���ݶ˿�
    output Audio_DA_SCLK,                          // ��Ƶ DA ����ʱ�Ӷ˿�
    output Audio_DA_LRCL,                          // ��Ƶ DA ��������ʱ�Ӷ˿�
    output Audio_DA_MCLK,                          // ��Ƶ DA ��ʱ�Ӷ˿�

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
    
    // GPIOS ���� IO �˿�
    output GPIO_TH1, GPIO_TH2, GPIO_TH3, GPIO_TH4, GPIO_TH5,
    output GPIO_TH6, GPIO_TH7, GPIO_TH8, GPIO_TH9, GPIO_TH10,

    // AD9361 pins
    input  [11:0] AD9361_P0_D,      // AD9361 ��Ƶ�����������
    input  AD9361_DATACLK,          // AD9361 ��Ƶ����ʱ���ź�
    input  AD9361_RX_FRAME,         // AD9361 ��Ƶ����֡�źţ�ָʾI Q��·
    
    output [11:0] AD9361_P1_D,      // AD9361 ��Ƶ�����������
    output AD9361_FBCLK,            // AD9361 ��Ƶ����ʱ���ź�
    output AD9361_TX_FRAME,         // AD9361 ��Ƶ����֡�źţ�ָʾI Q��·

    output AD9361_rst,              // AD9361 ��λ�˿ڣ�    

    input  AD9361_SPI_DO,           // AD9361 SPI ���ƶ˿�
    output AD9361_SPI_CLK,
    output AD9361_SPI_DI,
    output AD9361_SPI_ENB,
    output AD9361_SPI_SEL,

    output AD9361_ENABLE,           // AD9361 ʹ�ܿ�
    output AD9361_SYNC_IN,          // AD9361 ͬ�����ƿ�
    output AD9361_EN_AGC,           // AD9361 AGCZ���ƶ˿�
    output AD9361_TXNRX,            // AD9361 �շ��л��˿�
	
    input AD9361_PLLT_CLK_OUT,      // AD9361 ����ʱ�Ӷ˿�
    input AD9361_PLL_B_OUT_P,
    input AD9361_PLL_B_OUT_N,

    // other pins
    input McBSP0_CLKS0,             // �����˿ڣ���ʱû���õ�
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

// ʱ�ӷ�Ƶ���ź�Դ����
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
wire diff_data; // ��ֶ���������
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

// �����շ�
wire [11:0]revdata,revQ;
AD9361_1RT_FDD inst_AD9361
(
    .clk200M(clk200M),
    .AD9361_P0_D(AD9361_P0_D),                  // AD9361 ��Ƶ�����������
    .AD9361_DATACLK(AD9361_DATACLK),            // AD9361 ��Ƶ����ʱ���ź�
    .AD9361_RX_FRAME(AD9361_RX_FRAME),          // AD9361 ��Ƶ����֡�źţ�ָʾI Q��·
    .AD9361_RX_DAT_I(revdata),                  // AD9361 ����I·
    .AD9361_RX_DAT_Q(revQ),                     // AD9361 ����Q·
    .AD9361_RX_CLK(AD9361_RX_CLK),
    
    .AD9361_TX_DAT_I(psk_data),                 // AD9361 ��I·
    .AD9361_TX_DAT_Q(),                         // AD9361 ��Q·
    .AD9361_TX_CLK(AD9361_RX_CLK),
    .AD9361_P1_D(AD9361_P1_D),                  // AD9361 ��Ƶ�����������
    .AD9361_FBCLK(AD9361_FBCLK),                // AD9361 ��Ƶ����ʱ���ź�
    .AD9361_TX_FRAME(AD9361_TX_FRAME)           // AD9361 ��Ƶ����֡�źţ�ָʾI Q��·
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


// �˿ڹ̶�����
assign LS_DAC_MODE = 1;
// DA out
assign LS_DAC1_DB = {pn,13'd0} + 14'h2000; // ����ֱ��ƫ��
assign LS_DAC1_CLK = clk32d768M;
assign LS_DAC1_WRT = ~LS_DAC1_CLK;

assign LS_DAC2_DB = {psk_data_out,13'd0} + 14'h2000; // ����ֱ��ƫ��
assign LS_DAC2_CLK = clk32d768M;
assign LS_DAC2_WRT = LS_DAC1_CLK;

// io test
assign GPIO_TH1 = clk1d024M;    
assign GPIO_TH2 = pn;   
   
endmodule
