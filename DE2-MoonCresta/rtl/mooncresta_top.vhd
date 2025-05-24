---------------------------------------------------------------------------------
--
-- 					   		MoonCresta for DE2-35 
--          		          Pinballwiz.org
--							    22/05/2025
--
--	              DE2-35 toplevel code by Pinballwiz.org 
-- All Other code from Katsumi Degawa and the Mister project (Respective Authors)
--					
---------------------------------------------------------------------------------
-- Keyboard inputs :
--   5 : Add coin
--   2 : Start 2 players
--   1 : Start 1 player
--   Z : Fire
--   RIGHT arrow : Move Right
--   LEFT arrow  : Move Left
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
---------------------------------------------------------------------------------
entity mooncresta_top is
port(
 clock_50  : in std_logic;
 key       : in std_logic_vector(3 downto 0);

 ps2_clk : in std_logic;
 ps2_dat : inout std_logic;

 vga_r     : out std_logic_vector(9 downto 0);
 vga_g     : out std_logic_vector(9 downto 0);
 vga_b     : out std_logic_vector(9 downto 0);
 vga_clk   : out std_logic;
 vga_blank : out std_logic;
 vga_sync  : out std_logic;
 vga_hs    : out std_logic;
 vga_vs    : out std_logic;

 i2c_sclk : out std_logic;
 i2c_sdat : inout std_logic;
 
 aud_adclrck : out std_logic;
 aud_adcdat  : in std_logic;
 aud_daclrck : out std_logic;
 aud_dacdat  : out std_logic;
 aud_xck     : out std_logic;
 aud_bclk    : out std_logic
 );
end mooncresta_top;
--------------------------------------------------------------------------------
architecture struct of mooncresta_top is

 signal clock_36  : std_logic;
 signal clock_25  : std_logic;
 signal clock_18  : std_logic;
 signal clock_12  : std_logic;
 signal clock_9   : std_logic;
 signal clock_6  	: std_logic;

 signal video_r   : std_logic_vector(2 downto 0);
 signal video_g   : std_logic_vector(2 downto 0);
 signal video_b   : std_logic_vector(2 downto 0);
 signal video_clk : std_logic;
 signal csync     : std_logic;
 signal blankn    : std_logic;
 
 signal video_r_x2 : std_logic_vector(5 downto 0);
 signal video_g_x2 : std_logic_vector(5 downto 0);
 signal video_b_x2 : std_logic_vector(5 downto 0);
 signal hsync_x2   : std_logic;
 signal vsync_x2   : std_logic;
 
 signal h_sync    : std_logic;
 signal v_sync	   : std_logic;
 
 signal audio_a     : std_logic_vector(7 downto 0);
 signal audio_b     : std_logic_vector(7 downto 0);
 signal sound_string : std_logic_vector(31 downto 0);
 signal reset     : std_logic;
 
 alias  reset_n   : std_logic is key(0);
 
 signal kbd_intr  : std_logic;
 signal kbd_scancode  : std_logic_vector(7 downto 0);
 signal joy_BBBBFRLDU : std_logic_vector(8 downto 0);
-------------------------------------------------------------------------------
  component scandoubler 
    port (
    clk_sys 	: in std_logic;
    scanlines	: in std_logic_vector (1 downto 0);
    hs_in 		: in std_logic;
    vs_in 		: in std_logic;
    r_in       : in std_logic_vector (5 downto 0);
    g_in 	   : in std_logic_vector (5 downto 0);
    b_in			: in std_logic_vector (5 downto 0);
    hs_out 		: out std_logic;
    vs_out 		: out std_logic;
    r_out 		: out std_logic_vector (5 downto 0);
    g_out 		: out std_logic_vector (5 downto 0);
    b_out 		: out std_logic_vector (5 downto 0)
  );
	end component; 
------------------------------------------------------------------------------
begin

