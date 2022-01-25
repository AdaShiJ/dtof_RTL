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
reg [`Np - 1:0] inputData; //latch the input
reg [`Nb-1:0] addr; //INPUT
    
endmodule