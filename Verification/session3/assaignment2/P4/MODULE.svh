module processor ();
    logic [24] memory [int] ;
    localparam first_address = 400 ;

    initial begin
        memory [0] = 24'hA50400;
        memory [first_address]     = 24'h123456;
        memory [first_address+1]   = 24'h789ABC;
        memory [first_address+220] = 24'h0F1E2D;

        $display("the number of elements in the array is %d" , memory.num);
        foreach (memory[i]) begin
            $display("the elemnt in the array of index %d is %h" , i , memory[i]);
        end
    end
endmodule