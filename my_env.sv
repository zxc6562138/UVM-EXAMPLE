
`ifndef MY_ENV__SV
`define MY_ENV__SV 
`include "uvm_macros.svh" 
import uvm_pkg::*;

  
`include "my_scoreboard.sv"
`include "my_agent.sv"
`include "my_model.sv"
 
class my_env extends uvm_env;
/*裡面通常包含agent，model，scoreboard*/
   my_agent   i_agt;
   my_agent   o_agt;
   my_model   mdl;
   my_scoreboard scb;
   
   /*建立fifo，用於agent-scoreboard通信（monitor將監控結果發給scoreboard）*/
   /*agent-model通信（monitor將監控結果發給model）*/
   /*model-scoreboard通信（比較結果）*/
   uvm_tlm_analysis_fifo #(my_transaction) agt_scb_fifo;
   uvm_tlm_analysis_fifo #(my_transaction) agt_mdl_fifo;
   uvm_tlm_analysis_fifo #(my_transaction) mdl_scb_fifo;
   
   function new(string name = "my_env", uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      i_agt = my_agent::type_id::create("i_agt", this);
      o_agt = my_agent::type_id::create("o_agt", this);
      /*is_active為uvm_agent成員變量*/
      /*0，不實例化；1，實例化*/
      i_agt.is_active = UVM_ACTIVE;
      o_agt.is_active = UVM_PASSIVE;
      mdl = my_model::type_id::create("mdl", this);
      scb = my_scoreboard::type_id::create("scb", this);
      agt_scb_fifo = new("agt_scb_fifo", this);
      agt_mdl_fifo = new("agt_mdl_fifo", this);
      mdl_scb_fifo = new("mdl_scb_fifo", this);
      
   endfunction
   
   

   extern virtual function void connect_phase(uvm_phase phase);
   
   `uvm_component_utils(my_env)
endclass

function void my_env::connect_phase(uvm_phase phase);
   /*連接port在connect phase進行*/
   super.connect_phase(phase);
   i_agt.ap.connect(agt_mdl_fifo.analysis_export);
   mdl.port.connect(agt_mdl_fifo.blocking_get_export);
   mdl.ap.connect(mdl_scb_fifo.analysis_export);
   scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);
   o_agt.ap.connect(agt_scb_fifo.analysis_export);
   scb.act_port.connect(agt_scb_fifo.blocking_get_export);
   
endfunction

   

`endif