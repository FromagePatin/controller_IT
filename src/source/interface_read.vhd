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
    d_bus : out Def_data; --unsigned(data_bus_size - 1 downto 0);
    nCS, nAS, RnW : in Def_bit;
    vect_priorite : in Def_vect_priorite;
    vect_handler : in Def_vect_handler;
    masque : in Def_masque;
    pending : in Def_pending;
    blx : in Def_addr;
    EN : in Def_EN);
end entity interface_read;

architecture RTL of interface_read is

begin

  Reinitialisation : process (nRST)
  begin
    if nRST = '0' then
      -- init what is NOT an input !
    end if;
  end process Reinitialisation;

  --Read : process (RnW, CS, addr, vect_priorite, vect_handler, masque, pending, blx)
  Read : process (clk)
  begin
    if rising_edge(clk) then
      d_bus <= TriState;
      if nRST = '1'and nCS = '0' and RnW = '1' and nAS = '0' then
        d_bus <= (others => '0'); -- if addr is not covered

        -- case addr is
        --   when addr_EN => d_bus <= (0=>EN, others => '0');
        --   when addr_masque => d_bus <= (masque, others => '0');
        --   when addr_pending => d_bus <= (pending, others => '0');
        --   when addr_blx => d_bus <= blx(data_bus_size - 1 downto 0); -- LSB
        --   when addr_blx + 2 => d_bus <= (blx(addr_bus_size - 1 downto data_bus_size), others => '0'); -- MSB
        --   --when addr_vect_handler => d_bus <= vect_handler;
        --   --when addr_vect_priorite => d_bus <= vect_priorite;
        --  when others => 
        -- end case;

        handler_mapping :
        for i in (IT_size - 1) downto 0 loop
          -- i increment ID IT
          if (addr = addr_vect_handler + 4 * i) then -- LSB
            d_bus <= vect_handler(i)(data_bus_size - 1 downto 0);
          elsif (addr = addr_vect_handler + 4 * i + 2) then --MSB
            -- d_bus <= (vect_handler(i)(addr_bus_size - 1 downto data_bus_size), others => '0');
          end if;
        end loop;

        priority_mapping :
        for i in 0 to ((IT_size/2) - 1) loop
          if (addr = addr_vect_priorite + 2 * i) then
            d_bus <= (0 to 2 => vect_priorite(2 * i),
              8 to 10 => vect_priorite(2 * i + 1),
              (others => '0'));
          end if;
        end loop;
            -- priority map last impaire
        if ((IT_size mod 2) = 1 and addr = addr_vect_priorite + IT_size - 1) then
          d_bus <= (0 to 2 => vect_priorite(IT_size - 1));
        end if;

      end if;
    end if;

  end process Read;

end architecture RTL;