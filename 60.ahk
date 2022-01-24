#NoEnv  
SendMode Input  
SetWorkingDir %A_ScriptDir%  

; Capslock
CapsLock::
KeyWait, CapsLock
KeyWait, CapsLock, D T0.2
if ((ErrorLevel = 0) && (A_PriorKey = "CapsLock") )
{
SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"
}
return

CapsLock & W::Up
CapsLock & A::Left
CapsLock & S::Down
CapsLock & D::Right

CapsLock & C:: Send {Volume_Up}
CapsLock & X:: Send {Volume_Down}
CapsLock & Z::Send {Volume_Mute}

CapsLock & U::send, {PgUp down}{PgUp up}
CapsLock & J::send, {PgDn down}{PgDn up}
CapsLock & I::send, {Home down}{Home up}
CapsLock & K::send, {End down}{End up}

CapsLock & 1::send, {F1}
CapsLock & 2::send, {F2}
CapsLock & 3::send, {F3}
CapsLock & 4::send, {F4}
CapsLock & 5::send, {F5}
CapsLock & 6::send, {F6}
CapsLock & 7::send, {F7}
CapsLock & 8::send, {F8}
CapsLock & 9::send, {F9}
CapsLock & 0::send, {F10}
CapsLock & -::send, {F11}
CapsLock & =::send, {F12}

CapsLock & Q::
  AdjustScreenBrightness(-10)
  Return
  
CapsLock & E::
  AdjustScreenBrightness(10)
  Return
  
AdjustScreenBrightness(step) {
    service := "winmgmts:{impersonationLevel=impersonate}!\\.\root\WMI"
    monitors := ComObjGet(service).ExecQuery("SELECT * FROM WmiMonitorBrightness WHERE Active=TRUE")
    monMethods := ComObjGet(service).ExecQuery("SELECT * FROM wmiMonitorBrightNessMethods WHERE Active=TRUE")
    minBrightness := 5  ; level below this is identical to this

    for i in monitors {
        curt := i.CurrentBrightness
        break
    }
    if (curt < minBrightness)  ; parenthesis is necessary here
        curt := minBrightness
    toSet := curt + step
    if (toSet > 100)
        return
    if (toSet < minBrightness)
        toSet := minBrightness
    for i in monMethods {
        i.WmiSetBrightness(1, toSet)
        break
    }
}

