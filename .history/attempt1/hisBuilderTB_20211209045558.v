`timescale 10ns/100ps
`include "parametersSiFH.vh"
//`include "peakDetecter.v"
module hisBuilderTB (
    //ports
);
    reg clk;
    reg res;
    reg wrEn; //CH -> 2'b11 FH->2'b11
    //reg acqFinish;
    //wire [`Nb:1] addr; //ADDR : 1-Nb, there is no addr 0
    //addr -> input data from 1 to Np, only 1 to Nb is used in first his
    //reg hisNum;
    reg [`Np:1] roughData;

    wire [`Nb:1] data;
    wire [`peakMax-1:0] binCounts; //current single bin
    //wire [1:0] dataFinish;
    wire acq_count_finish;
    wire [`Nb:1] peakCH;
    wire [`Nb:1] peakFH;
    wire [`Np:1] THminus;
    wire [`Np:1] THpositive;
    wire [`Np:1] delta;
    wire nextFlag;
    wire hisNum;

    initial clk = 0;
    always #1 clk = ~clk;

    initial begin
        
        // res = 1;
        // #1
        //hisNum = 0;
        res = 1;
        #0.5
        res = 0;
        #0.5
        res = 1;
        roughData = 1;
        #1
        wrEn = 1'b1;
        //acqFinish = 0; //1_1_1
        #2
        roughData = 1;
        wrEn = 1'b1;
        //acqFinish = 0; //1_1_2

        #2
        roughData = 2;
        wrEn = 1'b1;
        //acqFinish = 0; //1_2_1

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
        res = 1;
        roughData = 2;
        wrEn = 1'b1;
        //acqFinish = 0; //1_2_2

        #2
        res = 1;
        roughData = 4;
        wrEn = 1'b1;
        //acqFinish = 0; //2_1_1

        #2
        roughData = 7;
        wrEn = 1'b1;
        //acqFinish = 0; //2_1_2

        #2
        roughData = 64;
        wrEn = 1'b1;
        //acqFinish = 0; //2_2_1

        // #2
        //acqFinish = 1; //5

        // #2
        // //res = 1;
        // acqFinish = 0;
        // wrEn = 2'b00;

        #2
        res = 1;
        roughData = 42;
        wrEn = 1'b1;
        //acqFinish = 0; //2_2_2

        #2
        res = 1;
        roughData = 2;
        wrEn = 1'b1;
        //acqFinish = 0; //NAN

        #2
        roughData = 4;
        wrEn = 1'b1;
        //acqFinish = 0; //NAN

        #2
        roughData = 4;
        wrEn = 1'b1;

        #2
        roughData = 3;
        wrEn = 1'b1;

        #2
        roughData = 2;
        wrEn = 1'b1;

        #2
        roughData = 41;
        wrEn = 1'b1;
        // #2
        // res = 0; //reset
        // //acqFinish = 0;
        #2
        res = 1;
        roughData = 4;
        wrEn = 1'b1;
        //acqFinish = 0; //1
        #2
        roughData = 0;
        wrEn = 1'b1;
        //acqFinish = 0; //2
     
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

// DF DF_U0(
//     .roughData(roughData),
//     .THminus(THminus),
//     .THpositive(THpositive),
//     .delta(delta),
//     .hisNum(hisNum),
//     .data(data)
// );

hisBuilderFSM hisBuilderrFSMU0
(
    .clk(clk),
    .res(res), 
    .wrEn(wrEn),
    //.acqFinish(acqFinish),
    .binCounts(binCounts[`peakMax-1:0]), //current single bin
    .addr(roughData),
    //.nextFlag(nextFlag),
    .acq_count_finish(acq_count_finish),
    .hisNum(hisNum)
);

// peakDetecter peakDetecterU0( 
//     .clk(clk), 
//     .NoC(binCounts[`peakMax-1:0]), 
//     .status(dataFinish[1:0]), 
//     .addr(data), 
//     .reset(res), 
//     .peakCH(peakCH), 
//     .peakFH(peakFH)
//     );



// algebraicBlock  algebraicBlockU0(
//     .peakCH(peakCH),
//     //input peakReady,
//     .THminus(THminus),
//     .THpositive(THpositive),
//     .delta(delta)
// );

endmodule