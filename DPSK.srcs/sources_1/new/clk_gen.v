`timescale 1ns/1ps
//-----------------------------------------------------
//   双相时钟信号生成模块
//-----------------------------------------------------
module clk_gen
(
    input clk,      //32MHz系统时钟
    input rst,      //高电平有效复位
    output clk_d1,  //时钟1
    output clk_d2   //时钟2
);

//-----------------------------------------------------
//  产生占空比为1:3，时钟为采样频率的双相时钟
//  两路时钟输出相位相差两个系统时钟周期 
//-----------------------------------------------------
reg [1:0] cnt;     //计数
reg clkd1 = 0, clkd2 = 0;

//在计数器的控制下完成指定时钟输出
always @ (posedge clk or posedge rst)
    if (rst) begin
        cnt <= 'd0; clkd1 <= 1'b0; clkd2 <= 1'b0;
    end
    else 
        case (cnt)
            2'd0 : begin  
                clkd1 <= 1'b1;
                clkd2 <= 1'b0;
                cnt <= cnt + 1'b1;
            end
            2'd2 : begin
                clkd1 <= 1'b0;
                clkd2 <= 1'b1;
                cnt <= cnt + 1'b1;
            end
            default : begin
                clkd1 <= 1'b0;
                clkd2 <= 1'b0;
                cnt <= cnt + 1'b1;
            end
        endcase

assign clk_d1 = clkd1;
assign clk_d2 = clkd2;

endmodule