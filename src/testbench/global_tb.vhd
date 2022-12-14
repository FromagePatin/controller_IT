----------------------------------------------------------------------------------
-- Course: SE2 SoC Design 
-- Engineer: Louison GOUY and Mathis BRIARD
-- 
-- Create Date: 28/10/2022 08:50 AM
-- Design Name: global tb
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

entity gloabal_tb is

end entity gloabal_tb;

architecture Bench of gloabal_tb is
  --signal
  signal clk : std_logic := '0';
  signal nRST : std_logic;
  signal d_bus : Def_data;
  signal nAS : Def_bit;
  signal addr : Def_addr;
  signal RnW : Def_bit;

  signal StopClock : boolean := FALSE;

  procedure config_UART (clk : in std_logic; addr : out Def_addr;  d_bus : out Def_data) is
  begin

    --  /* Set handler addr */
    -- CTRL_IT -> CTRL_IT_ADDR[nIT_UART] = & UART_Handler;
    addr <= to_unsigned(addr_vect_handler + 11 * 4, addr_bus_size); -- UART 11th element
    d_bus <= (others => '1'); -- 0xffff handler address

    wait until falling_edge(clk);

    -- /* Enable CTRL IT */
    -- CTRL_IT->CTRL_IT_EN = 0x0001;
    addr <= (others => '0');
    d_bus <= (0 = '1', others => '0');

    wait until falling_edge(clk);

    -- CTRL_IT->prio[nIT_UART].ch = 0x3;
    addr <= to_unsigned(addr_vect_priorite + 11, addr_bus_size);-- UART 11th element
    d_bus <= to_unsigned(3, data_bus_size); -- set prio 3

    wait until falling_edge(clk);

  end procedure;
begin

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
  CTRL_IT_init_UART : process (clk)
  begin

    nCS_IT <= '0';
    nAS <= '0';
    RnW <= '1';
    addr <= (others => '0');
    nRST <= '0';
    d_bus <= (others => 'Z');

    wait until falling_edge(clk);
    wait until falling_edge(clk);
    nRST <= '1';
    wait until falling_edge(clk);

    -- /* Disable CTRL IT */
    -- CTRL_IT->CTRL_IT_EN = 0x0000;
    addr <= (others => '0');
    d_bus <= (others => '0');

    wait until falling_edge(clk);

    
    wait until falling_edge(clk);

     --  /* Set handler addr */
    -- CTRL_IT -> CTRL_IT_ADDR[nIT_UART] = & UART_Handler;
    addr <= to_unsigned(addr_vect_handler + 11 * 4, addr_bus_size); -- UART 11th element
    d_bus <= (others => '1'); -- 0xffff handler address

    wait until falling_edge(clk);

    -- /* Enable CTRL IT */
    -- CTRL_IT->CTRL_IT_EN = 0x0001;
    addr <= (others => '0');
    d_bus <= (0 = '1', others => '0');

    wait until falling_edge(clk);

    -- CTRL_IT->prio[nIT_UART].ch = 0x3;
    addr <= to_unsigned(addr_vect_priorite + 11, addr_bus_size);-- UART 11th element
    d_bus <= to_unsigned(3, data_bus_size); -- set prio 3

    wait until falling_edge(clk);




  end process;
  void CTRL_IT_init_UART(void)
  {

  /* Mask the IC channel */
  CTRL_IT -> CTRL_IT_MSK = 1UL << nIT_UART;

  /* Set handler addr */
  CTRL_IT -> CTRL_IT_ADDR[nIT_UART] = & UART_Handler;

  /* Enable CTRL IT */
  CTRL_IT -> CTRL_IT_EN = 0x0001;
  }
  void CTRL_IT_init_Ext(void)
  {
  /* Disable CTRL IT */
  CTRL_IT -> CTRL_IT_EN = 0x0000;

  for (ID_IT_t i = nIT_ext0;
    i <= nIT_ext3;
    i ++)
    {
    /* Set 4 external IT priority to 3 */
    CTRL_IT -> prio[i].ch = 0x3;
    /* Group Ext IT setting same handler addr */
    CTRL_IT -> CTRL_IT_ADDR[i] = & Ext_Handler;
    }

    /* Enable CTRL IT */
    CTRL_IT -> CTRL_IT_EN = 0x0001;
    }

  end architecture Bench;