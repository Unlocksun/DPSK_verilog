`timescale 1ns/1ps
//-----------------------------------------------------
//    控制模块
//-----------------------------------------------------
module control
(
    input clk,      //32MHz系统时钟
    input rst,      //高电平有效复位
    input clk_d1,
    input clk_d2,
    input pd_before,
    input pd_after,
    output clk_i,
    output clk_q
);

wire gate_open = (~pd_before) & clk_d1;
wire gate_close = pd_after & clk_d2;
wire clk_in = gate_open | gate_close;   //分频器驱动时钟

reg clki = 0, clkq = 0;
reg [2:0] cnt;
always @ (posedge clk or negedge  rst)
    if (rst) begin
        cnt <= 'd0; clki <= 0; clkq <= 0;
    end
    else begin
        if (clk_in) cnt <= cnt + 1'b1;
        clki <= ~cnt[2];
        clkq <= cnt[2];
    end

assign clk_i = clki;
assign clk_q = clkq;

endmodule