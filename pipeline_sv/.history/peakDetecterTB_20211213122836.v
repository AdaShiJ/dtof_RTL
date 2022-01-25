`timescale 10ns/100ps
`include "parametersSiFH.vh"
//`include "peakDetecter.v"
module peakDetecterTB (
    //ports
);
    reg clk;
    reg [`peakMax-1:0] NoC; 
    reg [1:0] status;
    reg [`Nb:1] addr; 
    reg reset;
    wire [`Nb:1] peakCH;
    wire [`Nb:1] peakFH;
    initial clk = 0;
    always #1 clk = ~clk;

    initial begin
        NoC = 4;
        addr = 0;
        status = 0;
        #10
        NoC = 2;
        status = 0;
        addr = 1;
        #10
        NoC = 5;
        status = 2'b01;
        addr = 2;
        #10
        reset = 1;
        #10
        reset = 0;
        NoC = 9;
        status = 0;
        addr = 3;
        #9
        NoC = 7;
        status = 2'b11;
        addr = 4;
    end

peakDetecter peakDetecterU0( 
    .clk(clk), 
    .NoC(NoC[`peakMax-1:0]), 
    .status(status[1:0]), 
    .addr(addr[`Nb:1]), 
    .reset(reset), 
    .peakCH(peakCH[`Nb:1]), 
    .peakFH(peakFH[`Nb:1])
    );

hisBuilderReg hisBuilderRegU0
(
    .clk(clk),
    .res(reset), 
    .wrEnable(wrEnable), //CH -> 2'b11 FH->2'b01
    .addr(),
    .nextFlag(),
    .binCounts(), //current single bin
    .dataFinish()  //CH -> 2'b11 FH->2'b01
);

endmodule