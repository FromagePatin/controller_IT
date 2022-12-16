LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
USE IEEE.Numeric_Std.all;

LIBRARY work;
USE work.controller_IT_package.ALL;

ENTITY interface_read IS
   PORT( 
      d_bus         : OUT    Def_data;
      pending       : IN     Def_pending;
      blx           : IN     Def_addr;
      vect_handler  : IN     Def_vect_handler;
      RnW           : IN     Def_bit;
      nRST          : IN     Def_bit;
      masque        : IN     Def_masque;
      clk           : IN     Def_bit;
      EN            : IN     Def_EN;
      nCS_IT        : IN     Def_bit;
      nAS           : IN     Def_bit;
      addr          : IN     Def_addr;
      vect_priorite : IN     Def_vect_priorite;
      Ack_Read      : OUT    Def_bit
   );

-- Declarations

END interface_read ;

architecture Arch of interface_read is

begin

  Read : process (clk)
  begin
  --d_bus <= TriState;
  if rising_edge(clk) then
    d_bus <= TriState;
    Ack_Read <= '0';
    if (nRST='0') then
      Ack_Read <= '0';
    else
      if nCS_IT = '0' and RnW = '1' and nAS = '0' then
        d_bus <= (others => '0'); 
        case addr is
          when addr_EN => d_bus <= (0=>EN, others => '0');
          when addr_masque => d_bus <= (masque'length - 1  downto 0 => masque, others => '0');
          when addr_pending => d_bus <= (pending'length - 1 downto 0 => pending, others => '0');
          when addr_blx => 
            d_bus <= blx(d_bus'length - 1 downto 0); -- LSB
            Ack_Read <= '1';
          when addr_blx + 2 => d_bus <= (blx(blx'length - 1 downto d_bus'length)'length - 1 downto 0 => blx(blx'length - 1 downto d_bus'length), others => '0'); -- MSB
          --when addr_vect_handler => d_bus <= vect_handler;
          --when addr_vect_priorite => d_bus <= vect_priorite;
         when others => 
        end case;
  
        HANDLER_MAPPING_READ:
        for i in (IT_size - 1) downto 0 loop
          -- i increment ID IT
          if (addr = addr_vect_handler + 4 * i) then -- LSB
            d_bus <= vect_handler(i)(data_bus_size - 1 downto 0);
          elsif (addr = addr_vect_handler + 4 * i + 2) then --MSB
            d_bus <= (vect_handler(i)(addr_bus_size - 1 downto data_bus_size), others => '0');
          end if;
        end loop;
        
        priority_mapping_read :
        for i in 0 to ((IT_size/2) - 1) loop
            if (addr = addr_vect_priorite + 2 * i) then
              d_bus <= (2 downto 0 => vect_priorite(2 * i),
                10 downto 8 => vect_priorite(2 * i + 1),
                others => '0');
            end if;
        end loop;

        -- priority map last impaire
        if ((IT_size mod 2) = 1 and addr = addr_vect_priorite + IT_size - 1) then
            d_bus <= (2 downto 0 => vect_priorite(IT_size - 1), others => '0');
        end if;
  
      end if;
    end if;
  end if;
  end process Read;

end architecture Arch;
