----------------------------------------------------------------------------------
-- Course: SE2 SoC Design 
-- Engineer: Louison GOUY and Mathis BRIARD
-- 
-- Create Date: 28/10/2022 08:50 AM
-- Design Name: priority_solver
-- Project Name: controller_IT 
-- Description: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Entity declaration
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use IEEE.std_logic_unsigned.all;

use work.controller_it_package.all;

entity priority_solver is
  port (
    nIT_xxx : in unsigned(IT_size - 1 downto 0);
    priority_vector : in Def_vect_priorite;
    id_it : out unsigned(NB_BIT_IT - 1 downto 0);
    is_IT_active : out std_logic
  );
end entity priority_solver;

architecture Arch of priority_solver is
begin

is_IT_active <= not (and nIT_xxx);

  process (nIT_xxx)
    variable max_prio : unsigned(NB_BIT_PRIO - 1 downto 0) := to_unsigned(0, NB_BIT_PRIO);
    variable temp_id_it : unsigned(NB_BIT_IT - 1 downto 0) := to_unsigned(0, NB_BIT_IT);
  begin

    -- reset before loop
    id_it <= (others => '0');
    max_prio := to_unsigned(0, NB_BIT_PRIO);

    -- loop in all input
    for i in 0 to IT_size - 1 loop

      -- if the source is enable
      if nIT_xxx(i) = '0' then

        -- if it is the highest priority
        if priority_vector(i) > max_prio then
          max_prio := priority_vector(i); -- save the priority to be the highest
          temp_id_it := to_unsigned(i, NB_BIT_IT); -- save the id of the highest priority

          -- if the current priority is egal to the highest
        else if (priority_vector(i) = max_prio) and (i > temp_id_it) then
          temp_id_it := to_unsigned(i, NB_BIT_IT); -- save the id of the highest priority
        end if;

      end if; -- >

    end if; -- '0'

  end loop;

  id_it <= temp_id_it; -- set the output

end process;

end architecture Arch;