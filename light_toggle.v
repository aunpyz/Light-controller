//comment this verilog code via vim on git bash
module light_toggle(l, L, R, E, clk);
	input L, R, E, clk;
	output [5:0]l;
	wire reset;
	wire [2:0]light;
	wire [1:0]q;
	nor n1(reset, L, R);
	counter c(q, clk, reset);
	light_controller light_con(light, E, q, clk);
	and L1(l[0], light[0], L);
	and L2(l[1], light[1], L);
	and L3(l[2], light[2], L);
	and R1(l[3], light[0], R);
	and R2(l[4], light[1], R);
	and R3(l[5], light[2], R);
endmodule

module light_controller(l, E, q);
	input [2:0]q, E;
	output [2:0]l;
	wire l1;
	wire [2:0]nq;
	wire [4:0]out;
	not n0(nq[0], q[0]);
	not n1(nq[1], q[1]);
	not n2(nq[2], E);
	and a1(out[0], nq[2], q[1], nq[0]);
	and a2(out[1], nq[2], q[1], q[0]);
	and a3(out[2], E, nq[0], nq[1]);
	and a4(out[3], nq[2], nq[1], q[0]);
	or o1(l[1], out[0], out[1], out[2]);
	or o2(out[4], out[3], out[1], out[2]);
	or o3(l[0], l[1], out[4]);
	and a5(l[2], l[1], out[4]);
endmodule

module counter(q, clk, reset);
	input clk, reset;
	output [1:0]q;
	wire q0;
	T_FF t0(q[0], 1'b1, clk, reset);
	T_FF t1(q[1], q[0], clk, reset);
endmodule
	
module D_FF(q, d, clk, reset);
	output q;
	input d, clk, reset;
	reg q;
	always@(posedge reset or negedge clk)
	if(reset)
		q <= 1'b0;
	else
		q <= d;
endmodule

module T_FF(q, t, clk, reset);
	output q;
	input t, clk, reset;
	wire d;
	xor x1(d, q, t);
	D_FF d1(q, d, clk, reset);
endmodule
