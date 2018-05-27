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

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
{ 
;XDCC Downloader


numpad0::

inputBox, import, Import .txt?, Do you want to import a .txt file with bot/pack info?
if(import = "1"||import = "yes"||import = "Yes"||import = "YES"||import = "y"||import = "Y"||import = "true"||import = "True"||import = "TRUE")
	{
	importmode = 1
	}
if(importmode != "1")
	{
	inputbox, epnum , Number Of Episodes, Enter Number of Episodes to Download,
	}
inputbox, epsizmb , Length Of Episode, Enter approximate episode size in MB,
inputbox, dlspd , Connection Speed, Enter approximate download speed in kb/s,
epsizkb := epsizmb*1000
dllens := epsizkb/dlspd
dllen := dllens*1000
epindino = 1
if(importmode = "1")
	{
	run explorer
	msgBox, Please select the .txt file in question,
	Sleep 1000 ; ms
	Send {Enter}
	inputbox, botsame , Same bot?, Are all episodes from the same bot?,
	if(botsame = "1"||botsame = "yes"||botsame = "Yes"||botsame = "YES"||botsame = "y"||botsame = "Y"||botsame = "true"||botsame = "True"||botsame = "TRUE")
		{
		bot = 1
		}
	if(bot != "1")
		{
		inputbox, epnum , Number Of Episodes, Enter Number of Episodes to Download,
		}
	else
		{
		Sleep 500 ; ms
		Send +{down}^c
		sleep 500 ; ms
		pretxtsize1 = %clipboard%
		Stringlen, txtsize1, pretxtsize1
		alttxtsize1 := txtsize1-2
		sleep 200 ; ms
		Send ^a^c
		Sleep 500 ; ms
		pretxtsize2 = %clipboard%
		Stringlen, alttxtsize2, pretxtsize2
		txtsize2 := alttxtsize2+2
		epnum := txtsize2/txtsize1
		msgBox, epno: %epnum%
		loop %epnum%
			{
			Send {up}
			}
		loop %alttextsize1%
			{
			Send {left}
			}
		Sleep 200 ; ms
		}
	loop %epnum%
		{
		Send +{down}^c
		epi%epindino% = %clipboard%
		stringtrimright, ep%epindino%, epi%epindino%, 2
		Sleep 200 ; ms
		Send {right}{left}
		epindino++
		}
	send ^n
	msgBox, control,
	Sleep 300 ; ms
	epindino = 1
	loop %epnum%{
		episode := ep%epindino%
		Send {Raw}%episode%
		epindino++
		Send {Enter}
	}
	
	}
else
	{
	Loop, %epnum% {
		inputbox, ep%epindino% , Botinfo, Enter Pack and Bot %epindino%,
		epindino++
		}
	epindino = 1
	run notepad
	sleep 2000 ; ms
	Send The following has been input:{Enter}{Enter}
	loop %epnum%{
		episode := ep%epindino%
		Send {Raw}%episode%
		epindino++
		Send {Enter}
	}
	}
epinino = 1
inputbox, startbox, Ready to Start?, Press enter if all preparations are complete,
Sleep 3000 ; ms
Loop, %epnum% {
	episode := ep%epindino%
	Send {Raw}%episode%
	epindino++
	Send {Enter}
	Sleep 10000 ; ms
	Send ^n
	Sleep %dllen% ; ms
}
episode := ""
epindino = 1
run notepad
sleep 2000 ; ms
Send The following packs have been downloaded:{Enter}{Enter}
loop %epnum%{
	episode := ep%epindino%
	Send {Raw}%episode%
	epindino++
	Send {Enter}
}
Send {Enter}
dllenmin := dllens/60
totlens := dllens*epnum
totlenmin := dllenmin*epnum
Send Variables:{Enter}Download Speed: %dlspd% kB/s{Enter}Download Length: %dllenmin% min (%dllens% s){Enter}Total Download Length: %totlenmin% min (%totlens% s){Enter}Number of Episodes: %epnum%
return
}

{
;Episode List Wikifinder


numpad1::

InputBox, show , Showname, Enter Showname,
Run firefox
Sleep 3000 ; ms
Send List of %show% episodes {Enter}
Sleep 2000 ; ms
InputBox, finished , Wikicheck, Press the Enter key when the Google Search is finished,
Send {tab}{enter}
return
}

