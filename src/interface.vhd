library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
library work;
use work.controller_IT_package.all;

entity interface is
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
    EN : inout Def_ConfigRd.EN
  );
end entity interface;

architecture RTL of interface is

  -- Component declaration
  component interface_read
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
  end component;

  component interface_write
  port (
    clk     : in    Def_bit;
    nRST    : in    Def_bit;
    addr    : in    Def_addr;
    d_bus   : in    Def_data;
    nCS_IT,nAS,RnW  : in    Def_bit;
    vect_priorite : out  Def_ConfigWr.vect_priorite;
    vect_handler : out  Def_ConfigWr.vect_handler;
    masque : out Def_ConfigWr.masque;
    EN : inout Def_ConfigWr.EN
  );
  end component;

begin

    interface_read_generated : entity work.interface_read(RTL)
    port map(clk,nRST,addr,d_bus,nCS_IT,nAS,RnW,vect_priorite,vect_handler,masque,pending,blx,EN);

    interface_write_generated : entity work.interface_write(RTL)
    port map(clk,nRST,addr,d_bus,nCS_IT,nAS,RnW,vect_priorite,vect_handler,masque,EN);

end architecture RTL;