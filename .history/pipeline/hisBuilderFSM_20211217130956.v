`include "parametersSiFH.vh"

module hisBuilderFSM
(
    input clk,
    input res, 
    input wrEn, //CH -> 2'b11 FH->2'b01
    input [`Np - 1:0] data,
    output reg [((`Np)*(`PIXEL_NUM_PER_RAM)-1):0] result

);

    //**************INPUT/OUTPUT/RAM***************
    reg [(`peakMax - 1) : 0] BRAM [`BIN_NUM_PER_RAM - 1 : 0]; //RAM
    reg [`BIN_NUM_PER_RAM -1 : 0] stateRAM = 0; //SAVE THE STATE OF RAM :: 0 -> RESET NEEDED OR 1-> NO RESET NEEDED
    reg [`Nb-1:0] addr; //INPUT

    //**************BUFFERS***************
    reg [1:0] input_count = 0; //2
    reg [7:0] pixel_count = 0; //200
    reg [7:0] pixel_countt = 0; //200
    reg [7:0] pixel_counttt = 0; //200
    reg [19:0] acq_count = 0; //33333
    //reg input_count_finish;
    //reg pixel_count_finish;//, acq_count_finish;
    reg inside_ress = 0;
    reg inside_resss = 0; //= 0;
    reg inside_res,inside_res1, iinside_res;
    reg peakDonee;
    //reg wrEnn;
    
    //**************PEAK DETECTER***************
    reg [`peakMax-1:0] binCounts; // RESULT OF PEAK DETECTER
    reg [`peakMax-1 : 0] recentMax [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Nb-1:0] addrSaver [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np-1:0] peakResult [`PIXEL_NUM_PER_RAM -1 : 0];
    reg hisNumm;
    //reg hisNummm;
    //reg peakFlag = 0;
    //reg peakFlagg;
    reg [`Nb-1:0] addrr;
    
    

    //**************STATE REG***************
    reg hisNum;
    reg combin_res;
    reg acq_count_finish;
    reg peakDone;

    //**************ALGEBRAIC BLOCK***************
    reg [`Np - 1 : 0] TTHminus [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] TTHpositive [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] THminus [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] THpositive [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] delta [`PIXEL_NUM_PER_RAM -1 : 0];

    reg [`Np - 1 : 0] SB;
    reg [`Np - 1 : 0] CH [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] upperBound;
    reg [`Nb - 1 : 0] upperBoundCH;

    //reg algebraicReady;

    //**************OUTPUT RESULT***************
    integer y;
    always @(*) begin
        for (y = 0; y < (`PIXEL_NUM_PER_RAM); y=y+1) begin
            result[y*(`Np) +: `Np] = peakResult[y];
            //result[(y*(`Np)+(`Np-1)) : y*(`Np)] = peakResult[y];
        end
    end

    //**************INPUT DATA PROCESSING***************
    reg [`Np - 1:0] interData;
    always @(*) begin
        if (hisNum == 0) begin //only the first Nb bits is read
            addr = data[`Np -1 :(`Np-`Nb)];
            interData = 0;
        end
        else begin
            if ((data>=THminus[pixel_count]) && (data<=THpositive[pixel_count]))begin
                interData = data>delta[pixel_count]? (data - delta[pixel_count]):0;
                addr = interData[`Nb - 1:0];//[`Np:(`Np-`Nb+1)];
            end
            else
                addr = 0;
        end
    end

    //**************STATE SIGNALS***************
    always @(*) begin
        iinside_res = inside_resss && ~inside_ress; ///write into another always block
        combin_res = res&&(~inside_res);
        peakDonee = hisNum && (~(hisNumm));
    end

    // //**************GENERATE INTERNAL RESET SIGNAL***************

    // always @(*) begin
    //     peakDonee = hisNum && (~(hisNumm));
    // end


    //**************ALGEBRAIC BLOCK***************
    integer x;
    always @(*) begin

        upperBound = ~0;
        upperBoundCH = ~0;
        SB = 1'b1 << (`Nb - 1);//) + (1'b1 << (`Nb - 2)); //use the middle value of bin

        for (x = 0; x < (`PIXEL_NUM_PER_RAM); x=x+1) begin
            CH[x] = addrSaver[x] << (`Np - `Nb);// + (1'b1 << (`Nb - 2));
            TTHminus[x] = CH[x] - SB;//bound
            TTHpositive[x] = CH[x] + SB;//bound
        end

        if (peakDone == 1) begin

            for (x = 0; x < (`PIXEL_NUM_PER_RAM); x=x+1) begin
                THminus[x] = TTHminus[x];//[`Np:`Np-`Nb+1];
                THpositive[x] = TTHpositive[x];//[`Np:`Np-`Nb+1];
                delta[x] = THminus[x];// + THpositive - ((THpositive >> `Nb) << `Nb) ;

                if (CH[x] >=  (upperBound - SB)) begin
                    TTHpositive[x] = upperBound - upperBoundCH;//wtf
                    TTHminus[x] = TTHpositive[x] - 2* SB;
                    //algebraicReady = 0;//algebraicReadyy = 0;
                end
                else begin
                    if (CH[x] <=  SB) begin
                        TTHminus[x] = 0;
                        TTHpositive[x] = TTHminus[x] + 2* SB;
                        //algebraicReady = 0;//algebraicReadyy = 0;
                    end
                    else begin
                        TTHpositive[x] = CH[x] + SB;//wtf
                        TTHminus[x] = CH[x] - SB;
                        //algebraicReady = 0;//algebraicReadyy = 0;
                    end
                end 
            end

        end
        else begin
            for (x = 0; x < (`PIXEL_NUM_PER_RAM); x=x+1) begin
                THminus[x] = THminus[x];//[`Np:`Np-`Nb+1];
                THpositive[x] = THpositive[x];//[`Np:`Np-`Nb+1];
                delta[x] = delta[x];
                //algebraicReady = algebraicReady; 
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
        
        //wrEnn <= wrEn;  
        hisNumm <= hisNum;
        //hisNummm <= hisNumm;
        //peakFlagg <= peakFlag;
        pixel_countt <= pixel_count;
        pixel_counttt <= pixel_countt;
    end

    // always @(posedge clk) begin
    //     hisNumm <= hisNum;
    //     //hisNummm <= hisNumm;
    //     //peakFlagg <= peakFlag;
    //     pixel_countt <= pixel_count;
    //     pixel_counttt <= pixel_countt;
    // end

    //**************RESET WHOLE SYSTEM, ONLY HAPPEN WHEN A WHOLE FRAME IS DONE***************
    always @(posedge clk or negedge res) begin
        if (~res) begin
            hisNum <= 0;
            inside_resss <= 0; //!!!!!!!!!where to put this
        end
    end

    always @(posedge clk or negedge combin_res) begin //combine res
        

        if (~combin_res) begin
            
            binCounts <= 0;

            input_count <= 0;
            //input_count_finish <= 0;

            pixel_count <= 0;
            pixel_count_finish <= 0;

            acq_count <= 0;
            acq_count_finish <= 0;

            for (i = 0; i < (`BIN_NUM_PER_RAM); i=i+1) begin
                BRAM[i] <= 0; //reset whole bram
                stateRAM[i] <= 0;
            end 
            for (i = 0; i < (`PIXEL_NUM_PER_RAM); i=i+1) begin
                addrSaver[i] <= 0; //reset whole bram
                recentMax[i] <= 0;
            end 

            pixel_count <= 0;
            //peakFlag <= 0;
            //peakFlagg <= 0;
        end
            else begin
                recentMax[pixel_countt] <= (binCounts > recentMax[pixel_countt]) ? binCounts : recentMax[pixel_countt];
                addrSaver[pixel_countt] <= (binCounts > recentMax[pixel_countt]) ? addrr : addrSaver[pixel_countt];

                if (wrEn) begin
                    if ((input_count == 0)&&(pixel_count == 0)&&(acq_count == 0)) begin
                        inside_resss <= 0;
                    end

                    if (stateRAM[addr  + pixel_count*`BIN_NUM_PER_HIS]) begin
                        BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] <= BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] + 1;
                        binCounts <= BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] + 1;
                    
                    end
                    else begin
                        BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] <= 1;
                        binCounts <= 1;
                        stateRAM[addr  + pixel_count*`BIN_NUM_PER_HIS] <= 1;
                    end
                    if (input_count < `DATA_NUM - 1) begin
                        input_count <= input_count + 1;
                    end
                    else begin
                        input_count <= 0;  
                        //input_count_finish <= 1;
                        if (pixel_count < `PIXEL_NUM_PER_RAM - 1) begin
                            pixel_count <= pixel_count + 1;
                        end
                        else begin
                            pixel_count <= 0;
                            pixel_count_finish <= 1;
                            
                            if (acq_count < `ACQ_NUM - 1) begin
                                acq_count <= acq_count + 1;
                                if (acq_count == `ACQ_NUM - 2) begin
                                    acq_count_finish <= 1;
                                end
                            end        
                            else begin
                                if (acq_count == `ACQ_NUM - 1) begin
                                    acq_count_finish <= 1;
                                    if ((input_count == `DATA_NUM - 1)&&(pixel_count == `PIXEL_NUM_PER_RAM - 1)) begin
                                        inside_resss <= 1;
                                        hisNum <= ~hisNum;
                                    end

                                    else begin
                                        if ((input_count == `DATA_NUM - 2)&&(pixel_count == `PIXEL_NUM_PER_RAM - 1)) begin
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