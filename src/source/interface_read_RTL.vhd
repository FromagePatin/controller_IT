library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.Numeric_Std.all;

library controller_IT_lib;
use controller_IT_lib.controller_IT_package.all;
entity interface_read is
  port (
    d_bus : out Def_data;
    clk : in Def_bit;
    nAS : in Def_bit;
    nCS_IT : in Def_bit;
    nRST : in Def_bit;
    RnW : in Def_bit;
    EN : in Def_EN;
    vect_priorite : in Def_vect_priorite;
    pending : in Def_pending;
    masque : in Def_masque;
    addr : in Def_addr;
    blx : in Def_addr;
    vect_handler : in Def_vect_handler
  );

  -- Declarations

end interface_read;

architecture RTL of interface_read is

begin

  Read : process (clk)
  begin
    d_bus <= TriState;
    if rising_edge(clk) then
      if (nRST = '0') then
        -- reset signal 
      else
        if nCS_IT = '0' and RnW = '1' and nAS = '0' then
          d_bus <= (others => '0');
          case addr is
            when addr_EN => d_bus <= (0 => EN, others => '0');
            when addr_masque => d_bus <= (masque'length - 1 downto 0 => masque, others => '0');
            when addr_pending => d_bus <= (pending'length - 1 downto 0 => pending, others => '0');
            when addr_blx => d_bus <= blx(d_bus'length - 1 downto 0); -- LSB
            when addr_blx + 2 => d_bus <= (blx(blx'length - 1 downto d_bus'length)'length - 1 downto 0 => blx(blx'length - 1 downto d_bus'length), others => '0'); -- MSB
              --when addr_vect_handler => d_bus <= vect_handler;
              --when addr_vect_priorite => d_bus <= vect_priorite;
            when others =>
          end case;

          HANDLER_MAPPING :
          for i in (IT_size - 1) downto 0 loop
            -- i increment ID IT
            if (addr = addr_vect_handler + 4 * i) then -- LSB
              d_bus <= vect_handler(i)(data_bus_size - 1 downto 0);
            elsif (addr = addr_vect_handler + 4 * i + 2) then --MSB
              d_bus <= (vect_handler(i)(addr_bus_size - 1 downto data_bus_size), others => '0');
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

        end if; -- CS AS RnW
      end if; -- nRST
    end if; -- clk edge

  end process Read;

end architecture RTL;