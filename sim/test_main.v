`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/02/23 16:19:17
// Design Name: 
// Module Name: test_main
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


module test_main;
    reg Clock = 0;
    reg ir0 = 0;
    reg ir1 = 0;
    reg ir2 = 0;
    
    main MAIN (Clock, ir0, ir1, ir2);
    always
        #20 Clock = ~Clock;
    
    initial begin
        #110 ir0 = 1;
        #3 ir0 = 0;
    end
endmodule
