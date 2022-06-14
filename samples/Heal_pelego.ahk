#NoEnv
#Persistent
#SingleInstance force
SetBatchLines, -1

;-------
;Hotkeys
;-------
global full_bean_hotkey :=  "{F2}"
global half_bean_hotkey := "{F2}"
global heal_spell_hotkey := "{F1}"
;-----------
;Coordinates
;-----------
global hp_bar_x_beg := 845
global hp_bar_x_end := 948
global ki_bar_x_beg := 980
global ki_bar_x_end := 1088
global hp_y := 947 ;original 947
global ki_y := 947
;----------
;Thresholds
;----------
global heal_spell_threshold := .96 ; 1 = 90% - you can go lower, but not higher.
global half_bean_threshold := .40 ; % 
global full_bean_threshold := .40 ; %
global ki_threshold := .1 ; 5%
	
global hp_color_variation := 20
global ki_color_variation := 6
global spell_timeout := 150
global wintitle := "Return Of The Saiyans"

;------------------------------------------
;Dont edit below this line
;------------------------------------------
;From Timer.ahk
Timer(Timer_Name := "", Timer_Opt := "D")
{
	static
	global Timer, Timer_Count
	if !Timer
		Timer := {}
	if (Timer_Opt = "U" or Timer_Opt = "Unset")
		if IsObject(Timer[Timer_Name])
		{
			Timer.Remove(Timer_Name)
			Timer_Count --=
			return true
		}
		else
			return false
	if RegExMatch(Timer_Opt,"(\d+)",Timer_Match)
	{
		if !(Timer[Timer_Name,"Start"])
			Timer_Count += 1
		Timer[Timer_Name,"Start"] := A_TickCount
		Timer[Timer_Name,"Finish"] := A_TickCount + Timer_Match1
		Timer[Timer_Name,"Period"] := Timer_Match1
	}
	if RegExMatch(Timer_Opt,"(\D+)",Timer_Match)
		Timer_Opt := Timer_Match1
	else
		Timer_Opt := "D"
	if (Timer_Name = "")
	{
		for index, element in Timer
			Timer(index)
		return
	}
	if (Timer_Opt = "R" or Timer_Opt = "Reset")
	{
		Timer[Timer_Name,"Start"] := A_TickCount
		Timer[Timer_Name,"Finish"] := A_TickCount + Timer[Timer_Name,"Period"]
	}
	Timer[Timer_Name,"Now"] := A_TickCount
	Timer[Timer_Name,"Left"] := Timer[Timer_Name,"Finish"] - Timer[Timer_Name,"Now"]
	Timer[Timer_Name,"Elapse"] := Timer[Timer_Name,"Now"] - Timer[Timer_Name,"Start"]
	Timer[Timer_Name,"Done"] := true
	if (Timer[Timer_Name,"Left"] > 0)
		Timer[Timer_Name,"Done"] := false
	if (Timer_Opt = "D" or Timer_Opt = "Done")
		return Timer[Timer_Name,"Done"]
	if (Timer_Opt = "S" or Timer_Opt = "Start")
		return Timer[Timer_Name,"Start"]
	if (Timer_Opt = "F" or Timer_Opt = "Finish")
		return Timer[Timer_Name,"Finish"]
	if (Timer_Opt = "L" or Timer_Opt = "Left")
		return Timer[Timer_Name,"Left"]
	if (Timer_Opt = "N" or Timer_Opt = "Now")
		return Timer[Timer_Name,"Now"]
	if (Timer_Opt = "P" or Timer_Opt = "Period")
		return Timer[Timer_Name,"Period"]
	if (Timer_Opt = "E" or Timer_Opt = "Elapse")
		return Timer[Timer_Name,"Elapse"]
}

Full_Bean()
{
    If Timer("Full_Bean")
    {   
        ControlSend,, %full_bean_hotkey%, %wintitle%

        Timer("Full_Bean", 500) ;Full bean cooldown
    }
    Return
}

