`include "parametersSiFH.vh"

module hisBuilderFSM (
    input clk,
    input res,
    //input wrEn,
    input [`Nb - 1:0] addr,

    input [`peakMax-1:0] counts, //output b
    
    output reg [`RAM_ADDR-1:0] waddr, //addra
    output reg [`RAM_ADDR-1:0] raddr, //addrb
    output reg wEnable, //a 1-> Enable
    output reg rEnable, //b 0-> Enable
    output reg writeFlag, //mea
    output reg readFlag, //meb memory enable

    //output reg wrEn,
    output reg [`peakMax-1:0] newCounts,
    output reg hisBuildDone
    //output reg [`Np-1:0] peakResult [`PIXEL_NUM_PER_RAM -1 : 0]
);

//**************STATE REG***************
localparam IDLE = 3'd0; //IDLE
localparam M0 = 3'd1; //first data
localparam M1 = 3'd2; //other data 
localparam M2 = 3'd3; //write last data
// localparam M3 = 4'd4;
// localparam M4 = 4'd5;
// localparam M5 = 4'd6;
// localparam M5 = 4'd6;
// localparam M7 = 4'd7;
// localparam RESET = 4'd8;

reg [2:0] current_state = 3'b0;
reg [2:0] next_state = 3'b0;
reg [23:0] counter = 0;
reg [7:0] pixelCounter = 0;

reg readFinish;
reg findFinish;
reg resetFlag = 0;

reg insideCounter = 0;
reg [`Nb-1:0] addrr;

reg [7:0] maxCounts;

always @(posedge clk or negedge res) begin
    addrr <= addr;
    if (~res) begin
        resetFlag <= 1;
    end
end

always @(*) begin
    case (current_state)
        IDLE: 
                if (wrEn) next_state = M1;
                    else    next_state = IDLE;
        M0:   
                next_state = M1;
        M1:   
                if (readFinish) begin
                    next_state = M2;
                end
                    else next_state = M1;
        M2:      
                next_state = IDLE;//next_state = M3;
        // M3:   
        //         next_state = M4;
        //         // if (findFinish) begin
        //         //     next_state = M4;
        //         // end
        //         //     else next_state = M3;
        // M4:      
        //         if (counter == (`BIN_NUM_PER_RAM - 1)) begin
        //             next_state = M5;
        //         end
        //             else next_state = M4;
        // M5:     //last bin of each pixel's histogram
        //         if (findFinish) begin
        //             next_state = M0;
        //         end
        //             else next_state = M4;
        // RESET:
        //         if (wrEn) next_state = M0;
        //             else    next_state = RESET;
        // M6:
        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge res) begin
    if (~res) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

