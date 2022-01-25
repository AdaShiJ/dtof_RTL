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

    //**************FLAGS***************
    reg acq_count_finish = 0;

    parameter IDLE = 2'00,
    BUILD_HIS = 2'01,
    FIND_PEAK = 2'11,
    WAIT = 2'10;
    
    reg [1:0] current_state, next_state;

    //**************COUNTER***************
    always @(posedge clk or negedge res or current_state) begin
        if (~res or current_state == WAIT or current_state == WAIT or current_state == IDLE) begin
            input_count <= 0;
            pixel_count <= 0;
            acq_count <= 0;
            acq_count_finish <= 0;
        end
        else begin
                if (input_count < `DATA_NUM - 1) begin
                    input_count <= input_count + 1;
                end
                else begin
                    input_count <= 0; 
                    if (pixel_count < `PIXEL_NUM_PER_RAM - 1) begin
                        pixel_count <= pixel_count + 1;
                    end
                    else begin
                        pixel_count <= 0;
                        if (acq_count < `ACQ_NUM - 1) begin
                            acq_count <= acq_count + 1;
                        end
                        else begin
                            acq_count_finish <= 1;
                            acq_count <= 0;
                        end
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

    always @(*) begin
        case (curret_state)
        IDLE: begin
            addr = dataa[`Np -1 :(`Np-`Nb)];
            if (wrEn) begin
                next_state = BUILD_HIS;
            end
            else begin
                next_state = IDLE;
            end
        end

        BUILD_HIS: begin
            BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] = BRAM[addr  + pixel_count*`BIN_NUM_PER_HIS ] + 1;
            if (acq_count_finish) begin
                
            end
        end

        WAIT: begin
            
        end

        FIND_PEAK: begin
            
        end



        default :begin
            next_state = IDLE;
        end

        endcase
    end
    
endmodule