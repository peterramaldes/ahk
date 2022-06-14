setmousedelay 0 
setbatchlines 0

CoordMode, Pixel, Screen
Loop,
{ 
	if WinActive("ahk_exe Ranger's Arcani")
	{
		a1 := 114
		b1 := 94

		HealY:= 457

		color := 0
		
		Porc1:= 40
		pot1:= (((Porc1*(b1-a1))/100)+a1)
		checkcolor1:= 0x111419

		Porc2:= 70
		pot2:= (((Porc2*(b1-a1))/100)+a1)
		checkcolor2:= 0xfa4d53
		
		
		startcheckcolor:= 0xfed330
		posstartx:= 760
		posstarty:= 544
		
		check1:
		PixelGetColor, Checkstart, %posstartx%, %posstarty%, RGB
		if (Checkstart == startcheckcolor)
		{
			PixelGetColor, Check1, %pot2%, %HealY%, RGB
			if (Check1 != checkcolor1)
			{			
				PixelGetColor, Check1, %pot1%, %HealY%, RGB
					if (Check1 != checkcolor1)
					{
						send, {v}
						Sleep, 100
						Send, r
						Sleep, 200
						send, {Rbutton}
						goto, check1						
					}
					
				send, {Rbutton}
				Sleep, 100
				;send, {F4}
				;Sleep, 100
				;send, {F5}
				;Sleep, 100
			}
		}
	}
}
return

F12::exitapp
Pause::Pause
