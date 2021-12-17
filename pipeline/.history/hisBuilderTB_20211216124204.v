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
    //wire nextFlag;
    wire hisNum;
    wire peakDone;
    reg [31:0] BIN_NUM_PER_HIS;
    reg [31:0] PIXEL_NUM_PER_RAM;
    reg [31:0] BIN_NUM_PER_RAM;
    reg [31:0] RAM_SIZE;


    initial clk = 0;
    always #1 clk = ~clk;

    initial begin
        BIN_NUM_PER_HIS = 2**(`Nb);
        PIXEL_NUM_PER_RAM = (`PIXEL_NUM / `SRAM_NUM);
        BIN_NUM_PER_RAM = (`PIXEL_NUM_PER_RAM * `BIN_NUM_PER_HIS);
        RAM_SIZE = (`peakMax * `BIN_NUM_PER_RAM);
        // res = 1;
         #1
        //hisNum = 0;
        res = 1;
        wrEn = 1'b1;
        
        #0.5
        roughData =108;//1_1_1
        res = 0;
        #0.5
        res = 1;
        
        #1
        
        //#2
        //wrEn = 1'b1;
        //acqFinish = 0; 
        
        roughData = 511;
        wrEn = 1'b1;
        //acqFinish = 0; //1_1_2

        #2
        roughData = 1023;
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
        roughData = 90;
        wrEn = 1'b1;
        //acqFinish = 0; //1_2_2

        #2
        res = 1;
        roughData = 200;
        wrEn = 1'b1;
        //acqFinish = 0; //1_3_1

        #2
        roughData = 90;
        wrEn = 1'b1;
        //acqFinish = 0; //1_3_2

        #2
        roughData = 1023;
        wrEn = 1'b1;
        //acqFinish = 0; //2_1_1

        // #2
        //acqFinish = 1; //5

        // #2
        // //res = 1;
        // acqFinish = 0;
        // wrEn = 2'b00;

        #2
        res = 1;
        roughData = 700;
        wrEn = 1'b1;
        //acqFinish = 0; //2_1_2

        #2
        res = 1;
        roughData = 90;
        wrEn = 1'b1;
        //acqFinish = 0; //2_2_1

        #2
        roughData = 90; //2-2_2
        wrEn = 1'b1;
        //acqFinish = 0; //NAN

        #2
        roughData = 200;//2_3_1
        wrEn = 1'b1;

        #2
        roughData = 90;//2-3_2
        wrEn = 1'b1;

        #2
        roughData = 0;
        wrEn = 1'b1;

        #4
        roughData = 50;//begin of second acq
        wrEn = 1'b1;//1_1_1

        #2
        roughData = 50;
        wrEn = 1'b1;//1_1_2
        // #2
        // res = 0; //reset
        // //acqFinish = 0;
        #2
        res = 1;
        roughData = 102;
        wrEn = 1'b1;//1_2_1
        //acqFinish = 0; //1
        #2
        roughData = 102;
        wrEn = 1'b1;//1_2_2
        //acqFinish = 0; //2
        #2
        roughData = 32;
        wrEn = 1'b1;//1_3_1
        #2
        roughData = 33;
        wrEn = 1'b1;//1_3_2

        #2
        roughData = 50;
        wrEn = 1'b1;//2_1_1
        #2
        roughData = 128;
        wrEn = 1'b1;//2_1_2

        #2
        roughData = 50;
        wrEn = 1'b1;//2_2_1
        #2
        roughData = 128;
        wrEn = 1'b1;//2_2_2

        #2
        roughData = 50;
        wrEn = 1'b1;//2_3_1
        #2
        roughData = 128;
        wrEn = 1'b1;//2_3_2

        #4
        roughData = 0;
        wrEn = 1'b0;
     
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

hisBuilderFSM hisBuilderrFSMU0
(
    .clk(clk),
    .res(res), 
    .wrEn(wrEn),
    .binCounts(binCounts[`peakMax-1:0]), //current single bin
    .addr(data),
    .acq_count_finish(acq_count_finish),
    .hisNum(hisNum),
    .peakCH(peakCH), 
    .peakFH(peakFH),
    .peakDone(peakDone)
);

// peakDetecter peakDetecterU0( 
//     .clk(clk), 
//     .NoC(binCounts[`peakMax-1:0]), 
//     .hisNum(hisNum),
//     .acq_count_finish(acq_count_finish), 
//     .peakDone(peakDone), 
//     .addr(data), 
//     .reset(res), 
//     .peakCH(peakCH), 
//     .peakFH(peakFH)
//     );

algebraicBlock  algebraicBlockU0(
    .peakCH(peakCH),
    .peakDone(peakDone),
    //input peakReady,
    .THminus(THminus),
    .THpositive(THpositive),
    .delta(delta),
    .algebraicReady(algebraicReady)
);

endmodule