typedef enum bit [7:0] {
    UVM_CMD_READ_ID     = 8'h01,
    UVM_CMD_READ_STATUS = 8'h02,
    UVM_CMD_READ_DATA   = 8'h03,
    UVM_CMD_WRITE_DATA  = 8'h04
} cmd_e;

class myprefix_sequence_item extends uvm_sequence_item;
   rand cmd_e cmd;
   rand bit [15:0] addr_in;
   rand bit [7:0] data_in;
   bit [7:0] data_out;

   `uvm_object_utils_begin(myprefix_sequence_item)
       `uvm_field_enum(cmd_e, cmd, UVM_ALL_ON)
       `uvm_field_int(addr_in, UVM_ALL_ON)
       `uvm_field_int(data_in, UVM_ALL_ON)
       `uvm_field_int(data_out, UVM_ALL_ON)
   `uvm_object_utils_end

   function new(string name = "myprefix_sequence_item");
       super.new(name);
   endfunction
endclass
