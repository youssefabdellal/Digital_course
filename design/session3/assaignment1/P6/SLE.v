module sle_RTL (D,CLk,EN,ALn,ADn,SLn,SD,LAT,Q);
input D,CLk,EN,ALn,ADn,SLn,SD,LAT;
output reg Q ;

always @ (posedge CLk , negedge ADn , negedge ALn) begin
    if (~ALn) begin
        if (ADn == 1)
        Q <= 0 ; 
        else 
        Q <= 1 ;     
    end
    if (!LAT) begin
        if (EN) begin
            if (SLn)
            Q <= D ;
            else 
            Q <= SD;
        end
    end
    else begin
        if (CLk&&EN) begin
            if (SLn) 
            Q <= D ;
            else 
            Q <= SD ;
            end
        end
    end
endmodule