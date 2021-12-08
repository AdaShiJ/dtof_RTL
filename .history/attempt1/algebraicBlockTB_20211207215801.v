`timescale 10ns/100ps
`include "parametersSiFH.vh"
//`include "peakDetecter.v"
module algebraicBlockTB (
    //ports
);
    reg [`Nb:1] peakCH;
    wire [`Np:1] THminus;
    wire [`Np:1] THpositive;
    wire [`Nb:1] delta;

    reg clk;
    initial clk = 0;
    always #1 clk = ~clk;

    initial begin
        
        #20
        peakCH = 6'd63;
        #20
        peakCH = 6'd1;
        #20
        peakCH = 6'd24;

    end

algebraicBlock  algebraicBlockU0(
    .peakCH(peakCH),
    .THminus(THminus),
    .THpositive(THpositive),
    .delta(delta)
);

endmodule

// `define Nb 6
// `define Np 10
// `define NumberOfBins 64//2^(Nb)
// `define peakMax 21
// `define ACQ_NUM 4//33333
// `define DATA_NUM 2
// `define SRAM_NUM 2//200
// `define PIXEL_NUM 6//32000//200*160
// `define PIXEL_PER_RAM (`PIXEL_NUM / `SRAM_NUM)
// `define RAM_SIZE (`peakMax * `NUM_PER_RAM)
// `define ACQ_NUM_PER_RAM (`ACQ_NUM * `PIXEL_PER_RAM)//33333
//`define peakMaxb = 15
//`define peakMaxp = 11