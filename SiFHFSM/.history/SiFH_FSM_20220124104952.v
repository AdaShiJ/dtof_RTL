`include "parametersSiFH.vh"

module SiFH_FSM (
    input clk,
    input res,
    input wrEn,
    input [`Np - 1:0] data,

    input [`peakMax-1:0] counts, //output b
    output [`Nb-1:0] waddr, //addra
    output [`Nb-1:0] raddr, //addrb
    output reg wEnable, //a 1-> Enable
    output reg rEnable, //b 0-> Enable

    output reg [`peakMax-1:0] newCounts,
    output reg [`Np-1:0] peakResult [`PIXEL_NUM_PER_RAM -1 : 0]
);

//**************INPUT/OUTPUT/RAM***************
reg [`Np - 1:0] inputData; //latch the input
wire [`Nb-1:0] addr; //INPUT FOR HIS1

//**************STATE REG***************
localparam IDLE = 3'd0;
localparam M0 = 3'd1;
localparam M1 = 3'd2;
localparam M2 = 3'd3;
localparam M3 = 3'd4;
localparam M4 = 3'd5;
localparam M5 = 3'd6;
localparam WAIT = 3'd7;

reg [2:0] current_state;
reg [2:0] next_state;

endmodule