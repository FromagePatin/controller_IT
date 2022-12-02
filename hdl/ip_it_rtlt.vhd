-- VHDL Entity controller_IT_lib.IP_IT.symbol
--
-- Created:
--          by - E20B103C.UNKNOWN (irc107-06)
--          at - 17:20:18 30/11/2022
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2022.1 Built on 21 Jan 2022 at 13:00:30
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY controller_IT_lib;
USE controller_IT_lib.controller_IT_package.all;

ENTITY IP_IT IS
-- Declarations

END IP_IT ;

--
-- VHDL Architecture controller_IT_lib.IP_IT.RTLt
--
-- Created:
--          by - E20B103C.UNKNOWN (irc107-06)
--          at - 17:21:43 30/11/2022
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2022.1 Built on 21 Jan 2022 at 13:00:30
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.Numeric_Std.all;
LIBRARY controller_IT_lib;
USE controller_IT_lib.controller_IT_package.all;


ARCHITECTURE RTLt OF IP_IT IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL EN            : Def_EN;
   SIGNAL RnW           : Def_bit;
   SIGNAL addr          : Def_addr;
   SIGNAL blx           : Def_addr;
   SIGNAL clk           : Def_bit;
   SIGNAL d_bus         : Def_data;
   SIGNAL masque        : Def_masque;
   SIGNAL nAS           : Def_bit;
   SIGNAL nCS_IT        : Def_bit;
   SIGNAL nRST          : Def_bit;
   SIGNAL pending       : Def_pending;
   SIGNAL vect_handler  : Def_vect_handler;
   SIGNAL vect_priorite : Def_vect_priorite;


   -- Component Declarations
   COMPONENT interface
   PORT (
      EN            : IN     Def_EN ;
      RnW           : IN     Def_bit ;
      addr          : IN     Def_addr ;
      blx           : IN     Def_addr ;
      clk           : IN     Def_bit ;
      masque        : IN     Def_masque ;
      nAS           : IN     Def_bit ;
      nCS_IT        : IN     Def_bit ;
      nRST          : IN     Def_bit ;
      pending       : IN     Def_pending ;
      vect_handler  : IN     Def_vect_handler ;
      vect_priorite : IN     Def_vect_priorite ;
      d_bus         : OUT    Def_data 
   );
   END COMPONENT;
   COMPONENT interface_tb
   PORT (
      d_bus         : IN     Def_data ;
      nAS           : OUT    Def_bit ;
      nRST          : OUT    Def_bit ;
      EN            : OUT    Def_EN ;
      pending       : OUT    Def_pending ;
      blx           : OUT    Def_addr ;
      vect_handler  : OUT    Def_vect_handler ;
      vect_priorite : OUT    Def_vect_priorite ;
      masque        : OUT    Def_masque ;
      addr          : OUT    Def_addr ;
      clk           : OUT    Def_bit ;
      RnW           : OUT    Def_bit ;
      nCS_IT        : OUT    Def_bit 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : interface USE ENTITY controller_IT_lib.interface;
   FOR ALL : interface_tb USE ENTITY controller_IT_lib.interface_tb;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_0 : interface
      PORT MAP (
         EN            => EN,
         RnW           => RnW,
         addr          => addr,
         blx           => blx,
         clk           => clk,
         masque        => masque,
         nAS           => nAS,
         nCS_IT        => nCS_IT,
         nRST          => nRST,
         pending       => pending,
         vect_handler  => vect_handler,
         vect_priorite => vect_priorite,
         d_bus         => d_bus
      );
   U_1 : interface_tb
      PORT MAP (
         d_bus         => d_bus,
         nAS           => nAS,
         nRST          => nRST,
         EN            => EN,
         pending       => pending,
         blx           => blx,
         vect_handler  => vect_handler,
         vect_priorite => vect_priorite,
         masque        => masque,
         addr          => addr,
         clk           => clk,
         RnW           => RnW,
         nCS_IT        => nCS_IT
      );

END RTLt;
