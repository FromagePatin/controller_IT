library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
library work;
use work.controller_IT_package.all;

entity interface_write is
  port (
    clk : in Def_bit;
    nRST : in Def_bit;
    addr : in Def_addr;
    d_bus : in Def_data;
    nCS, nAS, RnW : in Def_bit;
    vect_priorite : in Def_vect_priorite;
    vect_handler : in Def_vect_handler;
    masque : out Def_masque;
    EN : inout Def_EN
  );
end entity interface_write;

architecture RTL of interface_write is

begin
  Write : process (clk)
  begin
    if rising_edge (clk) then
      if nRST = '0' then
        EN <= '0';
        masque <= (others => '0');
        --report "Write module reset";
      else
        if nCS = '0' and RnW = '0' and nAS = '0' then
          -- Enable register
          if (addr = addr_EN) then
            EN <= d_bus(0);
            --report "writing at address EN";
          end if;

        end if;
      end if;
    end if;
  end process Write;

end architecture RTL;