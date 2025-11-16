package reg_buggy_pkg;
    typedef enum logic [3:0] { adc0_reg ,adc1_reg ,temp_sensor0_reg ,temp_sensor1_reg , 
                        analog_test ,digital_test ,amp_gain ,digital_config } address_t;
    class reg_buggy_class;
        rand logic reset ;
        rand logic [7:0] [15:0] data_in ;
        rand address_t address_pkg ;
        rand address_t [8] address_arr;

        constraint reset_t {
            reset dist {0:/99 , 1:/1} ;
        }

        constraint address_datain  {
            foreach (address_arr[i])
                address_arr[i] inside {adc0_reg ,adc1_reg ,temp_sensor0_reg ,temp_sensor1_reg , 
                        analog_test ,digital_test ,amp_gain ,digital_config};

            foreach (address_arr[i])
                foreach (address_arr[j])
                  if (i != j) address_arr[i] != address_arr[j];

            foreach (data_in[j]) 
                data_in [j] dist {[16'h0 : 16'hffff] } ; 
        }
    endclass
endpackage