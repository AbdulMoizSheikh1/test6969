module engine_3x3_2_2 (clk,rst,en,fin,outa,outb,wi,control,v_flag);

parameter precision= 8;
parameter dim_w_1=3;
parameter dim_w_2=3;
parameter size_of_level = 2;
parameter feature_dim=8;
parameter dma_size=4;

input clk;
input rst;
input en;
input v_flag;
input [(dim_w_1*dim_w_2*precision)-1:0] wi;
output reg signed [(2*precision)-1:0] outa;
output reg signed [(2*precision)-1:0] outb;
input [(4*size_of_level)*(precision)-1:0] fin;

output  [1:0] control;
reg  [1:0] state;
wire signed [((dim_w_1*dim_w_2)*(2*precision))-1:0] out1;
wire signed [((dim_w_1*dim_w_2)*(2*precision))-1:0] out2;
reg [(dim_w_1+dim_w_2)*(2*size_of_level)*(precision)-1:0] f;
reg fflag;
reg [2:0] count;   //change this to 1

assign control=state;

always @ (posedge clk,posedge rst)
begin
if(rst)
begin
f=0;
end
else if(!en)
begin
f=0;
end
else
begin
if (state==2'b00 && fflag==1)   //change this if problem just get uncommented
begin
f=f>>dma_size*precision;
f[(feature_dim*precision)+(dma_size*precision)-1:(feature_dim*precision)]=fin[((feature_dim/2)*precision)-1:0];
f[(((feature_dim*dim_w_1)-dma_size)*precision)+(dma_size*precision)-1:(((feature_dim*dim_w_1)-dma_size)*precision)]=fin[((feature_dim)*precision)-1:(feature_dim/2)*precision];
end
else 
begin
f=f;
end
end
end



always @ (posedge clk, posedge rst)  //change to clk
begin
if (rst)
begin
fflag=0;
end
else if(!en)
begin
fflag=0;
end
else begin
if(v_flag==1)
begin
fflag=1;
end
else if(v_flag==0 && state==2'b00)    
begin
fflag=0;
end
else
fflag=fflag;
end
end 


/*always @ (v_flag,f,rst)
begin
if(rst)
fflag=1'b0;
else
fflag=~fflag;
end*/

/*always @ (f)
begin
fflag=1'b0;
end*/


always @ (posedge clk, posedge rst)  //change to clk
begin
if (rst)
begin
count[2:0]=3'b000;
end
else if(!en)
begin
count[2:0]=3'b000;
end
else begin
if(fflag==1 && count<3'b011)
begin
count=count+1;
end
else if(state==2'b11 && fflag==0)    //and this if problem change fflag=0
begin
count=3'b010;
end
else
count=count;
end
end

always @ (posedge clk, posedge rst/*out1,out2,count*/)
begin
if(rst)
begin
state=0;
end
else if(!en)
begin
state=0;
end
else
begin
if(count==3'b011 && state!=2'b11 && fflag==0)
state=state+1;
else 
if(count==3'b010 && state==2'b11 && fflag==0)  //change this if problem
begin
state=2'b00;
end
if(count==3'b011 && state!=2'b00 && fflag==1)  //change this if problem
begin
state=state+1;
end
else
state=state;
end
end


always @ (posedge clk, posedge rst)
begin
if(rst)
begin
outa=0;
end
else if(!en)
begin
outa=0;
end
else
begin
outa = out1[15:0]+out1[31:16]+out1[47:32]+out1[63:48]+out1[79:64]+out1[95:80]+out1[111:96]+out1[127:112]+out1[143:128];
end
end

always @ (posedge clk, posedge rst)
begin
if(rst)
begin
outb=0;
end
else if(!en)
begin
outb=0;
end
else
begin
outb = out2[15:0]+out2[31:16]+out2[47:32]+out2[63:48]+out2[79:64]+out2[95:80]+out2[111:96]+out2[127:112]+out2[143:128];
end
end

//1
genvar i,j;

generate 

for (j=0;j<dim_w_2;j=j+1)
begin

for(i=0;i<dim_w_1;i=i+1) 
begin

PE p1 (
.fi(f[(j*32)+(i*8)+7:(j*32)+(i*8)]),
.frv(f[(j*32)+(i*8)+7+96:(j*32)+(i*8)+96]),
.fot(f[(((i/2)*64)+(i*8)+16+7+(j*32)):(((i/2)*64)+(i*8)+16+(j*32))]),
.control(state),
.wi(wi[(j*(precision*dim_w_1))+(i*precision)+(precision-1):(j*(precision*dim_w_1))+(i*precision)]),
.out(out1[((i+1)*(2*precision))+(j*(size_of_level*precision*dim_w_1))-1:(i*(2*precision))+(j*(size_of_level*precision*dim_w_1))]),
.clk(clk),
.rst(rst),
.en(en)
);

end

end

endgenerate

//2
genvar n,m;

generate 

for (m=0;m<dim_w_2;m=m+1)
begin

for(n=0;n<dim_w_1;n=n+1) 
begin

PE p2 (
.fi(f[(m*32)+(n*8)+7+8:(m*32)+(n*8)+8]),
.frv(f[(m*32)+(n*8)+7+96+8:(m*32)+(n*8)+96+8]),
.fot(f[((n/2)*64)+(n*8)+24+7+(m*32)+((n%2)*64):((n/2)*64)+(n*8)+24+(m*32)+((n%2)*64)]),
.control(state),
.wi(wi[(m*(precision*dim_w_1))+(n*precision)+(precision-1):(m*(precision*dim_w_1))+(n*precision)]),
.out(out2[((n+1)*(2*precision))+(m*(size_of_level*precision*dim_w_1))-1:(n*(2*precision))+(m*(size_of_level*precision*dim_w_1))]),
.clk(clk),
.rst(rst),
.en(en)
);

end

end

endgenerate


endmodule
