`include "parametersSiFH.vh"

module hisBuilderFSM
(
    input clk,
    input res, 
    input wrEn, //CH -> 2'b11 FH->2'b01
    input [`Nb:1] addr,
    //input hisNum, add the data processing part all in DF
    //output reg nextFlag,
    output reg [`peakMax-1:0] binCounts, //current single bin
    output reg acq_count_finish,  //CH -> 2'b11 FH->2'b01
    output reg hisNum,
    output reg [`Nb-1:0] peakCH,//[`Nb:1] peakCH, 
    output reg [`Nb:1] peakFH,
    output reg peakDone

);
    //reg [(`peakMax - 1) : 0] BRAM [`BIN_NUM_PER_RAM - 1 : 0];
    reg [(`peakMax - 1) : 0] BRAM [`BIN_NUM_PER_RAM - 1 : 0];
    reg [31:0] see;
    reg [`Nb:1] addr;

    parameter RESET_ALL = 2'b00, INPUT_COUNT = 2'b01, PIXEL_COUNT = 2'b10, ACQ_COUNT = 2'b11;
    reg [1:0] current_state, next_state;
    reg [1:0] input_count = 0; //2
    reg [7:0] pixel_count = 0; //200
    reg [7:0] pixel_countt = 0; //200
    reg [7:0] pixel_counttt = 0; //200
    reg [19:0] acq_count = 0; //33333
    reg input_count_finish, pixel_count_finish;//, acq_count_finish;
    reg inside_ress = 0;
    reg inside_resss = 0; //= 0;
    //reg inside_ress1 = 0;
    reg inside_res,inside_res1, iinside_res;
    reg wrEnn;
    reg combin_res;
    reg [`BIN_NUM_PER_RAM -1 : 0] stateRAM = 0;
    //reg [`PIXEL_NUM_PER_RAM -1 : 0] peakReg = 0;

    //**************PEAK FINDER***************
    reg [`peakMax-1 : 0] recentMax [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Nb-1:0] addrSaver [`PIXEL_NUM_PER_RAM -1 : 0];
    reg hisNumm;
    reg peakFlag = 0;
    reg peakFlagg;
    reg [`Nb:1] addrr;
    reg peakDonee;

    // assign binCounts = BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ];

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
    reg algebraicReadyy;
    // reg peakDonee;
    // reg peakFlag;

    reg algebraicReady;

    // //**************INPUT DATA PROCESSING***************
    always @(*) begin
        if (hisNum) begin
            addr = data>delta[pixel_count]?(data - delta[pixel_count]):0;
        end
        else begin
            addr = data;
        end
    end

    //**************ALGEBRAIC BLOCK***************
    integer x;
    always @(*) begin

        upperBound = ~0;
        upperBoundCH = ~0;
        SB = 1'b1 << (`Nb - 1);//) + (1'b1 << (`Nb - 2)); //use the middle value of bin
        //tmp = (1'b1 << (`Nb - 2));

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
                algebraicReady = algebraicReadyy;   
                if (CH[x] >=  (upperBound - SB)) begin
                    TTHpositive[x] = upperBound - upperBoundCH;//wtf
                    TTHminus[x] = TTHpositive[x] - 2* SB;
                    algebraicReadyy = 0;
                end
                else begin
                    if (CH[x] <=  SB) begin
                        TTHminus[x] = 0;
                        TTHpositive[x] = TTHminus[x] + 2* SB;
                        algebraicReadyy = 0;
                    end
                    else begin
                        TTHpositive[x] = CH[x] + SB;//wtf
                        TTHminus[x] = CH[x] - SB;
                        algebraicReadyy = 0;
                    end
                end 
            end

        end
        else begin
            for (x = 0; x < (`PIXEL_NUM_PER_RAM); x=x+1) begin
                THminus[x] = THminus[x];//[`Np:`Np-`Nb+1];
                THpositive[x] = THpositive[x];//[`Np:`Np-`Nb+1];
                delta[x] = delta[x];
                algebraicReady = algebraicReady; 
            end
  

        // else begin
        //     THminus = TTHminus;//[`Np:`Np-`Nb+1];
        //     THpositive = TTHpositive;//[`Np:`Np-`Nb+1];
        //     delta = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
        //     algebraicReady = algebraicReadyy;  
        end

    end

    always @(*) begin
        see = addr  + pixel_count*`BIN_NUM_PER_HIS;
        iinside_res = inside_resss && ~inside_ress; ///write into another always block
        combin_res = res&&(~inside_res);
        //peakCH = addrSaver;
    end

    always @(*) begin
        peakDonee = hisNum && (~(hisNumm));
    end

    integer i;

    always @(posedge clk or negedge res) begin
        if (~res) begin
            hisNum <= 0;
            inside_resss <= 0; //!!!!!!!!!where to put this
            // for (i = 0; i < (`BIN_NUM_PER_RAM); i=i+1) begin
            //     BRAM[i] <= 0;//`BIN_NUM_PER_RAM{1'd0}; //reset whole bram
            //     stateRAM[i] <= 0;
            //     //stateRAM[i] <= 0;
            // end 
            // for (i = 0; i < (`PIXEL_NUM_PER_RAM); i=i+1) begin
            //     addrSaver[i] <= 0;//`BIN_NUM_PER_RAM{1'd0}; //reset whole bram
            //     recentMax[i] <= 0;
            //     //stateRAM[i] <= 0;
            // end 
        end
    end

    always @(posedge clk) begin
        inside_res <= inside_res1;
        inside_ress <= inside_resss;
        inside_res1 <= iinside_res;
        peakDone <= peakDonee;
        addrr <= addr;
        
        wrEnn <= wrEn;  
    end

    always @(posedge clk) begin
        hisNumm <= hisNum;
        peakFlagg <= peakFlag;
        pixel_countt <= pixel_count;
        pixel_counttt <= pixel_countt;
    end

    always @(posedge clk or negedge combin_res) begin //combine res
        

        if (~combin_res) begin
            
            binCounts <= 0;
            // dataFinish <= 0;

            input_count <= 0;
            input_count_finish <= 0;

            pixel_count <= 0;
            pixel_count_finish <= 0;

            acq_count <= 0;
            acq_count_finish <= 0;

            // for (i = 0; i < (`BIN_NUM_PER_RAM); i=i+1) begin
            //     //BRAM[i] <= 0;//`BIN_NUM_PER_RAM{1'd0}; //reset whole bram
            //     stateRAM[i] <= 0;
            // end 
            for (i = 0; i < (`BIN_NUM_PER_RAM); i=i+1) begin
                BRAM[i] <= 0;//`BIN_NUM_PER_RAM{1'd0}; //reset whole bram
                stateRAM[i] <= 0;
                //stateRAM[i] <= 0;
            end 
            for (i = 0; i < (`PIXEL_NUM_PER_RAM); i=i+1) begin
                addrSaver[i] <= 0;//`BIN_NUM_PER_RAM{1'd0}; //reset whole bram
                recentMax[i] <= 0;
                //stateRAM[i] <= 0;
            end 

            peakCH <= 0;
            peakFH <= 0;
            // recentMax <= 0;
            // addrSaver <= 0;
            pixel_count <= 0;
            peakFlag <= 0;
            peakFlagg <= 0;
        end
            else begin
                recentMax[pixel_countt] <= (binCounts > recentMax[pixel_countt]) ? binCounts : recentMax[pixel_countt];
                addrSaver[pixel_countt] <= (binCounts > recentMax[pixel_countt]) ? addrr : addrSaver[pixel_countt];
                if (wrEn) begin
                    if (stateRAM[addr  + pixel_count*`BIN_NUM_PER_HIS]) begin
                        BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] <= BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] + 1;//[addr  + pixel_count*`ACQ_NUM + acq_count*(`PIXEL_NUM_PER_RAM)*(`ACQ_NUM)] + 1;
                        binCounts <= BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] + 1;//[(addr - 1)  + pixel_count*`Nb + acq_count*(`PIXEL_NUM_PER_RAM)*(`Nb)]; ////is it right???
                    
                    end
                    else begin
                        BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] <= 1;//[addr  + pixel_count*`ACQ_NUM + acq_count*(`PIXEL_NUM_PER_RAM)*(`ACQ_NUM)] + 1;
                        binCounts <= 1;//[(addr - 1)  + pixel_count*`Nb + acq_count*(`PIXEL_NUM_PER_RAM)*(`Nb)]; ////is it right???
                        stateRAM[addr  + pixel_count*`BIN_NUM_PER_HIS] <= 1;
                    end
                    if (input_count < `DATA_NUM - 1) begin
                        input_count <= input_count + 1;
                    end
                    else begin
                        input_count <= 0;  
                        input_count_finish <= 1;
                        if (pixel_count < `PIXEL_NUM_PER_RAM - 1) begin
                            pixel_count <= pixel_count + 1;
                            // if (pixel_count_finish) begin
                            //     peakReg[pixel_count] <= binCounts[pixel_count];//
                            // end
                            
                        end
                        else begin
                            pixel_count <= 0;
                            pixel_count_finish <= 1;
                            
                            if (acq_count < `ACQ_NUM - 1) begin
                                acq_count <= acq_count + 1;
                                if (acq_count == `ACQ_NUM - 2) begin
                                    acq_count_finish <= 1;
                                end
                                //acq_count_finish <= 0;
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
                                        // else begin
                                        //     inside_resss <= 0;
                                        // end
                                        //acq_count_finish <= 0;

                                    end
                                end
                                acq_count <= 0;
                                
                            end 
                        end
                    end    

                end
            end

    end

    // always @(posedge clk or negedge res) begin
    //     if (~res) begin
    //         binCounts <= 0;
    //         // dataFinish <= 0;
    //         hisNum <= 0;

    //         input_count <= 0;
    //         input_count_finish <= 0;

    //         pixel_count <= 0;
    //         pixel_count_finish <= 0;

    //         acq_count <= 0;
    //         acq_count_finish <= 0;

    //         for (i = 1; i <= `RAM_SIZE; i=i+1) begin
    //             BRAM[i] = 0; //reset whole bram
    //         end 
    //     end
    //         else begin
    //         if (wrEn) begin
    //             if (~input_count_finish) begin
    //                 input_count = input_count + 1;
    //             end
    //             else input_count = 0;        

    //             if (input_count_finish == 1) begin
    //                 pixel_count = pixel_count + 1;
    //             end  

    //             if (pixel_count_finish == 1) begin
    //                 acq_count = acq_count + 1;
    //             end  

    //             if (acq_count_finish == 1) begin
    //                 pixel_count = pixel_count + 1;
    //                 binCounts <= 0;
    //                 // dataFinish <= 0;
    //                 hisNum <= 0;

    //                 input_count <= 0;
    //                 input_count_finish <= 0;

    //                 pixel_count <= 0;
    //                 pixel_count_finish <= 0;

    //                 acq_count <= 0;
    //                 acq_count_finish <= 0;

    //                 for (i = 1; i <= `RAM_SIZE; i=i+1) begin
    //                     BRAM[i] = 0; //reset whole bram
    //                 end 

    //                 hisNum = ~hisNum;
    //             end        
    //         end
    //         end
    // end

    // always @(*) begin
    //     if (input_count > `DATA_NUM - 1) begin
    //         input_count_finish = 1;
    //     end
    //     if (pixel_count > `PIXEL_NUM_PER_RAM - 1) begin
    //         pixel_count_finish = 1;
    //     end
    //     if (acq_count > `ACQ_NUM - 1) begin
    //         acq_count_finish = 1;
    //         hisNum = ~hisNum;
    //     end
    // end

    // always @(posedge clk or negedge res) begin
    //     if (~res) begin
    //         current_state = RESET_ALL;
    //     end
    //         else
    //         current_state <= next_state;
    // end

    // integer i;
    // always @(*) begin
    //     case (current_state)
    //         RESET_ALL:begin
    //             next_state = INPUT_COUNT;
    //         end 
    //         INPUT_COUNT:begin
    //             if (input_count_finish == 1) begin
    //                 next_state = PIXEL_COUNT;
    //             end
    //             else
    //             next_state = INPUT_COUNT;
    //         end
    //         PIXEL_COUNT:begin
    //             if (pixel_count_finish == 1) begin
    //                 next_state = ACQ_COUNT;
    //             end
    //             else 
    //             next_state = INPUT_COUNT;
    //         end
    //         ACQ_COUNT:begin
    //             if (acq_count_finish == 1) begin
    //                 next_state = RESET_ALL;
    //             end
    //             else 
    //             next_state = INPUT_COUNT;
    //         end
    //         default: next_state = RESET_ALL;
    //     endcase
    // end

    // always @(posedge clk or negedge res) begin
    //     if (~res) begin
    //         binCounts <= 0;
    //         // dataFinish <= 0;
    //         hisNum <= 0;

    //         input_count <= 0;
    //         input_count_finish <= 0;

    //         pixel_count <= 0;
    //         pixel_count_finish <= 0;

    //         acq_count <= 0;
    //         acq_count_finish <= 0;
    //     end
    //     else begin
    //         case (current_state)
    //             RESET_ALL:begin
    //                 for (i = 1; i <= `RAM_SIZE; i=i+1) begin
    //                     BRAM[i] = 0; //reset whole bram
    //                 end  

    //                 input_count <= 0;
    //                 input_count_finish <= 0;

    //                 pixel_count <= 0;
    //                 pixel_count_finish <= 0;

    //                 acq_count <= 0;
    //                 acq_count_finish <= 0;
    //             end 
    //             INPUT_COUNT:begin
    //                 input_count = input_count + 1;
    //                 if (input_count > `DATA_NUM - 1) begin
    //                     input_count_finish = 1;
    //                 end
    //             end
    //             PIXEL_COUNT:begin
    //                 pixel_count = pixel_count + 1;
    //                 input_count_finish <= 0;
    //                 input_count <= 0;
    //                 if (pixel_count > `PIXEL_NUM_PER_RAM - 1) begin
    //                     pixel_count_finish = 1;
    //                 end
    //             end
    //             ACQ_COUNT:begin
    //                 acq_count = acq_count + 1;
    //                 pixel_count_finish <= 0;
    //                 input_count_finish <= 0;
    //                 input_count <= 0;
    //                 pixel_count <= 0;
    //                 if (acq_count > `ACQ_NUM - 1) begin
    //                     acq_count_finish = 1;
    //                     hisNum = ~hisNum;
    //                 end
    //             end
    //             default: begin
    //                 for (i = 1; i <= `RAM_SIZE; i=i+1) begin
    //                     BRAM[i] = 0; //reset whole bram
    //                 end  
    //             end 
    //         endcase
    //     end
    // end
    
// `probe(BRAM);
endmodule