set target "tb_shifter_N"
do build.do
vsim -voptargs=+acc $target
add wave -position insertpoint \ $target/*
run 1200