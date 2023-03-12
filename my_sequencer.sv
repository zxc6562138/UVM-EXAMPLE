`ifndef MY_SEQUENCER__SV
`define MY_SEQUENCER__SV 
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "my_transaction.sv"


    
      
class my_sequencer extends uvm_sequencer #(my_transaction);
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction
   
  
   
   `uvm_component_utils(my_sequencer)
endclass

`endif

`ifndef MY_SEQUENCE__SV
`define MY_SEQUENCE__SV 

class my_sequence extends uvm_sequence #(my_transaction);
   my_transaction req;
   
   function new(string name= "my_sequence");
      super.new(name);
      
   endfunction
	/*sequence啟動後會自動運行該任務，生成transaction*/
   virtual task body();
   
        repeat (10) begin          
           `uvm_do(req)           
        end
        #1000;
     
   endtask
 
   `uvm_object_utils(my_sequence)
endclass


// write_sequence - "write" type

class write_sequence extends uvm_sequence#(my_transaction);
  my_transaction req;
  my_transaction rand_obj;
  int i = 0;
 
  `uvm_object_utils(write_sequence)
   
  
  function new(string name = "write_sequence");
    super.new(name);
    //set_automatic_phase_objection(1);
  endfunction
  
  virtual task body();
   
   
   if (i == 0) begin
     `uvm_create(rand_obj);
     i += 1;
     
   end
    
   
    //repeat(4) begin
      `do_randc(rand_obj, req, 1);
       
    //end
    //`uvm_do_with(req,{req.wr_en==1;})
   
    
  endtask
endclass


// read_sequence - "read" type

class read_sequence extends uvm_sequence#(my_transaction);
  my_transaction req;
  my_transaction rand_obj;
  int i = 0;
  `uvm_object_utils(read_sequence)
     
  function new(string name = "read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    if (i == 0) begin
     `uvm_create(rand_obj);
     i += 1;
   
   end
    
   
   
      `do_randc(rand_obj, req, 0);
     
    //`uvm_do_with(req,{req.rd_en==1;})
  endtask
endclass

class wr_rd_sequence extends uvm_sequence#(my_transaction);
  
  my_sequencer   sqr;
  write_sequence wr_seq;
  read_sequence  rd_seq;
  my_transaction req;
  `uvm_object_utils(wr_rd_sequence)
   
 
  function new(string name = "wr_rd_sequence");
    super.new(name);
    set_automatic_phase_objection(1);
  endfunction
  
  
  virtual task body();
    
    
    wr_seq = write_sequence::type_id::create("wr_seq");
    rd_seq = read_sequence::type_id::create("rd_seq");
    repeat (4) begin
          
            
          wr_seq.start(sqr,this);
          //`uvm_do(wr_seq)        
        end
    
        #1000;
       
    
    repeat (4) begin
                            
          rd_seq.start(sqr,this);     
        end
        
  
    
  endtask
endclass

`endif