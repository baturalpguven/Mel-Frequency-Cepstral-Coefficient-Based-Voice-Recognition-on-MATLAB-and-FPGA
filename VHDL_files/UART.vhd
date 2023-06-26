library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART is
Port ( clk: IN STD_LOGIC;
       reset: IN STD_LOGIC;
       start_in: IN STD_LOGIC;
       data_in: STD_LOGIC_VECTOR(7 downto 0);
       data_out: out STD_LOGIC;
       ready: OUT std_logic);
end UART;

architecture Behavioral of UART is

type stateType is (IDLE, START, DATA, STOP);
signal state  : stateType := IDLE;

signal baud_flag: STD_LOGIC:= '0';
signal baud_cnt: integer range 0 to 867 := 0;

signal start_detected: STD_LOGIC:= '0';
signal stored_data: STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
signal start_scan: STD_LOGIC:= '1';

signal data_index: integer range 0 to 8:= 0;
signal temp_ready: std_logic:= '1';
signal temp_data_out: std_logic:='1';

begin

ready <= temp_ready;
data_out <= temp_data_out;
process(clk)
begin
    if rising_edge(clk) then
        if (reset = '1') then
            baud_flag <= '0';
            baud_cnt <= 0;
        else
            if (baud_cnt = 867) then
                baud_flag <= '1';
                baud_cnt <= 0;
            else
                baud_flag <= '0';
                baud_cnt <= baud_cnt + 1;
            end if;
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        if (reset = '1') or (start_scan = '0') then
            start_detected <= '0';
        elsif (start_in = '1') and (start_detected = '0') then
            start_detected <= '1';
            stored_data <= data_in;  
        end if;
    end if;
end process;


process(clk)
begin
    if rising_edge(clk) then
        if temp_ready <= '1' and start_in = '1' then
            temp_ready <= '0';
        elsif  (state = IDLE) and (start_detected = '0') then
            temp_ready <= '1';
        end if;
    end if;
end process;


process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            state <= IDLE;
            temp_data_out <= '1';
            data_index <= 0; 
            start_scan <= '0';
        else
            if baud_flag = '1' then
                case state is
                    when IDLE =>
                        temp_data_out <= '1';
                        start_scan <= '1';
                        if start_detected = '1' then
                            start_scan <= '0';
                            state <= START;
                            temp_data_out <= '0';
                        end if;
                    when START =>
                        temp_data_out <= stored_data(data_index);
                        data_index <= data_index + 1;
                          state <= DATA;  
                    when DATA =>
                        if data_index = 8 then
                            data_index <= 0; 
                            start_scan <= '0';
                            state <= STOP;
                            temp_data_out <= '1';
                        else
                            temp_data_out <= stored_data(data_index);
                            data_index <= data_index + 1;
                        end if;
                    when STOP =>
                        start_scan <= '1';
                        state <= IDLE;
                    when others=>
                        state <= IDLE;
                end case;
            end if;
        end if;
    end if;
end process;

end Behavioral;
