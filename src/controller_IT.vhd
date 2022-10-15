----------------------------------------------------------------------------------
-- Course: SE2 SoC Design 
-- Engineer: Louison GOUY and Mathis BRIARD
-- 
-- Create Date: 13/10/2022 08:50 AM
-- Design Name: Interruption controller IP
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

entity controller_IT is
  generic(Nbbits_addr : INTEGER := 8;
	Nbbits_data : INTEGER := 8);
  port (
    clk     : in  std_logic;
    nRST    : in  std_logic;
    addr    : inout unsigned(Nbbits_addr-1 downto 0);
    d_bus   : inout unsigned(Nbbits_data-1 downto 0)
  );
end entity controller_IT;

architecture RTL of controller_IT is

begin

end architecture RTL;