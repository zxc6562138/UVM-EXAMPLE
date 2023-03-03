
`ifndef MY_ENV__SV
`define MY_ENV__SV 
`include "uvm_macros.svh" 
import uvm_pkg::*;

  
`include "my_scoreboard.sv"
`include "my_agent.sv"
`include "my_model.sv"
 
class my_env extends uvm_env;
/*�����q�`�]�tagent�Amodel�Ascoreboard*/
   my_agent   i_agt;
   my_agent   o_agt;
   my_model   mdl;
   my_scoreboard scb;
   
   /*�إ�fifo�A�Τ_agent-scoreboard�q�H�]monitor??��?�G??scoreboard�^*/
   /*agent-model�q�H�]monitor??��?�G??model�^*/
   /*model-scoreboard�q�H�]��??�G�^*/
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
      /*is_active?uvm_agent��??�q*/
      /*0�A��?�ҤơF1�A?�Ҥ�*/
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
   /*?��port�bconnect phase?��*/
   super.connect_phase(phase);
   i_agt.ap.connect(agt_mdl_fifo.analysis_export);
   mdl.port.connect(agt_mdl_fifo.blocking_get_export);
   mdl.ap.connect(mdl_scb_fifo.analysis_export);
   scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);
   o_agt.ap.connect(agt_scb_fifo.analysis_export);
   scb.act_port.connect(agt_scb_fifo.blocking_get_export);
   
endfunction

   

`endif