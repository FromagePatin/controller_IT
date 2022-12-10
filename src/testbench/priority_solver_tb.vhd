----------------------------------------------------------------------------------
-- Course: SE2 SoC Design 
-- Engineer: Louison GOUY and Mathis BRIARD
-- 
-- Create Date: 28/10/2022 08:50 AM
-- Design Name: priority_solver_tb
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
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

use work.priority_solver_pkg.all;
use work.controller_IT_package.all;

entity priority_solver_tb is

end entity priority_solver_tb;

architecture Bench of priority_solver_tb is
  --signal
  signal nIT_xxx : unsigned(IT_size - 1 downto 0);
  signal id_it : unsigned(NB_BIT_IT - 1 downto 0);

  signal priority_vector : t_array_prio(IT_size - 1 downto 0); -- := ("11", "01", "10", "00");
  signal mask : Def_masque := to_unsigned(0,Def_masque'length);
  signal nIT_xxx_masked : unsigned(IT_size - 1 downto 0);
begin

  mask_enity : entity work.mask(arch)
    port map(
      nIT_xxx => nIT_xxx,
      mask => mask,
      nIT_xxx_masked => nIT_xxx_masked
    );

  priority_solver : entity work.priority_solver(arch_priority_solver)
    port map(
      nIT_xxx => nIT_xxx_masked,
      priority_vector => priority_vector,
      id_it => id_it
    );

  gen_it_in_loop : process is
  begin

    -- Load priority register
    for i in 0 to IT_size - 1 loop
      priority_vector(i) <= to_unsigned(0, NB_BIT_PRIO); --to_unsigned(IT_size - i, NB_BIT_PRIO);
    end loop;
    

    priority_vector(1) <= to_unsigned(4, NB_BIT_PRIO);
    priority_vector(2) <= to_unsigned(4, NB_BIT_PRIO);
    priority_vector(4) <= to_unsigned(6, NB_BIT_PRIO);

    nIT_xxx <= (4=>'1',2=>'1',1=>'1', others =>'0');
    wait for 5 ns;
    nIT_xxx <= (1=>'1', others =>'0');
    wait for 5 ns;
    nIT_xxx <= (1=>'1',2=>'1', others =>'0');
    wait for 5 ns;
    wait; -- obligation
    
    
    for i in 0 to (2 ** IT_size) - 1 loop
      nIT_xxx <= to_unsigned(i, IT_size);
      wait for 5 ns;
    end loop;

    wait; -- obligation
  end process;

end architecture Bench;

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