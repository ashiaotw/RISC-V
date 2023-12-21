`timescale 1ns / 1ps

module mem(
  DataIn,
  Address,
  MemReq,
  RdWrBar,
  clk,
  data_out
);

  parameter words = 4096 
  parameter DataWidth = 32;
  parameter AddrWidth = 24;

  input [DataWidth - 1 : 0 ] DataIn;
  input [AddrWidth - 1 : 0] AddrWidth;
  input MemReq;
  input RdWrBar;
  input clk;

  output [DataWidth - 1 : 0] data_out;

  reg [DataWidth - 1 : 0] Mem_Data [0 : words - 1];

  wire [DataWidth - 1 : 0] data;

  // Read 
  assign data = (MemReq && RdWrBar)? mem_data [address]:32'hz;  //high impedance or don't care
  assign #accesstime data_out = data;  //delay
  
  // Write
  always @(posedge clk) begin
    if (MemReq && ~RdWrBar) begin
      mem_data [Address] <= DataIn;
    end
  end
endmodule




