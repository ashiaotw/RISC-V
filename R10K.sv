`ifndef __R10K__
`define __R10K__

`timescale 1ns/100ps

module R10K (
    input           clock,
    input           reset,
    input [3:0]     mem2proc_response,  //tag from memory about current request
    input [63:0]    mem2proc_data,      //data coming back from memory
    input [3:0]     mem2proc_tag,       //tag from memory about current reply

    output logic [1:0] proc2mem_command,    //command sent to memory
    output logic [`XLEN-1:0] proc2mem_addr, //address sent to memory
    output logic [63:0] proc2mem_data,      //data sent to memory
    output logic [$clog2(`WAY_NUM)-1:0] pipeline_completed_insts,
    output EXCEPTION_CODE pipeline_error_status [`WAY_NUM-1:0],

    //outputs from IF-Stage
    output logic [`WAY_NUM-1:0][`XLEN-1:0] if_NPC_out,
    output logic [`WAY_NUM-1:0][31:0] if_IR_out,
    output logic [`WAY_NUM-1:0] if_valid_inst_out,

    //outputs from IF/ID Pipeline Register
    output logic [`WAY_NUM-1:0][`XLEN-1:0] if_id_NPC,
    output logic [`WAY_NUM-1:0][31:0] if_id_IR,
    output logic [`WAY_NUM-1:0] if_id_valid_inst,

    //outputs form ID/Dispatch Pipeline Register
    output logic [`WAY_NUM-1:0][`XLEN-1:0] id_dispatch_NPC,
    output logic [`WAY_NUM-1:0][31:0] id_dispatch_IR,
    output logic [`WAY_NUM-1:0] id_dispatch_valid_inst
);
    
endmodule