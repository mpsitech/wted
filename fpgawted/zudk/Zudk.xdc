# file Zudk.xdc
# Avnet Zynq UltraScale+ MPSoC development kit pin mapping and constraints for Xilinx Vivado
# copyright: (C) 2017-2020 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 30 Jun 2024
# IP header --- ABOVE

# bank44 1.8V
set_property PACKAGE_PIN A8 [get_ports btn0];
set_property PACKAGE_PIN G6 [get_ports {probe[0]}];
set_property PACKAGE_PIN E8 [get_ports {probe[1]}];
set_property PACKAGE_PIN D7 [get_ports {probe[2]}];
set_property PACKAGE_PIN D6 [get_ports {probe[3]}];
set_property PACKAGE_PIN F8 [get_ports {probe[4]}];
set_property PACKAGE_PIN F7 [get_ports {probe[5]}];
set_property PACKAGE_PIN B5 [get_ports rgb0_b];
set_property PACKAGE_PIN B6 [get_ports rgb0_g];
set_property PACKAGE_PIN A7 [get_ports rgb0_r];

# banks
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 44]];
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 65]];
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 66]];

# IP clks --- BEGIN
# clocks
#create_generated_clock -name aclk_sig -source [get_ports/get_pins xxxxx] -edges {a b c} [get_pins root/myWted_core/myBufgAclk/O];
# IP clks --- END
