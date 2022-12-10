library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use IEEE.Numeric_Std.all;
use work.controller_IT_package.all;

entity interface_tb is
  -- port (
  --   d_bus : in Def_data;
  --   nAS : out Def_bit;
  --   nRST : out Def_bit;
  --   EN : out Def_EN;
  --   pending : out Def_pending;
  --   blx : out Def_addr;
  --   vect_handler : out Def_vect_handler;
  --   vect_priorite : out Def_vect_priorite;
  --   masque : out Def_masque;
  --   addr : out Def_addr;
  --   clk : out Def_bit;
  --   RnW : out Def_bit;
  --   nCS_IT : out Def_bit
  -- );

  -- Declarations

end interface_tb;

architecture RTL of interface_tb is
  --signal
  signal clk : std_logic;
  signal nCS_it : Def_bit;
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
   UUT : entity work.interface_read (RTL)
     port map(
       d_bus => d_bus,
       clk => clk,
       nAS => nAS,
       nCS_IT => nCS_IT,
       nRST => nRST,
       RnW => RnW,
       EN => EN,
       vect_priorite => vect_priorite,
       pending => pending,
       masque => masque,
       addr => addr,
       blx => blx,
       vect_handler => vect_handler
     );

  -- clock generation

    --  UUT : entity work.interface_read (RTL)
  --    port map(
  --      d_bus => d_bus,
  --      clk => clk,
  --      nAS => nAS,
  --      nCS_IT => nCS_IT,
  --      nRST => nRST,
  --      RnW => RnW,
  --      EN => EN,
  --      vect_priorite => vect_priorite,
  --      pending => pending,
  --      masque => masque,
  --      addr => addr,
  --      blx => blx,
  --      vect_handler => vect_handler
  --    );

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
    nCS_IT <= '0';
    nAS <= '0';
    RnW <= '1';
    addr <= (others => '0');
    nRST <= '0';
    EN <= '1';
    masque <= (0 => '1', 1 => '1', 2 => '1', others => '0');
    pending <= (6 => '1', others => '0'); --64
    blx <= (8 => '1', 20 => '1', others => '0'); --256 premiere lecture 16 deuxieme lecture
    for i in 0 to IT_size - 1 loop
      vect_handler(i) <= to_unsigned(i, addr'length);
    end loop;

    wait until rising_edge(clk);

    nRST <= '1';
    -- falling edge
    wait until falling_edge(clk);

    -- Read enable register

    addr <= (others => '0');

    wait until falling_edge(clk);

    -- Read masque register

    addr <= (1 => '1', others => '0');

    wait until falling_edge(clk);

    addr <= (2 => '1', others => '0');

    wait until falling_edge(clk);

    addr <= (1 => '1', 2 => '1', others => '0');

    wait until falling_edge(clk);

    addr <= (3 => '1', others => '0');

    -- set value in register handler   
    handler_address_tb :
    for i in (IT_size - 1) downto 0 loop
      -- i increment ID IT
      vect_handler(i) <= to_unsigned(i, addr_bus_size);
    end loop;

    wait until falling_edge(clk);

    -- handler address
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

    StopClock <= true;

    wait;

  end process proc_test_EN;

end architecture RTL;