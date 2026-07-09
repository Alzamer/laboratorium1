class myprefix_base_test extends uvm_test;
    `uvm_component_utils(myprefix_base_test)
    
    myprefix_env m_env;
    myprefix_config m_cfg; 

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_env = myprefix_env::type_id::create("m_env", this);
        m_cfg = myprefix_config::type_id::create("m_cfg");
        m_cfg.scoreboard_enable = 1; 
        
`ifdef COV_ENABLE
        m_cfg.coverage_enable = 1;
`endif
        uvm_config_db#(myprefix_config)::set(this, "m_env", "env_cfg", m_cfg);
        uvm_top.set_timeout(10ms, 1); 
    endfunction

    task main_phase(uvm_phase phase);
        myprefix_base_seq seq = myprefix_base_seq::type_id::create("seq");
        phase.phase_done.set_drain_time(this, 2000ns);
        phase.raise_objection(this);
        seq.start(m_env.m_seqr);
        phase.drop_objection(this);
    endtask

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology(); 
        m_cfg.print(); 
    endfunction
endclass
