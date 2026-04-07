#Requires AutoHotkey v2.0
#SingleInstance Force

SetWorkingDir(A_ScriptDir)

; 使用 $ 强制使用物理钩子
; 使用 * 允许组合修饰键触发

; 快捷键：Ctrl + [
$*^[::
{
    ; v2 中 Send 是函数，字符串需加双引号
    ; {Blind} 模式在 v2 中依然有效，能更稳定地处理修饰键状态
    Send("{Blind}^+9")
    Sleep(20)
    Send("{Esc}")
}

; 快捷键：Ctrl + \
$*^\::
{
    Send("{Blind}^+8")
    ; 如果你需要 Esc，可以取消下面一行的注释
    ; Send("{Esc}")
}