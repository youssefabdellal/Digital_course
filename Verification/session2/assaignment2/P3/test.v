module seq_det(clk, rst, x, Y , count);
    parameter IDLE = 2'b00;
    parameter ZERO = 2'b01;
    parameter ONE = 2'b11;
    parameter STORE = 2'b10;
    input clk, rst, x;
    output reg  [9:0] count;
    output Y ;

    reg [1:0] cs, ns; // cs: current state, ns: next state

    //State Memory
    always @(posedge clk or posedge rst) begin
        if(rst)
            cs <= IDLE;
        else
            cs <= ns;
    end

    //Output Logic depends on the cs only
    assign Y = (cs == STORE) ? 1 :0 ;

    always @(posedge clk or posedge rst) begin
        if (rst) count = 0 ;
        else begin
            if (cs == STORE) count = count + 1 ; 
        end 
    end
    

    //Next State Logic
    always @(cs, x) begin
        case (cs)
            IDLE: if (x)
                   ns = IDLE;
               else
                   ns = ZERO;
            ZERO: if (x)
                   ns = ONE;
               else
                   ns = ZERO;
            ONE: if (x)
                   ns = IDLE;
               else
                   ns = STORE;
            STORE: if (x)
                   ns = IDLE;
               else
                   ns = ZERO;
            default: ns = IDLE;
        endcase
    end
endmodule
