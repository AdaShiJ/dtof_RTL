`timescale 10ns/100ps
`include "parametersSiFH.vh"
//`include "peakDetecter.v"
module hisBuilderTB (
    //ports
);
    reg clk;
    reg res;
    reg [1:0]wrEn; //CH -> 2'b11 FH->2'b11
    reg acqFinish;
    reg [`Np:1] addr; //ADDR : 1-Nb, there is no addr 0
    //addr -> input data from 1 to Np, only 1 to Nb is used in first his
    wire [`peakMax-1:0] binCounts; //current single bin
    wire [1:0] dataFinish;
    wire [`Np:1] peakCH;
    wire [`Np:1] peakFH; 
    wire [`Np:1] THminus;
    wire [`Np:1] THpositive;
    wire [`Np:1] delta;

    initial clk = 0;
    always #1 clk = ~clk;

    initial begin
        
        res = 0;
        #1
        res = 0;
        #2
        res = 1;
        #2
        res = 0;
        addr = 1;
        wrEn = 2'b11;
        acqFinish = 0; //1
        #2
        addr = 1;
        wrEn = 2'b11;
        acqFinish = 0; //2

        #2
        addr = 2;
        wrEn = 2'b11;
        acqFinish = 0; //3

        // #2
        // // addr = 0;
        // // wrEn = 2'b01;
        // //acqFinish = 1; // The result when acqFinish =1 will not be counted
        // res = 0;
        // #2
        // //res = 1;
        // acqFinish = 0;
        // wrEn = 2'b00;
        #2
        res = 0;
        addr = 2;
        wrEn = 2'b11;
        acqFinish = 0; //1

        #2
        res = 0;
        addr = 3;
        wrEn = 2'b11;
        acqFinish = 0; //2

        #2
        addr = 1;
        wrEn = 2'b11;
        acqFinish = 0; //3

        #2
        addr = 2;
        wrEn = 2'b11;
        acqFinish = 0; //4

        // #2
        //acqFinish = 1; //5

        // #2
        // //res = 1;
        // acqFinish = 0;
        // wrEn = 2'b00;

        #2
        res = 0;
        addr = 3;
        wrEn = 2'b11;
        acqFinish = 0; //1

        #2
        res = 0;
        addr = 3;
        wrEn = 2'b11;
        acqFinish = 0; //2

        #2
        addr = 3;
        wrEn = 2'b11;
        acqFinish = 0; //3

        #2
        acqFinish = 1; //get result in the second clk

        #2
        acqFinish = 0; //wait for result
        #2
        res = 1; //reset
        acqFinish = 0;
        #2
        res = 0;
        addr = 1;
        wrEn = 2'b11;
        acqFinish = 0; //1
        #2
        addr = 0;
        wrEn = 2'b11;
        acqFinish = 0; //2
     
        // #5
        // addr = 0;
        // wrEn = 2'b01;
        // acqFinish = 0;
        // #5
        // addr = 0;
        // wrEn = 2'b01;
        // acqFinish = 0;
        // #5
        // addr = 1;
        // wrEn = 2'b01;
        // acqFinish = 0;
        // #5
        // addr = 0;
        // wrEn = 2'b01;
        // acqFinish = 0;
        // #1
        // addr = 0;
        // wrEn = 2'b01;
        // acqFinish = 1;
    end

hisBuilderReg hisBuilderU0
(
    .clk(clk),
    .res(res), 
    .wrEnable(wrEn[1:0]),
    .acqFinish(acqFinish),
    .binCounts(binCounts[`peakMax-1:0]), //current single bin
    .addr(addr[`Np:1]),
    .dataFinish(dataFinish[1:0])
);

// peakDetecter peakDetecterU0( 
//     .clk(clk), 
//     .NoC(binCounts[`peakMax-1:0]), 
//     .status(dataFinish[1:0]), 
//     .addr(addr[`Nb:1]), 
//     .reset(res), 
//     .peakCH(peakCH[`Np:1]), 
//     .peakFH(peakFH[`Np:1])
//     );



// algebraicBlock  algebraicBlockU0(
//     .peakCH(peakCH),
//     //input peakReady,
//     .THminus(THminus),
//     .THpositive(THpositive),
//     .delta(delta)
// );

endmodule