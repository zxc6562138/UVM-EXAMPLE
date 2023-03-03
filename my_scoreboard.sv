`ifndef MY_SCOREBOARD__SV
`define MY_SCOREBOARD__SV 
`include "uvm_macros.svh"
import uvm_pkg::*;
 
   
`include "my_transaction.sv"
class my_scoreboard extends uvm_scoreboard;
    
    
   /*期望值?列*/
   my_transaction  expect_queue[$];
   /*接收monitor及model?据*/
   uvm_blocking_get_port #(my_transaction)  exp_port;
   uvm_blocking_get_port #(my_transaction)  act_port;
   
   //bit [7:0] sc_mem [4];
   
   `uvm_component_utils(my_scoreboard)

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
endclass 

function my_scoreboard::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction 

function void my_scoreboard::build_phase(uvm_phase phase);
   super.build_phase(phase);
   exp_port = new("exp_port", this);
   act_port = new("act_port", this);
   
   //foreach(sc_mem[i]) sc_mem[i] = 8'hFF; 
   
   
   
endfunction 

task my_scoreboard::main_phase(uvm_phase phase);
   my_transaction  get_expect,  get_actual, tmp_tran;
   bit result;
   
   super.main_phase(phase);
    
   
   fork 
      while(1) begin
      
         /*?model接收*/
         exp_port.get(get_expect);
         
         expect_queue.push_back(get_expect);
         
         
      end   
      while (1) begin       
          /*?monitor接收*/
         act_port.get(get_actual);
              
         wait(expect_queue.size() > 0);
         if(expect_queue.size() > 0) begin
                    
            tmp_tran = expect_queue.pop_front();
             /*比??果*/
            result = get_actual.compare(tmp_tran);
            
            if(result) begin 
               `uvm_info("my_scoreboard", "Compare SUCCESSFULLY", UVM_LOW);
            end
            else begin
               `uvm_error("my_scoreboard", "Compare FAILED");
               $display("the expect pkt is");
               tmp_tran.print();
               $display("the actual pkt is");
               get_actual.print();
            end
         end
         
         else begin
            `uvm_error("my_scoreboard", "Received from DUT, while Expect Queue is empty");
            $display("the unexpected pkt is");
            get_actual.print();
         end
         
      end
   join
   
   
endtask
`endif