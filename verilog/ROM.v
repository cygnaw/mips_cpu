`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/02/21 10:47:25
// Design Name: 
// Module Name: ROM
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


module ROM(
    input [9:0] addr,
    input sel,
    output [31:0] data
    );
    reg [31:0] rom [0:2**10-1];
    assign data = sel ? rom[addr] : 0;
    initial $readmemh("/home/stitch/vivado/cpu/mips_cpu/sim/result.hex", rom);
endmodule
