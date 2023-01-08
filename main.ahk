#Requires AutoHotkey v2.0
debug := false
^c::ExitApp
^s:: Flow()

Flow(){
    doProcess := {
    }

    ; Trigger attribute
    tiggerName := ""
    triggerReplace := ""
    triggerProcess := ""

    Loop Files, "process\*.*", "D"  ; Recurse into subfolders.
    {
        doProcess.%A_LoopFileShortName% := {
            name: A_LoopFileShortName,
            img : A_LoopFileFullPath "\img.png",
            exec : A_LoopFileFullPath "\process.exe",
            conf : A_LoopFileFullPath "\conf.ini",
        }
    }

    LOOP{
        Sleep 200

        processObj := ""

        ; search where the process we are
        For key, obj in doProcess.OwnProps() {
            if SearchImage(&FoundX, &FoundY, obj.img){
                if (tiggerName != obj.name){
                    processObj := obj
                    break
                }
            }
        }

        ; we are in the process we defined, then doing the exec
        if IsObject(processObj){
            try{
                triggerReplace := IniRead(processObj.conf, "trigger", "replace")
                if (triggerReplace != ""){
                    tiggerName := processObj.name
                    triggerProcess := processObj
                }
                
            }catch{

            }

            if (triggerReplace == processObj.name){
                RunWait triggerProcess.exec
                triggerProcess := ""
                triggerReplace := ""
                tiggerName := ""
            }else{
                try{
                    if (tiggerName != processObj.name){
                        RunWait processObj.exec
                    }
                }catch{
                    MsgBox "ERROR"
                }
            }
        } else{
            RunWait doProcess.default.exec
        }
    }
}

ClickImage(img, count := 1){
    if SearchImage(&FoundX, &FoundY, img, 2)
        Click FoundX, FoundY, count
}

SearchImage(&FoundX, &FoundY, img, variation := 32) {
    CoordMode "Pixel" ; Interprets the coordinates below as relative to the screen rather than the active window.
    try
    {
        if ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" variation " " img)
            return 1
        return 0
    }
    catch as exc{
        if debug
            MsgBox "Could not conduct the search due to the following error:`n" exc.Message
    }
    else{
    }
    finally
    {
    }
}
