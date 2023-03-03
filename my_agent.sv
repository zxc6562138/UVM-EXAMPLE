
`ifndef MY_AGENT__SV
`define MY_AGENT__SV
`include "uvm_macros.svh" 
import uvm_pkg::*;


`include "my_transaction.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"   
class my_agent extends uvm_agent ;
   my_sequencer  sqr;
   my_driver     drv;
   my_monitor    mon;
   /*agent的端口，monitor与driver和外部通信的中?站*/
   uvm_analysis_port #(my_transaction)  ap;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 
   
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);

   `uvm_component_utils(my_agent)
endclass 


function void my_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   /*?入端口?例化sequence和driver*/
   if (get_is_active() == UVM_ACTIVE) begin
      sqr = my_sequencer::type_id::create("sqr", this);
      drv = my_driver::type_id::create("drv", this);
      
   end
   mon = my_monitor::type_id::create("mon", this);
   
endfunction 

function void my_agent::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   /*?driver端口与ap端口相?*/
   if (get_is_active() == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
      
   end
   
   /*?monitor端口与ap端口相?*/
     
     ap = mon.ap;
   
    
endfunction

`endif