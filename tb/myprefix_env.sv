class myprefix_env extends uvm_env;
    `uvm_component_utils(myprefix_env)
    
    myprefix_driver    m_drv;
    myprefix_sequencer m_seqr;
    myprefix_monitor m_mon;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_drv  = myprefix_driver::type_id::create("m_drv", this);
        m_seqr = myprefix_sequencer::type_id::create("m_seqr", this);
        m_mon = myprefix_monitor::type_id::create("m_mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_drv.seq_item_port.connect(m_seqr.seq_item_export);
    endfunction
endclass
