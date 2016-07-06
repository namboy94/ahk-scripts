{ ;Autohotkey File Utilities
	;This Script allows various file actions
}

{ ;Parameters
#NoEnv
SendMode Input
SetWorkingDir C:\
SetFormat, float, 0.2 
}


{ ;List of global Variables

	;webcopy
	
}

{ ;Functions
}

{ ;File Directory Function																										;defines all Windows directories used in the script for easy editing	
filedirectory(){
	
}
}
{ ;Copy web																														;Copies filename from Wikipedia, TVDB etc. and prompts for an episode number
copyweb(){
	
	global webcopy = 																											;Initializes variable webcopy as global
	clipboard =																													;Empties Clipboard
	send ^c																														;Copies episode name
	clipwait																													;Waits for clipboard to be filled
	webcopy = %clipboard%																										;Saves clipboard to local variable webcopy
	StringReplace, webcopy,webcopy,", , All																						;";Removes all "
	inputbox, episode, Episode Number, Enter Episode Number																		;Prompts for episode number and saves it to variable "episode"
	KeyWait, numpad3, D																											;Pauses script until numpad3 is pressed down
	send {f2}Episode %episode%-																									;Renames selected File
	send {raw}%webcopy%
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
			send {f2}Episode %episode%-																							;Renames selected File
			send {raw}%webcopy%
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


{ ;Keybinds
}

{ ;Episode Renamer																												;Manual file renamer with prfix Episode x-
numpad2::

copyweb()

return

}
{ ;Filecopypaster																												;Copies and pastest filenames
home::

filecopyer()
KeyWait, insert, D
filepaster()
	

return

}






















