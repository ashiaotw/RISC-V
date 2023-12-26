`timescale 1ns/100ps

module if_stage(
    input clock,
    input reset,
    input [3:0] Imem2proc_response_i,
    input [`MEMORY_DATA_SIZE-1:0] Imem2proc_data_i,
    input [3:0] Imem2proc_tag_i,
    input mem_req_accept_i,
    output IF_ID_PACKET [`WAY_NUM-1:0] if_id_packet_o,
    output BP_PACKET [`WAY_NUM-1:0] bp_packet_o
);

    IF_ICACHE_PACKET if_icache_packet;
    ICACHE_IF_PACKET icache_if_packet;
    logic [`WAY_NUM-1:0][`XLEN-1:0] PC_reg, next_PC_reg;


    //output to icache
    assign if_icache_packet.PC = {PC_reg[2], PC_reg[1], PC_reg[0]};

    //if_id packet output
    always_comb begin
        for (int i = 0; i < `WAY_NUM; i++) begin //instantiation
            if_id_packet_o[i] = {1'b0, 32'b0, 32'b0, 32'b0};
        end

        for (int i = 0; i < `WAY_NUM; i++) begin
            if_id_packet_o[i].PC = if_bp_packet[i].PC;
            if_id_packet_o[i].NPC = if_bp_packet[i].NPC;

            if (bp_packet_o[i].valid && icache_if_packet.valid[i]) begin
                if_id_packet_o[i].inst = icache_if_packet.inst[i];
                if_id_packet_o[i].valid = 1;
            end
            else begin
                break;
            end 
        end
    end

    if (mispredict_flag) begin
        for (int i = 0; i < `WAY_NUM; i++) begin
            if_id_packet_o[i] = {1'b0, 32'b0, 32'b0, 32'b0};
        end
    end

    always_comb begin
        PC_change_count = 0;
        bp_PC_change_count = 0;
        for (int i = 0; i < `WAY_NUM; i++) begin
            if_bp_packet[i] = {1'b0, 32'b0, 32'b0, 32'b0};
        end
        //check cache hit
        for (int i = 0; i < `WAY_NUM; i++) begin
            if_bp_packet[i].inst = icache_if_packet.inst[i];
            if_bp_packet[i].PC = PC_reg[i];
            if_bp_packet[i].NPC = PC_reg[i] + 4;
            if_bp_packet[i].valid = 1;
        end

        //predict taken
        for (int i = 0; i < `WAY_NUM; i++) begin
            if (bp_packet_o[i].valid && icache_if_packet.valid[i]) begin
                bp_PC_change_count = bp_PC_change_count + 1;
                PC_change_count = (inst_buffer_strutural_hazard_i) ? 0 : bp_PC_change_count;
            end
            else begin
                break;
            end
        end
    end

    //instruction fetch
    always_comb begin
        next_PC_reg = PC_reg;
        next_PC_reg[0] = PC_final;
        next_PC_reg[1] = PC_final + 4;
        next_PC_reg[2] = PC_final + 8;
    end

    //main block
    always_ff @(posedge clock) begin
        if(reset) begin
            PC_reg <= `SD {32'h0000_0008, 32'h0000_0004, 32'h0000_0000};
        end
        else begin
            PC_reg <= `SD next_PC_reg;
        end
    end

endmodule
