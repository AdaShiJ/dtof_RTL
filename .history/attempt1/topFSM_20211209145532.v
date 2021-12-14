`include "parametersSiFH.vh"

module topFSM (
    input clk,
    input res,
    input wrEN,
    input [`Nb-1:0] addr,
    output reg peakResult
);

    reg [`Nb-1:0] addrSaver = 0;
    reg [(`peakMax - 1) : 0] BRAM [`BIN_NUM_PER_RAM - 1 : 0]; //SRAM
    reg [`peakMax-1 : 0] recentMax = 0;

    parameter IDLE = 2'b00, HIS_PEAK = 2'b01, ALGEBRAIC_CAL = 2'b10;//HIS_BUILDER = 2'b01, PEAK_DETECT = 2'b10, ALGEBRAIC_CAL = 2'b11;
    
    always @(posedge clk or negedge res) begin
        r_state <= IDLE;
        else r_state <= next_state;
    end

    always @(posedge clk or negedge res) begin
        if (~res) begin
            peakCH <= 0;
            peakFH <= 0;
            recentMax <= 0;
            addrSaver <= 0;
            peakDone <= 0;
        end
        else begin
        case (r_state)
            IDLE: 
                input_count <= 0;
                input_count_finish <= 0;

            HIS_PEAK:
                if (wrEn) begin
                    //save into mem
                    BRAM[(addr - 1)  + pixel_count*`BIN_NUM_PER_HIS ] <= BRAM[(addr - 1)  + pixel_count*`BIN_NUM_PER_HIS ] + 1;//[(addr - 1)  + pixel_count*`ACQ_NUM + acq_count*(`PIXEL_NUM_PER_RAM)*(`ACQ_NUM)] + 1;
                    binCounts <= BRAM[(addr - 1)  + pixel_count*`BIN_NUM_PER_HIS ] + 1;//[((addr - 1) - 1)  + pixel_count*`Nb + acq_count*(`PIXEL_NUM_PER_RAM)*(`Nb)]; ////is it right???
                    if (input_count < `DATA_NUM - 1) begin
                        input_count <= input_count + 1;
                    end
                    else begin
                        input_count <= 0;  
                        input_count_finish <= 1;
                        if (pixel_count < `PIXEL_NUM_PER_RAM - 1) begin
                            pixel_count <= pixel_count + 1;
                        end
                        else begin
                            pixel_count <= 0;
                            pixel_count_finish <= 1;
                            if (acq_count < `ACQ_NUM - 1) begin
                                acq_count <= acq_count + 1;
                            end        
                            else begin
                                acq_count <= 0;
                                inside_ress <= 1;
                                acq_count_finish <= 1;
                                //hisNum = ~hisNum;
                            end 
                        end
                    end

                    //peak detect
                    recentMax <= (NoC > recentMax) ? NoC : recentMax;
                    addrSaver <= (NoC > recentMax) ? addr : addrSaver;
                    if (acq_count_finish) begin
                        if (~hisNumm) begin
                            peakCH <= addrSaver;
                            peakFH <= 0;
                            peakDone <= 1;
                        end
                        else begin
                            peakCH <= 0;
                            peakFH <= addrSaver;
                            peakDone <= 1;
                        end    
                    end

            default: 
        endcase
        end
    end

endmodule