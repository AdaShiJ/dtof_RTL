`include "parametersSiFH.vh"

module peakDetecter (
    ports
);
    
endmodule


M3: begin
                if (counter == 0) begin //read the first addr only
                readFlag    <= 1;
                rEnable     <= 1;
                raddr       <= 0;
                writeFlag   <= 1;
                wEnable     <= 1;
                waddr       <= 0; //save the addr of max counts into addr0
                newCounts   <= 0;
                counter     <= counter + 1;
                pixelCounter<=pixelCounter + 1;
            end
            
            M4: begin
                if (counter == 1) begin
                    readFlag    <= 1;
                    rEnable     <= 1;
                    raddr       <= raddr + 1;
                    maxCounts   <= counts; //save the result of first bin
                    
                    writeFlag   <= 1;
                    wEnable     <= 1;
                    waddr       <= 0;
                    newCounts   <= 0; 
                    
                    counter     <= counter + 1;
                end
                else begin //beside the first one and the last one
                    readFlag    <= 1;
                    rEnable     <= 1;
                    raddr       <= raddr + 1;

                    counter     <= counter + 1;
                    if (maxCounts   < counts) begin
                        maxCounts   <= counts;
                        writeFlag   <= 1;
                        wEnable     <= 1;
                        waddr       <= 0;
                        newCounts   <= addrr; 
                    end
                end
            end


            M5: begin
                if (pixelCounter == (`PIXEL_NUM_PER_RAM)) begin //last bin in SRAM
                    findFinish  <= 1; //only difference
                    if (maxCounts   < counts) begin
                        maxCounts   <= counts;
                        writeFlag   <= 1;
                        wEnable     <= 1;
                        waddr       <= 0;
                        newCounts   <= addrr; 
                    end
                end
                else begin //start from M4 for the next pixel
                    readFlag    <= 1;
                    rEnable     <= 1;
                    raddr       <= 0;
                    counter     <= 1;
                    if (maxCounts   < counts) begin
                        maxCounts   <= counts;
                        writeFlag   <= 1;
                        wEnable     <= 1;
                        waddr       <= 0;
                        newCounts   <= addrr; 
                    end
                end
            end

            M6: begin
                
            end