`timescale 1ns/1ps
//-----------------------------------------------------
//   ˫��ʱ���ź�����ģ��
//-----------------------------------------------------
module clk_gen
(
    input clk,      //32MHzϵͳʱ��
    input rst,      //�ߵ�ƽ��Ч��λ
    output clk_d1,  //ʱ��1
    output clk_d2   //ʱ��2
);

//-----------------------------------------------------
//  ����ռ�ձ�Ϊ1:3��ʱ��Ϊ����Ƶ�ʵ�˫��ʱ��
//  ��·ʱ�������λ�������ϵͳʱ������ 
//-----------------------------------------------------
reg [1:0] cnt;     //����
reg clkd1 = 0, clkd2 = 0;

//�ڼ������Ŀ��������ָ��ʱ�����
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