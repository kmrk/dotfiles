#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

; C-[
^[::
Send ^+9
Send {Esc}
Return

; C-\
^\::
Send ^+0
Return
