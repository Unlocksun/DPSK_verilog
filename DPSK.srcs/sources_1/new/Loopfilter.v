`timescale 1ns / 1ps
module Loopfilter(
    input clk,
    input rst,
    input [23:0]din,
    output reg freq_update,     // update freq word of NCO
    output reg [31:0]freq,
    output reg [23:0]df
    );

reg [3:0]cnt;
reg signed [23:0]sum;
reg signed [18:0]register2;      // C2
reg signed [23:0]register1;     // C1
integer start_freq = 32'h1000000;   // initial freq: 2.048MHz

always @(posedge clk or posedge rst) begin
    if(rst) begin
        cnt <= 4'b0;
        freq_update <= 0;
        df <= 24'b0;
        freq <= start_freq;
        sum <= 32'b0;
    end
    else begin
        register2 <= din[23:5];
        register1 <= din[23:0];
        if(cnt < 12)
            cnt <= cnt + 1;
        else
            cnt <= 4'b0;

        if(cnt == 1)
            sum <= sum + register2;
        if(cnt == 2) begin
            freq <= start_freq + sum + register1;
            df <= sum + register1;
            freq_update <= 1;
        end
        else
            freq_update <= 0;
    end
end

endmodule
