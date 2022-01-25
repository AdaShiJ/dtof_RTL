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


always @(*) begin
    case (current_state)
        IDLE: //IDLE
        M0://build his1
        M1://find peak
        M2://calculate filter
        M3://build his2
        M4://find peak
    endcase
end

hisBuilderFSM hisBuilderFSM (
    .clk(clk),
    .res(res),
    .wrEn(wrEn),
    .data(data),

    .counts(counts), //output b
    .waddr(waddr), //addra
    .raddr(raddr), //addrb
    .wEnable(wEnable), //a 1-> Enable
    .rEnable(rEnable), //b 0-> Enable
    .writeFlag(writeFlag), //mea
    .readFlag(readFlag), //meb memory enable

    .newCounts(newCounts)//,
    //.peakResult(peakResult)
);
    
endmodule