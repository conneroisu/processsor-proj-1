set target "tb_MIPS_Processor"
set file "${target}.vhd"

#This line should be in every .do file(and done first)!
vcom -2008 -work work ../src/MIPS_types.vhd
#This line (load basic gates & stuff) should be done second and should be in each integrated testing .do file
vcom -2008 -work work ../src/TopLevel/low_level/*.vhd

#Alu needs barrel shifter so buildd
vcom -2008 -work work ../src/TopLevel/barrel_shifter/*.vhd

#Build  Alu
vcom -2008 -work work ../src/TopLevel/alu/*.vhd

#Build control
vcom -2008 -work work ../src/TopLevel/control_unit/*.vhd

#Build Fetch
vcom -2008 -work work ../src/TopLevel/fetch/*.vhd

#Build Processor
vcom -2008 -work work ../src/TopLevel/MIPS_Processor.vhd

#Start SIM & load ram/dmem
#vsim -voptargs=+acc $target
#mem load -infile dmem.hex -format hex /$target/proc/dmem/ram
#add wave -position insertpoint \ ../$target/*
#run 1200

