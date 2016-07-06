#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SetFormat, float, 0.2

;Functions

{ ;Confirmation Function				confirmation					Creates a simple Yes/No Dialogue and returns 1(yes) or 0(no)		
confirmation(title,body){														
	loop{
		inputBox, answer, %title%, %body%,
		if(answer = "1"||answer = "yes"||answer = "Yes"||answer = "YES"||answer = "y"||answer = "Y"||answer = "true"||answer = "True"||answer = "TRUE"){
			return 1
			break
		}
		else if(answer = "0"||answer = "no"||answer = "No"||answer = "NO"||answer = "n"||answer = "N"||answer = "false"||answer = "False"||answer = "FALSE"){
			return 0
			break
		}
		else{
			msgBox,Please enter a valid answer
			continue
		}
	}
}
}
{ ;Print Function						print							Prints a variable or string to notepad and closes notepad after showing a messagebox
print(input){																		
	run notepad
	sleep 1000
	send %input%
}
}
{ ;Download Length Calculator			dlspeedscalculator				Calculates the download length from given kB/s(speed) and MB(size)	
dlspeedcalculator(size,speed){														
	dllen := (1000*size)/speed
	return dllen
}
}
{ ;Download Length Converter s to ms	dlspeedstoms					Converts Download Length from s to ms
dlspeedstoms(secondspeed){															
	dllen := secondspeed*1000
	return dllen
}
}
{ ;Download Length Converter s to min	dlspeedstominconverts			Converts Download Length from s to min
dlspeedstomin(secondspeed){															
	dllen := secondspeed/60
	return dllen
}
}
{ ;Download Length Converter s to h		dlspeedstoh						Converts Download Length from s to h
dlspeedstoh(secondspeed){															
	dllen := secondspeed/1440
	return dllen	
}
}
{ ;XDCC Pack txt Reader					packtxtreader					Reads an XDCC-packlist formated .txt file and saves the data to variables
packtxtreader(pack){																
	global
	local linenumber = 1
	shownum = 1
	epinocounter = 0
	loop{
		Send +{end}
		sleep 100
		Send^c
		Send {Home}
		sleep 500
		varino = %clipboard%
		if(varino = "Break"||varino = "BREAK"||varino = "break"){
			Send {down}
			Send +{end}
			sleep 100
			Send^c
			Send {Home}
			sleep 500
			show%shownum% = %clipboard%
			episodes%shownum% = %epinocounter%
			epinocounter = 0
			shownum++
			Send {down}{down}
		}
		else if(varino = "end"||varino = "End"||varino = "END"||varino = "stop"||varino = "Stop"||varino = "STOP"){
			counter := linenumber-1
			Send !{F4}
			break
		}
		else{
			Send {down}
			%pack%%linenumber% = %varino%
			linenumber++
			epinocounter++
			continue
		}
	}
}
}
{ ;XDCC Pack manual Reader				packmanualreader				Asks for a manual input of XDCC-packs and saves the data to variables
packmanualreader(pack){																
	global
	local packnumber
	packnumber = 1
	inputBox, counter, %Pack% Amount, How many %Pack%s should be downloaded?
	loop %counter%{
		inputbox, %pack%%packnumber%, Pack %packnumber%, Enter pack number %packnumber%,
		packnumber++
	}
}
}
{ ;XDCC Pack downloader					packdownloader					Downloads previously input XDCC packs via mIRC
packdownloader(pack,loopcounter,downloadspeedinms){									
	packnumber = 1
	loop %loopcounter%{
		if(stop = 1){
			break
		}
		else{
			episode := %pack%%packnumber%
			Send {Raw}%episode%
			Send {Enter}
			packnumber++
			Sleep 10000
			Send ^n
			Sleep %downloadspeedinms%
		}
	}
	packnumber :=
}
}
{ ;XDCC Pack Log Writer					packlogwriter					Writes a log of previously input XDCC packfiles
packlogwriter(prepost,havebeenwillbe,amount,pack,downspeed,downsize,downs,downmin,downh,totdowns,totdownmin,totdownh,shownum){	
	run notepad
	sleep 500
	Send %prepost%-Download Log File:{Enter}{Enter}The following packs %havebeenwillbe% downloaded:{Enter}{Enter}{Enter}
	packnumber = 1
	seriescount = 1
	loop %shownum%{
		shower := show%seriescount%
		Send Series: %shower%{Enter}{Enter}
		epicount := episodes%seriescount%
		loop %epicount%{
			pak := %pack%%packnumber%
			Send %pack% %packnumber%:{tab}
			Send {raw}%pak%
			Send {Enter}
			packnumber++
		}
		Send {Enter}{Enter}
		seriescount++
	}
	packnumber :=
	Send {Enter}Entered Variables:{Enter}Download Speed:{tab}{tab}{tab}%downspeed%{Enter}Median Download Size:{tab}{Tab}%downsize%{Enter}
	Send Individual Download length:{tab}%downs% Seconds{tab}{tab}%downmin% Minutes{tab}{tab}%downh% Hours{Enter}
	Send Total Download length:{tab}{tab}%totdowns% Seconds{tab}{tab}%totdownmin% Minutes{tab}{tab}%totdownh% Hours{Enter}
	Send Total number of %pack%s:{tab}%amount%
}
}
{ ;Directory Navigatornavigates			navigatetodirectory				Navigates to a certain directory using Windows Explorer
navigatetodirectory(directory){														
	run explorer
	sleep 500
	Send !d
	sleep 100
	Send {raw}%directory%
	Send {Enter}
}
}
{ ;txt File Saver						savetxtfile						Saves a .txt file to the given directory and with the give filename
savetxtfile(directory,savename){													
	Send !{F4}s
	sleep 200
	Send {raw}%savename%.txt
	Sleep 200
	Send !d
	sleep 200
	Send {raw}%directory%
	Send {Enter}
	sleep 100
	loop 10{
		Send {tab}
		sleep 100
	}
	Send {Enter}
}
}
{ ;Date Variable						savedaytovar					Saves the current date and time to a given variable
savedaytovar(date){																	
	global
	%date% = %A_YYYY%-%A_MM%-%A_DD% %A_Hour%-%A_Min%-%A_Sec%
}
}
{ ;Filename to Variable					filenametovar					Saves a filename to a given variable
filenametovar(outputvariable){														
	Send {F2}^c{Enter}
	Sleep 800
	outputvariable = %clipboard%
	msgBox, %outputvariable% 
}
}
{ ;Firefox Page Load Identifier			waitforfirefox					Waits for a Firefox page to load (needs a predetermined .png file to operate.)
waitforfirefox(pngfile){																														
	loop {
		sleep 2000
		ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight, %pngfile%
		if (ErrorLevel = "0"){
			break
		}
		else{
			continue
		}
	}
}
}
{ ;\desktop.ini Editor					desktopinieditor				Edits the desktop.ini file of a folder to accomodate a folder icon
desktopinieditor(icons,foldertype){
	Send [.ShellClassInfo]{Enter}
	Send {Raw}IconResource=%icons%,0
	Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=%foldertype%{Enter}
}
}
{ ;Anime Folder Icon Changer(single)	changesingleanimefoldericon		Changes Anime Folder Icon according to the HK14.07 anime convention
changesingleanimefoldericon(){														
	Send !{Enter}
	sleep 100 ; ms
	Send {Tab}{Tab}{Tab}{Tab}{Tab}
	Send {Right}{Right}{Right}
	Send {Tab}{Tab}{Tab}{Tab}{Tab}{Enter}
	Sleep 200 ; ms
	Send {Tab}{Tab}{Right}{Right}{Enter}
	Sleep 100 ; ms
	Send {Tab}{Tab}{Tab}{Enter}
	Sleep 100 ; ms
	Send {Tab}{Tab}{Tab}{Tab}{Tab}{Enter}
	Sleep 100 ; ms
	Send {F2}
	sleep 50
	Send ^c
	sleep 1000
	Send {Enter}
	sleep 500
	tempstorage1 = %clipboard%
	StringLen, length, tempstorage1
	minuslength := length-1
	edited = 0
	Send {Enter}
	Sleep 300 ; ms
	Send !d{Right}
	Send \desktop.ini{Enter}
	Sleep 400 ; ms
	Send ^a{del}
	if(tempstorage1 = "Folder Icon"){
		Send [.ShellClassInfo]{Enter}
		Send {Raw}IconResource=Folder.ico,0
		Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Pictures{Enter}
		lastfolder = 1
	}
	else if(length = 8){
		stringtrimright, tempstorage2, tempstorage1, 2
	}
	else{
		Stringtrimright, tempstorage2, tempstorage1, 3
	}
	
	if(tempstorage2 = "Season"){
		stringtrimleft, seasonnumber, tempstorage1, 7
		if(seasonnumber = "1"){
			Send [.ShellClassInfo]{Enter}
			Send {Raw}IconResource=..\Folder Icon\main.ico,0
			Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Videos{Enter}
			lastfolder = 0
		}
		else{
			Send [.ShellClassInfo]{Enter}
			Send {Raw}IconResource=..\Folder Icon\%tempstorage1%.ico,0
			Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Videos{Enter}
			lastfolder = 0
		}
	}
	else{
		stringtrimleft, tempstorage3, tempstorage1, %minuslength%
		if (tempstorage3 = "+"){
			tempstorage4 = %tempstorage1%
			stringtrimright, tempstorage1, tempstorage4, 1
			edited = 1
		}
	}
	
	if(tempstorage1 = "Dual-Audio SD"||tempstorage1 = "Dual-Audio 720p"||tempstorage1 = "Dual-Audio 1080p"||tempstorage1 = "Multi-Audio SD"||tempstorage1 = "Multi-Audio 720p"||tempstorage1 = "Multi-Audio 1080p"||tempstorage1 = "Subbed SD"||tempstorage1 = "Subbed 720p"||tempstorage1 = "Subbed 1080p"||tempstorage1 = "Dubbed SD"||tempstorage1 = "Dubbed 720p"||tempstorage1 = "Dubbed 1080p"){
		Send [.ShellClassInfo]{Enter}
		Send {Raw}IconResource=..\..\Folder Icon\%tempstorage1%.ico,0
		Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Videos{Enter}
		lastfolder = 1
	}
	else if(tempstorage1 = "Movies"||tempstorage1 = "Specials"||tempstorage1 = "Extras"||tempstorage1 = "OVA"){
			Send [.ShellClassInfo]{Enter}
			Send {Raw}IconResource=..\Folder Icon\%tempstorage1%.ico,0
			Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Videos{Enter}
			lastfolder = 0
	}
	else if(tempstorage1 = "Folder Icon"||tempstorage2 = "Season"){
	}
	else{
		Send [.ShellClassInfo]{Enter}
		Send {Raw}IconResource=Folder Icon\main.ico,0
		Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Videos{Enter}
		lastfolder = 0	
	}
	
	Sleep 300 ; ms
	Send ^s
	Sleep 300 ; ms
	Send !{F4}
	if(lastfolder = "1"){
		if(edited = "1"){
			ifWinExist, {raw}%tempstorage1%+
			WinActivate
		}
		else {
			ifWinExist, %tempstorage1%
			WinActivate
		}
		sleep 250 ; ms
		Send !d
		sleep 250 ; ms
		Send !{up}
	}
	else{
	}
}
}
{ ;New Folder Creator					newfolder						Creates a new folder in the current directory
newfolder(){
	Send ^+n
	Sleep 250
}
}	
{ ;Animefolder Creator					anifolder						Creates a special Anime Folder with integrated Sub/Dub Folder
anifolder(anitype, language, quality){
	newfolder()
	Send %anitype%{Enter}{Enter}
	Sleep 250 
	newfolder()
	Send %language% %quality%{Enter}
	Sleep 250 
	Send!{up}
	Sleep 250 
}
}	
{ ;Animefoldericon Special				anispecial						Takes care of changing anime folder icons for Specials, OVAs etc
anispecial(showname,type,lang,language,quality){
	Stringlen, typelength, type
	typelengthminus := typelength-1
	stringtrimright, typeletter, type, %typelengthminus%
	sleep 250
	if(type = "Specials"){
	send {down}
	sleep 150
	}
	else{
	ifWinExist, %showname%
	WinActivate
	sleep 200
	Send !d
	sleep 200
	Send {tab}{tab}{tab}%typeletter%
	sleep 160
	}
	changesingleanimefoldericon()
	ifWinExist, %type%
	WinActivate
	sleep 200
	send !d
	sleep 200
	Send {tab}{tab}{tab}%lang%
	sleep 170
	changesingleanimefoldericon()
	sleep 300
	ifWinExist, %language% %quality%
	WinActivate
	sleep 200
	send !d
	sleep 200
	Send !{up}
}
}
	
