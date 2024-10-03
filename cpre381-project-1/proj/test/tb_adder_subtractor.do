set target "tb_adder_subtractor"
set file "${target}.vhd"

#This line should be in every .do file(and done first)!
vcom -2008 -work work ../src/MIPS_types.vhd
#This line (load basic gates & stuff) should be done second and should be in each integrated testing .do file
vcom -2008 -work work ../src/TopLevel/low_level/*.vhd

#Alu needs barrel shifter so build
vcom -2008 -work work ../src/TopLevel/barrel_shifter/*.vhd

#Build  Alu
vcom -2008 -work work ../src/TopLevel/alu/*.vhd
vcom -2008 -work work $file

vsim -voptargs=+acc $target
add wave -position insertpoint \ ../$target/*
run 1120