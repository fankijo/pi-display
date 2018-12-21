#!/bin/bash

#Variables
MENUSTATE=1
SUBMENUSTATE=0
DISPLAYSCRIPT="/display/display-python/display.py"
MAINBUTTONLISTENERACTIVE="true"


#Needed for scrolling upwards
MENUCOUNTER=0
HIGHESTMENU=0

SUBMENUCOUNTER=0
HIGHESTSUBMENU=0

#declare two-dimensional Array which contains the menu
declare -A menu
menu[1,0]="LED Steuerung"
menu[1,1]="Anschalten"
menu[1,2]="Ausschalten"
menu[1,3]="Weiss"
menu[1,4]="Rot"
menu[1,5]="Gruen"
menu[1,6]="Blau"
menu[1,7]="7 Farben Wechsel"
menu[2,0]="Fritz!Box"
menu[2,1]="Aktive Hosts"
menu[2,2]="Externe IP"
menu[2,3]="Up/Download Rate"
menu[2,4]="Untermenu 4"
menu[2,5]="Untermenu 5"
menu[2,6]="Untermenu 6"
menu[2,7]="Untermenu 7"
menu[2,8]="Untermenu 8"
menu[2,9]="Untermenu 9"
menu[2,10]="Untermenu 10"
menu[3,0]="Menu 3"
menu[3,1]="Untermenu 1"
menu[3,2]="Untermenu 2"
menu[3,3]="Untermenu 3"
menu[3,4]="Untermenu 4"
menu[3,5]="Untermenu 5"
menu[3,6]="Untermenu 6"
menu[3,7]="Untermenu 7"
menu[3,8]="Untermenu 8"
menu[3,9]="Untermenu 9"
menu[3,10]="Untermenu 10"
menu[4,0]="Menu 4"
menu[4,1]="Untermenu 1"
menu[4,2]="Untermenu 2"
menu[4,3]="Untermenu 3"
menu[4,4]="Untermenu 4"
menu[4,5]="Untermenu 5"
menu[4,6]="Untermenu 6"
menu[4,7]="Untermenu 7"
menu[4,8]="Untermenu 8"
menu[4,9]="Untermenu 9"
menu[4,10]="Untermenu 10"
menu[5,0]="Menu 5"
menu[5,1]="Untermenu 1"
menu[5,2]="Untermenu 2"
menu[5,3]="Untermenu 3"
menu[5,4]="Untermenu 4"
menu[5,5]="Untermenu 5"
menu[5,6]="Untermenu 6"
menu[5,7]="Untermenu 7"
menu[5,8]="Untermenu 8"
menu[5,9]="Untermenu 9"
menu[5,10]="Untermenu 10"
menu[6,0]="Menu 6"
menu[6,1]="Untermenu 1"
menu[6,2]="Untermenu 2"
menu[6,3]="Untermenu 3"
menu[6,4]="Untermenu 4"
menu[6,5]="Untermenu 5"
menu[6,6]="Untermenu 6"
menu[6,7]="Untermenu 7"
menu[6,8]="Untermenu 8"
menu[6,9]="Untermenu 9"
menu[6,10]="Untermenu 10"
menu[7,0]="Menu 7"
menu[7,1]="Untermenu 1"
menu[7,2]="Untermenu 2"
menu[7,3]="Untermenu 3"
menu[7,4]="Untermenu 4"
menu[7,5]="Untermenu 5"
menu[7,6]="Untermenu 6"
menu[7,7]="Untermenu 7"
menu[7,8]="Untermenu 8"
menu[7,9]="Untermenu 9"
menu[7,10]="Untermenu 10"
menu[8,0]="Menu 8"
menu[8,1]="Untermenu 1"
menu[8,2]="Untermenu 2"
menu[8,3]="Untermenu 3"
menu[8,4]="Untermenu 4"
menu[8,5]="Untermenu 5"
menu[8,6]="Untermenu 6"
menu[8,7]="Untermenu 7"
menu[8,8]="Untermenu 8"
menu[8,9]="Untermenu 9"
menu[8,10]="Untermenu 10"
menu[9,0]="Menu 9"
menu[9,1]="Untermenu 1"
menu[9,2]="Untermenu 2"
menu[9,3]="Untermenu 3"
menu[9,4]="Untermenu 4"
menu[9,5]="Untermenu 5"
menu[9,6]="Untermenu 6"
menu[9,7]="Untermenu 7"
menu[9,8]="Untermenu 8"
menu[9,9]="Untermenu 9"
menu[9,10]="Untermenu 10"
menu[10,0]="Reboot Pi"



#Functions
set_display() {
	#The very standard function to display text
	python $DISPLAYSCRIPT "$1" "$2"
}

set_display_wait() {
	#Sets the display to "Bitte warten..."
	#Used during performed actions
	set_display "Bitte warten..." ""
}

set_display_feedback() {
	#Displays a status after an action for example "Erfolgreich" or "Error"
	#then waits 3 seconds and displays the menu before the action
	set_display "$1" "$2"
	sleep 2
	set_display "${menu[$MENUSTATE,0]}" "${menu[$MENUSTATE,$SUBMENUSTATE]}"
}

