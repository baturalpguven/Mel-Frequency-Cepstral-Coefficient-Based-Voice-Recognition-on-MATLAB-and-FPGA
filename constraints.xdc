set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
	
set_property PACKAGE_PIN V17 [get_ports {reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {reset}]
	
set_property PACKAGE_PIN U18 [get_ports button_in]						
	set_property IOSTANDARD LVCMOS33 [get_ports button_in]
set_property PACKAGE_PIN T18 [get_ports start_in_debug]						
	set_property IOSTANDARD LVCMOS33 [get_ports start_in_debug]
	
set_property PACKAGE_PIN U16 [get_ports {ready_out}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ready_out}]
set_property PACKAGE_PIN E19 [get_ports {ready_out_debug}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ready_out_debug}]
	
set_property PACKAGE_PIN A18 [get_ports txd_out]						
	set_property IOSTANDARD LVCMOS33 [get_ports txd_out]
	
set_property PACKAGE_PIN J1 [get_ports {chip_sel_out}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {chip_sel_out}]
#Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {spi_data_in}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {spi_data_in}]
#Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {spi_clk_out}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {spi_clk_out}]
