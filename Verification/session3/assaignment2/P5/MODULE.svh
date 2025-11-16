module Q5 ();
    typedef logic [6:0] section ;
    typedef struct  {
        section header ;
        section cmd ;
        section data;
        section crc ;
    } packet;

    initial begin
        packet my_packet ;
        my_packet.header = 7'h5A;
        $display("my packet header is %h" , my_packet.header);
        my_packet.cmd  = 7'h3C ;
        $display("my packet cmd is %h" , my_packet.cmd);
        my_packet.data = 7'h6E ;
        $display("my packet data is %h" , my_packet.data);
        my_packet.crc  = 7'h15 ;
        $display("my packet crc is %h" , my_packet.crc);
        $display("my packet is %p" , my_packet);
    end
endmodule