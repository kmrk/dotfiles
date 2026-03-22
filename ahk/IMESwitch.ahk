#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

; 使用 $ 强制使用物理钩子，避免逻辑循环
; 使用 * 允许即使你额外按了其他键也能触发（更灵敏）

$^[::
    ; 使用 {Blind} 模式可以更稳定地处理修饰键
    Send ^+9
    Sleep 20
    Send {Esc}
Return

$^\::
    Send ^+8
    ; 如果这个也需要 Esc，可以加上：Send {Esc}
Return
