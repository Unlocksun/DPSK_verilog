module Costas (
    input [11:0]psk,    // DPSK moduled signal
    input clk,
    input rst,
    output [23:0]data_i,      // output in-phase data
    output [23:0]data_q,      // output quadrature data
    output [23:0]df
);
    
    wire [23:0]mult_q;
    wire [23:0]mult_i;
    wire [11:0]nco_sin;
    wire [11:0]nco_cos;
    wire [31:0]nco_out;
    
    assign nco_sin = nco_out[27:16];
    assign nco_cos = nco_out[11:0];

    mult12_12 U1_MULT_Q (
        .CLK(clk),          // input wire CLK
        .A(nco_cos),        // input wire [11 : 0] A
        .B(psk),            // input wire [11 : 0] B
        .P(mult_q)          // output wire [23 : 0] P
    );

    mult12_12 U1_MULT_I (
        .CLK(clk),          // input wire CLK
        .A(nco_sin),        // input wire [11 : 0] A
        .B(psk),            // input wire [11 : 0] B
        .P(mult_i)          // output wire [23 : 0] P
    );

    wire [31:0]freq;
    wire freq_update;
    NCO U2_NCO (
        .aclk(clk),                                 // input wire aclk
        .s_axis_config_tvalid(freq_update),         // input wire s_axis_config_tvalid
        .s_axis_config_tdata(freq),                 // input wire [31 : 0] s_axis_config_tdata
        .m_axis_data_tvalid(),                      // output wire m_axis_data_tvalid
        .m_axis_data_tdata(nco_out)                 // output wire [31 : 0] m_axis_data_tdata
    );
    
    fir_compiler_0 U3_FILTER_Q (
        .aclk(clk),                         // input wire aclk
        .s_axis_data_tvalid(1'b1),          // input wire s_axis_data_tvalid
        .s_axis_data_tready(),              // output wire s_axis_data_tready
        .s_axis_data_tdata(mult_q),         // input wire [23 : 0] s_axis_data_tdata
        .m_axis_data_tvalid(),              // output wire m_axis_data_tvalid
        .m_axis_data_tdata(data_q)          // output wire [23 : 0] m_axis_data_tdata
    );

    fir_compiler_0 U3_FILTER_i (
        .aclk(clk),                         // input wire aclk
        .s_axis_data_tvalid(1'b1),          // input wire s_axis_data_tvalid
        .s_axis_data_tready(),              // output wire s_axis_data_tready
        .s_axis_data_tdata(mult_i),         // input wire [23 : 0] s_axis_data_tdata
        .m_axis_data_tvalid(),              // output wire m_axis_data_tvalid
        .m_axis_data_tdata(data_i)          // output wire [23 : 0] m_axis_data_tdata
    );

    // Phase Detection
    wire [23:0]PD;
    // always @(posedge clk) begin
    //     if(data_i[23])
    //         PD <= -data_q;
    //     else
    //         PD <= data_q;
    // end
    mult12_12 U_PHATH_DETECT (
        .CLK(clk),                  // input wire CLK
        .A(data_i[23:12]),          // input wire [11 : 0] A
        .B(data_q[23:12]),          // input wire [11 : 0] B
        .P(PD)                      // output wire [23 : 0] P
    );
    
    Loopfilter U4_loopf(
        .clk(clk),
        .rst(rst),
        .din(PD),
        .freq_update(freq_update),
        .freq(freq),
        .df(df)
    );
endmodule