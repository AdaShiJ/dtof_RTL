`define Nb 4//`define Nb 6
`define Np 6//`define Np 10 /// only to 1023
`define peakMax 21
`define ACQ_NUM 2//33333
`define DATA_NUM 2
`define SRAM_NUM 1//200  
`define PIXEL_NUM 3//200*160
`define BIN_NUM_PER_HIS 2**(`Nb)
`define PIXEL_NUM_PER_RAM 3//(`PIXEL_NUM / `SRAM_NUM)
`define BIN_NUM_PER_RAM (`PIXEL_NUM_PER_RAM * `BIN_NUM_PER_HIS)
`define RAM_SIZE (`peakMax * `BIN_NUM_PER_RAM)
//`define ACQ_NUM_PER_RAM (`ACQ_NUM * `PIXEL_PER_RAM)
`define PIXEL_PER_RAM 3
`define UPPER_BOUND (2**(`Np) - 1)
`define SB (2**(`Nb - 1))
`define MAX_BOUND (`UPPER_BOUND - 2*`SB -1)

`define RAM_ADDR 5

// `define Nb 6
// `define Np 10
// `define NumberOfBins 64//2^(Nb)
// `define peakMax 21
// `define ACQ_NUM 4//33333
// `define DATA_NUM 2
// `define SRAM_NUM 2//200
// `define PIXEL_NUM 6//32000//200*160
// `define NUM_PER_RAM (2^(`Nb))
// `define PIXEL_PER_RAM (`PIXEL_NUM / `SRAM_NUM)
// `define RAM_SIZE (`peakMax * `NUM_PER_RAM * `PIXEL_PER_RAM)
// `define ACQ_NUM_PER_RAM (`ACQ_NUM * `PIXEL_PER_RAM)//33333