set_display_output() {
	#Displays the output of an action and waits for a button to be pressed to return back to the menu
	set_display "$1" "$2"
	while true
		do
		read -r -sn1 input
		case $input in
			C) set_display "${menu[$MENUSTATE,0]}" "${menu[$MENUSTATE,$SUBMENUSTATE]}" && break;;
			D) set_display "${menu[$MENUSTATE,0]}" "${menu[$MENUSTATE,$SUBMENUSTATE]}" && break;;
		esac
	done
}

navigate_down() {
	echo "˅"
	
	#Check if Mainmenu or Submenu is active
	if (( SUBMENUSTATE == 0 )); then
		#Main menu is active
		#Check if the Array to show is set or not, if not continue with 1
		if [ -z "${menu[$((MENUSTATE+1)),0]}" ]; then
			#Array is empty, continue with 1
			set_display "${menu[1,0]}" "              ->"
			MENUSTATE=1
		else
			#If Array is set
			set_display "${menu[$((MENUSTATE+1)),0]}" "              ->"
			((++MENUSTATE))
		fi
	fi
	
	if (( SUBMENUSTATE > 0 )); then
		#If Submenu is active
		#Check if the Array to show is set or not, if not continue with 1
		if [ -z "${menu[$MENUSTATE,$((SUBMENUSTATE+1))]}" ]; then
			#Array is empty, continue with 1
			set_display "${menu[$MENUSTATE,0]}" "${menu[$MENUSTATE,1]}"
			SUBMENUSTATE=1
		else
			#If Array is set
			set_display "${menu[$MENUSTATE,0]}" "${menu[$MENUSTATE,$((SUBMENUSTATE+1))]}"
			((++SUBMENUSTATE))
		fi
	fi
}

navigate_up() {
	echo "˄"
	
	#Check if Mainmenu or Submenu is active
	if (( SUBMENUSTATE == 0 )); then
		#Main menu is active
		#Check if the Array to show is set or not, if not continue with last menu entry
		if [ -z "${menu[$((MENUSTATE-1)),0]}" ]; then
			#Array is empty, continue with last menu entry
			
			#Get number of highest set menu
			MENUCOUNTER=0
			HIGHESTMENU=0
			while [ true ]
			do
				((++MENUCOUNTER))
				if [ -z "${menu[$MENUCOUNTER,0]}" ]; then
					break
				fi
				((++HIGHESTMENU))
			done
			
			#Set display to menu with highest number
			set_display "${menu[$HIGHESTMENU,0]}" "              ->"
			MENUSTATE=$HIGHESTMENU
		else
			#Array is set
			set_display "${menu[$((MENUSTATE-1)),0]}" "              ->"
			((--MENUSTATE))
		fi
	fi
	
	if (( SUBMENUSTATE > 0 )); then
		#Submenu is active
		#Check if the Array to show is set or not, if not continue with last menu entry
		if [ -z "${menu[$MENUSTATE,$((SUBMENUSTATE-2))]}" ]; then
			#Array is empty, continue with last menu entry
			#Get number of highest set submenu
			SUBMENUCOUNTER=0
			HIGHESTSUBMENU=0
			while [ true ]
			do
				((++SUBMENUCOUNTER))
				if [ -z "${menu[$MENUSTATE,$SUBMENUCOUNTER]}" ]; then
					break
				fi
				((++HIGHESTSUBMENU))
			done
			
			#Set display to submenu with highest number
			set_display "${menu[$MENUSTATE,0]}" "${menu[$MENUSTATE,$HIGHESTSUBMENU]}"
			SUBMENUSTATE=$HIGHESTSUBMENU
		else
			#Array is set
			set_display "${menu[$MENUSTATE,0]}" "${menu[$MENUSTATE,$((SUBMENUSTATE-1))]}"
			((--SUBMENUSTATE))
		fi
	fi
}


navigate_ok() {
	echo "OK"

	if (( SUBMENUSTATE == 0 )); then
		#Mainmenu is active
		#If no Submenu exists
		if [ -z "${menu[$MENUSTATE,1]}" ]; then
			run_action "$MENUSTATE$SUBMENUSTATE"
		fi
		
		#If Submenu exists
		#Set display
		set_display "${menu[$((MENUSTATE)),0]}" "${menu[$MENUSTATE,1]}"
		((++SUBMENUSTATE))
		return
	fi
	
	if (( SUBMENUSTATE == 1 || SUBMENUSTATE > 1)); then
		#Submenu is active
		#Action
		echo Running action "$MENUSTATE$SUBMENUSTATE"
		set_display_wait
		run_action "$MENUSTATE$SUBMENUSTATE"
		return
	fi
}

navigate_cancel() {
	echo "Cancel"
	if (( SUBMENUSTATE == 1 || SUBMENUSTATE > 1)); then
		#Submenu is active
		#Set display
		set_display "${menu[$MENUSTATE,0]}" "              ->"
		SUBMENUSTATE=0
	fi
}

