class myprefix_env extends uvm_env;
    `uvm_component_utils(myprefix_env)
    
    myprefix_driver     m_drv;
    myprefix_sequencer  m_seqr;
    myprefix_monitor    m_mon;
    myprefix_scoreboard m_scb;
    myprefix_coverage   m_cov;
    myprefix_config     m_cfg;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if (!uvm_config_db#(myprefix_config)::get(this, "", "env_cfg", m_cfg))
            `uvm_fatal(get_full_name(), "Brak konfiguracji w env!")

        m_drv  = myprefix_driver::type_id::create("m_drv", this);
        m_seqr = myprefix_sequencer::type_id::create("m_seqr", this);
        m_mon  = myprefix_monitor::type_id::create("m_mon", this);
        
        if (m_cfg.scoreboard_enable) begin
            m_scb = myprefix_scoreboard::type_id::create("m_scb", this);
        end

	if (m_cfg.coverage_enable) begin
            m_cov = myprefix_coverage::type_id::create("m_cov", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_drv.seq_item_port.connect(m_seqr.seq_item_export);
        
        if (m_cfg.scoreboard_enable) begin
            m_mon.ap.connect(m_scb.ap_imp);
        end

	if (m_cfg.coverage_enable) begin
            m_mon.ap.connect(m_cov.analysis_export);
        end
    endfunction
endclass
