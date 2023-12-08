module buffer_top_64x8(clk, rst, addr_in_wr, in_data, wr_en_0, addr_in_rd, out_data, op_en_1);

input clk;
input rst;

//port for writing
input [2:0] addr_in_wr;
input [63:0] in_data;
input wr_en_0;

//port for reading
input [2:0] addr_in_rd;
output reg [63:0] out_data;
input op_en_1;

reg [63:0] mem [7:0];


//writing
always @ (posedge clk,posedge rst)
begin
if (rst)
begin
mem[0]=0;
mem[1]=0;
mem[2]=0;
mem[3]=0;
mem[4]=0;
mem[5]=0;
mem[6]=0;
mem[7]=0;
end
else
begin
if(wr_en_0)
begin
mem[addr_in_wr]=in_data;
end
end
end

//reading
always @ (posedge clk,posedge rst)
begin
if (rst)
begin
out_data=0;
end
else
begin
if(op_en_1)
begin
out_data=mem[addr_in_rd];
end
end
end


endmodule
