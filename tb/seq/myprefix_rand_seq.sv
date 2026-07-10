typedef enum {SINGLE=1, SHORT=5, MEDIUM=15, LONG=30, MAX=50} data_len_e;

class myprefix_rand_seq extends myprefix_base_seq;
    `uvm_object_utils(myprefix_rand_seq)

    rand data_len_e seq_len;

    constraint len_dist_c {
        seq_len dist {
            SINGLE := 5,
            SHORT  := 50,
            MEDIUM := 30,
            LONG   := 10,
            MAX    := 5
        };
    }

    function new(string name = "myprefix_rand_seq");
        super.new(name);
    endfunction

    virtual task body();
        myprefix_sequence_item req;
        int iters = seq_len;
        
        `uvm_info("RAND_SEQ", $sformatf("Wylosowano dlugosc sekwencji: %0s (%0d iteracji)", seq_len.name(), iters), UVM_LOW)
        
        if (iters < 2) iters = 2; 
        
        for (int i = 0; i < iters; i++) begin
            req = myprefix_sequence_item::type_id::create("req");
            start_item(req);
            
            if (!req.randomize()) `uvm_error("RAND_SEQ", "Blad randomizacji!")
            if (i == 0) begin
                req.cmd = 8'h04;
            end 
            else if (i == 1) begin
                req.cmd = 8'h03;
            end 
            else begin
                if (!req.randomize() with {
                    cmd dist { 
                        8'h04 := 45,
                        8'h03 := 45,
                        8'h01 := 5,
                        8'h02 := 5
                    };
                }) `uvm_error("RAND_SEQ", "Blad randomizacji CMD!")
            end
            
            finish_item(req);
        end
    endtask
endclass
