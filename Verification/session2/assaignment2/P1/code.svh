module two_state_array ();
    bit [11:0] my_array [4] ;
    initial begin
        my_array[0] = 12'h012 ;
        my_array[1] = 12'h345 ;
        my_array[2] = 12'h678 ;
        my_array[3] = 12'h9AB ;
        
        for (int i_for = 0 ; i_for < 4 ; i_for++ ) begin
            for (int j_for ; j_for < 12 ; j_for++) begin
                if (j_for == 5 ) $display("bit 5  of array using for loop  %d is %b " , i_for , my_array[i_for][5] );
                if (j_for == 4 ) $display("bit 4  of array using for loop  %d is %b " , i_for , my_array[i_for][4] );
            end
        end

        foreach (my_array[i_foreach]) begin
            foreach (my_array[i_foreach][j_foreach]) begin
                if (j_foreach == 5) $display("bit 5  of array using foreach loop %d is %b " , i_foreach , my_array[i_foreach][5] );
                if (j_foreach == 4) $display("bit 4  of array using foreach loop %d is %b " , i_foreach , my_array[i_foreach][4] );
            end
        end

    end
endmodule