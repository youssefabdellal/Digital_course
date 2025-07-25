module ALSU_TB ();
reg [2:0]A;
reg [2:0]B;
reg [2:0] opcode;
reg cin ;
reg serial_in ;
reg red_op_A;
reg red_op_B;
reg bypass_A;
reg bypass_B;
reg direction;
reg clk;
reg rst;
wire [5:0] out ;
wire [15:0] leds;
// instantiation 
ALSU  DUT (A,B,opcode,cin,serial_in,
        direction,red_op_A,red_op_B,
        bypass_A,bypass_B,clk,rst,
        leds,out);
//clock generation 
initial begin
    clk = 0 ;
    forever begin
        #1 clk = ~clk;
    end
end
integer i;
initial begin
    // test 2.1
    rst = 1 ;
    cin = 0 ;
    serial_in = 0 ;
    red_op_A  = 0 ;
    red_op_B  = 0 ;
    bypass_A  = 0 ;
    bypass_B  = 0 ;
    direction = 0 ;
    A = 0;
    B = 0;
    opcode = 0 ;
    @ (negedge clk) ;
    if (out == 6'b000000 && (leds == 16'b0000000000000000))
    $display ("test 2.1 passed");
    else 
    $display ("test 2.1 failed");
    // test 2.2 
    rst = 0 ;
    bypass_A = 1 ;
    bypass_B = 1 ;
    for (i = 0 ; i < 6 ; i = i + 1) begin
        A = $urandom_range(0, 7);
        B = $urandom_range(0, 7);
        opcode = $urandom_range(0,5);
        repeat (2) @ (negedge clk) ;
        if (out == A)
        $display ("test 2.2 passed");
        else
        $display ("test 2.2 failed");
    end
    // test 2.3
    bypass_A = 0 ;
    bypass_B = 0 ;
    opcode = 0 ;
    for (i = 0 ; i < 6 ; i = i + 1) begin
        A = $random ;
        B = $random ;
        red_op_A = $random;
        red_op_B = $random;
        repeat (2) @ (negedge clk) ;
        if (red_op_A && red_op_B) begin
            if (out == &A)
            $display ("test 2.3 passed");
            else 
            $display ("test 2.3 failed");
        end
        else if (red_op_A) begin
            if (out == &A)
            $display ("test 2.3 passed");
            else 
            $display ("test 2.3 failed");
        end
        else if (red_op_B) begin
            if (out == &B)
            $display ("test 2.3 passed");
            else 
            $display ("test 2.3 failed");
        end
        else begin
            if (out == (A & B))
            $display ("test 2.3 passed");
            else 
            $display ("test 2.3 failed");
        end
    end
    // test 2.4 
    opcode = 1 ;
    for (i = 0 ; i < 6 ; i = i + 1) begin
        A = $random ;
        B = $random ;
        red_op_A = $random;
        red_op_B = $random;
        repeat (2) @ (negedge clk) ;
        if (red_op_A && red_op_B) begin
            if (out == ^A)
            $display ("test 2.4 passed");
            else 
            $display ("test 2.4 failed");
        end
        else if (red_op_A) begin
            if (out == ^A)
            $display ("test 2.4 passed");
            else 
            $display ("test 2.4 failed");
        end
        else if (red_op_B) begin
            if (out == ^B)
            $display ("test 2.4 passed");
            else 
            $display ("test 2.4 failed");
        end
        else begin
            if (out == (A ^ B))
            $display ("test 2.4 passed");
            else 
            $display ("test 2.4 failed");
        end
    end
    // test 2.5 
    opcode = 2 ;
    red_op_A = 0 ;
    red_op_B = 0 ;
    for (i = 0 ; i < 6 ; i = i + 1) begin
        A = $random ;
        B = $random ;
        cin = $random ;
        repeat (2) @ (negedge clk) ;
        if (out == A + B + cin) 
        $display ("test 2.5 passed");
        else 
        $display ("test 2.5 failed");
    end
    // test 2.6 
    opcode = 3 ;
    for (i = 0 ; i < 6 ; i = i + 1) begin
        A = $random ;
        B = $random ;
        repeat (2) @ (negedge clk) ;
        if (out == A * B) 
        $display ("test 2.5 passed");
        else 
        $display ("test 2.5 failed");
    end
    // test 2.7 
    opcode = 4 ;
    for (i = 0 ; i < 6 ; i = i + 1) begin
        A = $random ;
        B = $random ;
        serial_in = $random;
        direction = $random;
        repeat (2) @ (negedge clk) ;
    end
    // test 2.8 
    opcode = 5 ;
    for (i = 0 ; i < 6 ; i = i + 1) begin
        A = $random ;
        B = $random ;
        serial_in = $random;
        direction = $random;
        repeat (2) @ (negedge clk) ;
    end
    $stop;
end 
endmodule