class myprefix_base_seq extends uvm_sequence #(myprefix_sequence_item);
    `uvm_object_utils(myprefix_base_seq)

    function new(string name = "myprefix_base_seq");
        super.new(name);
    endfunction

    task body();
        repeat(5) begin
            req = myprefix_sequence_item::type_id::create("req");
            start_item(req);
            if (!req.randomize() with { cmd inside {8'h01, 8'h02, 8'h03, 8'h04}; }) begin
                `uvm_error(get_type_name(), "Randomization failed")
            end
            finish_item(req);
        end
    endtask
endclass
