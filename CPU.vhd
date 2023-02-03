-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.0.0 Build 614 04/24/2018 SJ Lite Edition"
-- CREATED		"Tue Jan 12 09:49:06 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

LIBRARY work;


-- Entity declaration

ENTITY CPU IS 
	PORT
	(
		MAX10_CLK1_50 :  IN  STD_LOGIC; -- 50 MHz clock
		SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX2 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX3 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX4 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX5 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)	
	);

END CPU;


ARCHITECTURE bdf_type OF CPU IS 

-- Component instantiation

COMPONENT seg7_lut
	PORT(iDIG : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 oSEG : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		 );
END COMPONENT;

COMPONENT dig2dec
	PORT(vol : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 seg0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		 );
END COMPONENT;

COMPONENT decoder IS
    PORT (
        clk	:	in std_logic;
        instruction: in std_logic_vector(22 downto 0);
		  alu_zero: in std_logic;
        jmp: out std_logic;
		  reg_enable: out std_logic;
		  reg_write: out std_logic;
		  reg_write_address: out std_logic_vector(3 downto 0);
		  alu_reg_in1: out std_logic_vector(3 downto 0);
		  alu_reg_in2: out std_logic_vector(3 downto 0);
		  alu_immediate_in: out std_logic_vector(7 downto 0);
		  alu_op: out std_logic_vector(2 downto 0)
		  );
END COMPONENT;


COMPONENT ALU
	PORT(a, b, c: in std_logic_vector(7 downto 0); -- a and b are the inputs from the register, c is the direct one from the decoder
        op: in std_logic_vector(2 downto 0);
        result_out: out std_logic_vector(7 downto 0);
		  zero_flag: out std_logic;
		  w_enable: out std_logic
		  );
END COMPONENT;

COMPONENT reg
	PORT(
			en		:	in std_logic;
			w_enable :	in std_logic;
			clk		:	in std_logic;
			SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
			Address_w:	in std_logic_vector(3 downto 0);
			Address_r_1:	in std_logic_vector(3 downto 0);
			Address_r_2:	in std_logic_vector(3 downto 0);
			Data_in	:	in std_logic_vector(7 downto 0);
			Data_out_1:	out std_logic_vector(7 downto 0);
			Data_out_2:	out std_logic_vector(7 downto 0)
			);
END COMPONENT;

COMPONENT rom
	PORT(
			en			:	in std_logic;
			clk		:	in std_logic;
			Address	:	in std_logic_vector(7 downto 0);
			Data_out:	out std_logic_vector(22 downto 0)
			);
END COMPONENT;

COMPONENT Fetch
	port(
			en			:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			PC_load	:	in std_logic;
			PC_Jump	:	in std_logic_vector(7 downto 0);
			PC_out	:	out std_logic_vector(7 downto 0)
			);
END COMPONENT;

COMPONENT Event_Detect
	port(
			clk			:	in std_logic;
			IN_Signal	:	in std_logic;
			Event_L2H	:	out std_logic;
			Event_H2L	:	out std_logic
			);
END COMPONENT;


-- End of component instantiation


--Signal declarations

SIGNAL	fetch_enable : std_logic := '1';
SIGNAL	rom_enable : std_logic := '1';
SIGNAL	fetch_reset : std_logic := '0';

SIGNAL	instruction_address : std_logic_vector(7 downto 0) := "00000000";
SIGNAL	instruction : std_logic_vector(22 downto 0) := "10100000000000000000000";
SIGNAL	pc : std_logic_vector(7 downto 0) := "00000000";

SIGNAL	jmp_flag : std_logic;
SIGNAL	reg_enable : std_logic;
SIGNAL	reg_write_flag : std_logic;
SIGNAL	reg_write_address : std_logic_vector(3 downto 0);
SIGNAL	alu_reg_in1 : std_logic_vector(3 downto 0);
SIGNAL	alu_reg_in2 : std_logic_vector(3 downto 0);
SIGNAL	alu_immediate_in: std_logic_vector(7 downto 0);
SIGNAL	alu_op: std_logic_vector(2 downto 0);

