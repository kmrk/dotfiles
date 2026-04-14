#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)


; 快捷键：Ctrl + [
^[::
{
    Send("{Blind}^+9")
    Send("{Esc}")
}

; 快捷键：Ctrl + \
^\::
{
    Send("{Blind}^+8")
}
