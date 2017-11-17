; Copyright 2014-2017 Hermann Krumrey <hermann@krumreyh.com>
;
; This file is part of ahk-scripts.
;
; ahk-scripts is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; ahk-scripts is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with ahk-scripts.  If not, see <http://www.gnu.org/licenses/>.

{ ;Autohotkey XDCC Downloader
	;This Script allows a download chain of XDCC packs via mIRC
	;The data for this must be entered in a .txt file prior to running the script
}

{ ;Parameters
#NoEnv
SendMode Input
SetWorkingDir C:\
SetFormat, float, 0.2 
}


{ ;List of global Variables

	;workdir								Contains the working directory
	;xdccfile								The XDCC .txt file
	;xdccline%number%						The line of the XDCC .txt file saved to variables
	;dlspeed								The speed given in the XDCC .txt file in kB/s
	;series%number%							The name of the series consisting of several packs
	;packsize%number%						The size of a series' packs in MB
	;channel%number%						A series' IRC channel
	;packcount%number%						The number of packs in a series
	;pack%number%							Variable containing pack information
	;totalnumberofpacks						Total number of packs parsed
	;totalnumberofseries					Total number of series parsed
	;logname								Name of the log file
	;totaldownloadsize						Total size of all packs combined in MB
	;totaldownloadsizekb					Total size of all packs combined in KB
	;totaldownloadsizegb					Total size of all packs combined in GB
	;medianpacksize							Median pack size in MB
	;medianpacksizekb						Median pack size in KB
	;medianpacksizegb						Median pack size in GB
	;dltimems								Total Download Size of all packs in ms							
	;dltimeh								Total Download Size of all packs in h
	;dltimemin								Total Download Size of all packs in min
	;dltimes								Total Download Size of all packs in s
	;ircserver%number%						Stores the IRC Server of a Series
}

{ ;Functions
}

