library IEEE;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

entity adcFSM is
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
end adcFSM;

architecture Behavioral of adcFSM is

    signal clk_div_cnt: integer range 0 to 7:=0;
    signal falling_flag : std_logic;
    
    signal addr_sig : std_logic_vector (13 downto 0):= (others => '0');
    signal wea : std_logic_vector (0 downto 0):= "0";
    signal data_in : std_logic_vector (19 downto 0):= (others => '0');
    signal data_raw: std_logic_vector (11 downto 0):= (others => '0');
    signal data_sum: std_logic_vector (19 downto 0):= (others => '0');

    signal spi_clk_cnt_25: integer range 0 to 24 := 0;
    signal sample_cnt_16384: integer range 0 to 16383 := 0;
    signal decimation_cnt_32 : integer range 0 to 31 := 0;

    type SPIstate is (IDLE, START, WAIT_BITS, DATA, TRI_STATE); 
    signal state  : SPIstate := IDLE;
    
    signal DC_offset: std_logic_vector(11 downto 0):=x"800";
    
    
    component blk_mem_gen_0 is
      PORT (
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        clkb : IN STD_LOGIC;
        addrb : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
      );
      end component;
begin

DualPortROM:blk_mem_gen_0 
  PORT MAP(
    clka =>clock_in,
    wea => wea,
    addra =>addr_sig,
    dina =>data_in(11 downto 0),
    clkb =>clock_in,
    addrb =>addr_in,
    doutb =>data_out
  );


CLK_DIV: process(clock_in) 
begin
    if rising_edge(clock_in) then
        if reset_in = '1' then
            clk_div_cnt <= 0;
        else
            clk_div_cnt <= clk_div_cnt + 1;
            if clk_div_cnt = 7 then
                falling_flag <= '1';
                clk_div_cnt <= 0;
            else
                falling_flag <= '0';
            end if;
            if clk_div_cnt < 4 then
                spi_clk_out <= '0';
            else
                spi_clk_out <= '1';
            end if;
        end if;
    end if;
end process;


FSM: process(clock_in)
begin
    if rising_edge(clock_in) then
        if reset_in ='1' then
            chip_sel_out <= '1';
            addr_sig <= (others => '0');
            ready_out <= '0';
            state <= IDLE;
            data_sum <= (others => '0');
        else
            case state is
                when IDLE =>
                    ready_out <= '1';
                    chip_sel_out <= '1';
                    if start_in = '1' then                   
                        ready_out <= '0';
                        state <= START;
                    end if;
                when START =>
                    if falling_flag = '1' then
                        chip_sel_out <= '0';
                        state <= WAIT_BITS;
                    end if;
                when WAIT_BITS =>
                    if falling_flag = '1' then
                        if spi_clk_cnt_25 = 2 then
                            spi_clk_cnt_25 <= spi_clk_cnt_25 + 1;
                            data_raw(13-spi_clk_cnt_25) <= spi_data_in;                           
                            state <= DATA;
                        else
                            if spi_data_in = '0' then
                                spi_clk_cnt_25 <= spi_clk_cnt_25 + 1;
                            else
                                state <= WAIT_BITS;
                            end if;
                        end if;
                    end if;
                when DATA =>
                    if falling_flag = '1' then
                        if spi_clk_cnt_25 = 14 then
                            data_raw(14-spi_clk_cnt_25) <= spi_data_in;
                            spi_clk_cnt_25 <= spi_clk_cnt_25 + 1;
                            chip_sel_out <= '1';
                            state <= TRI_STATE;
                        else
                            data_raw(14-spi_clk_cnt_25) <= spi_data_in;
                            spi_clk_cnt_25 <= spi_clk_cnt_25 + 1;
                        end if;
                    end if;
                when TRI_STATE =>
                    if falling_flag = '1' then
                        if spi_clk_cnt_25 = 24 then
                            spi_clk_cnt_25 <= 0;
                            
                            if sample_cnt_16384 = 16383 then 
                                chip_sel_out <= '1';
                                sample_cnt_16384 <= 0;
                                addr_sig <= (others => '0');
                                ready_out <= '1';
                                decimation_cnt_32 <= 0;
                                state <= IDLE;
                            else
                                chip_sel_out <= '0';
                                state <= WAIT_BITS;
                            end if;
                        elsif spi_clk_cnt_25 = 21 then
                            spi_clk_cnt_25 <= spi_clk_cnt_25 + 1;                                
                            wea <= "0";     
                            if decimation_cnt_32 = 0 then
                                sample_cnt_16384 <= sample_cnt_16384 + 1;
                                addr_sig <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_sig))+1,14));
                            end if;
                        elsif spi_clk_cnt_25 = 20 then
                            spi_clk_cnt_25 <= spi_clk_cnt_25 + 1;                                
                            if decimation_cnt_32 = 0 then
--                                data_in <= std_logic_vector(signed(data_sum)- signed(DC_offset));
                                data_in <= std_logic_vector(unsigned(data_sum));
                                data_sum <= (others => '0');
                                wea <= "1";
                            end if;
                        elsif spi_clk_cnt_25 = 19 then
                            spi_clk_cnt_25 <= spi_clk_cnt_25 + 1;                                
                            if decimation_cnt_32 = 31 then
                                decimation_cnt_32 <= 0;
                                data_sum <= std_logic_vector(shift_right(unsigned(data_sum),4));
                            else
                                decimation_cnt_32 <= decimation_cnt_32 + 1;
                            end if;
                        elsif spi_clk_cnt_25 = 17 then
                            data_sum <= std_logic_vector(unsigned(data_sum) + unsigned(data_raw));
                            spi_clk_cnt_25 <= spi_clk_cnt_25 + 1;                                
                        else
                            spi_clk_cnt_25 <= spi_clk_cnt_25 + 1;
                        end if;
                    end if;
                when others =>
                    state <= IDLE;
            end case;
        end if;
    end if;
end process;

end Behavioral;