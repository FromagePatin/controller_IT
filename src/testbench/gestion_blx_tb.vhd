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

entity gestion_blx_tb is

end entity gestion_blx_tb;

architecture Bench of gestion_blx_tb is
  --signal
  signal clk : std_logic := '0';
  signal nRST : std_logic;
  signal nIT_CPU : Def_bit;
  signal id_it : unsigned(NB_BIT_IT - 1 downto 0);
  signal ack_read : std_logic;
  signal is_IT_active : std_logic;
  signal blx : Def_addr;
  signal vect_handler : Def_vect_handler;

  signal StopClock : boolean := FALSE;
begin

  gestion_blx : entity work.gestion_blx(arch)
    port map(
      clk => clk,
      nRST => nRST,
      nIT_CPU => nIT_CPU,
      id_it => id_it,
      ack_read => ack_read,
      is_IT_active => is_IT_active,
      blx => blx,
      vect_handler => vect_handler
    );

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


  gen_it_in_loop : process is
  begin

    -- Load priority register
    for i in 0 to IT_size - 1 loop
      vect_handler(i) <= to_unsigned(i, addr_bus_size);
    end loop;

    nRST <= '0';
    id_it <= to_unsigned(0, id_it'length);
    ack_read <= '0';
    is_IT_active <= '0';

    wait until falling_edge(clk);
    wait until falling_edge(clk);
    nRST <= '1';
    is_IT_active <= '1';
    id_it <= to_unsigned(2, id_it'length);
    
    wait until falling_edge(clk);
    id_it <= to_unsigned(3, id_it'length);

    wait until rising_edge(clk);
    ack_read <= '1';

    wait until rising_edge(clk);
    ack_read <= '0';

    wait until rising_edge(clk);
    wait until rising_edge(clk);
    ack_read <= '1';

    wait until rising_edge(clk);
    ack_read <= '0';

    wait until falling_edge(clk);
    id_it <= to_unsigned(2, id_it'length);

    wait until falling_edge(clk);


    StopClock <= TRUE;
    wait; -- obligation
  end process;

end architecture Bench;