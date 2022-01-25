`include "parametersSiFH.vh"

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

    output reg wrEn,
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

//**************hisBuilder REG***************

always @(*) begin
    case (current_state)
        IDLE: //IDLE
                if (conditions) begin
                    
                end
        M0://build his1
        M1://find peak
        M2://calculate filter
        M3://build his2
        M4://find peak
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

hisBuilderFSM hisBuilderFSM (
    .clk(clk),
    .res(res),
    .wrEn(wrEn),
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