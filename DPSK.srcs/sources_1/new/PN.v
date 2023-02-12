module PN_Gen
(
	input clk,
	output reg pn
);

reg[4:0] PN_buf = 5'd1;   // 赋值只在 modelsim 仿真中有用， 在电路工作时不起作用
wire rst;

initial begin
    pn <= 0;
end

always@(posedge clk) begin
    if(rst) begin
        PN_buf <= 5'd1;
        pn <= 0;
    end
    else begin
        PN_buf <= {PN_buf[3:0],PN_buf[4]+PN_buf[1]};
        pn <= PN_buf[4];
    end
end

assign rst = !(|PN_buf);  // PN_buf在全部为0的情况下, 会产生复位信号。

endmodule 