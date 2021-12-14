`include "parametersSiFH.vh"

module topFSM (
    input clk,
    input res,
    input [`Nb:1] addr,
    output reg peakResult
);
    reg [(`peakMax - 1) : 0] BRAM [`BIN_NUM_PER_RAM - 1 : 0]; //SRAM

    parameter RESET_ALL = 2'b00, INPUT_COUNT = 2'b01, PIXEL_COUNT = 2'b10, ACQ_COUNT = 2'b11;
    
endmodule