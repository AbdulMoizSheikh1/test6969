module controller_buff_top(clk,rst,en,in_data,out_data,state,v_flag,addr_in,we_in,addr_out_flag,oe_flag);

input clk;
input rst;
input en;

input [2:0] addr_in;
input we_in;

input [63:0] in_data;
output [63:0] out_data;

input [1:0] state;
output reg v_flag;

output [2:0] addr_out_flag;
output oe_flag;



reg [2:0] addr_in_temp;
reg we_in_reg;
reg [63:0] in_data_temp;

reg [2:0] counter;

wire out_en;
assign out_en=(counter==3'd3)?1'b1:1'b0;

reg [2:0] addr_out, addr_out_r1, addr_out_r2;
reg [1:0] startup;

assign oe_flag=out_en;
assign addr_out_flag=addr_out;

buffer_top_64x8 buff1
(
.clk(clk), 
.rst(rst), 
.addr_in_wr(addr_in), 
.in_data(in_data), 
.wr_en_0(we_in), 
.addr_in_rd(addr_out), 
.out_data(out_data), 
.op_en_1(out_en)
);

//writing to memory
always @ (posedge clk, posedge rst)
begin
if (rst)
begin
addr_in_temp<=0;
we_in_reg<=0;
end
else if(!en)
begin
addr_in_temp<=addr_in_temp;
we_in_reg<=we_in_reg;
end
else
begin
if(we_in)
begin
addr_in_temp<=addr_in;
we_in_reg<=1'b1;
end
else
begin
addr_in_temp<=addr_in_temp;
we_in_reg<=we_in_reg;
end
end
end


//counting pulses written for pipelining
always @ (posedge clk, posedge rst)
begin
if (rst)
begin
counter<=0;
end
else if(!en)
begin
counter<=0;
end
else
begin
if(we_in_reg) begin
case (addr_in_temp)
3'b000:begin
counter<=3'd1;
end
3'b001:begin
counter<=3'd2;
end
3'b010:begin
counter<=3'd3;
end
default:begin
if(addr_in_temp>3'b010)
counter<=3'd3;
else
counter<=counter;
end
endcase
end
else
counter<=counter;
end
end


always @ (posedge clk, posedge rst)
begin
if(rst)
begin
startup<=0;
end
else if(!en)
begin
startup<=0;
end
else 
begin
if(addr_out==0 && out_en && startup<2'b11)
startup<=startup+1;
else
startup<=startup;
end
end


//reading
always @ (posedge clk, posedge rst)
begin
if(rst)
begin
addr_out<=3'b000;
end
else if(!en)
begin
addr_out<=3'b000;
end
else 
begin
if(addr_out<addr_in_temp && state==2'b00 && out_en && addr_out==addr_out_r2 && startup==2'b11)
begin
addr_out<=addr_out+1;
end
else
begin
addr_out<=addr_out;
end
end
end

//reading
always @ (posedge clk, posedge rst)
begin
if(rst)
begin
addr_out_r1<=3'b000;
addr_out_r2<=3'b000;
end
else if(!en)
begin
addr_out_r1<=3'b000;
addr_out_r2<=3'b000;
end
else 
begin
addr_out_r1<=addr_out;
addr_out_r2<=addr_out_r1;
end
end

always @ (posedge clk, posedge rst)
begin
if(rst)
begin
v_flag<=0;
end
else if(!en)
begin
v_flag<=0;
end
else 
begin
if(addr_out_r1!=addr_out && addr_out!=0)
v_flag<=1'b1;
else if(addr_out==0 && out_en && startup<2'b01)
v_flag<=1'b1;
else
v_flag<=1'b0;
end
end

endmodule
