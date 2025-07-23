module shifter_RTL (sclr,sset,shiftin,load,data,clock,enable,aclr,aset,shiftout,q);
parameter LOAD_AVALUE = 1;
parameter SHIFT_DIRECTION = 0 ;
parameter LOAD_SVALUE = 1;
parameter SHIFT_WIDTH = 8;

input sclr,sset,shiftin,load,clock,enable,aclr,aset;
input [SHIFT_WIDTH-1:0] data;
output reg  shiftout ;
output reg [SHIFT_WIDTH-1:0] q;

always @(posedge clock , posedge aclr , posedge aset) begin
   if (aclr) begin
    q <= {SHIFT_WIDTH{1'b0}};
   end
   else if (aset) begin
    q <= LOAD_AVALUE [SHIFT_WIDTH-1]; 
   end
   else if (enable) begin
    if (sclr) begin
       q <= {SHIFT_WIDTH{1'b0}}; 
    end
    else if (sset) begin
       q <= LOAD_SVALUE [SHIFT_WIDTH-1];  
    end
    else if (load) begin
        q <= data ;
    end
    else begin
        if (SHIFT_DIRECTION == 0 )   
        {shiftout , q} = {q , shiftin} ; // left shift
        else if (SHIFT_DIRECTION == 1)             
        {q , shiftout} = {shiftin , q} ; // right shift 
    end
   end
end
endmodule
