library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity labADC is
    Port (
           reset_in : in STD_LOGIC;
           clock_in : in STD_LOGIC;
           spi_clk_out : out STD_LOGIC;
           chip_sel_out : out STD_LOGIC;
           spi_data_in : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (11 downto 0)
           );
end labADC;

architecture Behavioral of labADC is
    signal spi_data_in_internal:  STD_LOGIC; 
    signal internal_data: std_logic_vector(14 downto 0);
    signal SPI_clock: std_logic:='1';
    signal SPItickSignal: integer range 0 to 7:=0;
    signal CS_signal: std_logic  := '1';
    type SPIstate is (IDLE, WAIT_BITS, DATA, TRI_STATE); 
    signal state  : SPIstate := IDLE;
    signal ADC_clk_cnt : integer range 0 to 19:=0;
begin
    spi_clk_out <= SPI_clock;
    spi_data_in_internal <= spi_data_in;
    
    process(clock_in)
    begin
        if rising_edge(clock_in) then
            -- clock Divider for 12.5Mhz  100MHz/12.5Mhz => 100 000 000 / 12 500 000 = 8 clock tick
            if SPItickSignal = 7 then
                SPI_clock <= not SPI_clock;
                SPItickSignal <= 0;
            else
                SPItickSignal <= SPItickSignal + 1;
            end if;

            if reset_in = '1' then 
                spi_clk_out <= '1';
                chip_sel_out <= '1';
                CS_signal <= '1';
                SPI_clock <= '1';
                data_out <= (others => '0');
            else
                case state is
                    when IDLE =>
                        CS_signal <= '0';
                        state <= WAIT_BITS;
                    when WAIT_BITS =>
                    if SPI_clock = '0' then
                            if spi_data_in_internal = '0' then
                                if ADC_clk_cnt /= 2 then
                                    ADC_clk_cnt <= ADC_clk_cnt + 1;
                                else
                                    state <= DATA;
                                end if;
                            end if; 
                    end if;
                    when DATA => 
                        if SPI_clock = '0' then
                            if ADC_clk_cnt /= 15 then
                                internal_data(ADC_clk_cnt) <= spi_data_in_internal;
                            else
                                CS_signal <= '1';
                                state <= TRI_STATE;
                            end if;
                         end if;
                     when TRI_STATE =>
                        if SPI_clock = '0' then
                            if ADC_clk_cnt /= 19  then
                                ADC_clk_cnt <= ADC_clk_cnt + 1;
                            else
                                CS_signal <= '1';
                                ADC_clk_cnt <= 0;
                                state <= IDLE;
                            end if;
                         end if;
                end case;
            end if;
        end if;
    end process;
    
    chip_sel_out <= CS_signal;
    data_out <= internal_data(14 downto 3);
end Behavioral;