reset <= not reset_n;
------------------------------------------------------------------------------
-- Clocks
pll36 : entity work.pll_50mhz_36mhz
port map(
inclk0 => clock_50,
c0     => clock_36
);
	
process(clock_36)
begin
 if falling_edge(clock_36) then
  clock_18 <= not clock_18;
 end if; 
end process;

process (clock_50)
begin
 if rising_edge(clock_50) then
  clock_25  <= not clock_25;
 end if;
end process;

process (clock_25)
begin
 if rising_edge(clock_25) then
  clock_12  <= not clock_12;
 end if;
end process;

process (clock_18)
begin
 if rising_edge(clock_18) then
  clock_9  <= not clock_9;
 end if;
end process;

process (clock_12)
begin
 if rising_edge(clock_12) then
  clock_6  <= not clock_6;
 end if;
end process;
------------------------------------------------------------------------------
mooncresta : entity work.galaxian
  port map (
 W_CLK_18M  => clock_18,
 W_CLK_12M  => clock_12,
 W_CLK_6M   => clock_6,
 I_RESET    => reset,
 W_R      	=> video_r,
 W_G      	=> video_g,
 W_B      	=> video_b,
 W_H_SYNC   => h_sync,
 W_V_SYNC 	=> v_sync,
 W_SDAT_A	=> audio_a,
 W_SDAT_B	=> audio_b,
 P1_CSJUDLR => joy_BBBBFRLDU(7) & joy_BBBBFRLDU(5) & joy_BBBBFRLDU(4) & '0' & '0' & joy_BBBBFRLDU(2) & joy_BBBBFRLDU(3),
 P2_CSJUDLR => '0' & joy_BBBBFRLDU(6) & joy_BBBBFRLDU(4) & '0' & '0' & joy_BBBBFRLDU(2) & joy_BBBBFRLDU(3)
   );
------------------------------------------------------------------------------  
  u_dblscan : scandoubler
    port map (
		clk_sys => clock_25,
		r_in => video_r & video_r,
		g_in => video_g & video_g,
		b_in => video_b & video_b,
		hs_in => h_sync,
		vs_in => v_sync,
		r_out => video_r_x2,
		g_out => video_g_x2,
		b_out => video_b_x2,
		hs_out => hsync_x2,
		vs_out => vsync_x2,
		scanlines => "00"
	);
------------------------------------------------------------------------------
-- to output

	vga_r 	<= video_r_x2 & "0000";
	vga_g 	<= video_g_x2 & "0000";
	vga_b 	<= video_b_x2 & "0000";
	vga_hs   <= hsync_x2;
	vga_vs   <= vsync_x2;

	vga_clk   <= clock_25;
	vga_sync  <= '0';
	vga_blank <= '1';

	sound_string <= "0000" & audio_a & "0000" & "0000" & audio_b & "0000";
------------------------------------------------------------------------------
wm8731_dac : entity work.wm8731_dac
port map(
 clk18MHz => clock_18,
 sampledata => sound_string,
 i2c_sclk => i2c_sclk,
 i2c_sdat => i2c_sdat,
 aud_bclk => aud_bclk,
 aud_daclrck => aud_daclrck,
 aud_dacdat => aud_dacdat,
 aud_xck => aud_xck
); 
------------------------------------------------------------------------------
-- get scancode from keyboard
keyboard : entity work.io_ps2_keyboard
port map (
  clk       => clock_9,
  kbd_clk   => ps2_clk,
  kbd_dat   => ps2_dat,
  interrupt => kbd_intr,
  scancode  => kbd_scancode
);
------------------------------------------------------------------------------
-- translate scancode to joystick
joystick : entity work.kbd_joystick
port map (
  clk         => clock_9,
  kbdint      => kbd_intr,
  kbdscancode => std_logic_vector(kbd_scancode), 
  joy_BBBBFRLDU  => joy_BBBBFRLDU 
);
------------------------------------------------------------------------------
end struct;