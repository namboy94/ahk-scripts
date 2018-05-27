; Copyright 2014 Hermann Krumrey <hermann@krumreyh.com>
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

;My Autohotkey Script Collection

;Parameters
#NoEnv
SendMode Input
SetWorkingDir C:\
SetFormat, float, 0.2

;General File System Initializer
filesysteminitialize(){
global
mkvnixexe = C:\Program Files (x86)\MKV Toolnix\mmg.exe
cmdxexe = C:\Windows\System32\cmd.exe
}


;List of Global Variables

;General:						;mkvnixexe								Stores MKV Toolnix Exectuable Location

;XDCC:							;workdir								Contains the working directory
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
								
;Folder Icon Changer:			;series																														Stores the series name as a string
								;seasons																													Stores the amount of seasons of a show
								;ova																														Stores the availability of OVAs as a 1 or 0
								;specials																													Stores the availability of Specials as a 1 or 0
								;movies																														Stores the availability of Movies as a 1 or 0
								;extras																														Stores the availability of Extras as a 1 or 0
								;parent																														Stores the directory of the current directory
								;mainfolder																													Stores the directory of the main folder
								;foldericonfolder																											Stores the directory of the folder icon folder
								;seasonfolder%number%																										Stores the directory of the Season folder
								;ovafolder																													Stores the directory of the OVA folder
								;specialfolder																												Stores the directory of the Specials folder
								;moviefolder																												Stores the directory of the Movies folder
								;extrafolder																												Stores the directory of the Extras folder
								;genericicons																												Stores the directory of the generic icon folder
								;child																														Stores the directory of the child folder (or main folder)
								;anime																														Switches from anime mode(1) to normal mode (0)

;File Utilities:				;webcopy								
	
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


