`timescale 10ns/100ps
`include "parametersSiFH.vh"


module SiFH_FSM_TB (
    //ports
);
    reg clk;
    reg res;
    reg wrEn; 
    reg [`Np-1:0] data;

    reg [`peakMax-1:0] counts; //output b
    reg [`peakMax-1:0] newCounts; //output b
    reg [`Nb-1:0] waddr; //addra
    reg [`Nb-1:0] raddr; //addrb
    reg wEnable; //a 1-> Enable
    reg rEnable; //b 0-> Enable
    reg writeFlag; //mea
    reg readFlag; //meb memory enable   
    reg [`peakMax-1: 0] newCounts;

    reg [`Np-1:0] peakResult [`PIXEL_NUM_PER_RAM -1 : 0];

    integer n;

    initial clk = 0;
    always #1 clk = ~clk;


    initial begin


        #1
        res = 1;
        wrEn = 1'b1;
        
        #0.5
        
        res = 0;
        #0.5
        res = 1;
        
        
        roughData =108;//1_1_1
        
        // //read from txt since here
        // #0.1       
        // $readmemb("D:/OneDrive - Delft University of Technology/thesis/RTL/pipeline_sv/inputData.txt", inputData);   
            
        //     for (n = 0; n< (`PIXEL_NUM * `ACQ_NUM * `DATA_NUM * 2 + 3); n=n+1) begin
        //         @(posedge clk)
        //         #0.1  
        //         roughData = inputData[n];
        //         //#2
        //     end

        // //$readmemb("inputData.txt", inputData);

        // // integer n;
        // // for (n = 0; n<= (`PIXEL_NUM * `ACQ_NUM); n=n+1) begin
        // //     roughData = inputData[n];
        // //     #2
        // // end

        #1.1
        roughData = 511;
        wrEn = 1'b1; //1_1_2

        #2
        roughData = 1022;//1023;
        wrEn = 1'b1;//1_2_1


        #2
        res = 1;
        roughData = 1022;//1023;
        wrEn = 1'b1;//1_2_2

        #2
        res = 1;
        roughData = 200;
        wrEn = 1'b1; //1_3_1

        #2
        roughData = 90;
        wrEn = 1'b1;//1_3_2

        #2
        roughData = 511;
        wrEn = 1'b1;//2_1_1

        // #2
        // res = 1;
        // roughData = 1023;
        // wrEn = 1'b1;//2_1_2

        // #2
        // res = 1;
        // roughData = 90;
        // wrEn = 1'b1; //2_2_1

        // #2
        // roughData = 90; //2-2_2
        // wrEn = 1'b1;//NAN

        // #2
        // roughData = 90;//2_3_1
        // wrEn = 1'b1;

        // #2
        // roughData = 90;//2-3_2
        // wrEn = 1'b1;

        // #2
        // roughData = 1023;
        // wrEn = 1'b1;

        // #8
        // roughData = 300;//begin of second his
        // wrEn = 1'b1;//1_1_1

        // #2
        // roughData = 500;
        // wrEn = 1'b1;//1_1_2

        // #2
        // res = 1;
        // roughData = 50;
        // wrEn = 1'b1;//1_2_1
  
        // #2
        // roughData = 1000;
        // wrEn = 1'b1;//1_2_2
        
        // #2
        // roughData = 48;
        // wrEn = 1'b1;//1_3_1

        // #2
        // roughData = 90;
        // wrEn = 1'b1;//1_3_2

        // #2
        // roughData = 600;
        // wrEn = 1'b1;//2_1_1

        // #2
        // roughData = 500;
        // wrEn = 1'b1;//2_1_2

        // #2
        // roughData = 1000;
        // wrEn = 1'b1;//2_2_1

        // #2
        // roughData = 1023;
        // wrEn = 1'b1;//2_2_2

        // #2
        // roughData = 120;
        // wrEn = 1'b1;//2_3_1

        // #2
        // roughData = 90;
        // wrEn = 1'b1;//2_3_2

        #2
        roughData = 0;
        wrEn = 1'b1;

        #2
        roughData = 0;
        wrEn = 1'b0;

    end


SiFH_FSM SiFH_FSM (
    .clk(clk),
    .res(res),
    .wrEn(wrEn),
    .data(data),

    .counts(counts), //output b
    .newCounts(newCounts), //output b
    .waddr(waddr), //addra
    .raddr(raddr), //addrb
    .wEnable(wEnable), //a 1-> Enable
    .rEnable(rEnable), //b 0-> Enable
    .writeFlag(writeFlag), //mea
    .readFlag(readFlag), //meb memory enable

    .newCounts(newCounts),
    .peakResult(peakResult)
);

endmodule