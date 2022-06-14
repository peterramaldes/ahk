setmousedelay 0 
setbatchlines 0

global WIN_TITLE := "Ranger's Arcani - Mofaia"

CoordMode, Pixel, Screen
Loop,
{ 
	if WinActive(WIN_TITLE)
	{
		mana_check_color := 0x000000
		pos_start_x := 1118
		pos_start_y := 935		

		Start:
		PixelGetColor, mana_color, %pos_start_x%, %pos_start_y%, RGB
 		if (mana_color == mana_check_color)
 		{
 			Send, {F1}
 			Sleep, 200
 			Goto, Start						
 		} 

	}
}
return

F12::exitapp
ScrollLock::Pause