full_spell()
{
	 If Timer("Full_Bean")
    {        
        ControlSend,, %full_bean_hotkey%, %wintitle%

		hp_bar_x := round(hp_bar_x_end + full_bean_threshold * (hp_bar_x_beg - hp_bar_x_end))

		PixelGetColor, cfound, %hp_bar_x%, %hp_y%, RGB
		If IsColorInRange(cfound, 0x553838, hp_color_variation)
		{
			ControlSend,, %full_bean_hotkey%, %wintitle%
			Heal_Spell()
			return
		}

		Timer("Full_Bean", 500) ;Half bean cooldown
		Heal_Spell()
    }
    Return
}

half_spell()
{
	 If Timer("Half_Bean")
    {        
        ControlSend,, %half_bean_hotkey%, %wintitle%

		hp_bar_x := round(hp_bar_x_end + half_bean_threshold * (hp_bar_x_beg - hp_bar_x_end))

		PixelGetColor, cfound, %hp_bar_x%, %hp_y%, RGB
		If IsColorInRange(cfound, 0x553838, hp_color_variation)
		{
			ControlSend,, %half_bean_hotkey%, %wintitle%
			Heal_Spell()
			return
		}

		Timer("Half_Bean", 500) ;Half bean cooldown
		Heal_Spell()
		
    }
    Return
}

Half_Bean() 
{ 
    If Timer("Half_Bean")
    { 
		ControlSend,, %half_bean_hotkey%, %wintitle%
		hp_bar_x := round(hp_bar_x_end + half_bean_threshold * (hp_bar_x_beg - hp_bar_x_end))

		PixelGetColor, cfound, %hp_bar_x%, %hp_y%, RGB
		If IsColorInRange(cfound, 0x553838, hp_color_variation)
		{
			ControlSend,, %half_bean_hotkey%, %wintitle%
		}       
        
        Timer("Half_Bean", 500) ;Half bean cooldown
    }
    Return
}

Heal_Spell()   
{
    If Timer("Heal_Spell")
	{
		ControlSend,, %heal_spell_hotkey%, %wintitle%

		hp_bar_x := round(hp_bar_x_end + heal_spell_threshold * (hp_bar_x_beg - hp_bar_x_end))

		PixelGetColor, cfound, %hp_bar_x%, %hp_y%, RGB
		If IsColorInRange(cfound, 0x553838, hp_color_variation)
		{
			ControlSend,, %heal_spell_hotkey%, %wintitle%
			return
		}
		
        
        Timer("Heal_Spell", 500) ;Spell cooldown
	}
    Return
}

heal() {
	global full_bean_threshold, half_bean_threshold, heal_spell_threshold, ki_threshold
    return check_hp_threshold(full_bean_threshold, 1) or check_hp_threshold(half_bean_threshold, 2) or check_ki_threshold(ki_threshold) or check_hp_threshold(heal_spell_threshold, 3)
}

check_hp_threshold(byRef threshold, byRef key) 
{
	global hp_bar_beg, hp_bar_x_end, hp_y, hp_color_variation
	
	hp_bar_x := round(hp_bar_x_end + threshold * (hp_bar_x_beg - hp_bar_x_end))

    PixelGetColor, cfound, %hp_bar_x%, %hp_y%, RGB
	If IsColorInRange(cfound, 0x553838, hp_color_variation)
    {
		;MsgBox, (key)
        If ((key) = 1)
		{
			full_spell()
			return True
		}	
		Else If ((key) = 2)
		{	
			half_spell()
			return True
		}
		Else If ((key) = 3)
		{
			Heal_Spell()
			return True
		}
    }

    return False
}

check_ki_threshold(byRef threshold)
{
	ki_bar_x := round(ki_bar_x_beg + threshold * (ki_bar_x_end - ki_bar_x_beg))

	PixelGetColor, cfound, %ki_bar_x%, %ki_y%, RGB
	If IsColorInRange(cfound, 0x354459, ki_color_variation)
    {	
		Half_Bean()
        return True
    }

    return False
}

IsColorInRange(cTest, cComp, Range)
{
  return (Abs((cTest     & 0xFF) - ( cComp        & 0xFF)) <= Range
  &&  Abs(((cTest >> 8)  & 0xFF) - ((cComp >> 8)  & 0xFF)) <= Range
  &&  Abs(((cTest >> 16) & 0xFF) - ((cComp >> 16) & 0xFF)) <= Range)
}


Loop 
{
	if WinExist(wintitle)
	{
        if WinActive(wintitle)
		    heal()
	}
}

Pause::Pause, Toggle