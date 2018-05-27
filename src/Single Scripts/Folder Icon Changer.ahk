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

{ ;Autohotkey Folder Icon Changer(For Anime)
	;This Script allows the change of Anime Folders' icons
}

{ ;Parameters
#NoEnv
SendMode Input
SetWorkingDir C:\
SetFormat, float, 0.2 
}


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

{ ;Functions
}

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

{ ;Keybinds
}

{ ;numpad5					;Folder Creator with Prompt (Anime Mode)															;Main Program with Prompt, new folders

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
{ ;numpad4					;Folder Icon Changer (Anime Mode)																	;Main Program without prompt, existing folders

numpad4::
anime = 1																														;Activates Anime Mode
filedirectory()																													;Initializes file directory
folderparser()																													;Parses Folder Structure
foldericoncopy()																												;Copies folder icons to folder icon directory
foldericonchange()																												;Changes the folder icons
filedelete, %child%\Folder Icon\Season.ico																						;Deletes excess season.ico
return

}
{ ;numpad6					;Folder Converter (Anime Mode)																		;Converts old format to new

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
{ ;numpad9					;Script Summary																						;Opens notepad and enters Script Summary

numpad9::

filedirectory()															;Initializes the Windows File Directories
run notepad																;opens notepad.exe
winwaitactive, Untitled - Notepad										;Waits for the notepad window to become active
send AHK Folder Icon Converter - Summary{enter}{enter}					;Writes the summary via send command
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
send Number Pad 0:{tab}Create Anime Folders and change icons to generic folder icons{enter}
send Number Pad 1:{tab}Change existing anime folder structure icons{enter}
send Number Pad 2:{tab}Convert old format anime folder icons to new format{enter}
send Number Pad 9:{tab}Summary{enter}

return

}






















