----------------------------------------------------------------------------------
-- Course: SE2 SoC Design 
-- Engineer: Louison GOUY and Mathis BRIARD
-- 
-- Create Date: 16/11/2022 08:50 AM
-- Design Name: interface tb
-- Project Name: controller_IT 
-- Description: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Entity declaration
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use std.textio.all;
use std.env.finish;

--user include
library work;
use work.controller_IT_package.all;
use work.interface_read.all;

entity interface_tb is
end entity interface_tb;

architecture arch of interface_tb is
  --signal
  signal clk : std_logic;
  signal nCS : Def_bit;
  signal nAS : Def_bit;
  signal nRST : std_logic;
  signal addr : Def_addr;
  signal d_bus : Def_data;
  signal RnW : std_logic;

begin
  UUT : entity work.interface_read (interface_read)
    port map(
      clk : clk;
      nRST : nRST;
      addr : addr;
      d_bus : d_bus;
      RnW : RnW;
      nAS : nAS;
      nCS : nCS;
      EN : EN
    );

-- clock generation
ClockGen : process is
begin
  clk <= '0';
  wait for 5 ns;
  clk <= '1';
  wait for 5 ns;
end process ClockGen;

proc_test_EN : process is
begin
  -- init
  nCS <= '0';
  nAS <= '0';
  RnW <= '0';
  addr <= (others => '0');
  d_bus <= (others => '0');
  nRST <= '1';

  -- falling edge
  wait until falling_edge(clk);

  -- enable peripheral

  RnW <= '1'; -- Write
  addr <= (others => '0');

  d_bus <= to_unsigned(1, data_bus_size);

  wait until falling_edge(clk);

  RnW <= '1'; -- Read
  addr <= (others => '0');
  assert d_bus = to_unsigned(1, data_bus_size)
  report "Peripheral disable";

  finish;

end process proc_test_EN;

end architecture arch;
-- library IEEE;
-- use IEEE.STD_LOGIC_1164.all;
-- use IEEE.Numeric_Std.all;

-- entity Decoder_TB is
-- end entity Decoder_TB;

-- architecture Bench of Decoder_TB is

--     constant cte_Size  : INTEGER := 2;

--     signal Address_MSB : unsigned(cte_Size-1 downto 0);
--     signal CS_ram      : unsigned(2**cte_Size-1 downto 0);

-- begin

--     UUT: entity work.Address_Decoder(decoder)
--     generic map(cte_Size)
--     port map (
--         address_msb : Address_MSB;
--         CS_ram : CS_ram
--     );

--     ClockGen: process is
--     begin
--     while not StopClock loop
--         clock <= '0';
--         wait for 5 ns;
--         clock <= '1';
--         wait for 5 ns;
--     end loop;
--     wait;
--     end process ClockGen;

--     Stim: process is

--     begin

--     wait until rising_edge(clock); -- cycle 1
--     address_msb <= "00";
--     assert CS_ram = "0001";

--     wait until rising_edge(clock); -- cycle 2
--     address_msb <= "01";
--     assert CS_ram = "0010";

--     wait until rising_edge(clock); -- cycle 3
--     address_msb <= "10";
--     assert CS_ram = "0100";

--     wait until rising_edge(clock); -- cycle 4
--     address_msb <= "11";
--     assert CS_ram = "1000";

--     StopClock <= true;
--     wait;
--     end process;

-- end architecture Bench;