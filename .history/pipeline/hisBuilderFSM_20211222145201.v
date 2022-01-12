//*****************************************************************
//***** Target: pipelined SiFH algorithm realization (serial) *****
//*****     Authtor: Jia Shi Student number: 5218845          *****
//*****                   Date: 17/12/2021                    *****
//*****************************************************************

//*********************************BLOCK DIAGRAM OF THE SYSTEM************************************
//*****   _____________       ___________       _____________       _____________________   ******
//*****  |Data Filterer| --> |His Builder| --> |Peak Detecter|*-->*|Algebraic Calculation|  ******
//*****  |_____________|     |___________|     |_____________|     |_____________________|  ******
//*****          ^                                                             |            ******
//*****          |_____________________________________________________________|            ******
//*****                                                                                     ******
//************************************************************************************************


`include "parametersSiFH.vh"

module hisBuilderFSM
(
    input clk,
    input res, 
    input wrEn, 
    input [`Np - 1:0] data,
    output reg [((`Np)*(`PIXEL_NUM_PER_RAM)-1):0] result

);

    //**************INPUT/OUTPUT/RAM***************
    reg [(`peakMax - 1) : 0] BRAM [`BIN_NUM_PER_RAM - 1 : 0]; //RAM
    reg [`BIN_NUM_PER_RAM -1 : 0] stateRAM = 0; //SAVE THE STATE OF RAM :: 0 -> RESET NEEDED OR 1-> NO RESET NEEDED
    reg [`Nb-1:0] addr; //INPUT

    //**************BUFFERS***************
    reg [1:0] input_count = 0; //2
    reg [1:0] input_countt = 0; //2
    reg [7:0] pixel_count = 0; //200
    reg [7:0] pixel_countt = 0; //200
    reg [7:0] pixel_counttt = 0; //200
    reg [19:0] acq_count = 0; //33333
    reg inside_ress = 0;
    reg inside_resss = 0; //= 0;
    reg inside_res,inside_res1, iinside_res;
    reg peakDonee;
    reg [`Np - 1:0] dataa;

    //**************PEAK DETECTER***************
    reg [`peakMax-1:0] binCounts; // RESULT OF PEAK DETECTER
    reg [`peakMax-1 : 0] recentMax [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Nb-1:0] addrSaver [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np-1:0] peakResult [`PIXEL_NUM_PER_RAM -1 : 0];
    reg hisNumm;
    reg [`Nb-1:0] addrr;
    
    //**************STATE REG***************
    reg hisNum;
    reg combin_res;
    reg acq_count_finish;
    reg peakDone;
    reg [`PIXEL_NUM_PER_RAM -1 : 0] pixelCountFlag;

    //**************ALGEBRAIC CALCULATION***************
    reg [`Np - 1 : 0] TTHminus [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] TTHpositive [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] THminus [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] THpositive [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] delta [`PIXEL_NUM_PER_RAM -1 : 0];

    reg [`Np - 1 : 0] SB;
    reg [`Np - 1 : 0] CH [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] upperBound;
    //reg [`Nb - 1 : 0] upperBoundCH;
    reg [`Np - 1 : 0] maxBound;

    //**************OUTPUT RESULT***************
    integer y;
    always @(*) begin
        for (y = 0; y < (`PIXEL_NUM_PER_RAM); y=y+1) begin
            result[y*(`Np) +: `Np] = peakResult[y];
        end
    end

    //**************DATA FILTER (INPUT DATA PROCESSING)***************
    reg [`Np - 1:0] interData;
    // always @(*) begin
    //     if (hisNum == 0) begin //only the first Nb bits is read
    //         addr = data[`Np -1 :(`Np-`Nb)];
    //         interData = 0;
    //     end
    //     else begin
    //         if ((data>=THminus[pixel_count]) && (data<=THpositive[pixel_count]))begin
    //             interData = data>delta[pixel_count]? (data - delta[pixel_count]):0;
    //             addr = interData[`Nb - 1:0];
    //         end
    //         else
    //             addr = ~0;
    //     end
    // end

    always @(posedge clk) begin
        if (hisNum == 0) begin //only the first Nb bits is read
            //addr <= data[`Np -1 :(`Np-`Nb)];
            interData <= 0;
        end
        else begin
            if ((data>=THminus[pixel_count]) && (data<=THpositive[pixel_count]))begin
                interData <= dataa > delta[pixel_count]? (dataa - delta[pixel_count]):0;
                //addr = interData[`Nb - 1:0];
            end
            else begin
                interData <= 0;
            end
            // if ((data>=THminus[pixel_count]) && (data<=THpositive[pixel_count]))begin
            //     if (data > delta[pixel_count]) begin
            //         interData <= data - delta[pixel_count];
            //         addr = interData[`Nb - 1:0];
            //     end
            //     else begin
            //         addr <= ~0;
            //     end
            // end
            // else
            //     addr <= ~0;
        end
    end

    always @(*) begin
        if (hisNum == 0) begin //only the first Nb bits is read
            addr = data[`Np -1 :(`Np-`Nb)];
        end
        else begin
            if ((data>=THminus[pixel_count]) && (data<=THpositive[pixel_count]))begin
                addr = interData[`Nb - 1:0];
            end
            else
                addr = ~0;
        end
    end

    //**************STATE SIGNALS***************
    always @(*) begin
        iinside_res = inside_resss && ~inside_ress; ///write into another always block
        combin_res = res&&(~inside_res);
        peakDonee = hisNum && (~(hisNumm));//peakDonee = hisNum && (~(hisNumm));
    end

    //**************ALGEBRAIC CALCULATION***************
    integer x;
    always @(*) begin

        upperBound = ~0 ;
        //upperBoundCH = ~0;
        SB = 1'b1 << (`Nb - 1);
        maxBound = upperBound - 2*SB -1;

        // for (x = 0; x < (`PIXEL_NUM_PER_RAM); x=x+1) begin
        //     CH[x] = addrSaver[x] << (`Np - `Nb);
        //     TTHminus[x] = CH[x] - SB;//bound
        //     TTHpositive[x] = CH[x] + SB;//bound
        // end

        if (peakDonee == 1) begin
            for (x = 0; x < (`PIXEL_NUM_PER_RAM); x=x+1) begin
                CH[x] = addrSaver[x] << (`Np - `Nb);
                THminus[x] = TTHminus[x];
                THpositive[x] = TTHpositive[x];
                delta[x] = THminus[x];

                if (CH[x] > (upperBound - 2*SB - 1)) begin//(upperBoundCH - SB)) begin
                    TTHpositive[x] = upperBound;//upperBound - upperBoundCH;//wtf
                    TTHminus[x] = CH[x]*2 - upperBound;//TTHpositive[x] - 2* SB;
                end
                else begin
                    if (CH[x] <=  SB) begin
                        TTHminus[x] = 0;
                        TTHpositive[x] = TTHminus[x] + 2* SB;
                    end
                    else begin
                        TTHpositive[x] = CH[x] + SB;//wtf
                        TTHminus[x] = CH[x] - SB;
                        
                    end
                end 
            end

        end
        else begin
            for (x = 0; x < (`PIXEL_NUM_PER_RAM); x=x+1) begin
                THminus[x] = THminus[x];
                THpositive[x] = THpositive[x];
                delta[x] = delta[x];
            end
        end

        if ((inside_res1)&&(~hisNum)) begin
            for (x = 0; x < (`PIXEL_NUM_PER_RAM); x=x+1) begin
                peakResult[x] = addrSaver[x] + delta[x];
            end
        end
    end

    integer i;

    //**************BUFFERS***************
    always @(posedge clk) begin
        inside_res <= inside_res1;
        inside_ress <= inside_resss;
        inside_res1 <= iinside_res;
        peakDone <= peakDonee;
        addrr <= addr;
        
        hisNumm <= hisNum;
        pixel_countt <= pixel_count;
        pixel_counttt <= pixel_countt;
        input_countt <= input_count;
        dataa <= data;
    end

    //**************RESET WHOLE SYSTEM, ONLY HAPPEN WHEN A WHOLE FRAME IS DONE***************
    always @(posedge clk or negedge res) begin
        if (~res) begin
            hisNum <= 0;
            //inside_resss <= 0; 
        end
    end

    //**************HIS BUILDER & PEAK DETECTER***************
    always @(posedge clk or negedge combin_res) begin //combine res
        if (~combin_res) begin
            
            binCounts <= 0;
            input_count <= 0;
            pixel_count <= 0;

            acq_count <= 0;
            acq_count_finish <= 0;
            

            for (i = 0; i < (`BIN_NUM_PER_RAM); i=i+1) begin
                BRAM[i] <= 0; //reset whole bram
                stateRAM[i] <= 0;
            end 
            for (i = 0; i < (`PIXEL_NUM_PER_RAM); i=i+1) begin
                addrSaver[i] <= 0; //reset whole bram
                recentMax[i] <= 0;
                pixelCountFlag <= 0;
            end 

        end
            else begin
                if (addrr < 6'h3f) begin //make a max = ~0?????
                    recentMax[pixel_countt] <= (binCounts > recentMax[pixel_countt]) ? binCounts : recentMax[pixel_countt]; //SAVE THE VALUE OF ALL PIXELS
                    addrSaver[pixel_countt] <= (binCounts > recentMax[pixel_countt]) ? addrr : addrSaver[pixel_countt]; //SAVE THE VALUE OF ALL PIXELS
                end

                if (wrEn) begin
                    if ((hisNum) && (data>=THminus[pixel_count]) && (data<=THpositive[pixel_count])) begin
                        pixelCountFlag <= 0;
                    end
                    else pixelCountFlag <= 1;

                    if ((input_countt == 0)&&(pixel_count == 0)&&(acq_count == 0)) begin
                        inside_resss <= 0;
                    end

                    if (addr < ~0) begin
                        if (stateRAM[addr  + pixel_count*`BIN_NUM_PER_HIS]) begin
                            BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] <= BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] + 1;
                            binCounts <= BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] + 1;

                        end
                        else begin
                            BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] <= 1;
                            binCounts <= 1;
                            stateRAM[addr  + pixel_count*`BIN_NUM_PER_HIS] <= 1;
                        end
                    end

                    if (input_count < `DATA_NUM - 1) begin
                        input_count <= input_count + 1;
                    end
                    else begin
                        input_count <= 0;  
                    end
                    
                    if (input_countt == `DATA_NUM - 1) begin
                        if (pixel_count < `PIXEL_NUM_PER_RAM - 1) begin
                            pixel_count <= pixel_count + 1;
                        end
                        else begin
                            pixel_count <= 0;

                            if (acq_count < `ACQ_NUM - 1) begin
                                acq_count <= acq_count + 1;
                                if (acq_count == `ACQ_NUM - 2) begin
                                    acq_count_finish <= 1;
                                end
                            end        
                            else begin
                                if (acq_count == `ACQ_NUM - 1) begin
                                    acq_count_finish <= 1;
                                    if ((input_countt == `DATA_NUM - 1)&&(pixel_count == `PIXEL_NUM_PER_RAM - 1)) begin
                                        inside_resss <= 1;
                                        hisNum <= ~hisNum;
                                    end

                                    else begin
                                        if ((input_countt == `DATA_NUM - 2)&&(pixel_count == `PIXEL_NUM_PER_RAM - 1)) begin
                                            inside_resss <= 1;
                                        end

                                    end
                                end
                                acq_count <= 0;
                                
                            end 
                        end
                    end 
                end
            end

    end

endmodule