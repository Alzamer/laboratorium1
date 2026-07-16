class myprefix_monitor extends uvm_monitor;
    `uvm_component_utils(myprefix_monitor)
    
    virtual dut_if vif;
    uvm_analysis_port #(myprefix_sequence_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif_name", vif))
            `uvm_fatal(get_full_name(), "Monitor: Brak wirtualnego interfejsu w config_db!")
    endfunction

    task main_phase(uvm_phase phase);
        myprefix_sequence_item tr;
        forever begin
            wait(vif.valid == 1'b1 && vif.ready == 1'b1);
            tr = myprefix_sequence_item::type_id::create("tr");
            tr.cmd = cmd_e'(vif.cmd);
            tr.addr_in = vif.addr_in;
            tr.data_in = vif.data_in;
            @(negedge vif.valid);
            wait(vif.ready == 1'b1);
            tr.data_out = vif.data_out;
            ap.write(tr);
        end
    endtask
endclass
