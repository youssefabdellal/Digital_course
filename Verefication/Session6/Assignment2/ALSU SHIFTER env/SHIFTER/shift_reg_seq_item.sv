package shift_reg_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class shift_reg_item extends uvm_sequence_item;
        `uvm_object_utils(shift_reg_item)
        rand bit reset ;
        rand logic serial_in, direction, mode;
        rand logic [5:0] datain ; 
        logic [5:0] dataout;

        function new(string name = "shift_reg_item");
            super.new(name);
        endfunction

        function string convert2string(); 
            return $sformatf("%s reset = %b , serial_in = %b , direction = %b , mode = %b , data_in = %b " , super.convert2string() ,
                               reset , serial_in ,direction ,mode , datain);
        endfunction

        function string convert2string_stimuls(); 
            return $sformatf("reset = %b , serial_in = %b , direction = %b , mode = %b , datain = %b , dataout = %b " , 
                               reset , serial_in ,direction ,mode , datain , dataout);
        endfunction
    endclass
endpackage