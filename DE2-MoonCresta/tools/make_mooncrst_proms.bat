copy /b/y mc1 + mc2 + mc3 + mc4 + mc5.7r + mc6.8d + mc7.8e + mc8 main.bin
copy /b/y mcs_b + mcs_d 1h.bin
copy /b/y mcs_a + mcs_c 1k.bin

make_vhdl_prom main.bin rom0.vhd
make_vhdl_prom 1h.bin galaxian_1h.vhd
make_vhdl_prom 1k.bin galaxian_1k.vhd
make_vhdl_prom mmi6331.6l galaxian_6l.vhd

pause