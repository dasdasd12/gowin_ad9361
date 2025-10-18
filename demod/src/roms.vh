// `ifdef __ICARUS__
// `define SIN_ROM_PATH "./src/data/sine_rom.txt"
// `define ATAN_ROM_PATH "./src/data/atan_rom.txt"
// `define SQRT_ROM_PATH "./src/data/sqrt_rom.txt"
// `else
// `define SIN_ROM_PATH "C:/program1/Program/2019.1vivado_project/demod/src/data/sine_rom.txt"
// `define ATAN_ROM_PATH "C:/program1/Program/2019.1vivado_project/demod/src/data/atan_rom.txt"
// `define SQRT_ROM_PATH "C:/program1/Program/2019.1vivado_project/demod/src/data/sqrt_rom.txt"
// `endif
`define ZYNQ

`ifdef __ICARUS__
`define ROM_BASE_PATH "./src/data/"
`else
`define ROM_BASE_PATH "../../../../../demod/src/data/"
`endif

`define SIN_ROM_PATH {`ROM_BASE_PATH, "sine_rom.txt"}
`define ATAN_ROM_PATH {`ROM_BASE_PATH, "atan_rom.txt"}
`define SQRT_ROM_PATH {`ROM_BASE_PATH, "sqrt_rom.txt"}
`define TX_SIGNAL_PATH {`ROM_BASE_PATH, "../../tb/tx_signal.hex"}
