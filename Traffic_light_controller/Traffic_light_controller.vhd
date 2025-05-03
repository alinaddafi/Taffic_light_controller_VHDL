----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:10:57 05/03/2025 
-- Design Name: 
-- Module Name:    Traffic_light_controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Traffic_light_controller is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        emergency : in  STD_LOGIC;
        sensor    : in  STD_LOGIC;
        lights    : out STD_LOGIC_VECTOR(2 downto 0);
        seg_out   : out STD_LOGIC_VECTOR(6 downto 0)
    );
end Traffic_light_controller;

architecture Behavioral of Traffic_light_controller is
    type state_type is (RED, YELLOW, GREEN);
    signal current_state : state_type := RED;
    signal counter      : integer range 0 to 50000000 := 0; 
begin
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= RED;
            counter <= 0;
        elsif rising_edge(clk) then
            counter <= counter + 1;
            
            if emergency = '1' then
                current_state <= RED;
                counter <= 0;
            else
                case current_state is
                    when RED =>
                        if (sensor = '1' and counter >= 25000000) or counter >= 50000000 then
                            current_state <= GREEN;
                            counter <= 0;
                        end if;
                    when GREEN =>
                        if counter >= 25000000 then
                            current_state <= YELLOW;
                            counter <= 0;
                        end if;
                    when YELLOW =>
                        if counter >= 10000000 then
                            current_state <= RED;
                            counter <= 0;
                        end if;
                    when others =>
                        current_state <= RED;
                end case;
            end if;
        end if;
    end process;

    lights <= "001" when current_state = RED else
              "010" when current_state = YELLOW else
              "100" when current_state = GREEN;
    
    seg_out <= "0000000"; 
end Behavioral;