module tb();
    reg MOSI ;
    reg SS_n ;
    reg clk ;
    reg rst_n;
    wire MISO ;

    interface DUT (MOSI,MISO,SS_n,clk,rst_n);

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        $readmemh ("mem.dat" , DUT.master.mem);
        // enable reset
        rst_n = 0 ;
        SS_n = 0  ;
        @(negedge clk) ; 
        // disable reset   
        rst_n = 1 ;
        // enter loop to acesses the memory 
        repeat (10000) begin
        SS_n = 0  ;  // activate interferance 
        // give a 0 bit to go to write state  
        // give two 0 bits to recieve address to go to 
        repeat (3) begin
           MOSI = 0 ;     
           @(negedge clk) ;  
        end
        // randomize 8 bits ADDRESS
        repeat (8) begin
           MOSI = $random ; 
           @(negedge clk) ;  
        end
        @(negedge clk) ;    
        MOSI = 0 ;    // 0 bit to go to write state 
        @(negedge clk) ; 
        // get 0 bit & 1 bit to recieve data     
        MOSI = 0 ;    
        @(negedge clk) ;    
        MOSI = 1 ;
        @(negedge clk) ; 
        // randomize 8 bits DATA   
        repeat (8) begin
           MOSI = $random ;  
           @(negedge clk) ;  
        end
        @(negedge clk) ; 
        // disactivate interference 
        SS_n = 1 ;
        @(negedge clk) ;
        end  
        // ========================================================================================= //
        // eenter loop to read data from different places in memorey 
        repeat (10000) begin
        SS_n = 0  ;   // activate interferance
        // 1-1-0 to go to READ_ADD state  
        MOSI = 1 ;    
        @(negedge clk) ;
        MOSI = 1 ;
        @(negedge clk) ;
        MOSI = 0 ;
        @(negedge clk) ;
        // randomize 8 bits ADDRESS 
        repeat (8) begin
           MOSI = $random ; 
           @(negedge clk) ;  
        end
        @(negedge clk) ;
        // disactivate interference
        SS_n = 1 ;
        @(negedge clk) ;
        // activate interferance
        SS_n = 0 ;  
        // 1-1-1 to go to READ_DATA state  
        MOSI = 1 ;
        @(negedge clk) ;     
        MOSI = 1 ;
        @(negedge clk) ;    
        MOSI = 1 ;
        @(negedge clk) ; 
        // randomize 8 bits DATA   
        repeat (8) begin
           MOSI = $random ;  
           @(negedge clk) ; 
        end
        @(negedge clk) ; 
        // disactivate interference
        SS_n = 1 ;
        @(negedge clk) ;
        end
        $stop;
        end
endmodule
