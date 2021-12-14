`include "parametersSiFH.vh"

module topAll
(
    input clk,
    input res, 
    input wrEn, //CH -> 2'b11 FH->2'b01
    input [`Nb:1] addr,
    output reg [`peakMax-1:0] binCounts, //current single bin
    output reg acq_count_finish,  //CH -> 2'b11 FH->2'b01
    output reg hisNum

);




endmodule