{
;Copy Hotkey


numpad2::

Send ^c
return
}

{
;Episode Rename Script


numpad3::

InputBox, episode , Episode #, Enter Episode Number,
send {F2}Episode %episode%-^v{enter}
return
}

{
;Copy Renamer


numpad4::

send {F2}^c{Enter}
return


}
{
;Paste Renamer


numpad5::

send {F2}^v{Enter}
return

}
{
;Change Folder Icon Hotkey


numpad7::

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
Sleep 250 ; ms
Send {F2}^c{Enter}
sleep 800 ; ms
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
if (tempstorage1 = "Folder Icon")
	{
		Send [.ShellClassInfo]{Enter}
		Send {Raw}IconResource=Folder.ico,0
		Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Pictures{Enter}
		lastfolder = 1
	}
else if (length = 8)
	{
	stringtrimright, tempstorage2, tempstorage1, 2
	}
else
	{
	Stringtrimright, tempstorage2, tempstorage1, 3
	}
if (tempstorage2 = "Season")
	{
	stringtrimleft, seasonnumber, tempstorage1, 7
	if(seasonnumber = "1")
		{
			Send [.ShellClassInfo]{Enter}
			Send {Raw}IconResource=..\Folder Icon\main.ico,0
			Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Videos{Enter}
			lastfolder = 0
		}
	else
		{
			Send [.ShellClassInfo]{Enter}
			Send {Raw}IconResource=..\Folder Icon\%tempstorage1%.ico,0
			Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Videos{Enter}
			lastfolder = 0
		}
	}
else
	{
	stringtrimleft, tempstorage3, tempstorage1, %minuslength%
		if (tempstorage3 = "+")
		{
		tempstorage4 = %tempstorage1%
		stringtrimright, tempstorage1, tempstorage4, 1
		edited = 1
		}
	}
if(tempstorage1 = "Dual-Audio SD"||tempstorage1 = "Dual-Audio 720p"||tempstorage1 = "Dual-Audio 1080p"||tempstorage1 = "Multi-Audio SD"||tempstorage1 = "Multi-Audio 720p"||tempstorage1 = "Multi-Audio 1080p"||tempstorage1 = "Subbed SD"||tempstorage1 = "Subbed 720p"||tempstorage1 = "Subbed 1080p"||tempstorage1 = "Dubbed SD"||tempstorage1 = "Dubbed 720p"||tempstorage1 = "Dubbed 1080p")
	{
		Send [.ShellClassInfo]{Enter}
		Send {Raw}IconResource=..\..\Folder Icon\%tempstorage1%.ico,0
		Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Videos{Enter}
		lastfolder = 1
	}
else if(tempstorage1 = "Movies"||tempstorage1 = "Specials"||tempstorage1 = "Extras"||tempstorage1 = "OVA")
	{
		Send [.ShellClassInfo]{Enter}
		Send {Raw}IconResource=..\Folder Icon\%tempstorage1%.ico,0
		Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Videos{Enter}
		lastfolder = 0
	}
else if(tempstorage1 = "Folder Icon"||tempstorage2 = "Season")
	{
	}
else
	{
		Send [.ShellClassInfo]{Enter}
		Send {Raw}IconResource=Folder Icon\main.ico,0
		Send {Enter}[ViewState]{Enter}Mode={Enter}Vid={Enter}FolderType=Videos{Enter}
		lastfolder = 0
	}
Sleep 300 ; ms
Send ^s
Sleep 300 ; ms
Send !{F4}
if(lastfolder = "1")
	{
	if (edited = "1")
		{
		ifWinExist, {raw}%tempstorage1%+
		WinActivate
		}
	else 
		{
		ifWinExist, %tempstorage1%
		WinActivate
		}
	sleep 250 ; ms
	Send !d
	sleep 250 ; ms
	Send !{up}
	}
else
	{
	}
;}
Return

}

;Anime Icon Master Code

numpad8::

