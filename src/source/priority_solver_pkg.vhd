----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2022 08:36:54 PM
-- Design Name: 
-- Module Name: priority_solver_pkg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package priority_solver_pkg is
  CONSTANT NB_BIT_IT : INTEGER := 4;
  CONSTANT NB_BIT_PRIO : INTEGER := 3;
  --   -- Creates an unconstrained array (MUST be constrained when defined!)
  --   -- https://nandland.com/arrays/
  type t_array_prio is array (integer range <>) of unsigned(NB_BIT_PRIO - 1 downto 0);
end package priority_solver_pkg;

