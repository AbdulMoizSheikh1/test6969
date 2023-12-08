module top_wb_4_short(

input clk,
input rst,
input [7:0] addr,
input [31:0] data_in,
output [31:0] data_out,
output ack,
input cyc,
input we,
input str,

output [7:0] la_out_test,
output v_flag_io,
output state_flag_io,

output wi0_flag,
output wi1_flag,
output wi2_flag,
output wi3_flag,

output data_in_flag,
output data_out_flag
);


reg [31:0] data_out_reg;
reg [63:0] in_data;
reg [71:0] wi0;
reg [71:0] wi1;
reg [71:0] wi2;
reg [71:0] wi3;
reg [2:0] addr_in;
reg we_in;
wire [15:0] outa;
wire [15:0] outb;



//wire v_io, state_io;

wire reset_o_int;


assign data_out = data_out_reg;
assign ack=(cyc&&str&&we)?1'b1:1'b0;


reset_bridge r1(
.reset_i(rst),
.clk(clk),
.reset_o(reset_o_int)
);


top_four_engine t2(

.clk(clk),
.rst(reset_o_int),
.en(addr[7]),

.in_data(in_data),
.addr_in(addr_in),
.we_in(we_in),

.outa(outa),
.outb(outb),
.wi0(wi0),
.wi1(wi1),
.wi2(wi2),
.wi3(wi3),

.la_out(la_out_test),
.v_flag_io(v_flag_io),
.state_flag(state_flag_io),

.w0_comp_flag(wi0_flag),
.w1_comp_flag(wi1_flag),
.w2_comp_flag(wi2_flag),
.w3_comp_flag(wi3_flag),

.in_data_flag(data_in_flag),
.out_data_flag(data_out_flag)
);



always @ (posedge clk, posedge rst)
begin
if(rst)
begin
in_data=0;
we_in=0;
addr_in=0;
end
else
begin
if(cyc && str && we && addr[7:4]==4'b1100)
begin
we_in=1;
addr_in=addr[2:0];
case(addr[3])
0:begin
in_data[31:0]=data_in;
end
1:begin
in_data[63:32]=data_in;
end
endcase
end
else
begin
we_in=0;
in_data=in_data;
addr_in=addr_in;
end
end
end





always @ (posedge clk, posedge rst)
begin
if(rst)
begin
wi0=0;
wi1=0;
wi2=0;
wi3=0;
end
else
begin
if(cyc && str && we)
begin
case (addr)

8'b01010001:begin
wi0[31:0]=data_in[31:0];
end

8'b01010010:begin
wi0[63:32]=data_in[31:0];
end

8'b01010011:begin
wi0[71:64]=data_in[31:24];
end

8'b01010100:begin
wi1[31:0]=data_in[31:0];
end

8'b01010101:begin
wi1[63:32]=data_in[31:0];
end

8'b01010110:begin
wi1[71:64]=data_in[31:24];
end
///////
8'b01010111:begin
wi2[31:0]=data_in[31:0];
end

8'b01011000:begin
wi2[63:32]=data_in[31:0];
end

8'b01011001:begin
wi2[71:64]=data_in[31:24];
end
///////
8'b01011010:begin
wi3[31:0]=data_in[31:0];
end

8'b01011011:begin
wi3[63:32]=data_in[31:0];
end

8'b01011100:begin
wi3[71:64]=data_in[31:24];
end


default:begin
wi1=wi1;
wi0=wi0;
wi2=wi2;
wi3=wi3;
end

endcase
end

else
begin
wi1=wi1;
wi0=wi0;
end

end
end




/*
///data output
always @ (posedge clk, posedge rst)
begin
if(rst)
begin
data_out_reg=0;
end
else
begin
if( cyc && str )
begin
if(!we)
begin
case (addr[6:5])
00:begin

case (addr[4:0])
00001:begin
data_out_reg=32'h414d5331;     //"AMS1"
end

00010:begin
data_out_reg=32'h43454149;  //"CEAI"
end

00011:begin
data_out_reg=32'h312e3030;  //"1.00"
end

default: begin
data_out_reg=data_out_reg;
end

endcase
end

01: begin
if(addr[4:0]==5'b00000)
begin
data_out_reg={outb,outa};
end

else
begin
data_out_reg=data_out_reg;
end

end

default:begin
data_out_reg=data_out_reg;
end
endcase
end
end
end
end
*/

always @ (posedge clk, posedge rst)
begin
if(rst)
begin
data_out_reg=0;
end
else
begin
if(cyc && str && !we )
begin
case (addr)

8'b10000001:begin
data_out_reg=32'h414d5331;     //"AMS1"
end

8'b10000010:begin
data_out_reg=32'h43454149;  //"CEAI"
end

8'b10000011:begin
data_out_reg=32'h322e3030;  //"2.00"
end

8'b10100000:begin
data_out_reg={outb,outa};    //result output 
end

default: begin
data_out_reg=data_out_reg;   //retainment
end
endcase
end
else
begin
data_out_reg=0;
end
end
end


endmodule
