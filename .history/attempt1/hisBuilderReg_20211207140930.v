`include "parametersSiFH.vh"
// `define Nb 6
// `define Np 10
// `define peakMax 21

module hisBuilderReg
(
    input clk,
    input res, 
    input [1:0] wrEnable, //CH -> 2'b11 FH->2'b01
    //input acqFinish,
    input [`Nb:1] addr,
    //input hisNum, add the data processing part all in DF
    output reg nextFlag,
    output reg [`peakMax-1:0] binCounts, //current single bin
    output reg [1:0] dataFinish  //CH -> 2'b11 FH->2'b01

);
    reg [`NumberOfBins : 1] BRAM [`peakMax - 1 :0]; // a huge BRAM for num_per_ram pixels
    reg [`NumberOfBins : 1] stateRAM = 0;
    reg [`peakMax-1 : 0] addrSaver = 0;
    reg [1:0] count;//
    reg acqFinish = 0;
    reg hisFinish = 0;
    reg [16:0]acq_counter = 0;
    reg num_per_ram = `PIXEL_NUM / `SRAM_NUM;
    //reg ress;
    //reg resLatch;
    //wire sel;
    //wire wrEn;
    assign wrEn = wrEnable[0];

    always @(posedge clk or negedge res) begin
        if (~res) begin
            acq_counter = 0;
            nextFlag = 0;
            hisFinish = 0;
        end
        else if (acq_counter == `num_acq-1) begin
            acq_counter = 0;
            nextFlag = ~nextFlag;
            hisFinish = 1;
        end
        else acq_counter = acq_counter + 1;
    end

    always @(posedge clk or negedge res) begin
        if (~res) begin
            count = 0;
        end
        else if(count < 3)
            count = count + 1;
            else if (count > `data_num) begin
                acqFinish = 1;
                count = 1;
            end
            else begin
                acqFinish = 0;
                count = 0;
            end
    end
            
    integer i;
    always @(posedge clk or negedge res) begin
        //resLatch = res ^ ress;// for the SR
        if (~res) begin //the SR are also reset by resLatch
            for (i = 0; i < `NumberOfBins; i=i+1) begin
                BRAM[i] = 0; //reset whole bram
                dataFinish = 2'b00;
                binCounts = 2'b00;
                stateRAM[i] = 0;
            end
            
        end
        else begin
            dataFinish[1] = wrEnable[1];
            if (wrEnable[0]) begin
                if (hisFinish) begin//if (acqFinish) begin
                    dataFinish[0] = 1;
                end
                else begin
                    if (stateRAM[addr]) begin //bin is already reseted before, + 1
                        binCounts = BRAM[addr] + 1; //output
                    end
                    else begin //init
                        binCounts = 1;
                        stateRAM[addr] = 1;
                    end
                    BRAM[addr] = binCounts; // save all into the BRAM
                end
            end
        end
    end    

endmodule