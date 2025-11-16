module queue_operations () ;
    int j  ;
    int q [$] ;
    initial begin
        j = 1 ; 
        q = {0,2,5} ;
        q.insert (1 , j) ;
        $display("Queue elements afer inserting j = %p", q);
        q.delete (1) ;
        $display("Queue elements afer deleting= %p", q);
        q.push_front(7) ;
        $display("Queue elements afer pushing front 7= %p", q);
        q.push_back(9) ;
        $display("Queue elements afer pushing back 9 = %p", q);
        j = q.pop_back() ;
        $display ("the j variable has the value %d" , j) ;
        $display("Queue contents after pop back = %p", q);
        j = q.pop_front() ;
        $display ("the j variable has the value %d" , j) ;
        $display("Queue contents after pop front = %p", q);
        q.reverse() ;
        $display("reversed Queue contents = %p", q);
        q.sort() ;
        $display("sorted Queue contents = %p", q);
        q.rsort() ;
        $display("reversed sorted Queue contents = %p", q);
        q.shuffle() ;
        $display("shuffled Queue contents = %p", q);
    end
endmodule