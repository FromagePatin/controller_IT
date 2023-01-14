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

--use work.priority_solver_pkg.all;
library work;
use work.controller_IT_package.all;

entity priority_solver_tb is

end entity priority_solver_tb;

architecture Bench of priority_solver_tb is
  --signal
  signal nIT_xxx : unsigned(IT_size - 1 downto 0);
  signal id_it : unsigned(NB_BIT_IT - 1 downto 0);

  signal priority_vector : Def_vect_priorite; -- := ("11", "01", "10", "00");
  signal mask : Def_masque := to_unsigned(0,Def_masque'length);
  signal nIT_xxx_masked : unsigned(IT_size - 1 downto 0);
begin

  mask_enity : entity work.mask_entity(arch)
    port map(
      nIT_xxx => nIT_xxx,
      mask => mask,
      nIT_xxx_masked => nIT_xxx_masked
    );

  priority_solver : entity work.priority_solver(Arch)
    port map(
      nIT_xxx => nIT_xxx_masked,
      priority_vector => priority_vector,
      id_it => id_it,
      is_IT_active => open
    );

  gen_it_in_loop : process is
  begin

    -- Load priority register
    for i in 0 to IT_size - 1 loop
      priority_vector(i) <= to_unsigned(0, NB_BIT_PRIO);
    end loop;
    

   priority_vector(1) <= to_unsigned(4, NB_BIT_PRIO);
   priority_vector(2) <= to_unsigned(4, NB_BIT_PRIO);
   priority_vector(4) <= to_unsigned(6, NB_BIT_PRIO);
   
   nIT_xxx <= (others =>'1');

   wait for 5 ns;
    nIT_xxx <= (4=>'0',2=>'0',1=>'0', others =>'1');
    wait for 5 ns;
    nIT_xxx <= (1=>'0', others =>'1');
    wait for 5 ns;
    nIT_xxx <= (1=>'0',2=>'0', others =>'1');
    wait for 5 ns;

    
    for i in 0 to (2 ** IT_size) - 1 loop
      nIT_xxx <= to_unsigned(i, IT_size);
      wait for 5 ns;
    end loop;

    wait; -- obligation
  end process;

end architecture Bench;