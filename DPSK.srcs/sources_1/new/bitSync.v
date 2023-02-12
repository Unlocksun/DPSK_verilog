module bitSync
(
    input clk,          
    input rst,
    input din,
    output sync
);

wire clk_d1, clk_d2;
clk_gen U0
(
    .clk(clk),
    .rst(rst),
    .clk_d1(clk_d1),
    .clk_d2(clk_d2)
);

wire pd_after, pd_before;
phaseDetec U1
(
    .clk(clk),
    .rst(rst),
    .datain(din),
    .clk_i(clk_i),
    .clk_q(clk_q),
    .pd_before(pd_before),
    .pd_after(pd_after)
);


wire flop_out1;
moniflop U2
(
    .clk(clk),
    .rst(rst),
    .din(pd_before),      
    .dout(flop_out1)
);

wire flop_out2;
moniflop U3
(
    .clk(clk),
    .rst(rst),
    .din(pd_after),      
    .dout(flop_out2)
);

wire clk_i, clk_q;
control U4
(
    .clk(clk),
    .rst(rst),
    .clk_d1(clk_d1),
    .clk_d2(clk_d2),
    .pd_before(flop_out1),
    .pd_after(flop_out2),
    .clk_i(clk_i),
    .clk_q(clk_q)
);
assign sync = clk_i;

endmodule