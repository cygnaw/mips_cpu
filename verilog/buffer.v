`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/02/20 16:24:28
// Design Name: 
// Module Name: buffer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module buffer(
    input clk,
    input en,
    input clr,
    input [31:0] PC,
    input [31:0] IR,
    input [31:0] signal,
    input [4:0] dst,
    input [4:0] R1_pos,
    input [4:0] R2_pos,
    input [4:0] D,
    input [31:0] R1,
    input [31:0] R2,
    input [31:0] ALU_R,
    input [31:0] ext,
    input [31:0] v0,
    input [31:0] a0,
    output reg [31:0] out_PC,
    output reg [31:0] out_IR,
    output reg [31:0] out_signal,
    output reg [4:0] out_dst,
    output reg [4:0] out_R1_pos,
    output reg [4:0] out_R2_pos,
    output reg [4:0] out_D,
    output reg [31:0] out_R1,
    output reg [31:0] out_R2,
    output reg [31:0] out_ALU_R,
    output reg [31:0] out_ext,
    output reg [31:0] out_v0,
    output reg [31:0] out_a0
    );
    always @(posedge clk) begin
        if (en) begin
            out_PC = 0;
            if (clr) begin
                out_IR = 0;
                out_signal = 0;
            end else
                out_IR = IR;
                out_signal = signal;
            end
            out_dst = dst;
            out_R1_pos = R1_pos;
            out_R2_pos = R2_pos;
            out_D = D;
            out_R1 = R1;
            out_R2 = R2;
            out_ALU_R = ALU_R;
            out_ext = ext;
            out_v0 = v0;
            out_a0 = a0;
        end
endmodule