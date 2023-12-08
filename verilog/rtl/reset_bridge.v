module reset_bridge(

input reset_i,
input clk,
output reset_o
);

reg f1, f2;

assign reset_o=f2||reset_i;

always @ (posedge clk)
begin
f1<=reset_i;
f2<=f1;
end

endmodule
