`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/29 16:06:47
// Design Name: 
// Module Name: dut
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


module dut
#( parameter ADDR_WIDTH = 2,
   parameter DATA_WIDTH = 8 )
(


input           clk,
input           reset,

input [ADDR_WIDTH-1:0]  addr,
input                   wr_en,
input                   rd_en,
//input                   valid, ///
    //data signals
input  [DATA_WIDTH-1:0] wdata,
output [DATA_WIDTH-1:0] rdata


);


 reg [DATA_WIDTH-1:0] rdata = 8'h00;
  
  //Memory
  reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH] ;

  //Reset 
  always @(posedge reset) 
    for(int i=0;i<2**ADDR_WIDTH;i++) mem[i]=8'hFF;
   
  // Write data 
  always @(posedge clk) 
    if (wr_en)    mem[addr] <= wdata;

  // Read data 
  always @(posedge clk)
    if (rd_en) rdata <= mem[addr]; 




    





endmodule
