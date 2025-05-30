library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Kbd_Joystick is
port (
  Clk          : in std_logic;
  KbdInt       : in std_logic;
  KbdScanCode  : in std_logic_vector(7 downto 0);
  joy_BBBBFRLDU   : out std_logic_vector(8 downto 0);
  fn_pulse      : inout std_logic_vector(7 downto 0);
  fn_toggle     : inout std_logic_vector(7 downto 0)
);
end Kbd_Joystick;

architecture Behavioral of Kbd_Joystick is

signal IsReleased : std_logic;
signal fn_pulse_r : std_logic_vector(7 downto 0);

begin 

process(Clk)
begin
  if rising_edge(Clk) then
  
    fn_pulse_r <= fn_pulse;
  
    if KbdInt = '1' then
      if KbdScanCode = x"F0" then IsReleased <= '1'; else IsReleased <= '0'; end if; 
      if KbdScanCode = x"75" then joy_BBBBFRLDU(0) <= not(IsReleased); end if; -- up
      if KbdScanCode = x"72" then joy_BBBBFRLDU(1) <= not(IsReleased); end if; -- down
      if KbdScanCode = x"6B" then joy_BBBBFRLDU(2) <= not(IsReleased); end if; -- left
      if KbdScanCode = x"74" then joy_BBBBFRLDU(3) <= not(IsReleased); end if; -- right
      if KbdScanCode = x"14" then joy_BBBBFRLDU(4) <= not(IsReleased); end if; -- LCtrl
      if KbdScanCode = x"16" then joy_BBBBFRLDU(5) <= not(IsReleased); end if; -- 1 P1 start
      if KbdScanCode = x"1E" then joy_BBBBFRLDU(6) <= not(IsReleased); end if; -- 2 P2 start
      if KbdScanCode = x"2E" then joy_BBBBFRLDU(7) <= not(IsReleased); end if; -- 5 Coin
      if KbdScanCode = x"22" then joy_BBBBFRLDU(8) <= not(IsReleased); end if; -- x

      if KbdScanCode = x"05" then fn_pulse(0) <= not(IsReleased); end if; -- F1
      if KbdScanCode = x"06" then fn_pulse(1) <= not(IsReleased); end if; -- F2
      if KbdScanCode = x"04" then fn_pulse(2) <= not(IsReleased); end if; -- F3
      if KbdScanCode = x"0C" then fn_pulse(3) <= not(IsReleased); end if; -- F4
      if KbdScanCode = x"03" then fn_pulse(4) <= not(IsReleased); end if; -- F5
      if KbdScanCode = x"0B" then fn_pulse(5) <= not(IsReleased); end if; -- F6
      if KbdScanCode = x"83" then fn_pulse(6) <= not(IsReleased); end if; -- F7
      if KbdScanCode = x"0A" then fn_pulse(7) <= not(IsReleased); end if; -- F8
    end if;
	 
	 if fn_pulse_r(0) = '1' and fn_pulse(0) = '0' then fn_toggle(0) <= not fn_toggle(0); end if;
 	 if fn_pulse_r(1) = '1' and fn_pulse(1) = '0' then fn_toggle(1) <= not fn_toggle(1); end if;
 	 if fn_pulse_r(2) = '1' and fn_pulse(2) = '0' then fn_toggle(2) <= not fn_toggle(2); end if;
 	 if fn_pulse_r(3) = '1' and fn_pulse(3) = '0' then fn_toggle(3) <= not fn_toggle(3); end if;
 	 if fn_pulse_r(4) = '1' and fn_pulse(4) = '0' then fn_toggle(4) <= not fn_toggle(4); end if;
 	 if fn_pulse_r(5) = '1' and fn_pulse(5) = '0' then fn_toggle(5) <= not fn_toggle(5); end if;
 	 if fn_pulse_r(6) = '1' and fn_pulse(6) = '0' then fn_toggle(6) <= not fn_toggle(6); end if;
 	 if fn_pulse_r(7) = '1' and fn_pulse(7) = '0' then fn_toggle(7) <= not fn_toggle(7); end if;

  end if;
end process;

end Behavioral;


