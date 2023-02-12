module pskDemod (
	input rst,
    input clkHi,
    input clkd,
    input [11:0]din,
    output psk_demod,
    output reg decision,
    output signed [23:0]data_i,
    output signed [23:0]data_q,
    output signed [23:0]df,
    output [23:0]abs_data,
    output sync
);

    // Costas loop
    Costas costas_loop(
        .psk(din),
        .clk(clkHi),
        .rst(rst),
        .data_i(data_i),
        .data_q(data_q),
        .df(df)
    );

    // Gate decision
    always @(posedge clkd)
        decision <= data_i[23]?0:1;
        
    // Bit synchronous
	bitSync sync_module
    (
        .clk(clkHi),
        .rst(rst),
        .din(decision),
        .sync(sync)
    );
    
    reg [1:0]data_out_reg;
    reg syn_d = 0;
    always  @(posedge clkHi or posedge rst) begin
        if(rst) data_out_reg <= 2'b0; 
        else begin
            syn_d <= sync;
            if(syn_d == 1&&sync == 0)
                data_out_reg <= {data_out_reg[0], decision};
        end
    end
    
    
//    always  @(posedge sync or posedge rst)
//        if(rst) data_out_reg <= 2'b0;
//        else 
//            data_out_reg <= {data_out_reg[0], decision};
    wire psk_demod_diff = data_out_reg[0];

    // Differential decode
    assign psk_demod = !(data_out_reg[1] == data_out_reg[0]);
endmodule