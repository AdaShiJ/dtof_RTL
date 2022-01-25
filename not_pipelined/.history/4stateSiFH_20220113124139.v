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

    reg [`BIN_NUM_PER_RAM - 1 : 0] maxAddrSaver = 0;

    //**************FLAGS***************
    reg acq_count_finish = 0;

    //**************ALGEBRAIC CALCULATION***************
    reg [`Np - 1 : 0] THminus [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] THpositive [`PIXEL_NUM_PER_RAM -1 : 0];
    reg [`Np - 1 : 0] delta [`PIXEL_NUM_PER_RAM -1 : 0];

    reg [`Np - 1 : 0] SB;
    reg [`Np - 1 : 0] CH [`PIXEL_NUM_PER_RAM -1 : 0];

    parameter IDLE = 2'00,
    BUILD_HIS = 2'01,
    FIND_PEAK = 2'10,
    WAIT = 2'11;
    
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
                next_state = FIND_PEAK;
            end
            else begin
                next_state = BUILD_HIS;
            end
        end

        FIND_PEAK: begin
            if ((input_count==0)&&(pixel_count==0)) begin
                BRAM[pixel_count*`BIN_NUM_PER_HIS ] = BRAM[pixel_count*`BIN_NUM_PER_HIS ];
            end
            else if ((input_count==1)&&(pixel_count==0)) begin
                if (BRAM[1 + pixel_count*`BIN_NUM_PER_HIS ] > BRAM[pixel_count*`BIN_NUM_PER_HIS ]) begin
                    BRAM[pixel_count*`BIN_NUM_PER_HIS ] = BRAM[1 + pixel_count*`BIN_NUM_PER_HIS ]; // save the max value in addr0, save the addr of max value in addr1
                    
                end
            end
            BRAM[pixel_count*`BIN_NUM_PER_HIS ] = BRAM[input_count + pixel_count*`BIN_NUM_PER_HIS ] + 1;
        end

        WAIT: begin
            
        end

        default :begin
            next_state = IDLE;
        end

        endcase
    end
    
endmodule