{ ;File Directory Function

	;Has to run at the beginning of all scripts and functions that make us of Windows directories
	;defines all Windows directories used in the script for easy editing
	
filedirectory(){
	
	global														;Sets variables in function to global
	
	workdir = D:\Downloads\XDCC\								;Contains the working directory
	xdccfile = D:\Downloads\XDCC\XDCC.txt						;The XDCC .txt file
	mirc = C:\Program Files (x86)\mIRC\mirc.exe					;The mIRC executable
	
}
}
{ ;Error Checker

	;Checks if all needed files are present.
	;If not, a notepad file will be opened, which lists the necessary files and terminates the script

errorchecker(){

	global										;Sets variables to global due to compatibility issues
	filedirectory()								;initializes the Windows File Directories

	IfNotExist, %xdccfile%						;If the XDCC file is not in the specified directory, this will terminate the script
	{
		msgBox, %xdccfile% not found.`nPlease put the file in the specified directory or change the AHK source code
		return
	}
	ifNotExist, %mirc%							;If the mIRC executable is not installed in the specified directory, this will terminate the script
	{
		msgBox, %mirc% not found.`nPlease install mIRC in the specfied directory or change the AHK source code
		return
	}
}
}
{ ;.txt file reader

	;Reads a .txt file and saves the line's contents to variables xdccline%number%

txtfilereader(){
	
	global										;Sets variables in function to global

	filedirectory()								;Initializes the Windows File Directories
	local txtline = 1							;local variable txtline for saving the .txt lines in different variables
	
	loop, read, %xdccfile% 						;File Read Loop
	{					
		xdccline%txtline% := A_LoopReadLine		;Saves line to variable xdccline%number%
		txtline++								;Increases txtfile variable by 1
	}
}
}
{ ;Channel Checker
channelchecker(packinfo,seriesno){

	global													;Sets variables to global
	
	IfInString, packinfo, CR-EU|NEW							;Sets variable channel%number% with correct number and also ircserver%number%
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-NL|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-FR|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-CA|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-US|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-ARCHIVE|1080p
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-ARCHIVE|720p
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-ARCHIVE|SD
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-ARUTHA|NL-720p
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, Ginpachi-Sensei
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, HelloKitty
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, NIBL|Arutha
	{
	channel%seriesno% = intel
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, Doki|Homura
	{
	channel%seriesno% = doki
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, Doki|Kotomi
	{
	channel%seriesno% = doki
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, Doki|Kobato
	{
	channel%seriesno% = doki
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, Blargh|Other
	{
	channel%seriesno% = intel
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, [Arigatou]MrRoboto
	{
	channel%seriesno% = arigatou
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, Xide
	{
	channel%seriesno% = kametsu
	ircserver%seriesno% = irc.kametsu.com
	}
	
	
}
}
{ ;.txt file parser

	;Parses the .txt file and creates multiple variables needed later on.

txtfileparser(){

	global											;Sets variables in function to global

	local packnumber = 0									;Sets local variable that keeps track of the pack number
	local seriesnumber = 0									;Sets local variable that keeps track of the series number
	local episodecount = 0									;Sets local variable that keeps track of amount of packs in a series
	local parseline = 4										;Sets local variable that keeps track of the lines of the orginal .txt file
	
	stringtrimleft, dlspeed, xdccline1, 22					;Saves the download speed given in the .txt file (kB/s) to global variable dlspeed
	
	loop{													;parsing loop
		local linecontent := xdccline%parseline%			;saves the current line's content to a useable variable
		if(linecontent = "break"){							;"Break" Event
			seriesnumber++									;Increases variable seriesnumber by 1
			parseline--										;Decreases parseline by 1 to access last pack data
			local channelcheck := xdccline%parseline%		;Saves last pack data to useable local variable
			channelchecker(channelcheck,seriesnumber)		;Determines the channel of the series
			parseline++										;Returns to previous line
			parseline++										;Moves down a line in the original .txt file
			series%seriesnumber% := xdccline%parseline%		;Saves the name of the series in variable series%number%
			parseline++										;Moves down a line in the original .txt file
			local pretrim := xdccline%parseline%			;The size of the packs, but with unnecessary text included
			local posttrim = ""								;Initializes local variable posttrim
			stringtrimleft, posttrim, pretrim, 6			;The size of the current series' packs in MB without unnecessary text
			packsize%seriesnumber% := posttrim				;The size of the current series' packs in MB saved to global variable packsize%number%
			packcount%seriesnumber% := episodecount			;The amount of packs in this series saved to global variable packcount%number%
			episodecount = 0								;resets local variable episodecount for next series 
			parseline++										;Moves down a line in the original .txt file
			parseline++										;Moves down a line in the original .txt file
			parseline++										;Moves down a line in the original .txt file
		}
		else if(linecontent = "stop"){						;"Stop" Event
			break											;Ends the parsing loop
		}
		else if(linecontent = "-"){							;In case of "Airing" Placeholder
			parseline++										;Moves down the txt file to break of "Airing Section"
		}
		else if((linecontent = "..")||(linecontent = "...")||(linecontent = "....")||(linecontent = ".....")||(linecontent = "......")){						
															;Automatically adds systematic packs (e.g pack 1...pack20 will add all packs from 1 to 20) Amount of dots signifies amount of numbers in a pack number(usually 3 or 4)
			parseline--										;Goes up a line
			local continuous1 =								;Stores upper line in local variable
			local continuous2 =								;Stores lower line in local variable
			local starter =									;Stores upper packnumber
			local ender =									;Stores lower packnumber
			local contloop =								;Stores the loop variable locally
			local pattern =									;Saves standard pack pattern
			continuous1 := xdccline%parseline%
			parseline++
			parseline++
			continuous2 := xdccline%parseline%
			stringlen, contlen, continuous1					;Measures Stringlength of single pack
			local cutter =									;Variable to store the amount of unneccesary characters in string
			if(linecontent = ".."){							;Calculates the amount of numbers for the pack and also the standard packet structure
				cutter := contlen-2
				stringtrimright, pattern, continuous1, 2
			}
			else if(linecontent = "..."){
				cutter := contlen-3
				stringtrimright, pattern, continuous1, 3
			}
			else if(linecontent = "...."){
				cutter := contlen-4
				stringtrimright, pattern, continuous1, 4
			}
			else if(linecontent = "....."){
				cutter := contlen-5
				stringtrimright, pattern, continuous1, 5
			}
			else if(linecontent = "......"){
				cutter := contlen-6
				stringtrimright, pattern, continuous1, 6
			}
			stringtrimleft, starter, continuous1, %cutter%
			stringtrimleft, ender, continuous2, %cutter%
			contloop := ender-starter
			starter++
			loop %contloop%{
				packnumber++
				local prelimpack =
				prelimpack = %pattern%%starter%
				starter++
				pack%packnumber% := prelimpack
				episodecount++
			}
			parseline++
		}
		else if((linecontent = ",,")||(linecontent = ",,,")||(linecontent = ",,,,")||(linecontent = ",,,,,")||(linecontent = ",,,,,,")){						
															;Automatically adds systematic packs (e.g pack 1...pack20 will add all packs from 1 to 20) Amount of dots signifies amount of numbers in a pack number(usually 3 or 4)
			parseline--										;Goes up a line
			local continuous1 =								;Stores upper line in local variable
			local continuous2 =								;Stores lower line in local variable
			local starter =									;Stores upper packnumber
			local ender =									;Stores lower packnumber
			local contloop =								;Stores the loop variable locally
			local pattern =									;Saves standard pack pattern
			continuous1 := xdccline%parseline%
			parseline++
			parseline++
			continuous2 := xdccline%parseline%
			stringlen, contlen, continuous1					;Measures Stringlength of single pack
			local cutter =									;Variable to store the amount of unneccesary characters in string
			if(linecontent = ",,"){							;Calculates the amount of numbers for the pack and also the standard packet structure
				cutter := contlen-2
				stringtrimright, pattern, continuous1, 2
			}
			else if(linecontent = ",,,"){
				cutter := contlen-3
				stringtrimright, pattern, continuous1, 3
			}
			else if(linecontent = ",,,,"){
				cutter := contlen-4
				stringtrimright, pattern, continuous1, 4
			}
			else if(linecontent = ",,,,,"){
				cutter := contlen-5
				stringtrimright, pattern, continuous1, 5
			}
			else if(linecontent = ",,,,,,"){
				cutter := contlen-6
				stringtrimright, pattern, continuous1, 6
			}
			stringtrimleft, starter, continuous1, %cutter%
			stringtrimleft, ender, continuous2, %cutter%
			contloop := ender-starter
			starter++
			starter++
			loop %contloop%{
				packnumber++
				local prelimpack =
				prelimpack = %pattern%%starter%
				starter++
				starter++
				pack%packnumber% := prelimpack
				episodecount++
			}
			parseline++
		}
		else{												;Saves packs to variables
			packnumber++									;Increases local variable packnumber by 1
			pack%packnumber% := linecontent					;saves line content to global variable pack%number%
			parseline++										;Moves down a line in the original .txt file
			episodecount++									;Adds a pack to current series' episode counter
		}
	}
	totalnumberofpacks := packnumber
	totalnumberofseries := seriesnumber
}
}
{ ;Statistics calculator

	;Calculates various statstics for use in the log file and/or further calculations
	
statcalc(){

	global																			;Sets variables to global
		
	totaldownloadsize = 0															;intializes global variable to store entire download size in MB
	local seriestotaldownloadsize = ""												;initializes local calculation variable										
	local seriesize = ""															;initializes local calculation variable
	local seriesamount = ""															;initializes local calculation variable
	local seriescounter = 1															;initializes local variable to access global variables
	loop %totalnumberofseries%{														;total download size calculation loop
		seriesamount := packcount%seriescounter%									
		seriesize := packsize%seriescounter%
		seriestotaldownloadsize := seriesamount*seriesize
		totaldownloadsize := totaldownloadsize + seriestotaldownloadsize
		seriescounter++																;increments seriescounter
	}
	medianpacksize := totaldownloadsize/totalnumberofpacks							;global variable that stores themediandownload size of the packs in MB
	medianpacksizekb := medianpacksize*1000											;global variable that stores themediandownload size of the packs in KB
	medianpacksizeGB := medianpacksize/1000											;global variable that stores themediandownload size of the packs in GB
	totaldownloadsizekB := totaldownloadsize*1000									;global variable that saves the total download size in KB
	totaldownloadsizeGB := totaldownloadsize/1000									;global variable that saves the total download size in GB
	dltimes := totaldownloadsizekB/dlspeed											;global variable that save the total download time in s
	dltimemin := dltimes/60															;global variable that save the total download time in min
	dltimeh := dltimes/60/60														;global variable that save the total download time in h
	dltimems := dltimes*1000														;global variable that save the total download time in ms
}
}
{ ;Log File Writer

	;Writes a log to a .txt file in the working directory (workdir).
	;The file name contains the current date and time
	
logfilewriter(){

	global																;Sets variables in function to global
	filedirectory()														;Initializes Windows File DIrectories
	
	local packlog = 1													;Initalizes local variable packlog to count the packs
	local serieslog = 1													;Initalizes local variable serieslog to count the series
	
	local datevar := A_Now												;sets local variable datevar to current date and time
	logname = %workdir%XDCC LOG - %datevar%.txt							;sets global variable logname with the name XDCC LOG - Date&Time.txt
	
	fileappend, XDCC Download Log - %A_NOW%`n`n, %logname%				;Writes the log file to XDCC Log - Date&Time.txt
	fileappend, The following packs were entered:`n`n`n, %logname%
	loop %totalnumberofseries%{											;Log Writing loop for series and packs
		local showname := series%serieslog%								;inputs series name into useable local variable
		local showchannel := channel%serieslog%							;inputs series channel into useable local variable
		local showsize := packsize%serieslog%							;inputs series pack size into useable local variable
		fileappend, Series: `t%showname%`n, %logname%						;enters the series info to the txt file
		fileappend, IRC Channel: `t#%showchannel%`n, %logname%
		fileappend, Pack Size: `t%showsize% MB`n`n, %logname%					
		local numberofeps := packcount%serieslog%						;inputs series' number of packs into useable local variable
		loop %numberofeps%{
			local packet := pack%packlog%								;inputs pack data into useable local variable
			if(packlog<10){												;Variable Tabs If/Else for inputting pack names into txt file
				fileappend, Pack %packlog%:`t`t%packet%`n, %logname%
			}
			else{
				fileappend, Pack %packlog%:`t%packet%`n, %logname%
			}
			packlog++													;Increases packlog by 1
		}
		fileappend, `n`n, %logname%
		serieslog++														;Increases serieslog by 1
	}
	fileappend, `n, %logname%
	fileappend, Download Speed:`t`t`t`t%dlspeed% KB/s`n, %logname%		;Adds statistics to log file
	fileappend, Median Pack Size:`t`t`t%medianpacksizekb% KB`n, %logname%
	fileappend, `t`t`t`t`t%medianpacksize% MB`n, %logname%
	fileappend, `t`t`t`t`t%medianpacksizegb% GB`n, %logname%
	fileappend, Total Download Size:`t`t`t%totaldownloadsizekb% KB`n, %logname%
	fileappend, `t`t`t`t`t%totaldownloadsize% MB`n, %logname%
	fileappend, `t`t`t`t`t%totaldownloadsizegb% GB`n, %logname%
	fileappend, Total Amount of packs:`t`t`t%totalnumberofpacks%`n, %logname%
	fileappend, Total Amount of series:`t`t`t%totalnumberofseries%`n, %logname%
	fileappend, Approximate total download time:`t%dltimems% ms`n, %logname%
	fileappend, `t`t`t`t`t%dltimes% s`n, %logname%
	fileappend, `t`t`t`t`t%dltimemin% min`n, %logname%
	fileappend, `t`t`t`t`t%dltimeh% h, %logname%
}
}
{ ;mIRC Preparer

	;Prepares mIRC for download

mircprepare(){

	global							;sets variables to global
	filedirectory()					;initializes filesystem
	
	run %mirc%						;starts mIRC
	winwaitactive, mIRC				;waits until mIRC is active
}
}
{ ;mIRC Downloader

	;Downloads from mIRC using previous values

mircdownload(){

	global														;sets variables to global
	
	local mircseries = 1										;local variable for use in the download loop
	local mircpack = 1											;local variable for use in the download loop
	loop %totalnumberofseries%{									;download loop
		local mircchannel = channel%mircseries%					;sets channel as a useable local variable
		local mircserver = ircserver%mircseries%				;sets server as a useable local variable
		send {raw}/server %mircserver%
		send {enter}
		sleep 8000
		local mircsize = packsize%mircseries%					;sets individual packsize as a useable local variable
		local mirctime = ((mircsize*1000)/dlspeed)*1000			;calculates the required download time per pack as a useable local variable
		local mircpackloop = packcount%mircseries%				;repeats loop as many times as there are packs
		loop %mircpackloop%{									;pack enter loop
			send {raw}/join #									;sends /join #channel and presses enter to join channel
			send %mircchannel%{enter}							
			sleep 1000											;sleeps 1s
			send {esc}											;minimizes channel windows
			sleep 500											;sleeps 0.5s
			local mircpacket := pack%mircpack%					;creates useable local variable to store pack data in
			send {raw}%mircpacket%								;sends pack data and requests it
			sleep 100
			send {enter}
			sleep %mirctime%									;sleeps for the required download time
			mircpack++											;increments mircpack
		}
		mircseries++											;increments mircseries
	}
}
}


{ ;Keybinds
}

{ ;numpad0			Main
	
	;This is the main program, activated by pressing 0 on the number pad.
	;It will first evaluate the data in the prepared .txt file, write a log file and then download the packs via mIRC

numpad0::

filedirectory()															;Initializes the Windows File Directories

errorchecker()															;Checks for errors in the file directory variables
txtfilereader()															;Saves the XDCC txt files to variables xdccline%number%
txtfileparser()															;Parses the XDCC txt file to various variables
statcalc()																;Calculates necessary values for the log file
logfilewriter()															;Writes a log file with the current date as filename
mircprepare()															;Prepares mIRC for download
mircdownload()															;Downloads packs via mIRC

return
}
{ ;numpad1			Create template txt 

	;This script creates a file XDCCtemp.txt, which can be used as template for XDCC.txt.

numpad1::

filedirectory()																						;Initializes file directory
templatefile = %workdir%XDCCtemp.txt																;creates variable of new txt file name
fileappend, Download Speed(kB/s): 1000`n`n`n, %templatefile%										;Writes Template File with 2 shows and 7 packs
fileappend, pack1`npack2`npack3`nbreak`nSeries 1`nSize: 1000`nchannel: channel1`n`n`n, %templatefile%
fileappend, pack4`npack5`npack6`npack7`nbreak`nSeries 2`nSize: 2000`nchannel: channel2`n`n`n, %templatefile%
fileappend, stop, %templatefile%
return
}
{ ;numpad7			Open XDCC List 

	;This script opens XDCC.txt for viewing and editing

numpad7::

filedirectory()																						;Initializes file directory
run %xdccfile%
return
}
{ ;numpad8			Only Log Write

	;Only creates log file
	
numpad8::

filedirectory()															;Initializes the Windows File Directories

errorchecker()															;Checks for errors in the file directory variables
txtfilereader()															;Saves the XDCC txt files to variables xdccline%number%
txtfileparser()															;Parses the XDCC txt file to various variables
statcalc()																;Calculates necessary values for the log file
logfilewriter()															;Writes a log file with the current date as filename

return
}
{ ;numpad9			Script Summary

	;opens notepad and enters a summary of this script
	
numpad9::
	
filedirectory()															;Initializes the Windows File Directories
run notepad																;opens notepad.exe
winwaitactive, Untitled - Notepad										;Waits for the notepad window to become active
send AHK XDCC Downloader - Summary{enter}{enter}						;Writes the summary via send command
send Windows File directories:{enter}{enter}
send Working Directory:{tab}{tab}
send {raw}%workdir%
send {enter}XDCC File Directory:{tab}{tab}
send {raw}%xdccfile%
send {enter}mIRC Executable Directory:{tab}
send {raw}%mirc%
send {enter}{enter}{enter}
send Supported Bots, Channels and Servers:{enter}{enter}
send Bots:{tab}{tab}{tab}CR-EU|NEW{enter}
send {tab}{tab}{tab}CR-NL|NEW{enter}
send {tab}{tab}{tab}CR-FR|NEW{enter}
send {tab}{tab}{tab}CR-CA|NEW{enter}
send {tab}{tab}{tab}CR-US|NEW{enter}
send {tab}{tab}{tab}CR-ARCHIVE|1080p{enter}
send {tab}{tab}{tab}CR-ARCHIVE|720p{enter}
send {tab}{tab}{tab}CR-ARCHIVE|SD{enter}
send {tab}{tab}{tab}CR-ARUTHA|NL-720p{enter}
send {tab}{tab}{tab}Ginpachi-Sensei{enter}
send {tab}{tab}{tab}HelloKitty{enter}
send {tab}{tab}{tab}NIBL|Arutha{enter}
send {tab}{tab}{tab}Doki|Homura{enter}
send {tab}{tab}{tab}Doki|Kotomi{enter}
send {tab}{tab}{tab}Doki|Kobato{enter}
send {tab}{tab}{tab}Doki|Madoka{enter}
send Channels:{tab}{tab}
send {raw}#horriblesubs
send {enter}
send {tab}{tab}{tab}
send {raw}#intel
send {enter}
send {tab}{tab}{tab}
send {raw}#doki
send {enter}
send {tab}{tab}{tab}
send {raw}#arigatou
send {enter}
send IRC Server:{tab}{tab}irc.rizon.net
send {enter}{enter}{enter}
send Keybinds:{Enter}{Enter}
send Number Pad 0:{tab}Main Script{enter}
send Number Pad 1:{tab}XDCC File template creator{enter}
send Number Pad 2:{tab}XDCC File opener{enter}
send Number Pad 7:{tab}Log File creator{enter}
send Number Pad 9:{tab}Summary{enter}
return
}