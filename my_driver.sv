`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV
`include "uvm_macros.svh" 
import uvm_pkg::*;


 
`include "my_transaction.sv"

`define DRIV_IF vif.DRIVER.driver_cb
 
  
class my_driver extends uvm_driver#(my_transaction);

	/*定義虛接口*/
   virtual my_if vif; //to DUT
   
   `uvm_component_utils(my_driver)
   function new(string name = "my_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
         `uvm_fatal("my_driver", "virtual interface must be set for vif!!!")
         
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task drive_one_pkt( my_transaction req);
endclass

task my_driver::main_phase(uvm_phase phase);
   my_transaction req;
   super.main_phase(phase);
  

  
     
   while(1) begin
      //@(posedge vif.DRIVER.clk);
      //@(posedge vif.DRIVER.clk);
       /*獲取sequence*/
      seq_item_port.get_next_item(req);
       /*驅動到DUT*/
      drive_one_pkt(req);
      
       /*驅動結束*/
      seq_item_port.item_done();
   end
endtask

task my_driver::drive_one_pkt( my_transaction req);
       `DRIV_IF.wr_en <= 0;
       `DRIV_IF.rd_en <= 0;
       repeat(3) @(posedge vif.DRIVER.clk);
   `uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
       
       @(posedge vif.DRIVER.clk);
       `DRIV_IF.valid <= 1'b1;
       `DRIV_IF.addr <= req.addr;

       if(req.wr_en) begin // write operation
            `DRIV_IF.wr_en <= req.wr_en;
            `DRIV_IF.wdata <= req.wdata;
            @(posedge vif.DRIVER.clk);
              
       end
       else if(req.rd_en) begin //read operation
            `DRIV_IF.rd_en <= req.rd_en;
            
            
            @(posedge vif.DRIVER.clk);
            req.rdata = `DRIV_IF.rdata;
            
       end
        
       `DRIV_IF.valid <= 1'b0; 
   `uvm_info("my_driver", "end drive one pkt", UVM_LOW);
  
  
endtask
`endif