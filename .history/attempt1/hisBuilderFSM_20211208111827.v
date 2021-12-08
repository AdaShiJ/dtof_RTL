`include "parametersSiFH.vh"

module hisBuilderFSM
(
    input clk,
    input res, 
    input wrEnable, //CH -> 2'b11 FH->2'b01
    input [`Nb:1] addr,
    //input hisNum, add the data processing part all in DF
    output reg nextFlag,
    output reg [`peakMax-1:0] binCounts, //current single bin
    output reg dataFinish,  //CH -> 2'b11 FH->2'b01
    output reg hisNum

);
    reg [`RAM_SIZE : 1] BRAM [(`peakMax - 1) : 0];
    reg [`NUM_PER_RAM : 1] stateRAM = 0;
    reg [`peakMax-1 : 0] addrSaver = 0;
    reg [1:0] count;
    reg acqFinish = 0;
    reg hisFinish = 0;
    reg [16:0]acq_counter = 0;
    reg [8:0]pixel_count = 0;

    assign wrEn = wrEnable[0];

    always @(posedge clk or negedge res) begin
        if (~res) begin
            acq_counter = 0;
            nextFlag = 0;
            hisFinish = 0;
        end
        else if (acq_counter == `ACQ_NUM_PER_RAM-1) begin
            acq_counter = 0;
            nextFlag = ~nextFlag;
            hisFinish = 1;
            pixel_count = pixel_count + 1;
        end
        else acq_counter = acq_counter + 1;
    end

    always @(posedge clk or negedge res) begin
        if (~res) begin
            count = 0;
        end
        else if(count < 3)
            count = count + 1;
            else if (count > `DATA_NUM) begin
                acqFinish = 1;
                count = 1;
            end
            else begin
                acqFinish = 0;
                count = 0;
            end
    end
            
    integer i;
    integer num;
    always @(posedge clk or negedge res) begin
        //resLatch = res ^ ress;// for the SR
        if (~res) begin //the SR are also reset by resLatch
            for (num = 1; num <= `PIXEL_PER_RAM; num = num + 1) begin
                for (i = 0; i < `NUM_PER_RAM; i=i+1) begin
                    BRAM[(num-1)*(`Nb)+1+i] = 0; //reset whole bram
                    dataFinish = 2'b00;
                    binCounts = 2'b00;
                    stateRAM[(num-1)*(`Nb)+1+i] = 0;
                end                
            end
        end
        else begin
            dataFinish[1] = wrEnable[1];
            if (wrEnable[0]) begin
                if (hisFinish) begin//if (acqFinish) begin
                    dataFinish[0] = 1;
                end
                else begin
                    if (stateRAM[addr + (pixel_count * `peakMax)]) begin //bin is already reseted before, + 1
                        binCounts = BRAM[addr] + 1; //output
                    end
                    else begin //init
                        binCounts = 1;
                        stateRAM[addr + (pixel_count * `peakMax)] = 1;
                    end
                    BRAM[addr + (pixel_count * `peakMax)] = binCounts; // save all into the BRAM
                end
            end
        end              
    end


endmodule