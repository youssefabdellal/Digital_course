module test_dynamic_array ();
    int dyn_arr1 [] ,dyn_arr2 [] ;
    initial begin
        dyn_arr2 = '{9,1,8,3,4,4} ;
        dyn_arr1 = new[6] ;
        foreach (dyn_arr1[i]) begin
            dyn_arr1 [i] = i ;
        end
        $display ("elements of array 1 --> %p and it's size is %d" ,dyn_arr1 , dyn_arr1.size());
        dyn_arr1.delete() ;
        dyn_arr2.reverse ;
        $display ("the reversed array --> %p" , dyn_arr2);
        dyn_arr2.sort ;
        $display ("the sorted array --> %p" , dyn_arr2);
        dyn_arr2.rsort ;
        $display ("the reversed sorted array --> %p" , dyn_arr2);
        dyn_arr2.shuffle ;
        $display ("the shuffled array --> %p" , dyn_arr2);
    end
endmodule