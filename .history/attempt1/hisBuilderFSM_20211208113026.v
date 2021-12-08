`include "parametersSiFH.vh"

module hisBuilderFSM
(
    input clk,
    input res, 
    input wrEn, //CH -> 2'b11 FH->2'b01
    input [`Nb:1] addr,
    //input hisNum, add the data processing part all in DF
    output reg nextFlag,
    output reg [`peakMax-1:0] binCounts, //current single bin
    output reg dataFinish,  //CH -> 2'b11 FH->2'b01
    output reg hisNum

);
    reg [`BIN_NUM_PER_RAM : 1] BRAM [(`peakMax - 1) : 0];


    parameter RESET_ALL = 2'b00, INPUT_COUNT = 2'b01, PIXEL_COUNT = 2'b10, ACQ_COUNT = 2'b11;
    reg current_state, next_state;

    always @(posedge clk or negedge res) begin
        if (~res) begin
            current_state = RESET_ALL;
        end
            else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            REST_ALL:begin
                for (num = 1; num <= `PIXEL_PER_RAM; num = num + 1) begin
                    for (i = 0; i < `NUM_PER_RAM; i=i+1) begin
                        BRAM[(num-1)*(`Nb)+1+i] = 0; //reset whole bram
                        dataFinish = 2'b00;
                        binCounts = 2'b00;
                        stateRAM[(num-1)*(`Nb)+1+i] = 0;
                    end                
                end
            end 
            default: 
        endcase
    end
    

endmodule