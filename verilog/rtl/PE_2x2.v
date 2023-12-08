
module PE (fi,frv,fot,control,wi,out,clk,rst,en);

parameter bits_of_value = 8;

//reset has priority over enable 
//reset codition when rst==1
//enable condition when en==1

input [bits_of_value -1:0] fi;
input [bits_of_value -1:0] frv;
input [bits_of_value -1:0] fot;
input signed [bits_of_value -1:0] wi;
//input [bits_of_value -1:0] interm;
input clk;
input rst;
input en;
input [1:0] control;
output reg signed [2*bits_of_value -1:0] out;
//reg [2*bits_of_value -1:0] accu;
reg signed [bits_of_value -1:0] f;

always @ (posedge clk,posedge rst)
begin
if(rst)
begin
f=0;
end
else 
if(!en)
begin
f=0;
end
else 
begin
case (control)

1: begin
f=fi;
end

2:begin
f=fot;
end

3: begin
f=frv;
end

0:begin
f=0;
end

endcase
end
end



always @ (posedge clk,posedge rst)
begin
if(rst)
begin
out=0;
end
else 
if(!en)
begin
out=0;
end
else 
begin
case (wi)

0:begin
out=0;

end

1:begin
out={8'h00,f};

end


2:begin
out={7'b0000000,f[7:0],1'b0};

end

4:begin
out={6'b000000,f[7:0],2'b00};

end

8:begin
out={5'b00000,f[7:0],3'b000};

end

16:begin
out={4'b0000,f[7:0],4'b0000};

end

default: begin
out = f * wi;

end

endcase

end

end

/*always @ (posedge clk,posedge rst)
begin
if(rst)
begin
out=0;
end
else 
if(!en)
begin
out=0;
end
else 
begin
out = accu + interm ;
end
end*/

endmodule
