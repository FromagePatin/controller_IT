----------------------------------------------------------------------------------
-- Course: SE2 SoC Design 
-- Engineer: Louison GOUY and Mathis BRIARD
-- 
-- Create Date: 28/10/2022 08:50 AM
-- Design Name: gestion blx
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
use IEEE.std_logic_unsigned.all;

use work.priority_solver_pkg.all;
use work.controller_it_package.all;

entity gestion_blx is
  port (
    clk : in std_logic;
    nRST : in std_logic;
    nIT_CPU : out Def_bit;
    id_it : in unsigned(NB_BIT_IT - 1 downto 0);
    ack_read : in std_logic;
    is_IT_active : in std_logic;
    blx : out Def_addr;
    vect_handler : in Def_vect_handler
  );
end entity;

architecture arch of gestion_blx is
  type state_t is (WAIT_IT, WAIT_READ, NEXT_IT);
  signal state : state_t;
  signal prev_id_it : unsigned(NB_BIT_IT - 1 downto 0);
begin

  FSM : process (clk, nRST)
  begin
    if nRST = '0' then
      state <= WAIT_IT;
    elsif rising_edge(clk) then
        case state is
          when WAIT_IT =>
            if is_IT_active = '1' then
              state <= WAIT_READ;
            end if;

          when WAIT_READ =>
            if ack_read = '1' then
              state <= NEXT_IT;
            end if;

          when NEXT_IT =>
            if not (prev_id_it = id_it) then
              state <= WAIT_READ;
            elsif is_IT_active = '0' then
              state <= WAIT_IT;
            end if;

          when others =>
            state <= WAIT_IT;
        end case;
      end if; -- clk
  end process;

  FSMOut : process (state, nRST)
  begin
    if nRST = '0' then
      prev_id_it <= (others => '0');
      nIT_CPU <= '1';
      blx <= (others => '0');
    else
      case state is
        when WAIT_READ =>
          prev_id_it <= id_it;
          nIT_CPU <= '0';
          blx <= vect_handler(to_integer(id_it));

        when NEXT_IT =>
          nIT_CPU <= '1';

        when others =>
          prev_id_it <= (others => '0');
          nIT_CPU <= '1';
          blx <= (others => '0');
      end case;
    end if; -- nRST
  end process;
end architecture;