inputBox, showname, Showname, Please enter the name of the show,
inputBox, language, Language, What's the audio `r(Subbed/Dubbed/Multi-Audio/Dual-Audio)?,
inputBox, quality, Quality, What's the Quality? `r(SD/SD+/720p/720p+/1080p/1080p+),
inputBox, ova, OVA, Are there OVAs? (y/n),
inputBox, special, Specials, Are there Specials? (y/n),
inputBox, movie, Movies, Are there Movies? (y/n),
inputBox, extra, Extras, Are there Extras? (y/n),
inputBox, seasons, Seasons, How many seasons?,
inputBox, folders, New Folder?, Do you want to create new Folders?,
if(folders = "y"||folders = "yes"||folders = "Yes"||folders = "YES"||folders = "1"||folders = "True"||folders = "true"||folders = "TRUE")
{
Sleep 200 ; ms
Send ^+n
Sleep 350 ; ms
Send %showname%{Enter}{Enter}
Sleep 350 ; ms
Send ^+n
Sleep 250 ; ms
Send Folder Icon{Enter}{Enter}
Sleep 250 ; ms
Send!{up}
Sleep 250 ; ms
Send ^+n
Sleep 250 ; ms
Send Season 1{Enter}{Enter}
Sleep 250 ; ms
Send ^+n
Sleep 250 ; ms
Send %language% %quality%{Enter}
Sleep 250 ; ms
Send!{up}
Sleep 250 ; ms
season := seasons-1
seasonno = 2
if season >= 1
	{
		loop %season%{
			Send ^+n
			Sleep 250 ; ms
			Send Season %seasonno%{Enter}{Enter}
			Sleep 250 ; ms
			Send ^+n
			Sleep 250 ; ms
			Send %language% %quality%{Enter}
			Sleep 250 ; ms
			Send!{up}
			seasonno++
			Sleep 250 ; ms
		}
	}
if(ova = "y"||ova = "yes"||ova = "Yes"||ova = "YES"||ova = "1"||ova = "True")
	{
			ova = 1
			Send ^+n
			Sleep 250 ; ms
			Send OVA{Enter}{Enter}
			Sleep 250 ; ms
			Send ^+n
			Sleep 250 ; ms
			Send %language% %quality%{Enter}
			Sleep 250 ; ms
			Send!{up}
			Sleep 250 ; ms
	}
if(extra = "y"||extra = "yes"||extra = "Yes"||extra = "YES"||extra = "1"||extra = "True")
	{
			extra = 1
			Send ^+n
			Sleep 250 ; ms
			Send Extras{Enter}{Enter}
			Sleep 250 ; ms
			Send ^+n
			Sleep 250 ; ms
			Send %language% %quality%{Enter}
			Sleep 250 ; ms
			Send!{up}
			Sleep 250 ; ms
	}
if(special = "y"||special = "yes"||special = "Yes"||special = "YES"||special = "1"||special = "True")
	{
			special = 1
			Send ^+n
			Sleep 250 ; ms
			Send Specials{Enter}{Enter}
			Sleep 250 ; ms
			Send ^+n
			Sleep 250 ; ms
			Send %language% %quality%{Enter}
			Sleep 250 ; ms
			Send!{up}
			Sleep 250 ; ms
	}
if(movie = "y"||movie = "yes"||movie = "Yes"||movie = "YES"||movie = "1"||movie = "True")
	{
			movie = 1
			Send ^+n
			Sleep 250 ; ms
			Send Movies{Enter}{Enter}
			Sleep 250 ; ms
			Send ^+n
			Sleep 250 ; ms
			Send %language% %quality%{Enter}
			Sleep 400 ; ms
			Send!{up}
			Sleep 250 ; ms
	}
Send !{up}
}
StringLen, leng, language
lung := leng-1
stringtrimright, lang, language, %lung%
inputBox, confirm, Continue, Put the desired icons into the folder "Folder Icon" `rThen press Enter while selecting %showname% `r(Cancel with n)
if(confirm = "n"||confirm = "Cancel"||confirm = "cancel"||confirm = "CANCEL"||confirm = "false"||confirm = "no"||confirm = "No"||confirm = "NO"||confirm = "0")
	{
	}
