`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/02/20 08:37:03
// Design Name: 
// Module Name: main
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


module main(
	input Clock,
	input disp_total,
	input disp_j,
	input disp_b,
	input disp_lu,
	input disp_cycle,
	input ir0,
	input ir1,
	input ir2,
	output [7:0] digitalLocation,
    output [7:0] digitalStates
    );
	wire [31:0] if_pc, if_ir;

	wire [31:0] id_pc_1, id_ir_1, id_signal_1;
	wire [31:0] id_pc_2, id_ir_2, id_signal_2, id_r1_2, id_r2_2, id_ext_2, id_v0_2, id_a0_2;
	wire [4:0] id_dst_2, id_r1_pos_2, id_r2_pos_2;
	
	wire [31:0] ex_pc_1, ex_ir_1, ex_signal_1, ex_r1_1, ex_r2_1, ex_ext_1, ex_v0_1, ex_a0_1;
	wire [4:0] ex_dst_1, ex_r1_pos_1, ex_r2_pos_1;
	wire [31:0] ex_pc_2, ex_ir_2, ex_signal_2, ex_r2_2, ex_r_2, ex_v0_2, ex_a0_2, ex_cp0;
	wire [4:0] ex_dst_2;
	wire [31:0] ex_new_r1, ex_new_r2, ex_new_v0, ex_new_a0;
	
	wire [31:0] mem_pc_1, mem_ir_1, mem_signal_1, mem_r2_1, mem_r_1, mem_v0_1, mem_a0_1;
	wire [4:0] mem_dst_1;
	wire [31:0] mem_pc_2, mem_ir_2, mem_signal_2, mem_d_2, mem_r_2, mem_v0_2, mem_a0_2, mem_cp0;
	wire [4:0] mem_dst_2;
	
	wire [31:0] wb_pc_1, wb_ir_1, wb_signal_1, wb_d_1, wb_r_1, wb_v0_1, wb_a0_1, wb_cp0;
	wire [4:0] wb_dst_1;

    wire [31:0] new_pc, wb_data, result;
    
    wire wb_we, mem_we, lu, JB, is, eret;
    
    wire [31:0] pc_in_cp0, cp0_pc;
    wire [31:0] count_total, count_j, count_b, count_lu, count_cycle, display;
    
    wire clk;
    wire clk10K, clk1K, clk10, clk5, clk_final;
//    assign clk_final = Clock;
    div1000hz i_div1(Clock, clk10K);
    div10hz i_div3(clk10K, clk1K);
    div10hz i_div4(clk1K, clk100);
    div1000hz i_div2(clk10K, clk10);
    div2hz i_div5(clk10, clk5);
    div2hz i_div6(clk5, clk_final);
    
    assign display = disp_cycle ? count_cycle :
                     disp_lu ? count_lu :
                     disp_b ? count_b :
                     disp_j ? count_j :
                     disp_total ? count_total :
                     result;
    Display i_display (clk100, display, digitalLocation, digitalStates);
    
	Counter i_total (mem_signal_1[31], clk, count_total);
	Counter i_j (mem_signal_1[30], clk, count_j);
	Counter i_b (mem_signal_1[29], clk, count_b);
	Counter i_lu (mem_signal_1[28], clk, count_lu);
	Counter i_cycle (1'b1, clk, count_cycle);
	
    IF i_IF ( .lu(lu), .clk(clk), .new_pc(is|eret ? cp0_pc : new_pc),
              .pc_4(if_pc), .ir(if_ir));

    buffer IF_ID (.clk(clk), .en(~lu), .clr(JB|eret|is), .PC(if_pc), .IR(if_ir), .signal(32'h80000000), .dst(5'b0), .R1_pos(5'b0), .R2_pos(5'b0),
        .D(0), .R1(0), .R2(0), .ALU_R(0), .ext(0), .v0(0), .a0(0), .cp0(0),
        .out_PC(id_pc_1), .out_IR(id_ir_1), .out_signal(id_signal_1), .out_dst(), .out_R1_pos(), .out_R2_pos(),
        .out_D(), .out_R1(), .out_R2(), .out_ALU_R(), .out_ext(), .out_v0(), .out_a0(), .out_cp0());
        
        
    ID i_ID( .clk(clk), .in_pc(id_pc_1), .in_ir(id_ir_1), .in_signal(id_signal_1), .rw(wb_dst_1), .din(wb_data), .we(wb_we), 
        .out_pc(id_pc_2), .out_ir(id_ir_2), .out_signal(id_signal_2), .dst(id_dst_2), .r1_pos(id_r1_pos_2),
		.r2_pos(id_r2_pos_2), .ext(id_ext_2), .r1(id_r1_2), .r2(id_r2_2), .v0(id_v0_2), .a0(id_a0_2) );
        
        
    buffer ID_EX (.clk(clk), .en(1'b1), .clr(JB|lu|eret|is), .PC(id_pc_2), .IR(id_ir_2), .signal(id_signal_2), .dst(id_dst_2), .R1_pos(id_r1_pos_2), .R2_pos(id_r2_pos_2),
        .D(0), .R1(id_r1_2), .R2(id_r2_2), .ALU_R(0), .ext(id_ext_2), .v0(id_v0_2), .a0(id_a0_2), .cp0(0),
        .out_PC(ex_pc_1), .out_IR(ex_ir_1), .out_signal(ex_signal_1), .out_dst(ex_dst_1), .out_R1_pos(ex_r1_pos_1), .out_R2_pos(ex_r2_pos_1),
        .out_D(), .out_R1(ex_r1_1), .out_R2(ex_r2_1), .out_ALU_R(), .out_ext(ex_ext_1), .out_v0(ex_v0_1), .out_a0(ex_a0_1), .out_cp0());
		
	redirect rdrctr1 (.data(ex_r1_1), .dst(ex_r1_pos_1), .wb_data(wb_data), .wb_dst(wb_dst_1), .wb_we(wb_we), 
	   .mem_data(mem_signal_1[16] ? mem_cp0 : mem_r_1), .mem_dst(mem_dst_1), .mem_we(mem_we), .data_out(ex_new_r1));
	redirect rdrctr2 (.data(ex_r2_1), .dst(ex_r2_pos_1), .wb_data(wb_data), .wb_dst(wb_dst_1), .wb_we(wb_we), 
	   .mem_data(mem_signal_1[16] ? mem_cp0 : mem_r_1), .mem_dst(mem_dst_1), .mem_we(mem_we), .data_out(ex_new_r2));
	redirect rdrctv0 (.data(ex_v0_1), .dst(5'h2), .wb_data(wb_data), .wb_dst(wb_dst_1), .wb_we(wb_we), 
	   .mem_data(mem_signal_1[16] ? mem_cp0 : mem_r_1), .mem_dst(mem_dst_1), .mem_we(mem_we), .data_out(ex_new_v0));
	redirect rdrcta0 (.data(ex_a0_1), .dst(5'h4), .wb_data(wb_data), .wb_dst(wb_dst_1), .wb_we(wb_we), 
	   .mem_data(mem_signal_1[16] ? mem_cp0 : mem_r_1), .mem_dst(mem_dst_1), .mem_we(mem_we), .data_out(ex_new_a0));
    
	EX i_EX ( .clk(clk), .lu(lu), .in_pc(ex_pc_1), .in_pc_4(if_pc), .in_ir(ex_ir_1), .in_signal(ex_signal_1), .in_dst(ex_dst_1),
		.in_r1(ex_new_r1), .in_r2(ex_new_r2), .in_ext(ex_ext_1), .in_v0(ex_new_v0), .in_a0(ex_new_a0),
		.new_pc(new_pc), .out_pc(ex_pc_2), .out_ir(ex_ir_2), .out_signal(ex_signal_2),
		.out_dst(ex_dst_2), .out_r2(ex_r2_2), .out_r(ex_r_2), .out_v0(ex_v0_2), .out_a0(ex_a0_2), .JB(JB));

	load_use i_load_use ( .dst(ex_r2_pos_1), .memRead(ex_signal_1[4]), .R1(id_r1_pos_2), .R2(id_r2_pos_2), .syscall(id_signal_2[15]), .lu(lu) );
        

    assign eret = ex_signal_1[18];
    assign pc_in_cp0 = (ex_signal_1[31] ? ex_pc_1 :
                       id_signal_1[31] ? id_pc_1 :
                       if_pc) - 4;
    CP0 i_cp0 (.pos(ex_dst_1), .din(ex_new_r2), .pc(pc_in_cp0), 
               .we(ex_signal_1[17]), .clk(clk), .eret(eret),
               .ir0(ir0), .ir1(ir1), .ir2(ir2), .Reg(ex_cp0),
               .new_pc(cp0_pc), .is(is));
    
        
    buffer EX_MEM (.clk(clk), .en(1'b1), .clr(is), .PC(ex_pc_2), .IR(ex_ir_2), .signal(ex_signal_2), .dst(ex_dst_2), .R1_pos(5'b0), .R2_pos(5'b0),
        .D(0), .R1(0), .R2(ex_r2_2), .ALU_R(ex_r_2), .ext(0), .v0(ex_v0_2), .a0(ex_a0_2), .cp0(ex_cp0),
        .out_PC(mem_pc_1), .out_IR(mem_ir_1), .out_signal(mem_signal_1), .out_dst(mem_dst_1), .out_R1_pos(), .out_R2_pos(),
        .out_D(), .out_R1(), .out_R2(mem_r2_1), .out_ALU_R(mem_r_1), .out_ext(), .out_v0(mem_v0_1), .out_a0(mem_a0_1), .out_cp0(mem_cp0));
		
	MEM i_MEM ( .clk(clk), .in_pc(mem_pc_1), .in_ir(mem_ir_1), .in_signal(mem_signal_1), .in_dst(mem_dst_1), .in_r2(mem_r2_1), .in_r(mem_r_1), .in_v0(mem_v0_1), .in_a0(mem_a0_1),
		.out_pc(mem_pc_2), .out_ir(mem_ir_2), .out_signal(mem_signal_2), .out_dst(mem_dst_2), .out_d(mem_d_2), .out_r(mem_r_2), .out_v0(mem_v0_2), .out_a0(mem_a0_2), .mem_we(mem_we) );
            
            
    buffer MEM_WB (.clk(clk), .en(1'b1), .clr(0), .PC(mem_pc_2), .IR(mem_ir_2), .signal(mem_signal_2), .dst(mem_dst_2), .R1_pos(5'b0), .R2_pos(5'b0),
        .D(mem_d_2), .R1(0), .R2(0), .ALU_R(mem_r_2), .ext(0), .v0(mem_v0_2), .a0(mem_a0_2), .cp0(mem_cp0),
        .out_PC(wb_pc_1), .out_IR(wb_ir_1), .out_signal(wb_signal_1), .out_dst(wb_dst_1), .out_R1_pos(), .out_R2_pos(),
        .out_D(wb_d_1), .out_R1(), .out_R2(), .out_ALU_R(wb_r_1), .out_ext(), .out_v0(wb_v0_1), .out_a0(wb_a0_1), .out_cp0(wb_cp0));
		
	WB i_WB ( .Clock(clk_final), .in_pc(wb_pc_1), .in_signal(wb_signal_1), .in_d(wb_d_1), .in_r(wb_r_1),
		.in_v0(wb_v0_1), .in_a0(wb_a0_1), .in_cp0(wb_cp0), .out_data(wb_data), .out_we(wb_we), .display(result), .clk(clk) );
		
endmodule
