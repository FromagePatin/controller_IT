LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.Numeric_Std.all;
LIBRARY controller_IT_lib;
USE controller_IT_lib.controller_IT_package.all;

ENTITY interface_tb IS
   PORT( 
      d_bus         : IN     Def_data;
      nAS           : OUT    Def_bit;
      nRST          : OUT    Def_bit;
      EN            : OUT    Def_EN;
      pending       : OUT    Def_pending;
      blx           : OUT    Def_addr;
      vect_handler  : OUT    Def_vect_handler;
      vect_priorite : OUT    Def_vect_priorite;
      masque        : OUT    Def_masque;
      addr          : OUT    Def_addr;
      clk           : OUT    Def_bit;
      RnW           : OUT    Def_bit;
      nCS_IT        : OUT    Def_bit
   );

-- Declarations

END interface_tb ;

architecture RTL of interface_tb is
  --signal
  --signal clk : std_logic;
  --signal nCS : Def_bit;
  --signal nAS : Def_bit;
  --signal nRST : std_logic;
  --signal addr : Def_addr;
  --signal d_bus : Def_data;
  --signal RnW : std_logic;
  --signal EN : Def_EN;
  --signal vect_priorite : Def_vect_priorite;
  --signal vect_handler : Def_vect_handler;
  --signal masque : Def_masque;
  --signal pending : Def_pending;
  --signal blx : Def_addr;
  signal StopClock : boolean := FALSE;

begin
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
  masque <= (0=>'1',1=>'1',2=>'1', others => '0');
  pending <= (6=>'1', others => '0'); --64
  blx <= (8=>'1',20=>'1', others => '0'); --256 premiere lecture 16 deuxieme lecture
  for i in 0 to IT_size loop
    vect_handler(i) <= to_unsigned(i,addr'length);
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
  
  StopClock <= true;
  
  wait;

end process proc_test_EN;

end architecture RTL;