{ ;Autohotkey XDCC Downloader Functions

;This Script allows a download chain of XDCC packs via mIRC
;The data for this must be entered in a .txt file prior to running the script

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


;Functions

{ ;File Directory Function

	;Has to run at the beginning of all scripts and functions that make us of Windows directories
	;defines all Windows directories used in the script for easy editing
	
filedirectoryxdcc(){
	
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
	filedirectoryxdcc()								;initializes the Windows File Directories

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

	filedirectoryxdcc()								;Initializes the Windows File Directories
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
	
	IfInString, packinfo, CR-ARCHIVE|1080p					;Sets variable channel%number% with correct number and also ircserver%number%
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
	IfInString, packinfo, CR-ARUTHA|720p
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-CANADA|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-FRANCE2|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-FRANCE3|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-FRANCE|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-HOLLAND|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-NEWYORK|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-TEXAS2|NEW
	{
	channel%seriesno% = horriblesubs
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, CR-TEXAS|NEW
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
	IfInString, packinfo, Doki|Homura0
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
	IfInString, packinfo, E-D|Mashiro
	{
	channel%seriesno% = exiled-destiny
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, XDCC-ZLAND-COMEDYTV-BOXSETS
	{
	channel%seriesno% = ztv
	ircserver%seriesno% = irc.zestyland.com
	}
	IfInString, packinfo, Hiryuu
	{
	channel%seriesno% = intel
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, XDCC|Elsie
	{
	channel%seriesno% = intel
	ircserver%seriesno% = irc.rizon.net
	}
	IfInString, packinfo, Fagster
	{
	channel%seriesno% = intel
	ircserver%seriesno% = irc.rizon.net
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
	filedirectoryxdcc()														;Initializes Windows File DIrectories
	
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
	filedirectoryxdcc()					;initializes filesystem
	
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
}


;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


{ ;Autohotkey File Utilities Functions

;This Script allows various file actions


{ ;List of global Variables

	;webcopy
	
}

;Functions

{ ;Copy web																														;Copies filename from Wikipedia, TVDB etc. and prompts for an episode number
copyweb(){
	
	global webcopy = 																											;Initializes variable webcopy as global
	clipboard =																													;Empties Clipboard
	send ^c																														;Copies episode name
	clipwait																													;Waits for clipboard to be filled
	webcopy = %clipboard%																										;Saves clipboard to local variable webcopy
	StringReplace, webcopy,webcopy,", , All																						;";Removes all "
	inputbox, episode, Episode Number, Enter Episode Number																		;Prompts for episode number and saves it to variable "episode"
	inputbox, seasonvari, Season Number, Enter Season Number																	;Prompts for season number and saves it to variable "seasonvari"
	inputbox, shownamevari, Show Name, Enter Show Name																			;Prompts for show name and saves it to variable "shownamevari"
	KeyWait, numpad3, D																											;Pauses script until numpad3 is pressed down
	send {f2}																													;Opens Rename in explorer
	if(seasonvari > 9){																											;Pastes new Episode Name
		if(episode > 9){
			send {raw}%shownamevari% - S%seasonvari%E%episode% - %webcopy%
		}
		else{
			send {raw}%shownamevari% - S%seasonvari%E0%episode% - %webcopy%
		}
	}
	else{
		if(episode > 9){
			send {raw}%shownamevari% - S0%seasonvari%E%episode% - %webcopy%
		}
		else{
			send {raw}%shownamevari% - S0%seasonvari%E0%episode% - %webcopy%
		}
	}
	sleep 200
	send {tab}{enter}
	inputbox, newseries, Same Series?, Press stop to stop the script`nor press enter to continue with the next episode,			;Prompts for continuation
	if(newseries = "No"||newseries = "no"||||newseries = "N"||newseries = "n"||newseries = "0"||newseries = "stop"||newseries = "Stop"||newseries = "exit"||newseries = "false"){
	}
	else{
		loop{
			episode++
			clipboard =																											;Empties Clipboard
			KeyWait, numpad2, D																									;Waits for numpad2 keypress
			send ^c																												;Copies episode name
			clipwait																											;Waits for clipboard to be filled
			webcopy = %clipboard%																								;Saves clipboard to local variable webcopy
			StringReplace, webcopy,webcopy,", , All																				;";Removes all "
			KeyWait, numpad3, D																									;Pauses script until numpad3 is pressed down
			send {f2}																											;Opens Rename in Explorer
			if(seasonvari > 9){																									;Pastes new Episode Name
				if(episode > 9){
					send {raw}%shownamevari% - S%seasonvari%E%episode% - %webcopy%
				}
				else{
					send {raw}%shownamevari% - S%seasonvari%E0%episode% - %webcopy%
				}
			}
			else{
				if(episode > 9){
					send {raw}%shownamevari% - S0%seasonvari%E%episode% - %webcopy%
				}
				else{
					send {raw}%shownamevari% - S0%seasonvari%E0%episode% - %webcopy%
				}
			}
			sleep 200
			send {tab}{enter}																			
			inputbox, newseries, Same Series?, Press stop to stop the script`nor press enter to continue with the next episode,	;Prompts for continuation
			if((newseries = "No")||(newseries = "no")||(newseries = "N")||(newseries = "n")||(newseries = "0")||(newseries = "stop")||(newseries = "Stop")||(newseries = "exit")||(newseries = "false")){
				break																											;Stops the script
			}
			else{																												;Continues the script
				continue
			}
		}
	}
}
}
{ ;File Copy																													;Saves a filename to clipboard
filecopyer(){

	clipboard =
	send {F2}^c
	clipwait
	send {enter}

}
}
{ ;File Paste																													;Pastes Clipboard as Filename
filepaster(){

	send {F2}^v
	sleep 100
	send {tab}

}
}
}


;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


{ ;Autohotkey Folder Icon Changer Functions

;This Script allows the change of Folders' icons


{ ;List of global Variables

	;series																														;Stores the series name as a string
	;seasons																													;Stores the amount of seasons of a show
	;ova																														;Stores the availability of OVAs as a 1 or 0
	;specials																													;Stores the availability of Specials as a 1 or 0
	;movies																														;Stores the availability of Movies as a 1 or 0
	;extras																														;Stores the availability of Extras as a 1 or 0
	;parent																														;Stores the directory of the current directory
	;mainfolder																													;Stores the directory of the main folder
	;foldericonfolder																											;Stores the directory of the folder icon folder
	;seasonfolder%number%																										;Stores the directory of the Season folder
	;ovafolder																													;Stores the directory of the OVA folder
	;specialfolder																												;Stores the directory of the Specials folder
	;moviefolder																												;Stores the directory of the Movies folder
	;extrafolder																												;Stores the directory of the Extras folder
	;genericicons																												;Stores the directory of the generic icon folder
	;child																														;Stores the directory of the child folder (or main folder)
	;anime																														;Switches from anime mode(1) to normal mode (0)
	
}

;Functions

{ ;File Directory Function																										;defines all Windows directories used in the script for easy editing	
filedirectory(){
	
	global														;Sets variables in function to global
	
	genericicons = D:\Media\Images\Folder Icons\				;Contains the generic folder icons' directory
	
}
}
{ ;Current Directory(Explorer)																									;Stores the current directory in a variable "parent"
currentdir(){

	global																														;Sets variables to global
	
	clipboard =																													;Empties the clipboard
	send !d																														;Enters Windows Explorer bar
	sleep 100																													;sleeps 0.1s
	send ^c																														;Copies directory to clipboard
	clipwait																													;Waits for the clipboard to contain text
	parent = %clipboard%\																										;Copies clipboard's content to parent
	
}
}
{ ;Confirmation Prompt																											;Makes Yes/No Answers more reliable
confirmation(title,body){

	loop{
		inputbox, variable, %title%, %body%,																					;Asks the user for input
		if ((variable = 1)||(variable = "Y")||(variable = "y")||(variable = "Yes")||(variable = "yes")){						;if yes -> 1
			return 1
			break																												;Ends loop
		}
		if else ((variable = 0)||(variable = "N")||(variable = "n")||(variable = "No")||(variable = "no")){						;if no -> 0
			return 0
			break																												;Ends loop
		}
		else{
			msgbox, Error, Please revise your answer. Enter either Yes or No.													;Repeats loop
		}
}
}
}
{ ;Userinput																													;Asks the user details about the new folders to create
userinput(){

	global																														;Sets Variables to global
	local confirm = 																											;Initializes a local variable "confirm"

	loop{																														;loop for confirmation purposes
		inputbox, series, Series?, Please enter the series name for the new folder structure,									;Asks the user to input the series name and saves it in a variable
		inputbox, seasons, Seasons?, Please enter the amount of seasons for the new folder structure,							;Asks the user to input the amount of seasons and saves it in a variable
		ova := confirmation("OVA?","Are there OVAs for the new folder structure?")												;Asks the user if there are OVAs and saves it in a variable
		specials := confirmation("Specials?","Are there Specials for the new folder structure?")								;Asks the user if there are Specials and saves it in a variable
		movies := confirmation("Movies?","Are there Movies for the new folder structure?")										;Asks the user if there are Movies and saves it in a variable
		extras := confirmation("Extras?","Are there Extras for the new folder structure?")										;Asks the user if there are Extras and saves it in a variable	
		loop{																													;Confirmation Loop
			inputbox, confirm, Confirm?, The following was entered:`nSeries: %series%`tSeasons: %seasons%`nOVA: %ova%`tSpecials: %specials%`nMovies: %movies%`tExtras %extras%`nIs this OK?,																					
			if ((confirm = 1)||(confirm = "Y")||(confirm = "y")||(confirm = "Yes")||(confirm = "yes")){							
					break																										
			}
			if else ((confirm = 0)||(confirm = "N")||(confirm = "n")||(confirm = "No")||(confirm = "no")){						
					break																										
			}
			else{
				msgbox, Error, Please revise your answer. Enter either Yes or No.													
			}
		}
		if ((confirm = 1)||(confirm = "Y")||(confirm = "y")||(confirm = "Yes")||(confirm = "yes")){
			break
		}
	}
}
}
{ ;Quality Folder Creator(Anime)																								;Creates Video Quality and Audio Settings Folders
qualityfolders(parentdir){

	filecreatedir, %parentdir%\Subbed SD																						;Creates Audio Video Quality Folders
	filecreatedir, %parentdir%\Subbed 720p
	filecreatedir, %parentdir%\Subbed 1080p
	filecreatedir, %parentdir%\Subbed SD+
	filecreatedir, %parentdir%\Subbed 720p+
	filecreatedir, %parentdir%\Subbed 1080p+
	filecreatedir, %parentdir%\Dubbed SD
	filecreatedir, %parentdir%\Dubbed 720p
	filecreatedir, %parentdir%\Dubbed 1080p
	filecreatedir, %parentdir%\Dubbed SD+
	filecreatedir, %parentdir%\Dubbed 720p+
	filecreatedir, %parentdir%\Dubbed 1080p+
	filecreatedir, %parentdir%\Dual-Audio SD
	filecreatedir, %parentdir%\Dual-Audio 720p
	filecreatedir, %parentdir%\Dual-Audio 1080p
	filecreatedir, %parentdir%\Dual-Audio SD+
	filecreatedir, %parentdir%\Dual-Audio 720p+
	filecreatedir, %parentdir%\Dual-Audio 1080p+
	filecreatedir, %parentdir%\Multi-Audio SD
	filecreatedir, %parentdir%\Multi-Audio 720p
	filecreatedir, %parentdir%\Multi-Audio 1080p
	filecreatedir, %parentdir%\Multi-Audio SD+
	filecreatedir, %parentdir%\Multi-Audio 720p+
	filecreatedir, %parentdir%\Multi-Audio 1080p+

}
}
{ ;Quality Folder Icon copier(Anime)																							;Copies Dub/Sub/Quality icons to folder icon directory
qualityfoldericons(){

	global																														;Sets variables to global for access to global variables
	filedirectory()																												;Initializes files directory
	
	filecopy, %genericicons%Subbed SD.ico, %foldericonfolder%\
	filecopy, %genericicons%Subbed 720p.ico, %foldericonfolder%\
	filecopy, %genericicons%Subbed 1080p.ico, %foldericonfolder%\
	filecopy, %genericicons%Dubbed SD.ico, %foldericonfolder%\
	filecopy, %genericicons%Dubbed 720p.ico, %foldericonfolder%\
	filecopy, %genericicons%Dubbed 1080p.ico, %foldericonfolder%\
	filecopy, %genericicons%Dual-Audio SD.ico, %foldericonfolder%\
	filecopy, %genericicons%Dual-Audio 720p.ico, %foldericonfolder%\
	filecopy, %genericicons%Dual-Audio 1080p.ico, %foldericonfolder%\
	filecopy, %genericicons%Multi-Audio SD.ico, %foldericonfolder%\
	filecopy, %genericicons%Multi-Audio 720p.ico, %foldericonfolder%\
	filecopy, %genericicons%Multi-Audio 1080p.ico, %foldericonfolder%\

}
}
{ ;Quality Folder Icon changer(Anime)																							;Changes Anime specific folder icons
qualityfoldericonchanger(destiny,type,typenoplus){																				
	
	local qualitydestination =																									;Initializes local variables
	local iconizer =
	qualitydestination = %destiny%\%type%																						;Creates useable variables from parameters
	iconizer = ..\..\Folder Icon\%typenoplus%.ico
	autobat(iconizer,qualitydestination)																						;changes icons
	
}
}
{ ;Quality Folder Icon changer batch(Anime)																						;Changes all anime specific folder icons
qualityfullfoldericonchanger(destina){																				
	
	ifexist, %destina%\Subbed SD
		qualityfoldericonchanger(destina,"Subbed SD","Subbed SD")																;changes icons, if folder available
	ifexist, %destina%\Subbed SD+
		qualityfoldericonchanger(destina,"Subbed SD+","Subbed SD")
	ifexist, %destina%\Subbed 720p
		qualityfoldericonchanger(destina,"Subbed 720p","Subbed 720p")
	ifexist, %destina%\Subbed 720p+
		qualityfoldericonchanger(destina,"Subbed 720p+","Subbed 720p")
	ifexist, %destina%\Subbed 1080p
		qualityfoldericonchanger(destina,"Subbed 1080p","Subbed 1080p")
	ifexist, %destina%\Subbed 1080p+
		qualityfoldericonchanger(destina,"Subbed 1080p+","Subbed 1080p")
	ifexist, %destina%\Dubbed SD
		qualityfoldericonchanger(destina,"Dubbed SD","Dubbed SD")																	
	ifexist, %destina%\Dubbed SD+
		qualityfoldericonchanger(destina,"Dubbed SD+","Dubbed SD")
	ifexist, %destina%\Dubbed 720p
		qualityfoldericonchanger(destina,"Dubbed 720p","Dubbed 720p")
	ifexist, %destina%\Dubbed 720p+
		qualityfoldericonchanger(destina,"Dubbed 720p+","Dubbed 720p")
	ifexist, %destina%\Dubbed 1080p
		qualityfoldericonchanger(destina,"Dubbed 1080p","Dubbed 1080p")
	ifexist, %destina%\Dubbed 1080p+
		qualityfoldericonchanger(destina,"Dubbed 1080p+","Dubbed 1080p")
	ifexist, %destina%\Dual-Audio SD
		qualityfoldericonchanger(destina,"Dual-Audio SD","Dual-Audio SD")																	
	ifexist, %destina%\Dual-Audio SD+
		qualityfoldericonchanger(destina,"Dual-Audio SD+","Dual-Audio SD")
	ifexist, %destina%\Dual-Audio 720p
		qualityfoldericonchanger(destina,"Dual-Audio 720p","Dual-Audio 720p")
	ifexist, %destina%\Dual-Audio 720p+
		qualityfoldericonchanger(destina,"Dual-Audio 720p+","Dual-Audio 720p")
	ifexist, %destina%\Dual-Audio 1080p
		qualityfoldericonchanger(destina,"Dual-Audio 1080p","Dual-Audio 1080p")
	ifexist, %destina%\Dual-Audio 1080p+
		qualityfoldericonchanger(destina,"Dual-Audio 1080p+","Dual-Audio 1080p")
	ifexist, %destina%\Multi-Audio SD
		qualityfoldericonchanger(destina,"Multi-Audio SD","Multi-Audio SD")																	
	ifexist, %destina%\Multi-Audio SD+
		qualityfoldericonchanger(destina,"Multi-Audio SD+","Multi-Audio SD")
	ifexist, %destina%\Multi-Audio 720p
		qualityfoldericonchanger(destina,"Multi-Audio 720p","Multi-Audio 720p")
	ifexist, %destina%\Multi-Audio 720p+
		qualityfoldericonchanger(destina,"Multi-Audio 720p+","Multi-Audio 720p")
	ifexist, %destina%\Multi-Audio 1080p
		qualityfoldericonchanger(destina,"Multi-Audio 1080p","Multi-Audio 1080p")
	ifexist, %destina%\Multi-Audio 1080p+
		qualityfoldericonchanger(destina,"Multi-Audio 1080p+","Multi-Audio 1080p")
	
}
}
{ ;Folder from User Input Creator																								;Creates a folder directory based on user input
folderfrominput(){

	global																														;Sets variables to global
	
	mainfolder = %parent%%series%																								;Creates useable directory variables
	foldericonfolder = %parent%%series%\Folder Icon
	ovafolder = %parent%%series%\OVA
	specialfolder = %parent%%series%\Specials
	moviefolder = %parent%%series%\Movies
	extrafolder = %parent%%series%\Extras
	local seasonlooper = 1																										;Loop to create multiple Season Folder variables.
	loop %seasons%{
		seasonfolder%seasonlooper% = %parent%%series%\Season %seasonlooper%
		seasonlooper++
	}
	seasonlooper = 1
	filecreatedir, %mainfolder%																									;Creates Folder Directories
	filecreatedir, %foldericonfolder%
	if(ova = 1){
		filecreatedir, %ovafolder%
		if(anime = 1){
			qualityfolders(ovafolder)
		}
	}
	if(specials = 1){
		filecreatedir, %specialfolder%
		if(anime = 1){
			qualityfolders(specialfolder)
		}
	}
	if(movies = 1){
		filecreatedir, %moviefolder%
		if(anime = 1){
			qualityfolders(moviefolder)
		}
	}
	if(extras = 1){
		filecreatedir, %extrafolder%
		if(anime = 1){
			qualityfolders(extrafolder)
		}
	}
	loop %seasons%{
		seasonfolder := seasonfolder%seasonlooper%
		filecreatedir, %seasonfolder%
		if(anime = 1){
			qualityfolders(seasonfolder)
		}
		seasonlooper++
	}
}
}
{ ;Folder Icon Copier																											;Copies the generic folder icons from the default directory to the new one
foldericoncopy(){

	global																														;Sets variables to global
	filedirectory()																												;Initializes file directory
	
	if(anime = 1){																												;Copies Sub/Dub/Quality icons to icon folder
		qualityfoldericons()
	}
	local destination = 																										;initializes local variables
	local mainsource = 																											
	local foldersource = 
	local ovasource = 
	local specialsource = 
	local moviesource = 
	local extrasource = 
	local seasonsource = 
	local seasonpreliminarydestination = 
	destination = %foldericonfolder%\																							;creates useable local variables that contain the various .ico files
	mainsource = %genericicons%Main.ico
	foldersource = %genericicons%Folder.ico
	ovasource = %genericicons%OVA.ico
	specialsource = %genericicons%Specials.ico
	moviesource = %genericicons%Movies.ico
	extrasource = %genericicons%Extras.ico
	seasonsource = %genericicons%Season.ico
	seasonpreliminarydestination = %destination%Season.ico 
	
	filecopy, %mainsource%, %destination%																						;Copies files to destination
	filecopy, %foldersource%, %destination%
	local seasonlooper = 1
	loop %seasons%{
		filecopy, %seasonsource%, %destination%
		local seasoninfolder =
		seasoninfolder = %destination%Season %seasonlooper%.ico
		filemove, %seasonpreliminarydestination%, %seasoninfolder%																;Renames Season.ico to specific files, e.g. Season 1.ico
		seasonlooper++
	}
	if(ova = 1){
		filecopy, %ovasource%, %destination%
	}
	if(specials = 1){
		filecopy, %specialsource%, %destination%
	}
	if(movies = 1){
		filecopy, %moviesource%, %destination%
	}
	if(extras = 1){
		filecopy, %extrasource%, %destination%
	}
}
}
{ ;Autobat																														;Creates a folder icon changing .bat file, executes it, and deletes it
autobat(iconname,destination){

	bat = %destination%\autobat.bat
	workingbat = "%destination%\desktop.ini"
	workingfiledirectory = "%destination%"
	fileappend, attrib -s -h -r %workingbat%`n, %bat%																			;Changes attributes of eventually already existing .bat file															
	fileappend, break>%workingbat%`n, %bat%																						;Clears .bat file
	fileappend, echo [.ShellClassInfo]>>%workingbat%`n, %bat%																	;Writes [.ShellClassInfo] to bat file
	fileappend, echo IconFile=%iconname%>>%workingbat%`n, %bat%																	;Writes Iconresource=Folder.ico etc to bat file
	fileappend, echo IconIndex=0 >>%workingbat%`n, %bat%
	fileappend, echo [ViewState]>>%workingbat%`n, %bat%																			;Writes [ViewState]
	fileappend, echo Mode=>>%workingbat%`n, %bat%																				;Writes Mode=
	fileappend, echo Vid=>>%workingbat%`n, %bat%																				;Writes Vid=
	fileappend, echo FolderType=Videos>>%workingbat%`n, %bat%																	;Writes Foldertype=Videos
	fileappend, attrib +s +h +r %workingbat%`n, %bat%																				;Makes desktop.ini a system file
	fileappend, attrib +r %workingfiledirectory%, %bat%																	;Changes directory to read-only	
	run %bat%																													;Executes .bat file
	winwaitclose, C:\Windows\system32\cmd.exe																					;Waits until execution is completed
	filedelete, %bat%																											;Deletes the .bat file afterwards

}
}
{ ;Folder Icon Changer																											;Changes the folder icons with the help of a .bat script
foldericonchange(){

	global																														;Sets variables to global to access other global variables
	filedirectory()																												;Initializes file directory
	
	autobat("Folder Icon\Main.ico",mainfolder)																					;Executes autobat function for main
	autobat("Folder.ico",foldericonfolder)																						;Executes autobat function for folder icon
	local seasonlooper = 1																										;Executes autobat function for seasons
	loop %seasons%{
		local localseasonfolder=
		local seasonico = 
		seasonico = ..\Folder Icon\Season %seasonlooper%.ico
		localseasonfolder := seasonfolder%seasonlooper%
		autobat(seasonico,localseasonfolder)
		if(anime = 1){
			qualityfullfoldericonchanger(localseasonfolder)
		}
		seasonlooper++
	}
	if(ova = 1){																												;Executes autobat function for other folder types
		autobat("..\Folder Icon\OVA.ico",ovafolder)
		if(anime = 1){
			qualityfullfoldericonchanger(ovafolder)
		}
	}
	if(specials = 1){
		autobat("..\Folder Icon\Specials.ico",specialfolder)
		if(anime = 1){
			qualityfullfoldericonchanger(specialfolder)
		}
	}
	if(movies = 1){
		autobat("..\Folder Icon\Movies.ico",moviefolder)
		if(anime = 1){
			qualityfullfoldericonchanger(moviefolder)
		}
	}
	if(extras = 1){
		autobat("..\Folder Icon\Extras.ico",extrafolder)
		if(anime = 1){
			qualityfullfoldericonchanger(extrafolder)
		}
	}
	
}
}
{ ;Folder Parser																												;Evaluates a folder for icon changing actions
folderparser(){

	global																														;sets variables to global
	
	clipboard = 																												;clears clipboard
	send !d																														;Enter Windows Explorer Bar
	sleep 200																													;Sleeps 0.2s
	send ^c																														;Sends keystroke CTRL C
	clipwait																													;Waits for clipboard to be filled
	parent = %clipboard%\																										;saves clipboard as global variable parent
	clipboard = 																												;clears clipboard
	send {enter}{tab}{tab}{tab}{enter}																							;Enters child directory in explorer
	sleep 350																													;Sleeps 0.35s
	send !d																														;Enters Windows Explorer Bar
	sleep 200																													;Sleeps 0.2s
	send ^c																														;Sends CTRL C
	clipwait																													;Waits for clipboard to be filled
	child = %clipboard%																											;saves clipboard as global variable child
	ova = 0
	specials = 0
	movies = 0
	extras = 0
	ifexist, %child%\OVA																										;Checks if OVA exists and enters 1 to global variable ova if positive
	{
	ova = 1
	}
	ifexist, %child%\Specials																									;Checks if Specials exists and enters 1 to global variable specials if positive
	{
	specials = 1
	}
	ifexist, %child%\Movies																										;Checks if Movies exists and enters 1 to global variable movies if positive
	{
	movies = 1
	}
	ifexist, %child%\Extras																										;Checks if Extras exists and enters 1 to global variable extras if positive
	{
	extras = 1
	}
	local seasonlooper = 1																										;Initializes local loop helping variable
	seasons = 0																													;Initializes global variable seasons conatining the amount of seasons
	loop{																														;Checks for Seasons and saves amount of seasons to saesons
		ifexist, %child%\Season %seasonlooper%
		{
		seasons++
		}
		ifnotexist, %child%\Season %seasonlooper%
		{
		break
		}
		seasonlooper++
	}
	local parentlength =																										;initializes local variables
	local childlength =
	stringlen, parentlength, parent																								;measures the length of strings and saves to local variables
	stringlen, childlength, child
	stringtrimleft, series, child, %parentlength%																				;trims child variable by amount of parent variable characters, then saves to global variable series
	mainfolder = %child%																										;Sets global variables containing folder structures
	foldericonfolder = %child%\Folder Icon
	ovafolder = %child%\OVA
	specialfolder = %child%\Specials
	moviefolder = %child%\Movies
	extrafolder = %child%\Extras
	seasonlooper = 1
	loop %seasons%{
		seasonfolder%seasonlooper% = %child%\Season %seasonlooper%
		seasonlooper++
	}
}
}
}


;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



;Keybinds


{ ;numpad0			XDCC Downloader																								;Starts XDCC Downloader Script and creates a log file
	
	;This is the main program, activated by pressing 0 on the number pad.
	;It will first evaluate the data in the prepared .txt file, write a log file and then download the packs via mIRC

numpad0::

filedirectoryxdcc()															;Initializes the Windows File Directories

errorchecker()															;Checks for errors in the file directory variables
txtfilereader()															;Saves the XDCC txt files to variables xdccline%number%
txtfileparser()															;Parses the XDCC txt file to various variables
statcalc()																;Calculates necessary values for the log file
logfilewriter()															;Writes a log file with the current date as filename
mircprepare()															;Prepares mIRC for download
mircdownload()															;Downloads packs via mIRC

return
}
{ ;numpad1			XDCC Template																								;Creates a XDCC.txt template

	;This script creates a file XDCCtemp.txt, which can be used as template for XDCC.txt.

numpad1::

filedirectoryxdcc()																						;Initializes file directory
templatefile = %workdir%XDCCtemp.txt																;creates variable of new txt file name
fileappend, Download Speed(kB/s): 1000`n`n`n, %templatefile%										;Writes Template File with 2 shows and 7 packs
fileappend, pack1`npack2`npack3`nbreak`nSeries 1`nSize: 1000`nchannel: channel1`n`n`n, %templatefile%
fileappend, pack4`npack5`npack6`npack7`nbreak`nSeries 2`nSize: 2000`nchannel: channel2`n`n`n, %templatefile%
fileappend, stop, %templatefile%
return
}
{ ;numpad7			Open XDCC List 																								;Opens the XDCC.txt file

	;This script opens XDCC.txt for viewing and editing

numpad7::

filedirectoryxdcc()																						;Initializes file directory
run %xdccfile%
return
}
{ ;numpad8			XDCC Log Write																								;Writes a XDCC log file based off XDCC.txt	

	;Only creates log file
	
numpad8::

filedirectoryxdcc()															;Initializes the Windows File Directories

errorchecker()															;Checks for errors in the file directory variables
txtfilereader()															;Saves the XDCC txt files to variables xdccline%number%
txtfileparser()															;Parses the XDCC txt file to various variables
statcalc()																;Calculates necessary values for the log file
logfilewriter()															;Writes a log file with the current date as filename

return
}
{ ;numpad9			

	;opens notepad and enters a summary of this script
	
numpad9::
	
filedirectoryxdcc()														;Initializes the Windows File Directories for the XDCC scripts
filedirectory()														;Initializes the Windows File Directories for folder icon scripts
run notepad																;opens notepad.exe
winwaitactive, Untitled - Notepad										;Waits for the notepad window to become active
send Hermann Krumrey's AHK Script Collection - Summary{enter}{enter}	;Writes the summary via send command

send AHK XDCC Downloader Scripts:{enter}{enter}						
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
send {tab}{tab}{tab}Blargh|Other{enter}
send {tab}{tab}{tab}[Arigatou]MrRoboto{enter}
send {tab}{tab}{tab}Xide{enter}
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
send {raw}#kametsu
send {enter}
send {tab}{tab}{tab}
send {raw}#arigatou
send {enter}
send IRC Server:{tab}{tab}irc.rizon.net{enter}
send {tab}{tab}{tab}irc.kametsu.com
send {enter}{enter}{enter}

send AHK Folder Icon Converter Scripts{enter}{enter}
send Windows File directories:{enter}{enter}
send Generic Folder Icons Directory:{tab}{tab}
send {raw}%genericicons%
send {enter}{enter}{enter}
send Supported Folder Structure:{enter}{enter}
send Parent{tab}{tab}Series{tab}{tab}Folder Icon{enter}
send {tab}{tab}{tab}{tab}OVA{tab}{tab}{tab}Subbed/Dubbed/Multi-Audio/Dual-Audio SD/SD+/720p/720p+/1080p/1080p+{enter}
send {tab}{tab}{tab}{tab}Specials{tab}{tab}Subbed/Dubbed/Multi-Audio/Dual-Audio SD/SD+/720p/720p+/1080p/1080p+{enter}
send {tab}{tab}{tab}{tab}Movies{tab}{tab}{tab}Subbed/Dubbed/Multi-Audio/Dual-Audio SD/SD+/720p/720p+/1080p/1080p+{enter}
send {tab}{tab}{tab}{tab}Extras{tab}{tab}{tab}Subbed/Dubbed/Multi-Audio/Dual-Audio SD/SD+/720p/720p+/1080p/1080p+{enter}
send {tab}{tab}{tab}{tab}Season x{tab}{tab}Subbed/Dubbed/Multi-Audio/Dual-Audio SD/SD+/720p/720p+/1080p/1080p+{enter}
send {enter}{enter}{enter}

send Keybinds:{Enter}{Enter}
send Home Button:{tab}Copies a filename and can be pasted with insert{enter}
send Insert Button:{tab}Unbound, helps with Filename copy-paster{enter}
send Number Pad 0:{tab}XDCC Downloader Script{enter}
send Number Pad 1:{tab}Creates XDCCtemp.txt in %workdir%{enter}
send Number Pad 2:{tab}Episode Renamer Script{enter}
send Number Pad 3:{tab}Unbound, usaed for help in Episode Renamer Script{enter}
send Number Pad 4:{tab}Folder Icon Changer (Existing Folder){enter}
send Number Pad 5:{tab}Folder Crator and Changer{enter}
send Number Pad 6:{tab}Folder Converter (Icon mechanic){enter}
send Number Pad 7:{tab}Open XDCC.txt{enter}
send Number Pad 8:{tab}Writes a log file from XDCC.txt{enter}
send Number Pad 9:{tab}Summary
return
}
{ ;numpad2			Episode Renamer																								;Manual file renamer with prefix Episode x-
numpad2::

copyweb()

return

}
{ ;home				Filecopypaster																								;Copies and pastest filenames
home::

filecopyer()
KeyWait, insert, D
filepaster()
	
return
}
{ ;numpad5			Folder Creator with Prompt (Anime Mode)																		;Main Program with Prompt, new folders

numpad5::

anime = 1																														;Activates Anime Mode
filedirectory()																													;Initializes file directory variables
currentdir()																													;Establishes Current Directory
userinput()																														;Prompts Userinput
folderfrominput()																												;Creates folders based on userinput and currentdir
foldericoncopy()																												;Copies Folder Icons
foldericonchange()																												;Changes Folder Icons
	

	

return

}
{ ;numpad4			Folder Icon Changer (Anime Mode)																			;Main Program without prompt, existing folders

numpad4::
anime = 1																														;Activates Anime Mode
filedirectory()																													;Initializes file directory
folderparser()																													;Parses Folder Structure
foldericoncopy()																												;Copies folder icons to folder icon directory
foldericonchange()																												;Changes the folder icons
filedelete, %child%\Folder Icon\Season.ico																						;Deletes excess season.ico
return

}
{ ;numpad6			Folder Converter (Anime Mode)																				;Converts old format to new

numpad6::																														
anime = 1																														;Sets to anime mode
filedirectory()																													;Initializes file directory
folderparser()																													;Evaluates file structure
filecopy, %child%\Folder Icon\main.ico, %child%\Folder Icon\Season 1.ico														;Copies main.ico and creates a new Season 1.ico
filemove, %child%\Folder Icon\main.ico, %child%\Folder Icon\Main.ico															;Renames main.ico to Main.ico
filedelete, %child%\Folder Icon\*.png																							;Deletes .png files
foldericoncopy()																												;Copies missinf folder icons
foldericonchange()																												;Changes all folder icons to updated format
filedelete, %child%\Folder Icon\Season.ico																						;Deletes excess season.ico
send {tab}!{up}																													;Returns to parent directory
return

}


;Miscelaneous Program openers

{ ;mkvnix
::mkvnix::
filesysteminitialize()
run %mkvnixexe%
return
}
{ ;javacomp
::javacomp::
filesysteminitialize()
inputBox, javacompiler, Java Name, Name of .java file to be compiled
run C:\Windows\System32\cmd.exe
sleep 500
send cd..{enter}
sleep 150
send cd..{enter}
sleep 150
send cd users{enter}
sleep 150
send cd Hermann{enter}
sleep 150
send cd desktop{enter}
sleep 150
send javac %javacompiler%.java{enter}
loop{
keywait, end, d,
send javac %javacompiler%.java{enter}
} 
return
}