SIGNAL	alu_data_in1 : std_logic_vector(7 downto 0);
SIGNAL	alu_data_in2 : std_logic_vector(7 downto 0);
SIGNAL	alu_result : std_logic_vector(7 downto 0);
SIGNAL	alu_zero : std_logic;


SIGNAL	zero :  STD_LOGIC;
SIGNAL	one :  STD_LOGIC;
SIGNAL	HEX_out0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	seg7_in0 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);



BEGIN 

-- Component instantiation inside the concurrent statements

decoder_inst:	decoder
    PORT MAP (
        clk => MAX10_CLK1_50,
        instruction => instruction,
		  alu_zero => alu_zero,
        jmp => jmp_flag,
		  reg_enable => reg_enable,
		  reg_write => reg_write_flag,
		  reg_write_address => reg_write_address,
		  alu_reg_in1 => alu_reg_in1,
		  alu_reg_in2 => alu_reg_in2,
		  alu_immediate_in => alu_immediate_in,
		  alu_op => alu_op);

reg_inst:	reg 
PORT MAP(en => reg_enable,
			w_enable => reg_write_flag,
			clk => MAX10_CLK1_50,
			SW => SW,
			Address_w => reg_write_address,
			Address_r_1 => alu_reg_in1,
			Address_r_2 =>alu_reg_in2,
			Data_in => alu_result,
			Data_out_1 => alu_data_in1,
			Data_out_2 => alu_data_in2);


rom_inst:	rom 
PORT MAP(en	=> rom_enable,
			clk => MAX10_CLK1_50,
			Address => instruction_address,
		   Data_out => instruction);

fetch_inst:	Fetch 
PORT MAP(en => fetch_enable,
			clk => MAX10_CLK1_50,
			rst => fetch_reset,
			PC_load=> jmp_flag,
			PC_Jump=> alu_result,
		   PC_out=> instruction_address);

alu_inst:	ALU 
PORT MAP(a => alu_data_in1, 
			b => alu_data_in2,
			c => alu_immediate_in, 
			op => alu_op, 
			result_out => alu_result,
			zero_flag => alu_zero,
			w_enable => reg_write_flag);

			

		 
-- LED display components


b2v_inst : seg7_lut
PORT MAP(iDIG => seg7_in0,
		 oSEG => HEX_out4(6 DOWNTO 0));


b2v_inst1 : seg7_lut
PORT MAP(iDIG => seg7_in1,
		 oSEG => HEX_out3(6 DOWNTO 0));



b2v_inst2 : seg7_lut
PORT MAP(iDIG => seg7_in2,
		 oSEG => HEX_out2(6 DOWNTO 0));


b2v_inst3 : seg7_lut
PORT MAP(iDIG => seg7_in3,
		 oSEG => HEX_out1(6 DOWNTO 0));


b2v_inst4 : seg7_lut
PORT MAP(iDIG => seg7_in4,
		 oSEG => HEX_out0(6 DOWNTO 0));


b2v_inst5 : dig2dec
PORT MAP(		 vol => "1101010110101010",
		 seg0 => seg7_in4,
		 seg1 => seg7_in3,
		 seg2 => seg7_in2,
		 seg3 => seg7_in1,
		 seg4 => seg7_in0);


HEX0 <= HEX_out0;
HEX1 <= HEX_out1;
HEX2 <= HEX_out2;
HEX3 <= HEX_out3;
HEX4 <= HEX_out4;
HEX5(7) <= one;
HEX5(6) <= one;
HEX5(5) <= one;
HEX5(4) <= one;
HEX5(3) <= one;
HEX5(2) <= one;
HEX5(1) <= one;
HEX5(0) <= one;

zero <= '0';
one <= '1';
HEX_out0(7) <= '1';
HEX_out1(7) <= '1';
HEX_out2(7) <= '1';
HEX_out3(7) <= '1';
HEX_out4(7) <= '1';



LEDR <= SW;

END bdf_type;