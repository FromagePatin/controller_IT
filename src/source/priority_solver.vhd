----------------------------------------------------------------------------------
-- Course: SE2 SoC Design 
-- Engineer: Louison GOUY and Mathis BRIARD
-- 
-- Create Date: 28/10/2022 08:50 AM
-- Design Name: priority_solver
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

ENTITY priority_solver IS
    GENERIC (
        nb_bit_it : INTEGER := 2;
        nb_bit_prio : INTEGER := 2
    );
    PORT (
        nIT_xxx : IN unsigned((2 ** nb_bit_it) - 1 DOWNTO 0);
        id_it : OUT unsigned(nb_bit_it - 1 DOWNTO 0)
    );
END ENTITY priority_solver;

ARCHITECTURE arch_priority_solver OF priority_solver IS
    -- Creates an unconstrained array (MUST be constrained when defined!)
    -- https://nandland.com/arrays/
    TYPE t_array_prio IS ARRAY (INTEGER RANGE <>) OF unsigned(nb_bit_prio - 1 DOWNTO 0);
    TYPE t_array_nb_prio IS ARRAY (INTEGER RANGE <>) OF unsigned(2 ** nb_bit_prio - 1 DOWNTO 0);

    SIGNAL priority_vector : t_array_prio(0 TO (2 ** nb_bit_it) - 1) := ("11", "01", "10", "00");
    SIGNAL out_first_mux : t_array_nb_prio(0 TO 2 ** nb_bit_it - 1) := (OTHERS => (OTHERS => '0'));
    SIGNAL demuxed_priority : unsigned(2 ** nb_bit_prio - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL out_prio_decode : unsigned(2 ** nb_bit_prio - 1 DOWNTO 0);
    SIGNAL current_prio : unsigned(nb_bit_prio - 1 DOWNTO 0);

    FUNCTION or_array(vector : t_array_nb_prio(0 TO 2 ** nb_bit_it - 1)) RETURN unsigned IS
        VARIABLE result : unsigned(2 ** nb_bit_prio - 1 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        FOR i IN vector'RANGE LOOP
            result := result OR vector(i);
        END LOOP;
        RETURN result;
    END FUNCTION;

    FUNCTION prio_decoder(vector : unsigned(2 ** nb_bit_prio - 1 DOWNTO 0)) RETURN unsigned IS
        VARIABLE result : unsigned(2 ** nb_bit_prio - 1 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        -- FOR j IN 2 ** nb_bit_prio - 1 TO 0 LOOP
        --     FOR i IN 2 ** nb_bit_prio - 1 TO j LOOP
        --         IF (i = j) THEN
        --             result(j) := result(j) AND vector(i);
        --         ELSE
        --             result(j) := result(j) AND (NOT vector(i));
        --         END IF;
        --     END LOOP;
        -- END LOOP;

        result(0) := vector(0) AND (NOT vector(1)) AND (NOT vector(2)) AND (NOT vector(3));
        result(1) := vector(1) AND (NOT vector(2)) AND (NOT vector(3));
        result(2) := vector(2) AND (NOT vector(3));
        result(3) := vector(3);

        RETURN result;
    END FUNCTION;

BEGIN

    DEMUX_1 :
    FOR id_it_index IN priority_vector'RANGE GENERATE
        -- demultiplex from nIT_xxx[] to right priority channel
        out_first_mux(id_it_index) <= shift_left(to_unsigned(1, 2 ** nb_bit_it), to_integer(priority_vector(id_it_index)))
        WHEN nIT_xxx(id_it_index) = '1' ELSE
        to_unsigned(0, 2 ** nb_bit_it);
    END GENERATE;

    demuxed_priority <= or_array(out_first_mux);--or(out_first_mux(0));
    out_prio_decode <= prio_decoder(demuxed_priority);

    current_prio <= "00" WHEN out_prio_decode = "0000" ELSE
        "01" WHEN out_prio_decode = "0001" ELSE
        "01" WHEN out_prio_decode = "0010" ELSE
        "10" WHEN out_prio_decode = "0100" ELSE
        "11" WHEN out_prio_decode = "1000" ELSE
        "00";

        

END ARCHITECTURE arch_priority_solver;