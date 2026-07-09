`include "uvm_macros.svh"

package my_uvm_pkg;
  import uvm_pkg::*;
  `include "myprefix_config.sv"
  `include "myprefix_sequence_item.sv"
  `include "seq/myprefix_base_seq.sv"
  `include "myprefix_monitor.sv"
  `include "myprefix_scoreboard.sv"
  `include "myprefix_coverage.sv"
  `include "myprefix_sequencer.sv"
  `include "myprefix_driver.sv"
  `include "myprefix_env.sv"
  `include "tests/myprefix_base_test.sv"
endpackage
