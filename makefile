# Makefile for iCE40HX8K design
# Assumes Yosys, nextpnr-ice40, and iceprog are installed and in PATH

# Directory for temporary outputs
TMP_DIR = tmp

# Top-level Verilog file
TOP_FILE = Krypton.sv Video.sv Memory.sv# <- files go here
TOP_MODULE = Krypton  # <- top module goes here

# Output files
JSON = $(TMP_DIR)/test.json
PCF = oganesson.pcf  # Your constraints file
ASC = $(TMP_DIR)/test.asc
BIN = $(TMP_DIR)/test.bin

# Default target
.PHONY: all
all: clean synth program

# Synthesize the design using Yosys
.PHONY: synth
synth:
	mkdir -p $(TMP_DIR)
	yosys -p 'synth_ice40 -top $(TOP_MODULE) -json $(JSON)' $(TOP_FILE)

# Place and route using nextpnr-ice40, specifying iCE40HX8K and CT256 package
.PHONY: program
program: $(BIN)
	iceprog $(BIN)

# Generate bitstream from ASC
$(BIN): $(ASC)
	icepack $< $@

# Place and route the design
$(ASC): $(JSON) $(PCF)
	nextpnr-ice40 --json $(JSON) --pcf $(PCF) --asc $@ --hx8k --package ct256

# Clean temporary files
.PHONY: clean
clean:
	rm -rf $(TMP_DIR)

# Ensure TMP_DIR exists for outputs
$(TMP_DIR):
	mkdir -p $(TMP_DIR)