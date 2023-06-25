library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adcFSM_sim is
--  Port ( );
end adcFSM_sim;

architecture Behavioral of adcFSM_sim is

component adcFSM is 
Port (
           reset_in : in STD_LOGIC;
           start_in : in STD_LOGIC;
           clock_in : in STD_LOGIC;
           spi_clk_out : out STD_LOGIC;
           chip_sel_out : out STD_LOGIC;
           spi_data_in : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (11 downto 0);
           ready_out : out STD_LOGIC;
           addr_in : in STD_LOGIC_VECTOR (13 downto 0)
           );
end component;

signal reset_in : STD_LOGIC:='0';
signal start_in : STD_LOGIC:='0';
signal clock_in : STD_LOGIC:='1';
signal spi_clk_out : STD_LOGIC;
signal chip_sel_out : STD_LOGIC;
signal spi_data_in  : STD_LOGIC:='1';
signal data_out : STD_LOGIC_VECTOR (11 downto 0);
signal ready_out : STD_LOGIC;
signal addr_in : STD_LOGIC_VECTOR (13 downto 0):= (others => '0');

begin

UUT: adcFSM port map (
    reset_in   => reset_in ,
    start_in  =>  start_in ,
    clock_in   =>  clock_in ,
    spi_clk_out   =>  spi_clk_out ,
    chip_sel_out  =>  chip_sel_out,
    spi_data_in   =>  spi_data_in ,
    data_out   =>  data_out ,
    ready_out   =>  ready_out  ,
    addr_in   =>  addr_in 
);

clock_in <= not clock_in after 5ns;

process
begin
wait for 50ns;
wait until rising_edge(clock_in);
start_in <= '1';
wait for 10ns;
start_in <='0';
wait for 20 ns;
spi_data_in <= '0';
wait for 320 ns;
spi_data_in <= '1';
wait for 880 ns;
for i in 0 to 524288 loop
    spi_data_in <= '0'; 
    wait for 1840ns;
    spi_data_in <= '1';
    wait for 160ns;
end loop;
wait for 1ms;

end process;
end Behavioral;
