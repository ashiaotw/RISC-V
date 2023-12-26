`timescale 1ns/100ps

module decoder(
    input IF_ID_PACKET if_packet,
    output ALU_OPA_SELECT opa_select,
    output ALU_OPB_SELECT opb_select,
    output DEST_REG_SEL dest_reg,
    output ALU_FUNC alu_func,
    output logic rd_mem, wr_mem, cond_branch, uncond_branch,
    output logic csr_op,
    output logic valid_inst
);
    INST inst;
    logic valid_inst_in;

    assign inst          = if_packet.inst;
    assign valid_inst_in = if_packet.valid;
    assign valid_inst    = valid_inst_in & ~illegal;

    //define instructions

endmodule

module id_stage(
    input clock,
    input reset,
    input INST_BUFFER_PACKET [`WAY_NUM-1:0] inst_buffer_packet_i,
    output ID_DISPATCH_PACKET [`WAY_NUM-1:0] id_packet_o
);
    always_comb begin
        for (int i = 0; i < `WAY_NUM; i++) begin
            if_id_packet_i[i] = inst_buffer_packet_i[i].if_id_packet;
            bp_packet_i[i] = inst_buffer_packet_i[i].bp_packet;
        end
    end
    
    //pass down the packet from if_id
    always_comb begin
        for (int i = 0; i < `WAY_NUM; i++) begin
            id_packet_o[i].bp_packet = bp_packet_i[i];
            id_packet_o[i].inst      = if_id_packet_i[i].inst;
            id_packet_o[i].NPC       = if_id_packet_i[i].NPC;
            id_packet_o[i].PC        = if_id_packet_i[i].PC;
        end
    end
endmodule