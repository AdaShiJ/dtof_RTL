`include "parametersSiFH.vh"

module SiFH (
    input clk,
    input res,
    input wrEn,
    input [`Np - 1:0] data,
    input [`peakMax-1:0] counts,
    output reg [`peakMax-1:0] newCounts,
    output reg [`Np-1:0] peakResult [`PIXEL_NUM_PER_RAM -1 : 0]
);

//**************INPUT/OUTPUT/RAM***************
reg [(`peakMax - 1) : 0] BRAM [`BIN_NUM_PER_RAM - 1 : 0]; //RAM
reg [`BIN_NUM_PER_RAM -1 : 0] stateRAM = 0; //SAVE THE STATE OF RAM :: 0 -> RESET NEEDED OR 1-> NO RESET NEEDED
reg [`Nb-1:0] addr; //INPUT
    
endmodule