else
	{
		Sleep 250 ; ms
		send {numpad7}
		sleep 250 ; ms
		ifWinExist, %showname%
		WinActivate
		Sleep 200 ; ms
		Send !d
		sleep 200 ; ms
		Send {tab}{tab}{tab}f
		sleep 100 ; ms
		send {numpad7}
		seano = 1
		loop %seasons%{
				Sleep 250 ; ms
				if(seano = "1")
					{
					ifWinExist, %showname%
					WinActivate
					Sleep 200 ; ms
					Send !d
					sleep 200 ; ms
					Send {tab}{tab}{tab}s{up}
					}
				Send {down}
				Sleep 100 ; ms
				Send {numpad7}
				sleep 250 ; ms
				ifWinExist, Season %seano%
				WinActivate
				Sleep 200 ; ms
				Send !d
				sleep 200 ; ms
				Send {tab}{tab}{tab}%lang%
				sleep 100 ; ms
				Send {numpad7}
				Sleep 500 ; ms
				ifWinExist, Season %language% %quality%
				WinActivate
				Sleep 200 ; ms
				Send !d
				Sleep 200 ; ms
				Send !{up}
				seano++
			}
		if(special = "1")
			{
				Sleep 250 ; ms
				Send {down}
				Sleep 100 ; ms
				Send {numpad7}
				sleep 250 ; ms
				ifWinExist, Specials
				WinActivate
				Sleep 200 ; ms
				Send !d
				sleep 200 ; ms
				Send {tab}{tab}{tab}%lang%
				sleep 100 ; ms
				Send {numpad7}
				Sleep 500 ; ms
				ifWinExist, Season %language% %quality%
				WinActivate
				Sleep 200 ; ms
				Send !d
				Sleep 200 ; ms
				Send !{up}
			}
		if(ova = "1")
			{
				Sleep 250 ; ms
				ifWinExist, %showname%
				WinActivate
				Sleep 200 ; ms
				Send !d
				sleep 200 ; ms
				Send {tab}{tab}{tab}o
				Sleep 100 ; ms
				
				
				Send {numpad7}
				sleep 250 ; ms
				ifWinExist, OVA
				WinActivate
				Sleep 200 ; ms
				Send !d
				sleep 200 ; ms
				Send {tab}{tab}{tab}%lang%
				sleep 100 ; ms
				Send {numpad7}
				Sleep 500 ; ms
				ifWinExist, Season %language% %quality%
				WinActivate
				Sleep 200 ; ms
				Send !d
				Sleep 200 ; ms
				Send !{up}
			}
		if(extra = "1")
			{
				Sleep 250 ; ms
				ifWinExist, %showname%
				WinActivate
				Sleep 200 ; ms
				Send !d
				sleep 200 ; ms
				Send {tab}{tab}{tab}e
				Sleep 100 ; ms
				Send {numpad7}
				sleep 250 ; ms
				ifWinExist, Extras
				WinActivate
				Sleep 200 ; ms
				Send !d
				sleep 200 ; ms
				Send {tab}{tab}{tab}%lang%
				sleep 100 ; ms
				Send {numpad7}
				Sleep 500 ; ms
				ifWinExist, Season %language% %quality%
				WinActivate
				Sleep 200 ; ms
				Send !d
				Sleep 200 ; ms
				Send !{up}
			}
		if(movie = "1")
			{
				Sleep 250 ; ms
				ifWinExist, %showname%
				WinActivate
				Sleep 200 ; ms
				Send !d
				sleep 200 ; ms
				Send {tab}{tab}{tab}m
				Sleep 100 ; ms
				Send {numpad7}
				sleep 250 ; ms
				ifWinExist, Movies
				WinActivate
				Sleep 200 ; ms
				Send !d
				sleep 200 ; ms
				Send {tab}{tab}{tab}%lang%
				sleep 100 ; ms
				Send {numpad7}
				Sleep 500 ; ms
				ifWinExist, Season %language% %quality%
				WinActivate
				Sleep 200 ; ms
				Send !d
				Sleep 200 ; ms
				Send !{up}
			}
		Sleep 250 ; ms
		Send !{up}
	}
return



;Keymap


numpad9::

run notepad
sleep 2000 ; ms
Send Numpad0:{tab}XDCC Downloader{Enter}
Send Numpad1:{tab}Wikipedia Episode Searcher{Enter}
Send Numpad2:{tab}Copy Hotkey{Enter}
Send Numpad3:{tab}Paste Episode Name Hotkey{Enter}
Send Numpad4:{tab}Copy Filename{Enter}
Send Numpad5:{tab}Paste Filename{Enter}
Send Numpad6:{tab}{Enter}
Send Numpad7:{tab}Iconscript{Enter}
Send Numpad8:{tab}Ultimate Anime Folder Creator and Icon Customizer{Enter}
Send Numpad9:{tab}Keymap{Enter}
return


