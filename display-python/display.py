#Setzt das Display auf die uebergebenen Werte
#Aufruf: python display.py "Zeile 1" "Zeile 2"
import lcddriver
import sys

from time import *

lcd = lcddriver.lcd()

lcd.lcd_clear()
lcd.lcd_display_string(str(sys.argv[1]), 1)
lcd.lcd_display_string(str(sys.argv[2]), 2)
