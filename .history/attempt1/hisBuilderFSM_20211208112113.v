`include "parametersSiFH.vh"

module hisBuilderFSM
(
    input clk,
    input res, 
    input wrEnable, //CH -> 2'b11 FH->2'b01
    input [`Nb:1] addr,
    //input hisNum, add the data processing part all in DF
    output reg nextFlag,
    output reg [`peakMax-1:0] binCounts, //current single bin
    output reg dataFinish,  //CH -> 2'b11 FH->2'b01
    output reg hisNum

);
    reg [`RAM_SIZE : 1] BRAM [(`peakMax - 1) : 0];

    parameter RESET_ALL = 2'b00, INPUT_COUNT = 2'b01, PIXEL_COUNT = 2'b10, ACQ_COUNT = 2'b11;
    reg current
    always @(posedge clk or negedge res) begin
        if (~res) begin
            acq_counter = 0;
            nextFlag = 0;
            hisFinish = 0;
        end
        else if (acq_counter == `ACQ_NUM_PER_RAM-1) begin
            acq_counter = 0;
            nextFlag = ~nextFlag;
            hisFinish = 1;
            pixel_count = pixel_count + 1;
        end
        else acq_counter = acq_counter + 1;
    end

    

endmodule