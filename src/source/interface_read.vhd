library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

library work;
use work.controller_IT_package.all;

entity interface_read is
  port (
    clk : in Def_bit;
    nRST : in Def_bit;
    addr : in Def_addr;
    d_bus : out unsigned(data_bus_size - 1 downto 0);
    nCS_IT : in Def_bit;
    nAS : in Def_bit;
    RnW : in Def_bit;
    vect_priorite : in Def_vect_priorite;
    vect_handler : in Def_vect_handler;
    masque : in Def_masque;
    pending : in Def_pending;
    blx : in Def_addr;
    EN : in Def_EN
  );
end entity interface_read;

architecture RTL of interface_read is

  signal RST : Def_bit;
  signal CS : Def_bit;
  signal AS : Def_bit;

begin

  --Inserting NOT gates to make signals active low
  RST <= not nRST;
  CS <= not nCS_IT;
  AS <= not nAS;

  Reinitialisation : process (RST)
  begin
    if RST = '1' then
      -- init what is NOT an input !
    end if;
  end process Reinitialisation;

  --Read : process (RnW, CS, addr, vect_priorite, vect_handler, masque, pending, blx)
  Read : process (clk)
  begin
    d_bus <= TriState;
    if rising_edge(clk) and CS = '1' and RnW = '1' and AS = '1' then
      d_bus <= (others => '0'); 
      case addr is
        when addr_EN => d_bus <= (0 => EN, others => '0');
        when addr_masque => d_bus <= to_unsigned(to_integer(masque),addr_bus_size);
        when addr_pending => d_bus <= to_unsigned(to_integer(pending),addr_bus_size);
        when addr_blx => d_bus <= to_unsigned(to_integer(blx(data_bus_size-1 downto 0)),addr_bus_size); -- LSB
        when addr_blx_2 => d_bus <= to_unsigned(to_integer(blx(addr_bus_size-1 downto data_bus_size)),addr_bus_size); -- MSB
        --when addr_vect_handler => d_bus <= ve(std_logic_vector(blx(addr_bus_size - 1 downto data_bus_size)), others => '0')ct_handler;
        --when addr_vect_priorite => d_bus <= vect_priorite;
       when others => d_bus <= (others => '0');
      end case;

      HANDLER_MAPPING :
      for i in (IT_size - 1) downto 0 loop
        -- i increment ID IT
        if (addr = addr_vect_handler + 4 * i) then -- LSB
          d_bus <= vect_handler(i)(data_bus_size - 1 downto 0);
        elsif (addr = addr_vect_handler + 4 * i + 2) then --MSB
          d_bus <= to_unsigned(to_integer(vect_handler(i)(addr_bus_size - 1 downto data_bus_size)), addr_bus_size);
        end if;
      end loop;

    end if;
  end process Read;

end architecture RTL;