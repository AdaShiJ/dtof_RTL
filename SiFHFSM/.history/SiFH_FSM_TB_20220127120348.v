`timescale 10ns/100ps
`include "parametersSiFH.vh"


module SiFH_FSM_TB (
    //ports
);
    reg clk;
    reg res;
    wire wrEn; 
    reg [`Np-1:0] data;

    reg [`peakMax-1:0] counts; //output b
    wire [`peakMax-1:0] newCounts; //output b
    wire [`RAM_ADDR-1:0] waddr; //addra
    wire [`RAM_ADDR-1:0] raddr; //addrb
    wire wEnable; //a 1-> Enable
    wire rEnable; //b 0-> Enable
    wire writeFlag; //mea
    wire readFlag; //meb memory enable   

    wire [`Np-1:0] peakResult [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np-1:0] inputData [`PIXEL_NUM * `ACQ_NUM * `DATA_NUM * 2 - 1  + 4: 0];

    integer n;

    initial clk = 0;
    always #1 clk = ~clk;


    initial begin
        $readmemb("D:/OneDrive - Delft University of Technology/thesis/RTL/SIFHFSM/inputData.txt", inputData);   
        #1
        res = 1;
        #0.5
        
        res = 0;
        #0.5
        res = 1;

        //wrEn = 1'b1;
        
        // #1.1
        // data =108;//1_1_1
        
        // //read from txt since here
        // #0.1       
        #95
        //data = 3'b101;
        //if (wrEn) begin
            for (n = 0; n< (`PIXEL_NUM * `ACQ_NUM * `DATA_NUM * 2); n=n+1) begin
                @(posedge clk)
                //#0.1  
                data = inputData[n];
                counts = 0;
                //#2
            end
        //end    


        // //$readmemb("inputData.txt", inputData);

        // // integer n;
        // // for (n = 0; n<= (`PIXEL_NUM * `ACQ_NUM); n=n+1) begin
        // //     data = inputData[n];
        // //     #2
        // // end

        // #2
        // data = 511;
        // //wrEn = 1'b0; //1_1_2
        // counts = 0;

        // #2
        // data = 1022;//1023;
        // //wrEn = 1'b0;//1_2_1
        // counts = 0;


        // #2
        // res = 1;
        // data = 1022;//1023;
        // //wrEn = 1'b0;//1_2_2
        // counts = 1;

        // #2
        // res = 1;
        // data = 200;
        // //wrEn = 1'b0; //1_3_1
        // counts = 0;

        // #2
        // data = 90;
        // //wrEn = 1'b0;//1_3_2
        // counts = 0;

        // #2
        // data = 511;
        // counts = 0;//2_1_1

        // #2
        // res = 1;
        // data = 1023;
        // counts = 0;//2_1_2

        // #2
        // res = 1;
        // data = 90;
        // counts = 0; //2_2_1

        // #2
        // data = 90; //2-2_2
        // counts = 0;//NAN

        // #2
        // data = 90;//2_3_1
        // counts = 0;

        // #2
        // data = 90;//2-3_2
        // counts = 0;

        // #2
        // data = 1023;
        // counts = 0;
        // #8
        // data = 300;//begin of second his
        // counts = 0;//1_1_1

        // #2
        // data = 500;
        // counts = 0;//1_1_2

        // #2
        // res = 1;
        // data = 50;
        // counts = 0;//1_2_1
  
        // #2
        // data = 1000;
        // counts = 0;//1_2_2
        
        // #2
        // data = 48;
        // counts = 0;//1_3_1

        // #2
        // data = 90;
        // counts = 0;//1_3_2

        // #2
        // data = 600;
        // counts = 0;//2_1_1

        // #2
        // data = 500;
        // counts = 0;//2_1_2

        // #2
        // data = 1000;
        // counts = 0;//2_2_1

        // #2
        // data = 1023;
        // counts = 0;//2_2_2

        // #2
        // data = 120;
        // counts = 0;//2_3_1

        // #2
        // data = 90;
        // counts = 0;//2_3_2

        #2
        data = 0;
        //wrEn = 1'b1;

        #2
        data = 0;
        //wrEn = 1'b0;

    end


SiFHtop SiFHtop(
    .clk(clk),
    .res(res),
    .wrEn(wrEn),
    .data(data),

    .counts(counts), //output b
    .waddr(waddr), //addra
    .raddr(raddr), //addrb
    .wEnable(wEnable), //a 1-> Enable
    .rEnable(rEnable), //b 0-> Enable
    //.writeFlag(writeFlag), //mea
    //.readFlag(readFlag), //meb memory enable

    .newCounts(newCounts)//,
    //.peakResult(peakResult)
);

SRAMtest SRAMtest(
    .QA(counts), 
    //.QB(newCounts), //read output
    .ADRA(raddr), //read addr
    .WEA(~rEnable), //
    .MEA(rEnable), //memory enable
    .CLKA(clk), //
    .TEST1A(1'b0),
    .RMEA(1'b0),
    .RMA(4'b0),
    .LS(1'b0),
    .ADRB(addrb),
    .DB(newCounts), //write input
    .WEB(wEnable),
    .MEB(wEnable),
    .CLKB(clk),
    .TEST1B(1'b0),
    .RMEB(1'b0),
    .RMB(4'b0)
);

endmodule

//design of tb
//2 acq 3 pixels 2 data per pixel
//6 bits -> 4 bits
//histogram 1
010111
010110

000110
001000

011110
011101

011110
011101

001010
000101

000110
010101