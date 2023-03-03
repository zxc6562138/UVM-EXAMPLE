`ifndef MY_MONITOR__SV
`define MY_MONITOR__SV
`include "uvm_macros.svh"    
import uvm_pkg::*;


`include "my_transaction.sv"
`define MON_IF vif.MONITOR.monitor_cb
`define DRIV_IF vif.DRIVER.driver_cb
class my_monitor extends uvm_monitor;
   
   
   virtual my_if vif;
	/*ºÝ¤f¡AÉOscoreboard¤Îmodel*/
   uvm_analysis_port #(my_transaction)  ap;
   my_transaction tr;  
   `uvm_component_utils(my_monitor)
   function new(string name = "my_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
         `uvm_fatal("my_monitor", "virtual interface must be set for vif!!!");
      tr = new("tr");  
      ap = new("ap", this);
   endfunction

   extern task main_phase(uvm_phase phase);
  
endclass

task my_monitor::main_phase(uvm_phase phase);
   
   
   super.main_phase(phase);
   
   
   forever begin
      @(posedge vif.MONITOR.clk);
       
      
       
      @(negedge `DRIV_IF.valid);
      //wait(`MON_IF.wr_en || `MON_IF.rd_en);
        
        tr.addr = `MON_IF.addr;
      if(`MON_IF.wr_en) begin
        
        
        tr.wr_en = `MON_IF.wr_en;
        tr.wdata = `MON_IF.wdata;
        tr.rd_en = 0;
        
        @(posedge vif.MONITOR.clk);
      end
      if(`MON_IF.rd_en) begin
        
         
        tr.rd_en = `MON_IF.rd_en;
        tr.wr_en = 0;
        //`uvm_info("my_monitor", "rd_en ", UVM_LOW); 
        @(posedge vif.MONITOR.clk);
        @(posedge vif.MONITOR.clk);
        tr.rdata = `MON_IF.rdata;
      end
      
	  ap.write(tr);
	  
	  
	  //`uvm_info("my_monitor", "test ", UVM_LOW);  
   end
   
   

   //`uvm_info("my_monitor", "end  run phase ", UVM_LOW);
endtask

`endif