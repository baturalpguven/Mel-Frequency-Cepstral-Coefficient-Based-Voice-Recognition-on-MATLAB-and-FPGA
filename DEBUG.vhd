library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity DEBUG is
 Generic(N: integer:= 14);
 Port ( 
        reset_in: IN STD_LOGIC;
        clock_in: IN STD_LOGIC;
        mem_addr_out: OUT STD_LOGIC_VECTOR (N-1 downto 0);
        mem_data_in: in STD_LOGIC_VECTOR (31 downto 0);
        txd_out: OUT STD_LOGIC;
        start_in: in STD_LOGIC;
        ready_out: out STD_LOGIC:= '0');
end DEBUG;

architecture Behavioral of DEBUG is

component UART is 
Port ( clk: IN STD_LOGIC;
       reset: IN STD_LOGIC;
       start_in: IN STD_LOGIC;
       data_in: STD_LOGIC_VECTOR(7 downto 0);
       data_out: out STD_LOGIC;
       ready: OUT std_logic);
end component;
signal data_sent: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
signal count4: integer range 0 to 3:= 0;
signal mem_addr_out_1: STD_LOGIC_VECTOR (N-1 downto 0):= (others => '0');

signal start_uart: std_logic:= '0';
signal uart_data: STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
signal ready_uart: STD_LOGIC;


type stateType is (IDLE, START_DEBUG, DATA, STOP);
signal state  : stateType := IDLE;

begin
UART_comp: UART port map (
 clk     => clock_in,
 reset  =>  reset_in,
 start_in  => start_uart,
 data_in  => uart_data,
 data_out  => txd_out,
 ready    => ready_uart
 );

mem_addr_out <= mem_addr_out_1;

FSM_DEBUG: process(clock_in)
begin
    if rising_edge(clock_in) then
        if reset_in = '1' then
            mem_addr_out_1 <= (others => '0');
            ready_out <= '0';
            state <= IDLE;
            start_uart <= '0';
            uart_data <= (others => '0');  
            data_sent <= (others => '0'); 
            count4 <= 0;       
        else
            case state is
                when IDLE =>
                    mem_addr_out_1 <= (others => '0');
                    count4 <= 0;                   
                    ready_out <= '1';
                    start_uart <= '0';
                    if start_in = '1' then
                        ready_out <= '0';
                        data_sent <= x"55AACC03";
                        state <= START_DEBUG;
                    end if;
                when START_DEBUG =>
                    if start_uart = '1' then
                        start_uart <= '0';
                    elsif ready_uart = '1' then 
                        if count4 = 3 then
                            start_uart <= '1';
                            uart_data <= data_sent(8*count4+7 downto 8*count4);
                            count4 <= 0;
                            data_sent <= mem_data_in;
                            mem_addr_out_1 <= std_logic_vector(to_unsigned(to_integer(unsigned(mem_addr_out_1))+1,N));
                            state <= DATA;
                        else
                            start_uart <= '1';
                            uart_data <= data_sent(8*count4+7 downto 8*count4);
                            count4 <= count4 + 1;                        
                        end if;
                    end if;
                when DATA =>
                    if start_uart = '1' then
                        start_uart <= '0';
                    elsif ready_uart = '1' then
                        if mem_addr_out_1 = ("00000000000000") then
                            if count4 = 3 then
                                start_uart <= '1';
                                uart_data <= data_sent(8*count4+7 downto 8*count4);
                                count4 <= 0;
                                data_sent <= x"AA5503CC";
                                state <= STOP;
                            else
                                start_uart <= '1';
                                uart_data <= data_sent(8*count4+7 downto 8*count4);
                                count4 <= count4 + 1;                        
                            end if;
                        else
                            if count4 = 3 then
                                start_uart <= '1';
                                uart_data <= data_sent(8*count4+7 downto 8*count4);
                                count4 <= 0;
                                data_sent <= mem_data_in;
                                mem_addr_out_1 <= std_logic_vector(to_unsigned(to_integer(unsigned(mem_addr_out_1))+1,N));
                            else
                                start_uart <= '1';
                                uart_data <= data_sent(8*count4+7 downto 8*count4);
                                count4 <= count4 + 1;                        
                            end if;
                        end if;
                    end if;
                when STOP =>
                    if start_uart = '1' then
                        start_uart <= '0';
                    elsif ready_uart = '1' then 
                        if count4 = 3 then
                            start_uart <= '1';
                            uart_data <= data_sent(8*count4+7 downto 8*count4);
                            count4 <= 0;
                            ready_out <= '1';
                            state <= IDLE;
                        else
                            start_uart <= '1';
                            uart_data <= data_sent(8*count4+7 downto 8*count4);
                            count4 <= count4 + 1;                        
                        end if;
                    end if;                    
                when others =>
                    state <= IDLE;
            end case ;       
        end if;
    end if;
end process FSM_DEBUG;

end Behavioral;