{ ;Test Function						testfunction					Used to test variable functions
testfunction(){
}
}


;Keybinds

{		;numpad0		Title: XDCC Downloader				Function: Inputs XDCC packs via .txt or manual input, downloads via mIRC and produces log files
numpad0::

txtprompt := confirmation("Import .txt?","Do you want to import a .txt file that contains bot and pack`rinformation in a compatible format?")
archivelogs := confirmation("Archive logfiles?","Do you want to save your log files to the download folder?")
loop{												; Inputloop
	Inputbox, speed, Download Speed, Please enter the estimated download speed`r(In kB/s),
	Inputbox, size, File Size, Please enter the estimated individual file size`r(In MB),
	downloadspeeds := dlspeedcalculator(size,speed)
	downloadspeedms := dlspeedstoms(downloadspeeds)
	downloadspeedmin := dlspeedstomin(downloadspeeds)
	downloadspeedh := dlspeedstoh(downloadspeeds)
	if(txtprompt = "1"){							;.txt import active
		run explorer
		msgbox, Please select the .txt File in question
		Send {Enter}
		sleep 300
		packtxtreader("Episode")
	}
	else{											;.txt import inactive, instead manual download
		packmanualreader("Episode")
	}
	totdownloadspeeds := downloadspeeds*counter
	totdownloadspeedmin := downloadspeedmin*counter
	totdownloadspeedh := downloadspeedh*counter
	logprompt := confirmation("Log","Do you want to create a log before starting the download procedure?")
	if(logprompt = "1"){							;log will be created
		packlogwriter("Pre","will be",counter,"Episode",speed,size,downloadspeeds,downloadspeedmin,downloadspeedh,totdownloadspeeds,totdownloadspeedmin,totdownloadspeedh,shownum)
		reconsider := confirmation("Confirm","Do you want to proceed with the download (Yes)`ror do you want to re-enter your values? (No)")
		if(reconsider != "1"){						;chance to loop
			keeplog := confirmation("Keep log open?","Do you want to keep the log file open as reference?")
			if(keeplog != "1"){						;keeps log open
				Send !{F4}n
			}
			continue
		}
		else{										;ends loop,proceeds with download
			if(archivelogs = "1"){					;saves .txt file
				savedaytovar("filename")
				savetxtfile("C:\Users\Hermann\Downloads\XDCC",filename)
			}
			else{
				Send !{F4}n
			}
			break
		}
	}
	else{											;no log, loop definite end
		break
	}
}
msgBox, Please prepare mIRC for download
packdownloader("Episode",counter,downloadspeedms)
packlogwriter("Post","have been",counter,"Episode",speed,size,downloadspeeds,downloadspeedmin,downloadspeedh,totdownloadspeeds,totdownloadspeedmin,totdownloadspeedh,shownum)
sleep 200
if(archivelogs = "1"){								;Save log to folder
	savedaytovar("filename")
	savetxtfile("C:\Users\Hermann\Downloads\XDCC",filename)
}
else{												;Close log without saving
	Send !{F4}n
}
sleep 30000
navigatetodirectory("C:\Users\Hermann\Downloads\XDCC")
return
}
{		;numpad1		Title: Episode List Wikifinder		Function: Searches the episode list of a show on wikipedia via google.
numpad1::

inputBox, showname, Showname, Enter Name of the show,
Run firefox
WinWaitActive, Mozilla Firefox Start Page - Mozilla Firefox
Send List of %showname% episodes{Enter}
sleep 2500
waitforfirefox("C:\Program Files (x86)\AutoHotkey\reload.png")
sleep 500
Send {tab}{enter}
return
}
{		;numpad2		Title: Episode Renamer				Function: HK-patented Episode renamer in Episode x-Episodename Format with Copy&Paste Function
numpad2::

Send ^c
inputBox, episode, Episode Number, Enter Episode Number,
KeyWait, numpad3, D
send {F2}Episode %episode%-^v{Enter}
inputBox, newseries, Same series check, Type yes when you're not renaming the next episode or want to quit,
if(newseries = "y"||newseries = "Y"||||newseries = "Yes"||newseries = "YES"||newseries = "yes"||newseries = "true"||newseries = "True"||newseries = "t"||newseries = "TRUE"||newseries = "1"){
}
else{
	loop{
		episode++
		KeyWait, numpad2, D
		Send ^c
		keywait, numpad3, D
		send {F2}Episode %episode%-^v{Enter}
		inputBox, newseries, Same series check, Type yes when you're not renaming the next episode or want to quit,
		if(newseries = "y"||newseries = "Y"||||newseries = "Yes"||newseries = "YES"||newseries = "yes"||newseries = "true"||newseries = "True"||newseries = "t"||newseries = "TRUE"||newseries = "1"){
			break
		}
		else{
			continue
		}
	}
}
return
}
{		;numpad3		Title: Episode Renamer Support		Function: Has to stay blank for the sake of Episode Renamer
numpad3::
return
}
{		;numpad4		Title: Filenamecopier				Function: Saves a filename to the clipboard
numpad4::

send {F2}^c{Enter}
return
}
{		;numpad5		Title: Filenamepaster				Function: Pastes a filename from the closes
numpad5::

send {F2}^v{Enter}
Return
}
{		;numpad6		Title: 								Function:
numpad6::

return
}
{		;numpad7		Title: Anime Folder Icon Changer(1)	Function: Automatically changes an anime folder icon according to HK14.07 regulations
numpad7::
changesingleanimefoldericon()
return
}
{		;numpad8		Title: AniFolder+Icons Creator		Functon: Creates Anime (Revision HK14.07) Folders and applies Folder Icons
numpad8::

inputBox, showname, Showname, Please enter the name of the show,
inputBox, language, Language, What's the audio? `r(Subbed/Dubbed/Multi-Audio/Dual-Audio),
inputBox, quality, Quality, What's the Quality? `r(SD/SD+/720p/720p+/1080p/1080p+),
inputBox, seasons, Seasons, How many seasons?,
ova := confirmation("OVA","Are there OVAs? (y/n)")
special := confirmation("Specials","Are there Specials? (y/n)")
movie := confirmation("Movies","Are there Movies? (y/n)")
extra := confirmation("Extras","Are there Extras? (y/n)")
folders := confirmation("New Folders?","Do you want to create new Folders?")
if(folders = "1"){
	sleep 200
	newfolder()
	send %showname%
	Sleep 250
	Send {Enter}{Enter}
	sleep 250
	newfolder()
	Send Folder Icon{Enter}{Enter}
	Sleep 250
	Send !{up}
	Sleep 250
	newfolder()
	Send Season 1{Enter}{Enter}
	Sleep 250
	newfolder()
	Send %language% %quality%{Enter}
	Sleep 250
	Send !{up}
	Sleep 250
	season := seasons-1
	seasonno = 2
	if(season >= 1){
		loop %season%{
			newfolder()
			Send Season %seasonno%{Enter}{Enter}
			Sleep 250
			newfolder()
			Send %language% %quality%
			Sleep 250
			Send !{up}
			seasonno++
			Sleep 250
		}
	}
	if(ova = "1"){
		anifolder("OVA",language,quality)
	}
	if(special = "1"){
		anifolder("Specials",language,quality)
	}
	if(extra = "1"){
		anifolder("Extras",language,quality)
	}
	if(movie = "1"){
		anifolder("Movies",language,quality)
	}
	Send !{up}
}
stringlen, leng, language
lung := leng-1
stringtrimright, lang, language, %lung%
inputBox, confirm, Continue, Put the desired icons into the folder "Folder Icon" `rThen press Enter while selecting %showname% `r(Cancel with n)
if(confirm = "n"||confirm = "Cancel"||confirm = "cancel"||confirm = "CANCEL"||confirm = "false"||confirm = "no"||confirm = "No"||confirm = "NO"||confirm = "0"){
}	
else{
	sleep 250
	changesingleanimefoldericon()
	sleep 250
	ifWinExist, %showname%
	WinActivate
	sleep 200
	Send !d
	sleep 200
	Send {tab}{tab}{tab}f
	sleep 200
	changesingleanimefoldericon()
	sleep 250
	seano = 1
	loop %seasons%{
		sleep 250
		if(seasno = "1"){
			ifWinExist, %showname%
			WinActivate
			sleep 200
			Send !d
			sleep 250
			Send {tab}{tab}{tab}s{up}
		}
		send {down}
		sleep 100
		changesingleanimefoldericon()
		sleep 250
		ifWinExist, Season %seano%
		WinActivate
		sleep 200
		Send !d
		sleep 200
		send {tab}{tab}{tab}%lang%
		sleep 100
		changesingleanimefoldericon()
		sleep 500
		ifWinExist, %language% %quality%
		WinActivate
		sleep 200
		send !d
		sleep 200
		send !{up}
		seano++
	}
	if(special = "1"){
		anispecial(showname,"Specials",lang,language,quality)
	}
	if(ova = "1"){
		anispecial(showname,"OVA",lang,language,quality)
	}
	if(extra = "1"){
		anispecial(showname,"Extras",lang,language,quality)
	}
	if(movie = "1"){
		anispecial(showname,"Movies",lang,language,quality)
	}
	sleep 250
	Send !{up}
}
return
}
{		;numpad9		Title: Tester						Function: Currently used for various testing purposes
numpad9::
changesingleanimefoldericon()
return
}
{		;Capslock		Tilte: Caps Lock Disabler			Function: Disables Caps Lock
CapsLock::

Return
}
{		;Insert			Title: Insert Disabler				Function: Disables Insert
Insert::

If(stop = 1){
	stop = 0
}
else{
	stop = 1
}
Return
}



