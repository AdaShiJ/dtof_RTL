`include "parametersSiFH.vh"

module SiFH_FSM (
    input clk,
    input res,
    input wrEn,
    input [`Np - 1:0] data,

    input [`peakMax-1:0] counts, //output b
    
    output reg [`Nb-1:0] waddr, //addra
    output reg [`Nb-1:0] raddr, //addrb
    output reg wEnable, //a 1-> Enable
    output reg rEnable, //b 0-> Enable
    output reg writeFlag, //mea
    output reg readFlag, //meb memory enable

    output reg [`peakMax-1:0] newCounts//,
    //output reg [`Np-1:0] peakResult [`PIXEL_NUM_PER_RAM -1 : 0]
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

reg [2:0] current_state = 3'b0;
reg [2:0] next_state = 3'b0;
reg [23:0] counter = 0;

reg readFinish;
reg findFinish;

reg insideCounter = 0;
reg [`Nb-1:0] addrr;

always @(posedge clk or negedge res) begin
    addrr <= addr;
end

always @(*) begin
    case (current_state)
        IDLE: if (wrEn) next_state = M0;
                else    next_state = IDLE;
        M0:   next_state = M1;
        M1:   if (readFinish) begin
                next_state = M2;
              end
              else next_state = M1;
        M2:      next_state = IDLE;//next_state = M3;
        M3:   if (findFinish) begin
                next_state = M4;
              end
               else next_state = M3;
        M4:      next_state = M5;
        M5:   if (wrEn) begin
                next_state = M0;
              end
              else next_state = M5;
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
        case (next_state)
            IDLE: begin
                raddr       <= 0;
                readFlag    <= 0;
                rEnable     <= 0;
                writeFlag   <= 0;
                wEnable     <= 0;
                readFinish  <= 0;
                findFinish  <= 0;
                counter     <= 0;
            end
            M0: begin //read pixel 0 data 0, read only
                readFlag    <= 0;
                rEnable     <= 0;
                //raddr       <= 0; //addrb

                writeFlag   <= 1;
                wEnable     <= 1;
                waddr       <= addrr;
                newCounts   <= 1;
                counter     <= counter + 1;
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


            end
            M2: begin //write pixel n data1, write only
                readFlag    <= 0;
                rEnable     <= 0;
                //raddr       <= addr; //addrb

                writeFlag   <= 1;
                wEnable     <= 1;
                waddr       <= addrr;
                newCounts   <= counts + 1;
                counter     <= counter + 1;
            end
        endcase
    end
end

endmodule