integer i;
always @(posedge clk or negedge res) begin
    if (~res) begin
            waddr       <= 0; //addra
            raddr       <= 0; //addrb
            wEnable     <= 0; //a 1-> Enable
            rEnable     <= 0; //b 0-> Enable
            writeFlag   <= 0;
            readFlag    <= 0; //memory enable
            readFinish  <= 0;
            findFinish  <= 0;
            insideCounter <= 0;
            counter     <= 0;
    end

    else begin
        case (current_state)
            IDLE: begin
                raddr       <= 0;
                readFlag    <= 0;
                rEnable     <= 0;
                writeFlag   <= 0;
                wEnable     <= 0;
                readFinish  <= 0;
                findFinish  <= 0;
                counter     <= 0;
                hisBuildDone<= 0;
            end

            // RESET:begin //read pixel 0 addr 0, read only
            //     resetFlag   <= 0;
            //     readFlag    <= 0;
            //     rEnable     <= 0;
            //     //raddr       <= 0; //addrb

            //     writeFlag   <= 1;
            //     wEnable     <= 1;
            //     waddr       <= addrr;
            //     newCounts   <= 0;
                
            //     if (counter == 0) begin
            //         waddr       <= 0; //addra
            //         wEnable     <= 1;
            //     end
            //     else begin
            //         waddr       <= waddr + 1; //addra
            //         wEnable     <= 1; 
            //     end
            //     if (waddr == (`BIN_NUM_PER_HIS*`PIXEL_NUM_PER_RAM - 1)) begin
            //         wrEn <= 1;
            //         counter     <= 0;
            //     end
            //         else begin
            //             wrEn <= 0;
            //             counter     <= counter + 1;
            //         end 
            //     end

            M0: begin //read pixel 0 addr 0, read only
                readFlag    <= 0;
                rEnable     <= 0;
                //raddr       <= 0; //addrb
                raddr       <= addr;

                writeFlag   <= 0;
                wEnable     <= 0;
                // writeFlag   <= 1;
                // wEnable     <= 1;
                // waddr       <= addrr;
                // newCounts   <= 1;
                counter     <= counter + 1;
                hisBuildDone<= 0;
                //counter     <= 0;
            end

            M1: begin //read + write
                readFlag    <= 1;
                rEnable     <= 1;
                raddr       <= addr; //addrb

                writeFlag   <= 1;
                wEnable     <= 1;
                waddr       <= addrr;
                newCounts   <= counts + 1;
                counter     <= counter + 1;
                if (counter == `ACQ_NUM*`addr_NUM*`PIXEL_NUM_PER_RAM - 2) begin
                    readFinish <= 1;
                end
                hisBuildDone<= 0;
            end

            M2: begin //write pixel n addr1, write only
                readFlag    <= 0;
                rEnable     <= 0;
                //raddr       <= addr; //addrb

                writeFlag   <= 1;
                wEnable     <= 1;
                waddr       <= addrr;
                newCounts   <= counts + 1;
                counter     <= 0;//counter + 1;
                hisBuildDone<= 1;
            end

            // M3: begin
            //     if (counter == 0) begin //read the first addr only
            //     readFlag    <= 1;
            //     rEnable     <= 1;
            //     raddr       <= 0;
            //     writeFlag   <= 1;
            //     wEnable     <= 1;
            //     waddr       <= 0; //save the addr of max counts into addr0
            //     newCounts   <= 0;
            //     counter     <= counter + 1;
            //     pixelCounter<=pixelCounter + 1;
            // end
            
            // M4: begin
            //     if (counter == 1) begin
            //         readFlag    <= 1;
            //         rEnable     <= 1;
            //         raddr       <= raddr + 1;
            //         maxCounts   <= counts; //save the result of first bin
                    
            //         writeFlag   <= 1;
            //         wEnable     <= 1;
            //         waddr       <= 0;
            //         newCounts   <= 0; 
                    
            //         counter     <= counter + 1;
            //     end
            //     else begin //beside the first one and the last one
            //         readFlag    <= 1;
            //         rEnable     <= 1;
            //         raddr       <= raddr + 1;

            //         counter     <= counter + 1;
            //         if (maxCounts   < counts) begin
            //             maxCounts   <= counts;
            //             writeFlag   <= 1;
            //             wEnable     <= 1;
            //             waddr       <= 0;
            //             newCounts   <= addrr; 
            //         end
            //     end
            // end


            // M5: begin
            //     if (pixelCounter == (`PIXEL_NUM_PER_RAM)) begin //last bin in SRAM
            //         findFinish  <= 1; //only difference
            //         if (maxCounts   < counts) begin
            //             maxCounts   <= counts;
            //             writeFlag   <= 1;
            //             wEnable     <= 1;
            //             waddr       <= 0;
            //             newCounts   <= addrr; 
            //         end
            //     end
            //     else begin //start from M4 for the next pixel
            //         readFlag    <= 1;
            //         rEnable     <= 1;
            //         raddr       <= 0;
            //         counter     <= 1;
            //         if (maxCounts   < counts) begin
            //             maxCounts   <= counts;
            //             writeFlag   <= 1;
            //             wEnable     <= 1;
            //             waddr       <= 0;
            //             newCounts   <= addrr; 
            //         end
            //     end
            // end

            // M6: begin //send out the peak result
                
            // end
        endcase
    end
end

endmodule

