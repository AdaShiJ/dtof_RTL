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
    //wire [`Nb:1] addr; //ADDR : 1-Nb, there is no addr 0
    //addr -> input data from 1 to Np, only 1 to Nb is used in first his
    reg hisNum;
    reg [`Np:1] roughData;

    wire [`Nb:1] data;
    wire [`peakMax-1:0] binCounts; //current single bin
    wire [1:0] dataFinish;
    wire [`Nb:1] peakCH;
    wire [`Nb:1] peakFH;
    wire [`Np:1] THminus;
    wire [`Np:1] THpositive;
    wire [`Np:1] delta;
    wire nextFlag;

    initial clk = 0;
    always #1 clk = ~clk;

    initial begin
        
        res = 1;
        #1
        //hisNum = 0;
        res = 1;
        #0.5
        res = 0;
        #0.5
        res = 1;
        hisNum = 0;
        roughData = 1;
        wrEn = 2'b11;
        acqFinish = 0; //1_1_1
        #2
        roughData = 1;
        wrEn = 2'b11;
        acqFinish = 0; //1_1_2

        #2
        roughData = 2;
        wrEn = 2'b11;
        acqFinish = 0; //1_2_1

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
        wrEn = 2'b11;
        acqFinish = 0; //1_2_2

        #2
        res = 1;
        roughData = 124;
        wrEn = 2'b11;
        acqFinish = 0; //2_1_1

        #2
        roughData = 1024;
        wrEn = 2'b11;
        acqFinish = 0; //2_1_2

        #2
        roughData = 1023;
        wrEn = 2'b11;
        acqFinish = 0; //2_2_1

        // #2
        //acqFinish = 1; //5

        // #2
        // //res = 1;
        // acqFinish = 0;
        // wrEn = 2'b00;

        #2
        res = 1;
        roughData = 512;
        wrEn = 2'b11;
        acqFinish = 0; //2_2_2

        #2
        res = 1;
        roughData = 400;
        wrEn = 2'b11;
        acqFinish = 0; //NAN

        #2
        roughData = 800;
        wrEn = 2'b11;
        acqFinish = 0; //NAN

        #2
        acqFinish = 1; //get result in the second clk

        #2
        acqFinish = 0; //wait for result
        #2
        res = 0; //reset
        acqFinish = 0;
        #2
        res = 1;
        roughData = 900;
        wrEn = 2'b11;
        acqFinish = 0; //1
        #2
        roughData = 0;
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

DF DF_U0(
    .roughData(roughData),
    .THminus(THminus),
    .THpositive(THpositive),
    .delta(delta),
    .hisNum(hisNum),
    .data(data)
);

hisBuilderReg hisBuilderU0
(
    .clk(clk),
    .res(res), 
    .wrEnable(wrEn[1:0]),
    //.acqFinish(acqFinish),
    .binCounts(binCounts[`peakMax-1:0]), //current single bin
    .addr(data),
    .nextFlag(nextFlag),
    .dataFinish(dataFinish[1:0])
);

peakDetecter peakDetecterU0( 
    .clk(clk), 
    .NoC(binCounts[`peakMax-1:0]), 
    .status(dataFinish[1:0]), 
    .addr(data), 
    .reset(res), 
    .peakCH(peakCH), 
    .peakFH(peakFH)
    );



// algebraicBlock  algebraicBlockU0(
//     .peakCH(peakCH),
//     //input peakReady,
//     .THminus(THminus),
//     .THpositive(THpositive),
//     .delta(delta)
// );

endmodule