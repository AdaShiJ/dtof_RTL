`include "parametersSiFH.vh"

module  algebraicBlock(
    input [`Nb - 1 : 0] peakCH,
    input peakDone,
    //input peakReady,
    output reg [`Np - 1 : 0] THminus,
    output reg [`Np - 1 : 0] THpositive,
    output reg [`Np - 1 : 0] delta,
    output reg algebraicReady
);

reg [`Np - 1 : 0] TTHminus;
reg [`Np - 1 : 0] TTHpositive;
reg [`Np - 1 : 0] SB;
reg [`Np - 1 : 0] CH;
reg [`Np - 1 : 0] upperBound;
reg [`Nb - 1 : 0] upperBoundCH;
reg algebraicReadyy;
reg peakDonee;
reg peakFlag;
reg [`Nb - 1 : 0] tmp;

// always @(posedge peakDone) begin
//     peakDonee <= peakDone;
//     peakFlag = peakDone & (~peakDonee);
// end
always @(*) begin
    upperBound = ~0;
    upperBoundCH = ~0;
    SB = 1'b1 << (`Nb - 1);//) + (1'b1 << (`Nb - 2)); //use the middle value of bin
    CH[`Np - 1 : `Np - `Nb] = peakCH << (`Np - `Nb);// + (1'b1 << (`Nb - 2));
    tmp = (1'b1 << (`Nb - 2));
    CH[] = 
    TTHminus = CH - SB;//bound
    TTHpositive = CH + SB;//bound


    if (peakDone == 1) begin
        THminus = TTHminus;//[`Np:`Np-`Nb+1];
        THpositive = TTHpositive;//[`Np:`Np-`Nb+1];
        delta = THminus + THpositive - ((THpositive >> `Nb) << `Nb) ;
        algebraicReady = algebraicReadyy;   

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

    end
    else begin
        THminus = THminus;//[`Np:`Np-`Nb+1];
        THpositive = THpositive;//[`Np:`Np-`Nb+1];
        delta = delta;
        algebraicReady = algebraicReady;   
        
    // else begin
    //     THminus = TTHminus;//[`Np:`Np-`Nb+1];
    //     THpositive = TTHpositive;//[`Np:`Np-`Nb+1];
    //     delta = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
    //     algebraicReady = algebraicReadyy;  
    end

end
    
endmodule

// `include "parametersSiFH.vh"

// module  algebraicBlock(
//     input [`Nb - 1 : 0] peakCH,
//     input peakDone,
//     input clk,
//     input res,
//     //input peakReady,
//     output reg [`Np - 1 : 0] THminus [`PIXEL_NUM_PER_RAM - 1 : 0],
//     output reg [`Np - 1 : 0] THpositive [`PIXEL_NUM_PER_RAM - 1 : 0],
//     output reg [`Np - 1 : 0] delta [`PIXEL_NUM_PER_RAM - 1 : 0],
//     output reg algebraicReady
// );

// reg [`Np - 1 : 0] TTHminus;// [`PIXEL_NUM_PER_RAM - 1 : 0];
// reg [`Np - 1 : 0] TTHpositive;// [`PIXEL_NUM_PER_RAM - 1 : 0];
// reg [`Np - 1 : 0] SB;// [`PIXEL_NUM_PER_RAM - 1 : 0];
// reg [`Np - 1 : 0] CH;// [`PIXEL_NUM_PER_RAM - 1 : 0];
// reg [`Np - 1 : 0] upperBound;// [`PIXEL_NUM_PER_RAM - 1 : 0];
// reg [`Nb - 1 : 0] upperBoundCH;// [`PIXEL_NUM_PER_RAM - 1 : 0];
// reg algebraicReadyy;
// reg peakDonee;
// reg peakFlag;
// reg [7:0] pixel_count = 0;

// reg [`Np - 1 : 0] THminus [`PIXEL_NUM_PER_RAM - 1 : 0],
// reg [`Np - 1 : 0] THpositive [`PIXEL_NUM_PER_RAM - 1 : 0],
// reg [`Np - 1 : 0] delta [`PIXEL_NUM_PER_RAM - 1 : 0],

// always @(posedge peakDone) begin
//     peakDonee <= peakDone;
// end

// integer i;
// always @(posedge clk or negedge res) begin
//     if(~res) begin
//         for (i = 0; i < (`PIXEL_NUM_PER_RAM); i=i+1) begin
//             THminus[i] <= 0;//`BIN_NUM_PER_RAM{1'd0}; //reset whole bram
//             THpositive[i] <= 0;
//             delta[i] <= 0;
//             TTHminus[i] <= 0;
//             TTHpositive[i] <= 0;
            
//             upperBound[i] <= 0;
//             upperBoundCH[i] <= 0;
//         end 
//     end
//     else begin
//         if (peakDone) begin
//             pixel_count <= pixel_count + 1;
//         end
//         else
//         begin
//             pixel_count <= pixel_count;
//         end
//     end
// end

// always @(*) begin
//     peakFlag = peakDonee;// & (~peakDonee);
//     upperBound = ~0;
//     upperBoundCH = ~0;
//     SB = (1'b1 << (`Nb - 1)) + (1'b1 << (`Nb - 2)); //use the middle value of bin
//     CH = peakCH << (`Np - `Nb);
//     TTHminus = CH - SB;//bound
//     TTHpositive = CH + SB;//bound
//     if (CH >=  (upperBound - SB)) begin
//         TTHpositive = upperBound - upperBoundCH;//wtf
//         TTHminus = TTHpositive - 2* SB;
//         algebraicReadyy = 0;
//     end
//     else begin
//         if (CH <=  SB) begin
//             TTHminus = 0;
//             TTHpositive = TTHminus + 2* SB;
//             algebraicReadyy = 0;
//         end
//         else begin
//             TTHpositive = CH + SB;//wtf
//             TTHminus = CH - SB;
//             algebraicReadyy = 0;
//         end
//     end

//     if (peakFlag) begin
//         THminuss[pixel_count] = TTHminus;//[`Np:`Np-`Nb+1];
//         THpositivee[pixel_count] = TTHpositive;//[`Np:`Np-`Nb+1];
//         deltaa[pixel_count] = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
//         algebraicReady = algebraicReadyy;   
//     end

//     THminus <= THminuss;
//     THpositive <= THpositivee;
//     delta <= deltaa;

    
//     // else begin
//     //     THminus = TTHminus;//[`Np:`Np-`Nb+1];
//     //     THpositive = TTHpositive;//[`Np:`Np-`Nb+1];
//     //     delta = THminus + THpositive - (THpositive >> `Nb) << `Nb ;
//     //     algebraicReady = algebraicReadyy;  
//     // end

// end
    
// endmodule