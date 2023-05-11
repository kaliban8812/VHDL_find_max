-- Filename     : processing.vhd
-- Author       : Vladimir Lavrov
-- Date         : 29.01.2021
-- Annotation   : find a few max in a signal
-- Version      : 1.0
-- Mod.Data     : 17.02.2021
-- Note         : 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processing is
    generic (
        DATA_LENGTH_I : integer := 26 - 1;
        DATA_LENGTH_O : integer := 13 - 1
    );
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;

        valid_i  : in std_logic;
        data_3_i : in std_logic_vector(DATA_LENGTH_I downto 0); -- data_i    : in port_array_8_bit;
        data_2_i : in std_logic_vector(DATA_LENGTH_I downto 0); -- data_i    : in port_array_8_bit;
        data_1_i : in std_logic_vector(DATA_LENGTH_I downto 0); -- data_i    : in port_array_8_bit;
        data_0_i : in std_logic_vector(DATA_LENGTH_I downto 0); -- data_i    : in port_array_8_bit;

        rdy_stb_o : out std_logic;
        data_3_o  : out std_logic_vector(DATA_LENGTH_O downto 0); -- port_array_16_bit
        data_2_o  : out std_logic_vector(DATA_LENGTH_O downto 0); -- port_array_16_bit
        data_1_o  : out std_logic_vector(DATA_LENGTH_O downto 0); -- port_array_16_bit
        data_0_o  : out std_logic_vector(DATA_LENGTH_O downto 0)  -- port_array_16_bit

    );
end entity processing;

architecture rtl of processing is
    -- combine the input lines
    constant NUM_LINES : integer := 3; -- 0 to 3
    type data_i_type is array (0 to NUM_LINES) of std_logic_vector(data_0_i'range);
    signal data_i : data_i_type;
    -- combine the output lines
    type data_o_type is array (0 to NUM_LINES) of std_logic_vector(data_0_o'range);
    signal data_o : data_o_type;
    -- fsm
    type prc_fsmtype is (prc_st_idle, prc_st_proc, prc_st_spit); -- fsm
    signal prc_fsm : prc_fsmtype := prc_st_idle;                 -- fsm
    -- point counter
    constant PRC_POINT_LENGTH : unsigned(data_0_o'range) := to_unsigned((2 ** (DATA_LENGTH_O + 1)) - 1, data_0_o'length);
    constant PRC_POINT_MAX    : unsigned(data_0_o'range) := PRC_POINT_LENGTH;
    signal prc_point_cnt      : unsigned(data_0_o'range);
    -- signal for sensors, num sensors in line
    constant PRC_NUM_SENS : integer := 3;
    type prc_sens_cnt_type is array (0 to NUM_LINES) of integer range 0 to PRC_NUM_SENS;
    signal prc_sens_cnt : prc_sens_cnt_type;
    type prc_sens_type is array (0 to NUM_LINES) of std_logic_vector(data_0_i'range);
    signal prc_sens_val : prc_sens_type;
    type prc_point_type is array (0 to NUM_LINES, 0 to PRC_NUM_SENS) of unsigned(data_0_o'range);
    signal prc_point : prc_point_type;
    type prc_top_type is array (0 to NUM_LINES) of boolean;
    signal prc_top : prc_top_type;
    -- threshold
    constant PRC_DATA_THRESHOLD : std_logic_vector(data_0_i'range) := std_logic_vector(to_unsigned(1800000, data_0_i'length));
    -- 
    signal prc_valid_prev : std_logic;

begin

    PRC_PROC : process (clk_i, rst_i)
    begin
        if rst_i = '1' then
            prc_fsm        <= prc_st_idle;
            prc_valid_prev <= '0';

        elsif rising_edge(clk_i) then

            prc_valid_prev <= valid_i;

            case prc_fsm is

                when prc_st_idle =>

                    if prc_valid_prev = '0' and valid_i = '1' then -- pos edge
                        prc_fsm <= prc_st_proc;
                    end if;
                    rdy_stb_o     <= '0';
                    prc_point     <= (others => (others => (others => '0')));
                    prc_point_cnt <= (others => '0');
                    prc_sens_cnt  <= (others => 0);
                    prc_top       <= (others => false);
                    prc_sens_val  <= (others => (others => '0'));

                when prc_st_proc =>
                    for n in 0 to NUM_LINES loop
                        if data_i(n) >= PRC_DATA_THRESHOLD then
                            prc_top(n) <= true;
                            if prc_sens_val(n) < data_i(n) then
                                prc_sens_val(n)                <= data_i(n);
                                prc_point (n, prc_sens_cnt(n)) <= prc_point_cnt;
                            end if;
                        else
                            if prc_top(n) then
                                prc_top(n)      <= false;
                                prc_sens_val(n) <= (others => '0');
                                if prc_sens_cnt(n) < PRC_NUM_SENS and prc_point_cnt < PRC_POINT_MAX then
                                    prc_sens_cnt(n) <= prc_sens_cnt(n) + 1;
                                end if;
                            end if;
                        end if;
                    end loop;

                    if prc_valid_prev = '1' and valid_i = '0' then -- neg edge
                        prc_fsm         <= prc_st_spit;
                        prc_sens_cnt(0) <= 0;
                    elsif prc_point_cnt = PRC_POINT_MAX then
                        prc_fsm         <= prc_st_spit;
                        prc_sens_cnt(0) <= 0;
                    else
                        prc_point_cnt <= prc_point_cnt + 1;
                    end if;

                when prc_st_spit =>
                    rdy_stb_o <= '1';
                    if prc_sens_cnt(0) = PRC_NUM_SENS then
                        prc_fsm <= prc_st_idle;
                    else
                        prc_sens_cnt(0) <= prc_sens_cnt(0) + 1;
                    end if;

                    for n in 0 to NUM_LINES loop
                        data_o(n) <= std_logic_vector(prc_point(n, prc_sens_cnt(0)));
                    end loop;

                when others =>
            end case;
        end if;

    end process PRC_PROC;

    -- combine the data lines
    -- the input lines
    data_i(0) <= data_0_i;
    data_i(1) <= data_1_i;
    data_i(2) <= data_2_i;
    data_i(3) <= data_3_i;
    -- the output lines
    data_0_o <= data_o(0);
    data_1_o <= data_o(1);
    data_2_o <= data_o(2);
    data_3_o <= data_o(3);

end architecture rtl;