`ifndef MY_IF__SV
`define MY_IF__SV 
interface my_if(input clk, input reset);
    
  logic [1:0] addr;
  logic wr_en;
  logic rd_en;
  logic [7:0] wdata;
  logic [7:0] rdata;
  logic valid; ////
  
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output addr;
    output wr_en;
    output rd_en;
    output wdata;
    output valid;  ////
    input  rdata;  
  endclocking
  
  //---------------------------------------
  //monitor clocking block
  //---------------------------------------
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input addr;
    input wr_en;
    input rd_en;
    input wdata;
    input rdata;  
  endclocking
  
  //driver modport
  modport DRIVER  (clocking driver_cb,input clk,reset);
  
  //monitor modport  
  modport MONITOR (clocking monitor_cb,input clk,reset);  
endinterface

`endif