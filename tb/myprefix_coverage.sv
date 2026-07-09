class myprefix_coverage extends uvm_subscriber #(myprefix_sequence_item);
    `uvm_component_utils(myprefix_coverage)

    myprefix_sequence_item m_item;

`ifdef COV_ENABLE
    covergroup i2c_cg;
        cp_cmd: coverpoint m_item.cmd {
            bins read_id = {8'h01};
            bins read_st = {8'h02};
            bins read_d  = {8'h03};
            bins write_d = {8'h04};
        }
        cp_addr: coverpoint m_item.addr_in {
            bins low_addr  = {[16'h0000 : 16'h00FF]};
            bins high_addr = {[16'h0100 : 16'hFFFF]};
        }
        cross_cmd_addr: cross cp_cmd, cp_addr;
    endgroup
`endif

    function new(string name, uvm_component parent);
        super.new(name, parent);
`ifdef COV_ENABLE
        i2c_cg = new();
`endif
    endfunction

    virtual function void write(myprefix_sequence_item t);
        m_item = t;
        
`ifdef COV_ENABLE
        i2c_cg.sample();
`endif
        `uvm_info(get_name(), $sformatf("Coverage: Otrzymano CMD: %0h", t.cmd), UVM_LOW)
    endfunction
endclass
