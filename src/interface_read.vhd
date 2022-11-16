library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
library work;
use work.controller_IT_package.all;

entity interface_read is
  port (
    clk     : in    Def_bit;
    nRST    : in    Def_bit;
    addr    : in    Def_addr;
    d_bus   : out    Def_data;
    nCS_IT,nAS,RnW  : in    Def_bit;
    vect_priorite : in  Def_ConfigRd.vect_priorite;
    vect_handler : in  Def_ConfigRd.vect_handler;
    masque : in Def_ConfigRd.masque;
    pending : in Def_ConfigRd.pending;
    blx : in Def_ConfigRd.blx;
    EN : in Def_ConfigRd.EN
  );
end entity interface_read;

architecture RTL of interface_read is

    signal RST : Def_bit;
    signal CS : Def_bit;
    signal AS : Def_bit;

begin

RST <= not nRST;
CS <= not nCS_IT;
AS <= not nAS;

Reinitialisation : process(RST)
    begin
    if RST = '1' then  
        vect_priorite <= (others => '0');
        vect_handler <= (others => '0');
        masque <= (others => '0');
        pending <= (others => '0');
        blx <= (others => '0');
        EN <= (others => '0');
    end if;
end process Reinitialisation;

Read : process (RnW,CS,addr,vect_priorite,vect_handler,masque,pending,blx)
  begin
      d_bus <= TriState;
      if CS='1' and RnW='1' and AS='1' then
        case addr is
          when addr_masque =>
            d_bus <= masque
          when addr_vect_priorite =>
            d_bus <= vect_priorite;
          when addr_vect_handler =>
            d_bus <= vect_handler;
          when addr_pending =>
            d_bus <= pending;
          when addr_blx =>
            d_bus <= blx;
          when addr_EN =>
            d_bus <= EN;
          when others =>
                
        end case;
      end if;
end process Read;

end architecture RTL;
