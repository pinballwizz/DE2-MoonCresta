copy /B mcs_b + mcs_d 1h.bin
copy /B mcs_a + mcs_c 1k.bin
copy /B smc1f + smc2f + smc3f + smc4f + e5 + bepr199 + e7 + smc8f main.bin


make_vhdl_prom main.bin rom0.vhd
make_vhdl_prom 1h.bin galaxian_1h.vhd
make_vhdl_prom 1k.bin galaxian_1k.vhd
make_vhdl_prom mmi6331.6l galaxian_6l.vhd



pause

