`include "parametersSiFH.vh"

module 4stateSiFH (
    input clk,
    input res, 
    input wrEn, 
    input [`Np - 1:0] data,
    output reg [((`Np)*(`PIXEL_NUM_PER_RAM)-1):0] result
);

    //**************INPUT/OUTPUT/RAM***************
    reg [(`peakMax - 1) : 0] BRAM [`BIN_NUM_PER_RAM - 1 : 0]; //RAM
    reg [`Nb-1:0] addr; //INPUT

    //**************BUFFERS***************
    reg [1:0] input_count = 0; //2
    reg [7:0] pixel_count = 0; //200
    reg [19:0] acq_count = 0; //33333

    parameter IDLE = 2'00,
    BUILD_HIS = 2'01,
    FIND_PEAK = 2'10,
    WAIT = 2'11;
    
    reg [2:0] current_state, next_state;

    //**************COUNTER***************
    always @(posedge clk or negedge res or current_state) begin
        if (~res or current_state == WAIT or current_state == WAIT or current_state == IDLE) begin
            input_count <= 0;
            pixel_count <= 0;
            acq_count <= 0;
        end
        else begin
                if (input_count < `DATA_NUM - 1) begin
                    input_count <= input_count + 1;
                end
                else begin
                    input_count <= 0;  
                end

                if (input_count == `DATA_NUM - 1) begin
                    if (pixel_count < `PIXEL_NUM_PER_RAM - 1) begin
                        pixel_count <= pixel_count + 1;
                    end
                    else begin
                        pixel_count <= 0;
                    end
                end

        end
    end

    always @(posedge clk or negedge res) begin
        if (~res) begin
            current_state <= IDLE;
        end
        else
            current_state <= next_state;
    end
    
endmodule