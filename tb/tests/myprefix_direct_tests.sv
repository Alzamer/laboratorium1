class myprefix_long_rw_test extends myprefix_base_test;
    `uvm_component_utils(myprefix_long_rw_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task main_phase(uvm_phase phase);
        myprefix_long_rw_seq seq = myprefix_long_rw_seq::type_id::create("seq");
        phase.phase_done.set_drain_time(this, 2000ns);
        phase.raise_objection(this);
        seq.start(m_env.m_seqr);
        phase.drop_objection(this);
    endtask
endclass

class myprefix_err_inject_test extends myprefix_base_test;
    `uvm_component_utils(myprefix_err_inject_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task main_phase(uvm_phase phase);
        myprefix_err_inject_seq seq = myprefix_err_inject_seq::type_id::create("seq");
        phase.phase_done.set_drain_time(this, 2000ns);
        phase.raise_objection(this);
        seq.start(m_env.m_seqr);
        phase.drop_objection(this);
    endtask
endclass
