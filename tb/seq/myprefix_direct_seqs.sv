class myprefix_long_rw_seq extends myprefix_base_seq;
   `uvm_object_utils(myprefix_long_rw_seq)

   function new(string name = "myprefix_long_rw_seq");
       super.new(name);
   endfunction

   virtual task body();
       myprefix_sequence_item req;
       bit [15:0] start_addr = 16'h0010;
        
       `uvm_info("DIR_SEQ", "Rozpoczynamy test: Long Read/Write", UVM_LOW)
        
       for(int i=0; i<10; i++) begin
           req = myprefix_sequence_item::type_id::create("req");
           start_item(req);
           req.cmd = UVM_CMD_WRITE_DATA;
           req.addr_in = start_addr + i;
           req.data_in = 8'hA0 + i;
           finish_item(req);
       end
        
       for(int i=0; i<10; i++) begin
           req = myprefix_sequence_item::type_id::create("req");
           start_item(req);
           req.cmd = UVM_CMD_READ_DATA;
           req.addr_in = start_addr + i;
           finish_item(req);
       end
   endtask
endclass

class myprefix_err_inject_seq extends myprefix_base_seq;
   `uvm_object_utils(myprefix_err_inject_seq)

   function new(string name = "myprefix_err_inject_seq");
       super.new(name);
   endfunction

   virtual task body();
       myprefix_sequence_item req;
        
       `uvm_info("DIR_SEQ", "Rozpoczynamy test: Error Injection (Nieznana komenda)", UVM_LOW)
        
       req = myprefix_sequence_item::type_id::create("req");
       start_item(req);
       req.cmd = cmd_e'(8'hFF);
       req.addr_in = 16'h0000;
       req.data_in = 8'h00;
       finish_item(req);
   endtask
endclass
