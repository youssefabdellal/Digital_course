module shifter_TB ();
parameter LOAD_AVALUE = 2;
parameter SHIFT_DIRECTION = 0 ;  // left shifting 
parameter LOAD_SVALUE = 4;
parameter SHIFT_WIDTH = 8;
reg sclr,sset,shiftin,load,clock,enable,aclr,aset;
reg [SHIFT_WIDTH-1:0] data ;
wire shiftout ;
wire [SHIFT_WIDTH-1 :0] q_expected ;

shifter_RTL #(
    .LOAD_AVALUE(LOAD_AVALUE),
    .LOAD_SVALUE(LOAD_SVALUE),
    .SHIFT_DIRECTION(0),
    .SHIFT_WIDTH(SHIFT_WIDTH)
    ) DUT (sclr,sset,shiftin,load,data,clock
    ,enable,aclr,aset,shiftout,q_expected);

initial begin
    clock = 0 ;
    forever begin
        #1 clock = ~clock;
    end
end

initial begin
    aclr = 1 ;
    aset = 1 ;
    repeat (10) begin
        sclr = $random ;
        sset = $random ;
        shiftin = $random ;
        load = $random ;
        enable = $random ;
        data = $random ;
    @ (negedge clock) ;
    if (q_expected == 0)
    $display ("asynchronous reset sucsseful");
    else 
    $display ("asynchronous reset failed");
    end

    aclr = 0 ;
    aset = 1 ;
    repeat (10) begin
        sclr = $random ;
        sset = $random ;
        shiftin = $random ;
        load = $random ;
        enable = $random ;
        data = $random ;
    @ (negedge clock) ;
    if (q_expected == LOAD_AVALUE [SHIFT_WIDTH-1] )
    $display ("asynchronous set sucsseful");
    else 
    $display ("asynchronous set failed");
    end

    aclr = 0 ;
    aset = 0 ;
    sclr = 1 ;
    sset = 1 ;
    repeat (10) begin
        shiftin = $random ;
        load = $random ;
        enable = $random ;
        data = $random ;
    @ (negedge clock) ;
    if (q_expected == 0)
    $display ("synchronous reset sucsseful");
    else 
    $display ("synchronous reset failed");
    end

    aclr = 0 ;
    aset = 0 ;
    sclr = 0 ;
    sset = 1 ;
    repeat (10) begin
        shiftin = $random ;
        load = $random ;
        enable = $random ;
        data = $random ;
    @ (negedge clock) ;
    if (q_expected == LOAD_SVALUE [SHIFT_WIDTH-1])
    $display ("synchronous set sucsseful");
    else 
    $display ("synchronous set failed");
    end

    aclr = 0 ;
    aset = 0 ;
    sclr = 0 ;
    sset = 0 ;
    load = 1 ;
    enable = 1  ;
    repeat (10) begin
        shiftin = $random ;
        data = $random ;
    @ (negedge clock) ;
    if (q_expected == data)
    $display ("Data loaded sucsseful");
    else 
    $display ("Data loaded failed");
    end

    aclr = 0 ;
    aset = 0 ;
    sclr = 0 ;
    sset = 0 ;
    load = 0 ;
    shiftin = 0 ;
    enable = 1 ;
    data = 8'b10001000;
    @(negedge clock);
    $display("shifted data = %b" ,q_expected);
    $stop;
end
endmodule