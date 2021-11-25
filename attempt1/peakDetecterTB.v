`timescale 10ns/100ps
`include "parametersSiFH.vh"
//`include "peakDetecter.v"
module peakDetecterTB (
    //ports
);
    reg clk;
    reg [`peakMax:0] NoC; 
    reg [1:0] status;
    reg [`peakMax:0] addr; 
    reg reset;
    wire [`peakMax:0] peakCH;
    wire [`peakMax:0] peakFH;
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
        status = 2'b10;
        addr = 4;
    end

peakDetecter u0( 
    .clk(clk), 
    .NoC(NoC[`peakMax:0]), 
    .status(status[1:0]), 
    .addr(addr[`peakMax:0]), 
    .reset(reset), 
    .peakCH(peakCH[`peakMax:0]), 
    .peakFH(peakFH[`peakMax:0])
    );

endmodule