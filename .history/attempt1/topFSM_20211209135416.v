`include "parametersSiFH.vh"

module topFSM (
    input clk,
    input res,
    input [`Nb:1] addr,
    output reg peakResult
);
    reg [(`peakMax - 1) : 0] BRAM [`BIN_NUM_PER_RAM - 1 : 0]; //SRAM

    parameter IDLE = 2'b00, HIS_BUILDER = 2'b01, PEAK_DETECT = 2'b10,ALGEBRAIC_CAL = 2'b11;
    
endmodule