run_action() {
	#Decides which actions should be performed
	
	#Example Action
	if (( $1 == 999 )); then
		#Run Action
		OUTPUT="$(command goes here)"
		#Give Feedback
		if [[ $OUTPUT = *"Turning on bulb"* ]]; then
			set_display_feedback "Erfolgreich!" "" "timeout in seconds"
		else
			set_display_feedback "Error" "" "timeout in seconds"
		fi
	fi
	
	
	#Turn LEDs on
	if (( $1 == 11 )); then
		#python -m flux_led -s
		OUTPUT="$(python -m flux_led -s -S --on)"
		echo $OUTPUT
		#Give Feedback
		if [[ $OUTPUT = *"Turning on bulb"* ]]; then
			set_display_feedback "Erfolgreich!" ""
		else
			set_display_feedback "Error" ""
		fi
	fi
	
	
	#Turn LEDs off
	if (( $1 == 12 )); then
		OUTPUT="$(python -m flux_led -s -S --off)"
		echo $OUTPUT
		#Give Feedback
		if [[ $OUTPUT = *"Turning off bulb"* ]]; then
			set_display_feedback "Erfolgreich!" ""
		else
			set_display_feedback "Error" ""
		fi
	fi
	
	
	#LEDs white
	if (( $1 == 13 )); then
		#Run Action
		OUTPUT="$(python -m flux_led -s -S --color=255,255,255)"
		echo $OUTPUT
		#Give Feedback
		if [[ $OUTPUT = *"Setting color RGB"* ]]; then
			set_display_feedback "Erfolgreich!" ""
		else
			set_display_feedback "Error" ""
		fi
	fi


	#LEDs red
	if (( $1 == 14 )); then
		#Run Action
		OUTPUT="$(python -m flux_led -s -S --color=255,0,0)"
		echo $OUTPUT
		#Give Feedback
		if [[ $OUTPUT = *"Setting color RGB"* ]]; then
			set_display_feedback "Erfolgreich!" ""
		else
			set_display_feedback "Error" ""
		fi
	fi


	#LEDs green
	if (( $1 == 15 )); then
		#Run Action
		OUTPUT="$(python -m flux_led -s -S --color=0,255,0)"
		echo $OUTPUT
		#Give Feedback
		if [[ $OUTPUT = *"Setting color RGB"* ]]; then
			set_display_feedback "Erfolgreich!" ""
		else
			set_display_feedback "Error" ""
		fi
	fi


	#LEDs blue
	if (( $1 == 16 )); then
		#Run Action
		OUTPUT="$(python -m flux_led -s -S --color=0,0,255)"
		echo $OUTPUT
		#Give Feedback
		if [[ $OUTPUT = *"Setting color RGB"* ]]; then
			set_display_feedback "Erfolgreich!" ""
		else
			set_display_feedback "Error" ""
		fi
	fi


	#LEDs seven color fade
	if (( $1 == 17 )); then
		#Run Action
		OUTPUT="$(python -m flux_led -s -S -p 37 10)"
		echo $OUTPUT
		#Give Feedback
		if [[ $OUTPUT = *"Setting preset pattern: Seven Color Cross Fade"* ]]; then
			set_display_feedback "Erfolgreich!" ""
		else
			set_display_feedback "Error" ""
		fi
	fi


	#FritzBox Hosts active
	if (( $1 == 21 )); then
		#Run Action
		OUTPUT="$(/display/fb-info.sh --hostsonline)"
		echo $OUTPUT Hosts online
		set_display_output "$OUTPUT Hosts online" ""
	fi


	#Routers external IPv4 adress
	if (( $1 == 22 )); then
		#Run Action
		OUTPUT="$(curl ipv4.icanhazip.com)"
		echo external IP: $OUTPUT
		set_display_output "Externe IP:" "$OUTPUT"
	fi


	#FritzBox DSL Up- and Download speed
	if (( $1 == 23 )); then
		#Run Action
		OUTPUT="$(python fritzbox-tools/fritzstatus.py | grep "max. bit rate:")"
		#Extract Up and Download Rates from Output string
		UPLOAD=$(echo "$OUTPUT" | cut -d"'" -f2)
		DOWNLOAD=$(echo "$OUTPUT" | cut -d"'" -f4)
		
		#Remove " MBit/s" from string so only the numbers are left
		UPLOAD=${UPLOAD::-7}
		DOWNLOAD=${DOWNLOAD::-7}
		
		echo Up:$UPLOAD Down:$DOWNLOAD
		set_display_output "Up/Down Rate" "$UPLOAD/$DOWNLOAD MBit/s"
	fi
	
	
	
	
	
	#Reboot Pi
	if (( $1 == 100)); then
		#Run Action
		set_display "Starte neu" "Bitte warten..."
		OUTPUT="$(reboot)"
	fi
}

#Set Display for the first time
set_display "${menu[$MENUSTATE,$SUBMENUSTATE]}" "              ->"

#Listen for arrow keys and call function for pressed key
while true
do
    read -r -sn1 input
    case $input in
        A) navigate_up;;
        B) navigate_down;;
        C) navigate_ok;;
        D) navigate_cancel;;
    esac
done
