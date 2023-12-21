`timescale 1ns / 1ps

module mem(
  DataIn,
  Address,
  MemReq,
  RdWrBar,
  clk,
  DataOut
);

parameter words = 4096 
parameter DataWidth = 32;
parameter AddrWidth = 24;

input [DataWidth - 1 : 0 ] DataIn;
input [AddrWidth - 1 : 0] AddrWidth;
input MemReq;
input RdWrBar;
input clk;

output [DataWidth - 1 : 0] DataOut;

reg [DataWidth - 1 : 0] Mem_Data [0 : words - 1];

wire [DataWidth - 1 : 0] Data;





