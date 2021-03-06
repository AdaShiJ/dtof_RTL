`timescale 10ns/100ps
`include "parametersSiFH.vh"

module hisBuilderTB (
    //ports
);
    reg clk;
    reg res;
    reg wrEn; 
    reg [`Np-1:0] roughData;

    wire [((`Np)*(`PIXEL_NUM_PER_RAM)-1):0] result;
    wire [`Np-1:0] result_pixel1;
    wire [`Np-1:0] result_pixel2;
    wire [`Np-1:0] result_pixel3;

    initial clk = 0;
    always #1 clk = ~clk;

    assign result_pixel1[`Np-1:0] = result[0*(`Np) +: `Np];
    assign result_pixel2[`Np-1:0] = result[1*(`Np) +: `Np];
    assign result_pixel3[`Np-1:0] = result[2*(`Np) +: `Np];

    initial begin

        #1
        res = 1;
        wrEn = 1'b1;
        
        #0.5
        roughData =108;//1_1_1
        res = 0;
        #0.5
        res = 1;
        
        #1        
        roughData = 511;
        wrEn = 1'b1; //1_1_2

        #2
        roughData = 1023;
        wrEn = 1'b1;//1_2_1


        #2
        res = 1;
        roughData = 90;
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

        #2
        res = 1;
        roughData = 700;
        wrEn = 1'b1;//2_1_2

        #2
        res = 1;
        roughData = 90;
        wrEn = 1'b1; //2_2_1

        #2
        roughData = 90; //2-2_2
        wrEn = 1'b1;//NAN

        #2
        roughData = 90;//2_3_1
        wrEn = 1'b1;

        #2
        roughData = 90;//2-3_2
        wrEn = 1'b1;

        #2
        roughData = 0;
        wrEn = 1'b1;

        #6
        roughData = 300;//begin of second acq
        wrEn = 1'b1;//1_1_1

        #2
        roughData = 500;
        wrEn = 1'b1;//1_1_2

        #2
        res = 1;
        roughData = 50;
        wrEn = 1'b1;//1_2_1
  
        #2
        roughData = 70;
        wrEn = 1'b1;//1_2_2
        
        #2
        roughData = 30;
        wrEn = 1'b1;//1_3_1

        #2
        roughData = 90;
        wrEn = 1'b1;//1_3_2

        #2
        roughData = 600;
        wrEn = 1'b1;//2_1_1

        #2
        roughData = 500;
        wrEn = 1'b1;//2_1_2

        #2
        roughData = 70;
        wrEn = 1'b1;//2_2_1

        #2
        roughData = 120;
        wrEn = 1'b1;//2_2_2

        #2
        roughData = 120;
        wrEn = 1'b1;//2_3_1

        #2
        roughData = 90;
        wrEn = 1'b1;//2_3_2

        #4
        roughData = 0;
        wrEn = 1'b0;

    end


hisBuilderFSM hisBuilderrFSMU0
(
    .clk(clk),
    .res(res), 
    .wrEn(wrEn),
    .data(roughData),
    .result(result)
);

endmodule