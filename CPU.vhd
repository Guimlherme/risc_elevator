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

ENTITY decoder IS
    PORT (
        clk	:	in std_logic;
        instruction: in unsigned(31 downto 0);
		  alu_zero: in std_logic;
        jmp: out std_logic;
		  jmp_reg: out std_logic_vector(3 downto 0);
		  ram_read: out std_logic_vector;
		  ram_write: out std_logic_vector;
		  ram_address: out std_logic_vector(7 downto 0);
		  reg_write: out std_logic;
		  reg_write_address: out std_logic_vector(3 downto 0);
		  alu_reg_in1: out std_logic_vector(3 downto 0);
		  alu_reg_in2: out std_logic_vector(3 downto 0);
		  alu_immediate_in: out std_logic_vector(7 downto 0);
		  alu_op: out std_logic_vector(2 downto 0)
    );
end decoder;


COMPONENT ALU
	PORT(a, b, c: in std_logic_vector(7 downto 0); -- a and b are the inputs from the register, c is the direct one from the decoder
        op: in std_logic_vector(2 downto 0);
        result: out std_logic_vector(7 downto 0);
		  w_enable: out std_logic;
	);
END COMPONENT;

COMPONENT reg
	PORT(
			en		:	in std_logic;
			w_enable :	in std_logic;
			clk		:	in std_logic;
			Address_w:	in std_logic_vector(3 downto 0);
			Address_r_1:	in std_logic_vector(3 downto 0);
			Address_r_2:	in std_logic_vector(3 downto 0);
			Data_in	:	in std_logic_vector(7 downto 0);
			Data_out_1:	out std_logic_vector(7 downto 0);
			Data_out_2:	out std_logic_vector(7 downto 0);
			pc	: out std_logic_vector(7 downto 0);
			
			);
END COMPONENT;

COMPONENT ram
	PORT(
			rw,en		:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			Adress	:	in std_logic_vector(7 downto 0);
			Data_in	:	in std_logic_vector(7 downto 0);
			Data_out:	out std_logic_vector(31 downto 0)
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

SIGNAL	instruction : unsigned(31 downto 0);

SIGNAL	result : 

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

decoder_inst: decoder IS
    PORT MAP (
        clk=>MAX10_CLK1_50,
        instruction=>instruction;
        jmp_z: out std_logic;
		  jmp_reg_z: out std_logic_vector(3 downto 0);
		  ram_read: out std_logic_vector;
		  ram_write: out std_logic_vector;
		  ram_address: out std_logic_vector(7 downto 0);
		  reg_write: out std_logic;
		  reg_write_address: out std_logic_vector(3 downto 0);
		  alu_reg_in1: out std_logic_vector(3 downto 0);
		  alu_reg_in2: out std_logic_vector(3 downto 0);
		  alu_immediate_in: out std_logic_vector(7 downto 0);
		  alu_op: out std_logic_vector(2 downto 0)
    );
end decoder;

reg_inst:	reg 
PORT MAP(Address_w=>reg_write_address,
			Address_r_1=>alu_reg_in1,
			Address_r_2=>alu_reg_in2,
			Data_in=>result,
			w_enable=>w_enable,
			Data_out_1=>a,
			Data_out_2=>b,
			clk=>MAX10_CLK1_50 );


ram_inst:	ram 
PORT MAP(Adress=>PC_out,
		   Data_out=>instruction,
			clk=>MAX10_CLK1_50);

fetch_inst:	Fetch 
PORT MAP(clk=>MAX10_CLK1_50,
		   PC_out=>Adress, 
			PC_Jump=>jmp,
			PC_load=> pc);

alu_inst:	ALU 
PORT MAP(clk=>MAX10_CLK1_50,
			a=>Data_out_1, 
			b=>Data_out_2,
			c=>alu_immediate_in, 
			op=>alu_op, 
			result=>Data_in,	
			w_enable=>w_enable);

			

		 
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