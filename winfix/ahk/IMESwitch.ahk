#Requires AutoHotkey v2.0
#SingleInstance Force

SetWorkingDir(A_ScriptDir)


CapsLock::Ctrl

PrintScreen::LWin

LWin::LAlt


~^[::
{ 
    Send("{Blind}^+9")
}

^\:: 
{
    Send("{Blind}^+8")     
}   

~^s:: 
{
    Send("{Blind}^+9")
    Send("{Esc}")
}