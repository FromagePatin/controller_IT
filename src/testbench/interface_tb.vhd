LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
USE IEEE.Numeric_Std.all;
LIBRARY work;
USE work.controller_IT_package.all;

ENTITY interface_tb IS

-- Declarations
PORT( 
   d_bus   : INOUT  Def_data;
   nAS     : OUT    Def_bit;
   nRST    : OUT    Def_bit;
   addr    : OUT    Def_addr;
   clk     : OUT    Def_bit;
   RnW     : OUT    Def_bit;
   nCS_IT  : OUT    Def_bit
);

END interface_tb ;

architecture Arch of interface_tb is
  --signal


  signal StopClock : boolean := FALSE;

begin


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
  RnW <= '0';
  addr <= addr_EN;
  nRST <= '0';
  --EN <= '1';
  --masque <= (0=>'1',1=>'1',2=>'1', others => '0');
  --pending <= (6=>'1', others => '0'); --64
  --blx <= (8=>'1',20=>'1', others => '0'); --256 premiere lecture 16 deuxieme lecture
  --for i in 0 to IT_size-1 loop
  --  vect_handler(i) <= to_unsigned(i,addr'length);
  --end loop;
  --set value for reg (these regs are read-only registers

 -- pending <= (6=>'1', others => '0'); --64
  --blx <= (8=>'1',20=>'1', others => '0'); --256 premiere lecture 16 deuxieme lecture

  wait until rising_edge(clk);
  wait until rising_edge(clk);
  
  nRST <= '1';
  
  ------------------------------------------------------------------
  --Writing section
  ------------------------------------------------------------------
  d_bus <= (0 => '1', others => '0');
  
  wait until rising_edge(clk);
  wait until falling_edge(clk);
  
  addr <= addr_masque;
  d_bus <= (0=>'1',1=>'1',2=>'1', others => '0');
  
  wait until falling_edge(clk);

  write_handler : for i in 0 to (IT_size - 1) loop
    -- i increment ID IT
    addr <= addr_vect_handler + i * 4;
    d_bus <= to_unsigned(i,data_bus_size);
    wait until falling_edge(clk);
    addr <= addr_vect_handler + i * 4 + 2;
    d_bus <= (others => '0');
    if(i/=IT_size-1) then
      wait until falling_edge(clk);
    end if;
  end loop;
  
  write_priority: for i in 0 to ((IT_size/2) - 1) loop
    -- i increment ID IT
    addr <= addr_vect_priorite + i * 2;
    d_bus <= (2 downto 0 => to_unsigned(2*i,3), 10 downto 8 => to_unsigned(2*i+1,3), others => '0');
    wait until falling_edge(clk);
  end loop;
  addr <= addr_vect_priorite + 14;  
  d_bus <= (2 downto 0 => to_unsigned(6,3), others => '0');
  
  wait until falling_edge(clk);
  
  ------------------------------------------------------------------
  --End writing section
  ------------------------------------------------------------------
  
  ------------------------------------------------------------------
  --Reading section
  ------------------------------------------------------------------
  
  RnW <= '1';
  
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
  --handler_address_tb :
  --for i in (IT_size - 1) downto 0 loop
    -- i increment ID IT
    --vect_handler(i) <= to_unsigned(i, addr_bus_size);
  --end loop;

  wait until falling_edge(clk);

  -- handler address
  handler_address_view_tb :
  for i in 0 to (IT_size - 1) loop
    -- i increment ID IT
    addr <= addr_vect_handler + i * 4;
    wait until falling_edge(clk);
    addr <= addr_vect_handler + i * 4 + 2;
    if(i/=IT_size-1) then
      wait until falling_edge(clk);
    end if;
  end loop;

  -- set value in register priority   
  --handler_priority_tb :
  --for i in (IT_size - 1) downto 0 loop
    -- i increment ID IT
    --vect_priorite(i) <= to_unsigned(i, 3);
  --end loop;

  wait until falling_edge(clk);

  handler_priority_view_tb :
  for i in 0 to ((IT_size/2) - 1) loop
    -- i increment ID IT
    addr <= addr_vect_priorite + i * 2;
    wait until falling_edge(clk);
  end loop;
  
  addr <= addr_vect_priorite + IT_size - 1; 
  
  wait until falling_edge(clk);

  ------------------------------------------------------------------
  --End reading section
  ------------------------------------------------------------------
  
  StopClock <= true;
  
  wait;

end process proc_test_EN;

end architecture Arch;
