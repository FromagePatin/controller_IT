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
--use work.interface_read.all;

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
  signal EN : Def_EN;
  signal vect_priorite : Def_vect_priorite;
  signal vect_handler : Def_vect_handler;
  signal masque : Def_masque;
  signal pending : Def_pending;
  signal blx : Def_addr;
  signal StopClock : boolean := FALSE;

begin
  UUT_read : entity work.interface_read (RTL)
    port map(
      clk => clk,
      nRST => nRST,
      addr => addr,
      d_bus => d_bus,
      nCS => nCS,
      nAS => nAS,
      RnW => RnW,
      vect_priorite => vect_priorite,
      vect_handler => vect_handler,
      masque => masque,
      pending => pending,
      blx => blx,
      EN => EN
    );

  UUT_write : entity work.interface_write (RTL)
    port map(
      clk => clk,
      nRST => nRST,
      addr => addr,
      d_bus => d_bus,
      nCS => nCS,
      nAS => nAS,
      RnW => RnW,
      vect_priorite => vect_priorite,
      vect_handler => vect_handler,
      masque => masque,
      EN => EN
    );
  -- clock generation
  ClockGen : process is
  begin
    while not StopClock loop
      clk <= '0';
      wait for 5 ns;
      clk <= '1';
      wait for 5 ns;
    end loop;
    wait;
  end process ClockGen;

  proc_test_EN : process is
  begin
    -- init
    nCS <= '1';
    nAS <= '1';
    RnW <= '0';
    addr <= (others => '0');
    d_bus <= (others => 'Z');
    nRST <= '0';

    wait until rising_edge(clk);

    nRST <= '1'; -- disable reset

    wait until falling_edge(clk);

    -- set value in register handler   
    handler_address_tb :
    for i in (IT_size - 1) downto 0 loop
      -- i increment ID IT
      vect_handler(i) <= to_unsigned(i, addr_bus_size);
    end loop;

    wait until falling_edge(clk);

    d_bus <= TriState;
    RnW <= '1'; -- Read
    nCS <= '0';
    nAS <= '0';
    handler_address_view_tb :
    for i in 0 to (IT_size - 1) loop
      -- i increment ID IT
      addr <= addr_vect_handler + i * 4;
      wait until falling_edge(clk);
      addr <= addr_vect_handler + i * 4 + 2;
      wait until falling_edge(clk);
    end loop;

    -- set value in register priority   
    handler_priority_tb :
    for i in (IT_size - 1) downto 0 loop
      -- i increment ID IT
      vect_priorite(i) <= to_unsigned(i, 3);
    end loop;

    wait until falling_edge(clk);

    handler_priority_view_tb :
    for i in 0 to ((IT_size/2) - 1) loop
      -- i increment ID IT
      addr <= addr_vect_priorite + i * 2;
      wait until falling_edge(clk);
    end loop;

    finish;

    StopClock <= true;
    wait;

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