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
    nCS_IT, nAS, RnW : in Def_bit;
    vect_priorite : in Def_vect_priorite;
    vect_handler : in Def_vect_handler;
    masque : in Def_masque;
    EN : in Def_EN
  );
end entity interface_write;

architecture RTL of interface_write is

  signal RST : Def_bit;
  signal CS : Def_bit;
  signal AS : Def_bit;

begin

  RST <= not nRST;
  CS <= not nCS_IT;
  AS <= not nAS;

  Reinitialisation : process (RST)
  begin
    if RST = '1' then
      vect_priorite <= (others => '0');
      vect_handler <= (others => '0');
      masque <= (others => '0');
      EN <= (others => '0');
    end if;
  end process Reinitialisation;

  Write : process (clk)
  begin
    if rising_edge (clk) then
      if CS = '1' and RnW = '0' and AS = '1' then
        case addr is
          when addr_masque =>
            masque <= d_bus;
          when addr_vect_priorite =>
            vect_priorite <= d_bus;
          when addr_vect_handler =>
            if EN = '0' then
              vect_handler <= d_bus;
            else
              vect_handler <= (others => '0');
            end if;
          when addr_EN =>
            EN <= d_bus;
          when others =>

        end case;
      end if;
    end if;
  end process Write;

end architecture RTL;