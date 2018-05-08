vsim -gui work.processor
# vsim 
# Start time: 01:46:11 on May 07,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.processor(mainarch)
# Loading work.cu(maincu)
# Loading work.ifet(archifet)
# Loading work.mux2x1(archmux2x1)
# Loading work.mux4x1(archmux4x1)
# Loading work.pc_reg(archpc_reg)
# Loading work.instruction_memory(archinstruction_memory)
# Loading work.fetch_decode_buffer(archfetch_decode_buffer)
# Loading work.decoder(maindecoder)
# Loading work.registerfile(mainregisterfile)
# Loading work.mux(mainmux)
# Loading work.genericregister(registerarch)
# Loading work.my_dff(a_my_dff)
# Loading work.executestage(exearch)
# Loading work.genericadder(gadderarch)
# Loading work.fulladder(adderarch)
# Loading work.alu(aluarch)
# Loading work.forwunit(fuarch)
# Loading work.flagbuffer(flagarch)
# Loading work.branchcalc(brancharch)
# ** Warning: Design size of 11496 statements or 97 leaf instances exceeds ModelSim PE Student Edition recommended capacity.
# Expect performance to be quite adversely affected.
# ** Warning: (vsim-8683) Uninitialized out port /processor/myExecuter/OUT_PORT(15 downto 0) has no driver.
# 
# This port will contribute value (16'hXXXX) to the signal network.
# vsim 
# Start time: 01:01:44 on May 07,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.processor(mainarch)
# Loading work.cu(maincu)
# Loading work.ifet(archifet)
# Loading work.mux2x1(archmux2x1)
# Loading work.mux4x1(archmux4x1)
# Loading work.pc_reg(archpc_reg)
# Loading work.instruction_memory(archinstruction_memory)
# Loading work.fetch_decode_buffer(archfetch_decode_buffer)
# Loading work.decoder(maindecoder)
# Loading work.registerfile(mainregisterfile)
# Loading work.mux(mainmux)
# Loading work.genericregister(registerarch)
# Loading work.executestage(exearch)
# Loading work.genericadder(gadderarch)
# Loading work.fulladder(adderarch)
# Loading work.alu(aluarch)
# Loading work.forwunit(fuarch)
# Loading work.flagbuffer(flagarch)
# Loading work.branchcalc(brancharch)
# ** Warning: Design size of 11424 statements or 95 leaf instances exceeds ModelSim PE Student Edition recommended capacity.
# Expect performance to be quite adversely affected.
# ** Warning: (vsim-8683) Uninitialized out port /processor/myExecuter/OUT_PORT(15 downto 0) has no driver.
# 
# This port will contribute value (16'hXXXX) to the signal network.
# vsim 
# Start time: 00:48:49 on May 07,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.processor(mainarch)
# Loading work.cu(maincu)
# Loading work.ifet(archifet)
# Loading work.mux2x1(archmux2x1)
# Loading work.mux4x1(archmux4x1)
# Loading work.pc_reg(archpc_reg)
# Loading work.instruction_memory(archinstruction_memory)
# Loading work.fetch_decode_buffer(archfetch_decode_buffer)
# Loading work.decoder(maindecoder)
# Loading work.registerfile(mainregisterfile)
# Loading work.mux(mainmux)
# Loading work.genericregister(registerarch)
# Loading work.executestage(exearch)
# Loading work.genericadder(gadderarch)
# Loading work.fulladder(adderarch)
# Loading work.alu(aluarch)
# Loading work.forwunit(fuarch)
# Loading work.flagbuffer(flagarch)
# Loading work.branchcalc(brancharch)
# ** Warning: Design size of 11424 statements or 95 leaf instances exceeds ModelSim PE Student Edition recommended capacity.
# Expect performance to be quite adversely affected.
# ** Warning: (vsim-8683) Uninitialized out port /processor/myExecuter/OUT_PORT(15 downto 0) has no driver.
# 
# This port will contribute value (16'hXXXX) to the signal network.
mem load -i {C:/Users/Owner/Desktop/Cairo University/Senior-1/Computer Architecture/final project/Arch project/rana.mem} /processor/myFetch/Instruction_mem/ram
mem load -i {C:/Users/Owner/Desktop/Cairo University/Senior-1/Computer Architecture/final project/Arch project/rana.mem} /processor/myFetch/Instruction_mem/ram
add wave  \
sim:/processor/Clk \
sim:/processor/Interrupt \
sim:/processor/Reset
add wave  \
sim:/processor/myCU/Opcode \
sim:/processor/myCU/ALUSelect
add wave  \
sim:/processor/myFetch/bubble \
sim:/processor/myFetch/newPC \
sim:/processor/myFetch/PC_plus_1_out \
sim:/processor/myFetch/Opcode_F
add wave  \
sim:/processor/myFetchBuffer/Opcode_out
add wave  \
sim:/processor/myDecoder/readaddr1 \
sim:/processor/myDecoder/readaddr2 \
sim:/processor/myDecoder/writeaddr \
sim:/processor/myDecoder/writedata \
sim:/processor/myDecoder/dataout1 \
sim:/processor/myDecoder/dataout2
add wave  \
sim:/processor/myExecuter/Data1 \
sim:/processor/myExecuter/Data2 \
sim:/processor/myExecuter/Output
force -freeze sim:/processor/Clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/processor/Interrupt 0 0
force -freeze sim:/processor/Reset 0 0
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /processor/myExecuter/myALU
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /processor/myExecuter/myALU
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /processor/myFetch/Instruction_mem
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /processor/myExecuter/myALU
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /processor/myExecuter/myALU
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /processor/myFetch/Instruction_mem
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /processor/myExecuter/myALU
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /processor/myExecuter/myALU
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /processor/myFetch/Instruction_mem
force -freeze sim:/processor/myDecoder/writeaddr 3'h4 0
force -freeze sim:/processor/myDecoder/writedata 16'h2 0
run
force -freeze sim:/processor/myDecoder/writeaddr 3'h2 0
force -freeze sim:/processor/myDecoder/writedata 16'h1 0
run
force -freeze sim:/processor/myDecoder/writedata 16'h3 0
force -freeze sim:/processor/myDecoder/writeaddr 3'h5 0
run
force -freeze sim:/processor/myDecoder/writeaddr 3'h3 0
force -freeze sim:/processor/myDecoder/writedata 16'h6 0
run
force -freeze sim:/processor/myDecoder/writeaddr 3'h1 0
force -freeze sim:/processor/myDecoder/writedata 16'h9 0
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 550 ns  Iteration: 3  Instance: /processor/myExecuter/myALU
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 550 ns  Iteration: 3  Instance: /processor/myExecuter/myALU
run
run