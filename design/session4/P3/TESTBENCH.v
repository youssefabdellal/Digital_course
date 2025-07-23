module TDM_tb ();
    reg [1:0] in0 ;
    reg [1:0] in1 ;
    reg [1:0] in2 ;
    reg [1:0] in3 ;
    reg rst;
    reg clk;
    wire [1:0] out;
    // Instantiate DUT
    TDM DUT (in0, in1, in2, in3, rst, clk, out);
    // Clock generation
    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end
    end
    // Testing scenarios
    integer i;
    reg [1:0] expected;
    initial begin
        // Apply reset
        rst = 1;
        in0 = 2'b00;
        in1 = 2'b01;
        in2 = 2'b10;
        in3 = 2'b11;
        @(negedge clk);
        if (out == in0)
            $display("RESET Test PASSED");
        else
            $display("RESET Test FAILED");

        rst = 0;

        // Run multiple cycles to test mux behavior
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            case (DUT.counter_out)
                2'b00: expected = in0;
                2'b01: expected = in1;
                2'b10: expected = in2;
                2'b11: expected = in3;
            endcase
            if (out == expected)
                $display("Test passed");
            else
                $display("Test failed");
        end
        $stop;
    end
endmodule