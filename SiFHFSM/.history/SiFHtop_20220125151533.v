`include "parametersSiFH.vh"

//there are two SRAMs, one save histogram and the max bin value, another one save TH+ and TH-
module SiFHtop (
    input clk,
    input res,
    //input wrEn,
    input [`Np - 1:0] data,

    input [`peakMax-1:0] counts, //output b
    
    output reg [`RAM_ADDR-1:0] waddr, //addra
    output reg [`RAM_ADDR-1:0] raddr, //addrb
    output reg wEnable, //a 1-> Enable
    output reg rEnable, //b 0-> Enable
    output reg writeFlag, //mea
    output reg readFlag, //meb memory enable

    output reg wrEn, //give to TDC
    output reg [`peakMax-1:0] newCounts//,
    //output reg [`Np-1:0] peakResult [`PIXEL_NUM_PER_RAM -1 : 0]
);

//**************STATE REG***************
localparam IDLE = 3'd0;
localparam M0 = 3'd1;
localparam M1 = 3'd2;
localparam M2 = 3'd3;
localparam M3 = 3'd4;
localparam M4 = 4'd5;
localparam RESET = 4'd6;

reg resetHis = 1;
reg [23:0] counter = 0;
reg wrEnHis = 1;

//**************hisBuilder REG***************

always @(*) begin
    case (current_state)
        IDLE: //IDLE
                if (~res) begin
                    next_state = RESET;
                end
                else next_state = IDLE;
        M0://build his1
        M1://find peak
        M2://calculate filter
        M3://build his2
        M4://find peak
        RESET://reset the whole SRAM
    endcase
end

always @(posedge clk or negedge res) begin
    if (~res) begin
        current_state <= RESET;
    end
    else begin
        current_state <= next_state;
    end
end

always @(posedge clk or negedge res) begin
    if (~res) begin
            waddr       <= 0; //addra
            raddr       <= 0; //addrb
            wEnable     <= 0; //a 1-> Enable
            rEnable     <= 0; //b 0-> Enable
            writeFlag   <= 0;
            readFlag    <= 0; //memory enable

    end
    else begin
        case (current_state)
            RESET:begin //read pixel 0 data 0, read only
                resetFlag   <= 0;
                readFlag    <= 0;
                rEnable     <= 0;
                //raddr       <= 0; //addrb

                writeFlag   <= 1;
                wEnable     <= 1;
                waddr       <= addrr;
                newCounts   <= 0;
                
                if (counter == 0) begin
                    waddr       <= 0; //addra
                    wEnable     <= 1;
                end
                else begin
                    waddr       <= waddr + 1; //addra
                    wEnable     <= 1; 
                end
                if (waddr == (`BIN_NUM_PER_HIS*`PIXEL_NUM_PER_RAM - 1)) begin
                    wrEn <= 1;
                    counter     <= 0;
                end
                    else begin
                        wrEn <= 0;
                        counter     <= counter + 1;
                    end 
                end
            IDLE: begin
                raddr       <= 0;
                readFlag    <= 0;
                rEnable     <= 0;
                writeFlag   <= 0;
                wEnable     <= 0;
                counter     <= 0;
            end
        endcase
    end

end

hisBuilderFSM hisBuilderFSM (
    .clk(clk),
    .res(res),
    .wrEn(wrEnHis),
    .data(dataHis),

    .counts(countsHis), //output b
    .waddr(waddrHis), //addra
    .raddr(raddrHis), //addrb
    .wEnable(wEnableHis), //a 1-> Enable
    .rEnable(rEnableHis), //b 0-> Enable
    .writeFlag(writeFlagHis), //mea
    .readFlag(readFlagHis), //meb memory enable

    .newCounts(newCountsHis),
    hisBuildDone
    //.peakResult(peakResult)
);
    
endmodule