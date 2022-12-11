
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.priority_solver_pkg.all;
use work.controller_IT_package.all;


entity mask is
    port (
        nIT_xxx : in unsigned(IT_size - 1 downto 0);
        mask : in Def_masque;
        nIT_xxx_masked : out unsigned(IT_size - 1 downto 0)
    );
end entity;

architecture arch of mask is
 
begin
    nIT_xxx_masked <= nIT_xxx and not mask;
end arch ; -- arch

-- notes
    -- need : set_property FILE_TYPE {VHDL 2008} [get_files <file>.vhd] 