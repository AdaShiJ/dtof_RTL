`include "parametersSiFH.vh"
// `define Nb 6
// `define Np 10
// `define peakMax 21
module srLatch( //hhttps://www.xilinx.com/support/documentation/university/ISE-Teaching/HDL-Design/14x/Nexys3/Verilog/docs-pdf/lab5.pdf
    input S,
    input R,
    output Q//,
    //output Qn
    );
 
wire Qbar;
 
nor (Q, R, Qbar);
nor (Qbar, S, Q); 
// assign Q_int = ~(S & Qn_int);
// assign Qn_int = ~(R & Q_int);
// assign Q = Q_int;
// assign Qn = Qn_int;
endmodule

module deMux (
    //input wrEn,
    input [`Nb-1:0] addr,
    output reg [`NumberOfBins-1:0] S
);

    //assign S = 0；
    always @(*) begin
        S[addr] = 1;
    end
    
endmodule

module Mux (
    input [`NumberOfBins-1:0] Q,
    input [`Nb-1:0] addr,
    output reg sel
);

    //sel = 0；
    always @(*) begin
        sel <= Q[addr];
    end
    
endmodule

module memReset (
    input wrEn,
    input [`Nb-1:0] addr,
    input resLatch,
    output sel
);

wire [`NumberOfBins-1:0] S;
reg [`NumberOfBins-1:0] R;
wire [`NumberOfBins-1:0] Q;

deMux deMux0( 
    //.wrEn(wrEn),
    .addr(addr[`Nb-1:0]),
    .S(S[`NumberOfBins-1:0])
    );

Mux Mux0 (
    .Q(Q),
    .addr(addr),
    .sel(sel)
    );

genvar i;
generate
    for (i = 0; i < `NumberOfBins; i=i+1) begin
        srLatch srLatch0(
            .S(S[i]),
            .R(R[i]),
            .Q(Q[i])
            );
        end
endgenerate

integer a;//should the integer name be reused???? compiler / hardware difference?
always @(*) begin
    for (a = 0; a < `NumberOfBins; a=a+1) begin
        R[a] = resLatch; //all connected to a same latch reset signal
    end
end
    
endmodule

module hisBuilder
(
    input clk,
    input res, 
    input [1:0]wrEnable, //CH -> 2'b11 FH->2'b01
    input acqFinish,
    input [`Nb-1:0] addr,
    output reg [`peakMax-1:0] binCounts, //current single bin
    output reg [1:0] dataFinish  //CH -> 2'b11 FH->2'b01
);
    reg [`NumberOfBins-1 : 0] BRAM [`peakMax - 1 :0];
    reg [`peakMax-1 : 0] addrSaver = 0;
    reg ress;
    reg resLatch;
    wire sel;
    wire wrEn;
    assign wrEn = wrEnable[0];

    memReset memReset1(
    .wrEn(wrEn),
    .addr(addr),
    .resLatch(resLatch),
    .sel(sel)
);

    always @(posedge clk) begin
        ress <= res;
    end
            
    integer i;
    always @(posedge clk or posedge res) begin
        resLatch = res ^ ress;// for the SR
        if (res) begin //the SR are also reset by resLatch
            for (i = 0; i < `NumberOfBins; i=i+1) begin
                BRAM[i] = 0; //reset whole bram
                dataFinish = 2'b00;
                binCounts = 2'b00;
            end
        end
        else begin
            dataFinish[1] <= wrEnable[1];
            if (wrEnable[0]) begin
                if (acqFinish) begin
                    dataFinish[0] <= 1;
                end
                else begin
                    if (sel) begin //bin is already reseted before, + 1
                        binCounts = BRAM[addr] + 1; //output
                    end
                    else begin //init
                        binCounts = 1;
                    end
                    BRAM[addr] = binCounts; // save all into the BRAM
                end
            end
        end
    end    

endmodule