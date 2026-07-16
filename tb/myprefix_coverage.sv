class myprefix_coverage extends uvm_subscriber #(myprefix_sequence_item);
   `uvm_component_utils(myprefix_coverage)

   myprefix_sequence_item m_item;

   covergroup i2c_cg;
       cp_cmd: coverpoint m_item.cmd {
           bins read_id = {UVM_CMD_READ_ID};
           bins read_st = {UVM_CMD_READ_STATUS};
           bins read_d  = {UVM_CMD_READ_DATA};
           bins write_d = {UVM_CMD_WRITE_DATA};
       }
       cp_addr: coverpoint m_item.addr_in {
           bins low_addr  = {[16'h0000 : 16'h00FF]};
           bins high_addr = {[16'h0100 : 16'hFFFF]};
       }
       cross_cmd_addr: cross cp_cmd, cp_addr;
   endgroup

   function new(string name, uvm_component parent);
       super.new(name, parent);
       i2c_cg = new();
   endfunction

   virtual function void write(myprefix_sequence_item t);
       m_item = t;
       i2c_cg.sample();
       
       `uvm_info(get_name(), $sformatf("Coverage: Otrzymano CMD: %0h", t.cmd), UVM_LOW)
   endfunction
endclass
