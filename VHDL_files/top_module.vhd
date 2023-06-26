library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity top_module is
Generic (COUNTER_SIZE : integer := 10_000;
         N: integer:= 14);
Port (  clk: in  std_logic;
        reset: in  std_logic;
        button_in  : in  std_logic;
        spi_clk_out : out STD_LOGIC;
        chip_sel_out : out STD_LOGIC;
        spi_data_in : in STD_LOGIC;  
        ready_out : out STD_LOGIC;
        txd_out: OUT STD_LOGIC;
        start_in_debug: in STD_LOGIC;
        ready_out_debug: out STD_LOGIC:= '0'             
);
end top_module;

architecture Behavioral of top_module is

component button_debounce is
    generic (
            COUNTER_SIZE : integer := 10_000
            );
    port ( clk        : in  std_logic;
           reset      : in  std_logic;
           button_in  : in  std_logic;
           button_out : out std_logic);
end component;

component adcFSM is
Port (     reset_in : in STD_LOGIC;
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

component DEBUG is
 Generic(N: integer:= 14);
 Port ( 
        reset_in: IN STD_LOGIC;
        clock_in: IN STD_LOGIC;
        mem_addr_out: OUT STD_LOGIC_VECTOR (N-1 downto 0);
        mem_data_in: in STD_LOGIC_VECTOR (31 downto 0);
        txd_out: OUT STD_LOGIC;
        start_in: in STD_LOGIC;
        ready_out: out STD_LOGIC:= '0');
end component;

signal button_adc_out: std_logic; 
signal data_adc_out: STD_LOGIC_VECTOR (11 downto 0);
signal addr_adc_in: STD_LOGIC_VECTOR (13 downto 0);
signal button_debug_out: std_logic;
begin
UUT1: adcFSM      
       port map(
       reset_in       => reset,
       start_in       => button_adc_out,
       clock_in       => clk,
       spi_clk_out    => spi_clk_out,
       chip_sel_out   => chip_sel_out,
       spi_data_in    => spi_data_in,
       data_out       => data_adc_out,
       ready_out      => ready_out,
       addr_in        =>addr_adc_in);
       
UUT2: button_debounce 
        generic map(
        COUNTER_SIZE => COUNTER_SIZE)
        port map(
        clk        =>  clk,
        reset      =>  reset,
        button_in  =>  button_in,
        button_out =>  button_adc_out);

UUT3: DEBUG 
        generic map ( N => N)
        port map (
        reset_in     =>  reset,
        clock_in     =>  clk,
        mem_addr_out =>  addr_adc_in,
        mem_data_in  =>  "00000000000000000000"&data_adc_out,
        txd_out      =>  txd_out,
        start_in     =>  button_debug_out,
        ready_out    =>  ready_out_debug);
        
UUT4: button_debounce 
      generic map (COUNTER_SIZE => COUNTER_SIZE)
      port map(
        clk        =>  clk,
        reset      =>  reset,
        button_in  =>  start_in_debug,
        button_out =>  button_debug_out);
      
end Behavioral;
