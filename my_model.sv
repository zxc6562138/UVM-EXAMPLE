
`ifndef MY_MODEL__SV
`define MY_MODEL__SV
`include "uvm_macros.svh" 
import uvm_pkg::*;

   
`include "my_transaction.sv"


class my_model extends uvm_component;

     
   /*接收端口与?送端口，分?与monitor及scoreboard通信*/
   uvm_blocking_get_port #(my_transaction)  port;
   uvm_analysis_port #(my_transaction)  ap;
   bit [7:0] sc_mem [4];
   
   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual  task main_phase(uvm_phase phase);
   extern virtual task one_pkt(my_transaction mem_pkt);
   `uvm_component_utils(my_model)
endclass 

function my_model::new(string name, uvm_component parent);
   super.new(name, parent);
endfunction 

function void my_model::build_phase(uvm_phase phase);
   super.build_phase(phase);
   port = new("port", this);
   ap = new("ap", this);
   foreach(sc_mem[i]) sc_mem[i] = 8'hFF; 
   
endfunction

task my_model::main_phase(uvm_phase phase);
   my_transaction tr;
   my_transaction new_tr;
   super.main_phase(phase);
   while(1) begin
      
      /*接收*/
      port.get(tr);
      
      new_tr = new("new_tr");
      
      `uvm_info("my_model", "get one transaction", UVM_LOW)
      
      
      new_tr.copy(tr);
      one_pkt(new_tr);
      
      
      /*發送*/
      ap.write(new_tr);
      
   end
endtask

task my_model::one_pkt( my_transaction mem_pkt);
  
  if(mem_pkt.wr_en) begin
        //sc_mem[mem_pkt.addr] = mem_pkt.wdata;
        
        `uvm_info(get_type_name(),$sformatf("------ :: WRITE DATA       :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Addr: %0h",mem_pkt.addr),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Data: %0h",mem_pkt.wdata),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)        
      end
      else if(mem_pkt.rd_en) begin
        //mem_pkt.rdata = sc_mem[mem_pkt.addr] ;
       
          `uvm_info(get_type_name(),$sformatf("------ :: READ DATA Match :: ------"),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Addr: %0h",mem_pkt.addr),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("  Data: %0h",mem_pkt.rdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
       
        
      end
endtask
`endif