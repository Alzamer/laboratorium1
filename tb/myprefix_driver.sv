class myprefix_driver extends uvm_driver #(myprefix_sequence_item);
    `uvm_component_utils(myprefix_driver)
    virtual dut_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif_name", vif))
            `uvm_fatal(get_full_name(), "Brak interfejsu dut_if w config_db!")
    endfunction

    task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        vif.valid <= 1'b0;
        vif.cmd <= 8'h00;
        vif.addr_in <= 16'h0000;
        vif.data_in <= 8'h00;
        @(negedge vif.rstn);
        @(posedge vif.rstn);
        phase.drop_objection(this);
    endtask

    task main_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            
            wait(vif.ready == 1'b1);
            @(posedge vif.clk);
            
            vif.valid <= 1'b1;
            vif.cmd <= req.cmd;
            vif.addr_in <= req.addr_in;
            vif.data_in <= req.data_in;
            
            @(posedge vif.clk);
            vif.valid <= 1'b0;
            
            wait(vif.ready == 1'b1);
            req.data_out = vif.data_out;
            
            seq_item_port.item_done();
        end
    endtask
endclass
