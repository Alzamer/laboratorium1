class myprefix_sequencer extends uvm_sequencer #(myprefix_sequence_item);
    `uvm_component_utils(myprefix_sequencer)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass
