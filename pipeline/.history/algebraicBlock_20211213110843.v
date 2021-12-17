`include "parametersSiFH.vh"

module  algebraicBlock(
    input [`Nb - 1 : 0] peakCH,
    input peakDone,
    input clk,
    input res,
    //input peakReady,
    output reg [`Np - 1 : 0] THminus [`PIXEL_NUM_PER_RAM - 1 : 0],
    output reg [`Np - 1 : 0] THpositive [`PIXEL_NUM_PER_RAM - 1 : 0],
    output reg [`Np - 1 : 0] delta [`PIXEL_NUM_PER_RAM - 1 : 0],
    output reg algebraicReady
);

reg [`Np - 1 : 0] TTHminus [`PIXEL_NUM_PER_RAM - 1 : 0];
reg [`Np - 1 : 0] TTHpositive [`PIXEL_NUM_PER_RAM - 1 : 0];
reg [`Np - 1 : 0] SB [`PIXEL_NUM_PER_RAM - 1 : 0];
reg [`Np - 1 : 0] CH [`PIXEL_NUM_PER_RAM - 1 : 0];
reg [`Np - 1 : 0] upperBound [`PIXEL_NUM_PER_RAM - 1 : 0];
reg [`Nb - 1 : 0] upperBoundCH [`PIXEL_NUM_PER_RAM - 1 : 0];
reg algebraicReadyy;
reg peakDonee;
reg peakFlag;

always @(posedge peakDone) begin
    peakDonee <= peakDone;
    
end

integer i;
always @(posedge clk or negedge res) begin
    if(res) begin
        for (i = 0; i < (`PIXEL_NUM_PER_RAM); i=i+1) begin
            THminus[i] <= 0;//`BIN_NUM_PER_RAM{1'd0}; //reset whole bram
            THpositive[i] <= 0;
            delta[i] <= 0;
        end 
    end
end

always @(*) begin
    peakFlag = peakDone & (~peakDonee);
    upperBound = ~0;
    upperBoundCH = ~0;
    SB = (1'b1 << (`Nb - 1)) + (1'b1 << (`Nb - 2)); //use the middle value of bin
    CH = peakCH << (`Np - `Nb);
    TTHminus = CH - SB;//bound
    TTHpositive = CH + SB;//bound
    if (CH >=  (upperBound - SB)) begin
        TTHpositive = upperBound - upperBoundCH;//wtf
        TTHminus = TTHpositive - 2* SB;
        algebraicReadyy = 0;
    end
    else begin
        if (CH <=  SB) begin
            TTHminus = 0;
            TTHpositive = TTHminus + 2* SB;
            algebraicReadyy = 0;
        end
        else begin
            TTHpositive = CH + SB;//wtf
            TTHminus = CH - SB;
            algebraicReadyy = 0;
        end
    end

    if (peakFlag) begin
        THminus = TTHminus;//[`Np:`Np-`Nb+1];
        THpositive = TTHpositive;//[`Np:`Np-`Nb+1];
        delta = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
        algebraicReady = algebraicReadyy;   
    end
    // else begin
    //     THminus = TTHminus;//[`Np:`Np-`Nb+1];
    //     THpositive = TTHpositive;//[`Np:`Np-`Nb+1];
    //     delta = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
    //     algebraicReady = algebraicReadyy;  
    // end

end
    
endmodule