

`ifndef MY_TRANSACTION__SV
`define MY_TRANSACTION__SV
`include "uvm_macros.svh" 
import uvm_pkg::*;

`define do_randc(rand_obj,req,string) \
    begin \
      `uvm_create(``req``); \
      start_item(``req``); \
      if (!``rand_obj``.randomize() with {``rand_obj``.wr_en == string;} ) \
        `uvm_fatal("RAND_ERR",{"\n",``rand_obj``.sprint()}); \
        ``req``.copy(``rand_obj``); \
      finish_item(``req``); \
    end    
    

class my_transaction extends uvm_sequence_item;

  randc bit [1:0] addr;
  rand bit       wr_en;
  rand bit       rd_en;
  rand bit [7:0] wdata;
       bit [7:0] rdata;
   
  
constraint wr_rd_c { wr_en != rd_en;}; 


   `uvm_object_utils_begin(my_transaction)
    `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_field_int(wr_en,UVM_ALL_ON)
    `uvm_field_int(rd_en,UVM_ALL_ON)
    `uvm_field_int(wdata,UVM_ALL_ON)
    `uvm_field_int(rdata,UVM_ALL_ON)
  `uvm_object_utils_end
  

   function new(string name = "my_transaction");
      super.new();
   endfunction   
    
   
   
   
endclass





`endif

