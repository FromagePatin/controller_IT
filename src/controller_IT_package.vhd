LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE controller_IT_package IS

    --Constants for the project  
    constant addr_bus_size : integer := 22;
    constant data_bus_size : integer := 16;
    constant byte_size : integer := 8;
    constant IT_size : integer := 15;
  
    --Data type for the project
    subtype Def_addr is unsigned(addr_bus_size-1 downto 0);
    subtype Def_data is unsigned(data_bus_size-1 downto 0);
    subtype Def_vect_priorite is array (0 to IT_size-1 of unsigned(byte_size-1 downto 0));
    subtype Def_vect_handler is array (0 to IT_size-1 of Def_addr);
    subtype Def_bit is std_logic;
    subtype Def_masque is Def_bit;
    subtype Def_pending is Def_bit;
    subtype Def_EN is Def_bit;
    
    type Def_Branch is record
        blx : Def_addr;
    end record;

    type Def_ConfigWr is record
        vect_handler : Def_vect_handler;
        vect_priorite : Def_vect_priorite;
        masque : Def_masque;
        EN : Def_EN;
    end record;

    type Def_ConfigRd is record
        vect_handler : Def_vect_handler;
        blx : Def_addr;
        vect_priorite : Def_vect_priorite;
        masque : Def_masque;
        pending : Def_pending;
        EN : Def_EN;
    end record;    
  
    --Constants for the project
    constant TriState : Def_data := (others => 'Z');
    constant addr_EN : Def_addr := X"0";
    constant addr_masque : Def_addr := X"2";
    constant addr_vect_handler : Def_addr := X"A"; 
    constant addr_vect_priorite : Def_addr := X"44";
    constant addr_pending : Def_addr := X"4";
    constant addr_blx : Def_addr := X"6";

END controller_IT_package;
