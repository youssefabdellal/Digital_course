module p2 (a,b,c,d,sel,out,out_bar);
input a,b,c,sel;
input [2:0]d;
output reg out ,out_bar;
reg AND2,OR1,XNOR1;

always @ (*) begin 

    AND2 = d[0] & d[1];
    OR1  = d[2] | AND2;
    XNOR1= ~(a^b^c);
    if (sel==1) begin 
        out = XNOR1;
    end 
    else begin 
        out = OR1;
    end
    out_bar = ~out;
end
endmodule 