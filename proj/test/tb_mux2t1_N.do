set target "tb_mux2t1_N"
set file "${target}.vhd"

#This line should be in every .do file!
vcom -2008 -work work ../src/*.vhd

vcom -2008 -work work $file

vsim -voptargs=+acc $target
add wave -position insertpoint \ ../$target/*
run 1700
