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
--use IEEE.std_logic_unsigned.all;
--USE ieee.std_logic_arith.all;
use work.controller_IT_package.all;

entity global_tb is

end entity global_tb;
library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;
library work;
use work.controller_IT_package.all;
architecture Bench of global_tb is
  --signal
  signal clk : std_logic := '0';
  signal nRST : std_logic;
  signal d_bus : Def_data;
  signal nAS : Def_bit;
  signal addr : Def_addr;
  signal RnW : Def_bit;
  signal nCS_IT : std_logic;
  signal nIT_xxx : unsigned(IT_size - 1 downto 0);

  signal StopClock : boolean := FALSE;

  component top_level_design is
    -- Declarations
    port (
      d_bus : inout Def_data;
      nAS : in Def_bit;
      nRST : in Def_bit;
      addr : out Def_addr;
      clk : in Def_bit;
      RnW : in Def_bit;
      nCS_IT : in Def_bit;
      nIT_xxx : in unsigned(IT_size - 1 downto 0)
    );
  end component;

begin

  top_design : top_level_design
  port map(
    d_bus => d_bus,
    nAS => nAS,
    nRST => nRST,
    addr => addr,
    clk => clk,
    RnW => RnW,
    nCS_IT => nCS_IT,
    nIT_xxx => nIT_xxx
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
  process
  begin

    nCS_IT <= '0';
    nAS <= '0';
    RnW <= '1';
    addr <= (others => '0');
    nRST <= '0';
    d_bus <= (others => 'Z');
    nIT_xxx <= (others => '0');

    wait until falling_edge(clk);
    nRST <= '1';
    -- /* Enable CTRL IT */
    -- CTRL_IT->CTRL_IT_EN = 0x0001;
    RnW <= '0';
    addr <= (others => '0');
    d_bus <= (others => '0');

    wait until falling_edge(clk);
    --  /* Set handler addr */
    -- CTRL_IT -> CTRL_IT_ADDR[nIT_UART] = & UART_Handler;
    RnW <= '0';
    addr <= addr_vect_handler + 11 * 4; -- UART 11th element
    d_bus <= x"ff11"; -- 0xffff handler address

    wait until falling_edge(clk);

    --  /* Set handler addr */
    -- CTRL_IT -> CTRL_IT_ADDR[nIT_PCI] = & PCI_Handler;
    RnW <= '0';
    addr <= addr_vect_handler + 10 * 4; -- UART 11th element
    d_bus <= x"ff10"; -- 0xffff handler address

    wait until falling_edge(clk);

    -- CTRL_IT->prio[nIT_UART].ch = 0x3;
    -- CTRL_IT->prio[nIT_PCI].ch = 0x5;
    RnW <= '0';
    addr <= addr_vect_priorite + 10;-- PCI 11th element
    d_bus <= (X"0300" or x"0005", others => '0'); -- set prio 3
    wait until falling_edge(clk);

    -- /* Enable CTRL IT */
    -- CTRL_IT->CTRL_IT_EN = 0x0001;
    RnW <= '0';
    addr <= (others => '0');
    d_bus <= (0 => '1', others => '0');

    wait until falling_edge(clk);

    RnW <= '0';
    d_bus <= (others => 'Z') ;
    nAS <= '1';
    nIT_xxx <= (10=>'1', 11=>'1', others => '0');

    wait until falling_edge(clk);
    
    -- Read lsb of blx
    nAS <= '0';
    RnW <= '1';
    d_bus <= (others => 'Z') ;
    addr <= addr_blx;

    wait until falling_edge(clk);

    nAS <= '1'; --bus unused
    d_bus <= (others => 'Z') ;

    -- clean PCI flag
    nIT_xxx <= (11=>'1', others => '0');

    wait until falling_edge(clk);

    
    -- Read lsb of blx
    nAS <= '0';
    RnW <= '1';
    d_bus <= (others => 'Z') ;
    addr <= addr_blx;

    wait until falling_edge(clk);

    nAS <= '1'; --bus unused
    d_bus <= (others => 'Z') ;

    -- clean PCI flag
    nIT_xxx <= ( others => '0');

    wait until falling_edge(clk);


    wait until falling_edge(clk);



    StopClock <= true;
    wait;

  end process;
  -- void CTRL_IT_init_UART(void)
  -- {

  -- /* Mask the IC channel */
  -- CTRL_IT -> CTRL_IT_MSK = 1UL << nIT_UART;

  -- /* Set handler addr */
  -- CTRL_IT -> CTRL_IT_ADDR[nIT_UART] = & UART_Handler;

  -- /* Enable CTRL IT */
  -- CTRL_IT -> CTRL_IT_EN = 0x0001;
  -- }
  -- void CTRL_IT_init_Ext(void)
  -- {
  -- /* Disable CTRL IT */
  -- CTRL_IT -> CTRL_IT_EN = 0x0000;

  -- for (ID_IT_t i = nIT_ext0;
  --   i <= nIT_ext3;
  --   i ++)
  --   {
  --   /* Set 4 external IT priority to 3 */
  --   CTRL_IT -> prio[i].ch = 0x3;
  --   /* Group Ext IT setting same handler addr */
  --   CTRL_IT -> CTRL_IT_ADDR[i] = & Ext_Handler;
  --   }

  --   /* Enable CTRL IT */
  --   CTRL_IT -> CTRL_IT_EN = 0x0001;
  --   }

end architecture Bench;