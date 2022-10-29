----------------------------------------------------------------------------------
-- Course: SE2 SoC Design 
-- Engineer: Louison GOUY and Mathis BRIARD
-- 
-- Create Date: 28/10/2022 08:50 AM
-- Design Name: priority_solver_tb
-- Project Name: controller_IT 
-- Description: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Entity declaration
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY priority_solver_tb IS

END ENTITY priority_solver_tb;

ARCHITECTURE Bench OF priority_solver_tb IS
    -- constant
    CONSTANT cte_nb_bit_id_it : INTEGER := 2;
    CONSTANT cte_nb_bit_prio : INTEGER := 2;
    --signal
    SIGNAL nIT_xxx : unsigned((2 ** cte_nb_bit_id_it) - 1 DOWNTO 0);
    SIGNAL id_it : unsigned(cte_nb_bit_id_it - 1 DOWNTO 0);

BEGIN

    priority_solver : ENTITY work.priority_solver(arch_priority_solver)
        GENERIC MAP(
            cte_nb_bit_id_it,
            cte_nb_bit_prio
        )
        PORT MAP(
            nIT_xxx,
            id_it
        );

        

    gen_it_in_loop : PROCESS IS
    BEGIN
        nIT_xxx <= "0001";

            FOR i IN 0 TO 2 ** cte_nb_bit_id_it - 1 LOOP
                nIT_xxx <= to_unsigned(i, 2 ** cte_nb_bit_id_it);
                WAIT FOR 5 ns;
            END LOOP;

        wait; -- obligation
    END PROCESS;

END ARCHITECTURE Bench;

-- library IEEE;
-- use IEEE.STD_LOGIC_1164.all;
-- use IEEE.Numeric_Std.all;

-- entity Decoder_TB is
-- end entity Decoder_TB;

-- architecture Bench of Decoder_TB is

--     constant cte_Size  : INTEGER := 2;

--     signal Address_MSB : unsigned(cte_Size-1 downto 0);
--     signal CS_ram      : unsigned(2**cte_Size-1 downto 0);

-- begin

--     UUT: entity work.Address_Decoder(decoder)
--     generic map(cte_Size)
--     port map (
--         address_msb : Address_MSB;
--         CS_ram : CS_ram
--     );

--     ClockGen: process is
--     begin
--     while not StopClock loop
--         clock <= '0';
--         wait for 5 ns;
--         clock <= '1';
--         wait for 5 ns;
--     end loop;
--     wait;
--     end process ClockGen;

--     Stim: process is

--     begin

--     wait until rising_edge(clock); -- cycle 1
--     address_msb <= "00";
--     assert CS_ram = "0001";

--     wait until rising_edge(clock); -- cycle 2
--     address_msb <= "01";
--     assert CS_ram = "0010";

--     wait until rising_edge(clock); -- cycle 3
--     address_msb <= "10";
--     assert CS_ram = "0100";

--     wait until rising_edge(clock); -- cycle 4
--     address_msb <= "11";
--     assert CS_ram = "1000";

--     StopClock <= true;
--     wait;
--     end process;

-- end architecture Bench;