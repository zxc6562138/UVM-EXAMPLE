
`ifndef BASE_TEST__SV
`define BASE_TEST__SV
`include "uvm_macros.svh" 
import uvm_pkg::*;

  
 `include "my_env.sv"
class base_test extends uvm_test;
   my_sequencer sqr;
   my_env  env;
   wr_rd_sequence seq;
   function new(string name = "base_test", uvm_component parent = null);
      super.new(name,parent);
      
   endfunction
   
 /*  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
      seq = wr_rd_sequence::type_id::create("seq");
      seq.start(env.i_agt.sqr);
    phase.drop_objection(this); 
    
    //set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase  */
   /*uvm���۫ت��@��phase��ƩΥ��ȡA�|�۰ʦ��ǱҰ�*/
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void report_phase(uvm_phase phase);
   /*�Ncomponent���U��factory��*/
   `uvm_component_utils(base_test)
endclass

/*��ҤƳ��bbuild phase���i��*/
function void base_test::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
       
   /*�ϥ�uvm����ҤƤ覡�A�N����Q��factory����*/
   
   env  =  my_env::type_id::create("env", this);
   
   seq = wr_rd_sequence::type_id::create("seq");
   
   uvm_config_db#(uvm_object_wrapper)::set(this,"env.i_agt.sqr.main_phase","default_sequence",wr_rd_sequence::type_id::get());
endfunction

function void base_test::report_phase(uvm_phase phase);
   uvm_report_server server;
   int err_num;
   super.report_phase(phase);

   server = get_report_server();
   err_num = server.get_severity_count(UVM_ERROR);
   //�d�ݸ����ҥ��x���ݾ뵲�c
   uvm_top.print_topology();

   if (err_num != 0) begin
      $display("TEST CASE FAILED");
   end
   else begin
      $display("TEST CASE PASSED");
   end
endfunction  

`endif