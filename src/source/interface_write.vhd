--
-- VHDL Architecture work.interface_write.RTL
--
-- Created:
--          by - E20B103C.UNKNOWN (irc107-02)
--          at - 18:00:01 06/12/2022
--
-- using Mentor Graphics HDL Designer(TM) 2022.1 Built on 21 Jan 2022 at 13:00:30
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
USE IEEE.Numeric_Std.all;

LIBRARY work;
USE work.controller_IT_package.ALL;

ENTITY interface_write IS
   PORT( 
      d_bus         : IN     Def_data;
      clk           : IN     Def_bit;
      vect_handler  : OUT    Def_vect_handler;
      masque        : OUT    Def_masque;
      RnW           : IN     Def_bit;
      nCS_IT        : IN     Def_bit;
      nAS           : IN     Def_bit;
      addr          : IN     Def_addr;
      nRST          : IN     Def_bit;
      EN            : OUT    Def_EN;
      vect_priorite : OUT    Def_vect_priorite
   );

-- Declarations

END interface_write ;

ARCHITECTURE Arch OF interface_write IS
BEGIN
  
  
  --EN <= '1';
  
  
  Write : process (clk)
  begin  
    if rising_edge (clk) then
      if nRST = '0' then
        EN <= '0';
        masque <= (others => '0');
        reset_priority_registers : for i in 0 to (IT_size - 1) loop
              vect_priorite(i) <= (others => '0');
        end loop;
        -- priority map last impaire
        if ((IT_size mod 2) = 1) then
            vect_priorite(IT_size - 1) <= (others =>'0');
        end if;
        
        reset_handler_registers : for i in (IT_size - 1) downto 0 loop
          -- i increment ID IT
            vect_handler(i) <= (others => '0');
        end loop;
        
      else
        if nCS_IT = '0' and RnW = '0' and nAS = '0' then
          -- Enable register
          case addr is
            when addr_EN => EN <= d_bus(0);
            when addr_masque => masque <= d_bus(masque'length-1 downto 0);
            --when addr_vect_handler => d_bus <= vect_handler;
            --when addr_vect_priorite => d_bus <= vect_priorite;
            when others => 
        end case;
        
        HANDLER_MAPPING_WRITE :
        for i in (IT_size - 1) downto 0 loop
          -- i increment ID IT
          if (addr = addr_vect_handler + 4 * i) then -- LSB
            vect_handler(i)(data_bus_size-1 downto 0) <= d_bus;
          elsif (addr = addr_vect_handler + 4 * i + 2) then --MSB
            vect_handler(i)(addr_bus_size-1 downto data_bus_size) <= d_bus(addr_bus_size-data_bus_size-1 downto 0);
          end if;
        end loop;
        
        priority_mapping_write :
        for i in 0 to ((IT_size/2) - 1) loop
            if (addr = addr_vect_priorite + 2 * i) then
              vect_priorite(2*i) <= d_bus(2 downto 0);
              vect_priorite(2*i+1) <= d_bus(10 downto 8);
            end if;
        end loop;
        
        --priority map last odd
        if ((IT_size mod 2) = 1 and addr = addr_vect_priorite + IT_size - 1) then
            vect_priorite(IT_size - 1) <= d_bus(2 downto 0);
        end if;

        end if;
      end if;
    end if;
  end process Write;
  
END ARCHITECTURE Arch;

