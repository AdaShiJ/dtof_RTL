`timescale 10ns/100ps
`include "parametersSiFH.vh"

module hisBuilderTB (
    //ports
);
    reg clk;
    reg res;
    reg wrEn; 
    reg [`Np-1:0] roughData;

    // wire [((`Np)*(`PIXEL_NUM_PER_RAM)-1):0] result;
    // wire [`Np-1:0] result_pixel1;
    // wire [`Np-1:0] result_pixel2;
    // wire [`Np-1:0] result_pixel3;
    wire [`Np-1:0] peakResult [`PIXEL_NUM_PER_RAM -1 : 0];

    reg [`Np-1:0] inputData [`PIXEL_NUM -1 : 0];

    integer n;

    initial clk = 0;
    always #1 clk = ~clk;

    // assign result_pixel1[`Np-1:0] = result[0*(`Np) +: `Np];
    // assign result_pixel2[`Np-1:0] = result[1*(`Np) +: `Np];
    // assign result_pixel3[`Np-1:0] = result[2*(`Np) +: `Np];
    //assign peakResult = result;

    initial begin


        #1
        res = 1;
        wrEn = 1'b1;
        
        #0.5
        
        res = 0;
        #0.5
        res = 1;
        
        
        roughData =108;//1_1_1
        
        //read from txt since here
        //#1.1        
        $readmemb("inputData.txt", inputData);   
            
            for (n = 0; n<= (`PIXEL_NUM * `ACQ_NUM); n=n+1) begin
                @(posedge clk)
                roughData = inputData[n];
                //#2
            end
        //$readmemb("inputData.txt", inputData);

        // integer n;
        // for (n = 0; n<= (`PIXEL_NUM * `ACQ_NUM); n=n+1) begin
        //     roughData = inputData[n];
        //     #2
        // end

        // roughData = 511;
        // wrEn = 1'b1; //1_1_2

        // #2
        // roughData = 1022;//1023;
        // wrEn = 1'b1;//1_2_1


        // #2
        // res = 1;
        // roughData = 1022;//1023;
        // wrEn = 1'b1;//1_2_2

        // #2
        // res = 1;
        // roughData = 200;
        // wrEn = 1'b1; //1_3_1

        // #2
        // roughData = 90;
        // wrEn = 1'b1;//1_3_2

        // #2
        // roughData = 511;
        // wrEn = 1'b1;//2_1_1

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
        // roughData = 300;//begin of second acq
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


// hisBuilderFSM hisBuilderrFSMU0
// (
//     .clk(clk),
//     .res(res), 
//     .wrEn(wrEn),
//     .data(roughData),
//     .result(result)
// );

hisBuilderFSM hisBuilderrFSMU0
(
    .clk(clk),
    .res(res), 
    .wrEn(wrEn),
    .data(roughData),
    .peakResult(peakResult)
);

endmodule