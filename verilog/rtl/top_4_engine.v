module top_four_engine(

input clk,
input rst,
input en,

input [63:0] in_data,
input [2:0] addr_in,
input we_in,

output [15:0] outa,
output [15:0] outb,


input [71:0] wi0,
input [71:0] wi1,
input [71:0] wi2,
input [71:0] wi3,

output [7:0] la_out,
output v_flag_io,
output state_flag,

output w0_comp_flag,
output w1_comp_flag,
output w2_comp_flag,
output w3_comp_flag,

output in_data_flag,
output out_data_flag

);

wire [15:0] out1;
wire [15:0] out2;
wire [15:0] out3;
wire [15:0] out4;
wire [15:0] out5;
wire [15:0] out6;
wire [15:0] out7;
wire [15:0] out8;

wire [63:0] out_data_inter;
wire [1:0] state_inter,state_inter1,state_inter2,state_inter3;
wire v_flag_inter;

wire [2:0] addr_out_flag;
wire out_en_flag;
 

assign w0_comp_flag=(wi0[31:0]!=0 && wi0[63:32]!=0 && wi0[71:64]!=0)?1'b1:1'b0;
assign w1_comp_flag=(wi1[31:0]!=0 && wi1[63:32]!=0 && wi1[71:64]!=0)?1'b1:1'b0;
assign w2_comp_flag=(wi2[31:0]!=0 && wi2[63:32]!=0 && wi2[71:64]!=0)?1'b1:1'b0;
assign w3_comp_flag=(wi3[31:0]!=0 && wi3[63:32]!=0 && wi3[71:64]!=0)?1'b1:1'b0;

assign in_data_flag=(in_data[63:32]!=0 && in_data[31:0]!=0)?1'b1:1'b0;
assign out_data_flag=(out_data_inter[63:32]!=0 && out_data_inter[31:0]!=0)?1'b1:1'b0;

assign outa=out1+out3+out5+out7;
assign outb=out2+out4+out6+out8;
assign la_out={addr_out_flag,out_en_flag,addr_in,we_in};
assign v_flag_io=v_flag_inter;
assign state_flag=(state_inter1==2'b11 && state_inter2==2'b11 && state_inter3==2'b11)?1'b1:1'b0;

controller_buff_top con1
(
.clk(clk),
.rst(rst),
.en(en),
.in_data(in_data),
.out_data(out_data_inter),
.state(state_inter),
.v_flag(v_flag_inter),
.addr_in(addr_in),
.we_in(we_in),
.addr_out_flag(addr_out_flag),
.oe_flag(out_en_flag)
);



engine_3x3_2_2 a1
(
.clk(clk),
.rst(rst),
.en(en),
.fin(out_data_inter),
.outa(out1),
.outb(out2),
.wi(wi0),
.control(state_inter),
.v_flag(v_flag_inter)
);

engine_3x3_2_2 a2
(
.clk(clk),
.rst(rst),
.en(en),
.fin(out_data_inter),
.outa(out3),
.outb(out4),
.wi(wi1),
.control(state_inter1),
.v_flag(v_flag_inter)
);

engine_3x3_2_2 a3
(
.clk(clk),
.rst(rst),
.en(en),
.fin(out_data_inter),
.outa(out5),
.outb(out6),
.wi(wi2),
.control(state_inter2),
.v_flag(v_flag_inter)
);

engine_3x3_2_2 a4
(
.clk(clk),
.rst(rst),
.en(en),
.fin(out_data_inter),
.outa(out7),
.outb(out8),
.wi(wi3),
.control(state_inter3),
.v_flag(v_flag_inter)
);

endmodule
