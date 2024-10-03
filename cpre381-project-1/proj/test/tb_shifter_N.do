set target "tb_shifter_N"
set file "${target}.vhd"

#This line should be in every .do file!
vcom -2008 -work work ../src/MIPS_types.vhd
#This line should be done second and should *basically* be in each integrated testing file
vcom -2008 -work work ../src/TopLevel/low_level/*.vhd

vcom -2008 -work work ../src/TopLevel/barrel_shifter/*.vhd
vcom -2008 -work work $file

vsim -voptargs=+acc $target
add wave -position insertpoint \ ../$target/*
run 1700
