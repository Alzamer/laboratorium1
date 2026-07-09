class myprefix_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(myprefix_scoreboard)
    
    uvm_analysis_imp #(myprefix_sequence_item, myprefix_scoreboard) ap_imp;
    
    bit [7:0] memory_model [int];
    bit [7:0] stored_status = 8'h00;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap_imp = new("ap_imp", this);
    endfunction

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
    endfunction

    virtual function void write(myprefix_sequence_item tr);
        `uvm_info(get_name(), $sformatf("Scoreboard przechwycił CMD: %0h", tr.cmd), UVM_LOW)
        
        case (tr.cmd)
            8'h01: check_read_id(tr);
            8'h02: store_read_status(tr);
            8'h03: check_read_data(tr);
            8'h04: store_write_data(tr);
            default: `uvm_warning(get_name(), $sformatf("Nieznana komenda: %0h", tr.cmd))
        endcase
    endfunction

    function void check_read_id(myprefix_sequence_item tr);
        bit [7:0] expected_id = 8'hA5; 
        if (tr.data_out !== expected_id) begin
            `uvm_error("SCB_ID_MISMATCH", $sformatf("Błąd ID! Oczekiwano: %0h, Otrzymano: %0h", expected_id, tr.data_out))
        end else begin
            `uvm_info("SCB_ID_OK", "Odczyt ID prawidłowy (0xA5)", UVM_LOW)
        end
    endfunction

    function void store_read_status(myprefix_sequence_item tr);
        stored_status = tr.data_out;
        `uvm_info("SCB_STATUS_STORED", $sformatf("Zapisano status układu: %0h", stored_status), UVM_LOW)
    endfunction

    function void store_write_data(myprefix_sequence_item tr);
        memory_model[tr.addr_in] = tr.data_in;
        `uvm_info("SCB_WRITE", $sformatf("Model zapisał dane %0h pod adres %0h", tr.data_in, tr.addr_in), UVM_LOW)
    endfunction

    function void check_read_data(myprefix_sequence_item tr);
        bit [7:0] expected_data;
        
        if (memory_model.exists(tr.addr_in)) begin
            expected_data = memory_model[tr.addr_in];
        end else begin
            expected_data = 8'hFF;
        end

        if (tr.data_out !== expected_data) begin
            `uvm_error("SCB_DATA_MISMATCH", $sformatf("Błąd odczytu danych pod adresem %0h! Oczekiwano: %0h, Otrzymano: %0h", tr.addr_in, expected_data, tr.data_out))
        end else begin
            `uvm_info("SCB_DATA_OK", $sformatf("Odczyt poprawny pod adresem %0h (Dane: %0h)", tr.addr_in, tr.data_out), UVM_LOW)
        end
    endfunction
endclass
