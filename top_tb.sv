`timescale 1ns / 1ps

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "dut.sv"

`include "my_if.sv"
`include "my_transaction.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "my_model.sv"
`include "my_scoreboard.sv"
`include "my_env.sv"
`include "base_test.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/29 14:21:01
// Design Name: 
// Module Name: top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb;

reg clk;
reg reset;


my_if intf(clk, reset);/////////////////////////////




dut my_dut(
            .clk(intf.clk),
           .reset(intf.reset),
           .addr(intf.addr),
           .wr_en(intf.wr_en),
           .rd_en(intf.rd_en),
           .wdata(intf.wdata),
           .rdata(intf.rdata)
           );
           


initial begin
   clk = 0;
  
   forever begin
      #100 clk = ~clk;
   end
end


initial begin
   reset = 1;
   #1000;
   reset = 0;
end





    
/*將driver，monitor的接口與測試平台接口相連*/
/*第一個參數為父類，第二個參數為第一個參數的相對路徑*/
/*對於在top中自動構建的實例，名字默認為uvm_test_top*/
initial begin
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", intf);
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", intf);
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.o_agt.mon", "vif", intf);
   
   
  
end

initial begin
   /*該命令會自動構建測試實例，uvm_test_top*/
   run_test("base_test");
   
end

endmodule
