#Requires AutoHotkey v2.0
debug := false
^x::ExitApp
^a:: Flow()

Flow(){
    doProcess := {
    }

    Loop Files, "process\*.*", "D"  ; Recurse into subfolders.
    {
        doProcess.%A_LoopFileName% := {
            img : A_LoopFileFullPath "\img.png",
            exec : A_LoopFileFullPath "\process.exe",
        }
    }

    LOOP{
        Sleep 2000

        processObj := ""

        ; search where the process we are
        For key, obj in doProcess.OwnProps() {
            if SearchImage(&FoundX, &FoundY, obj.img){
                processObj := obj
                break
            }
        }

        ; we are in the process we defined, then doing the exec
        if IsObject(processObj){
            RunWait processObj.exec
        }
    }
}

ClickImage(img, count := 1){
    if SearchImage(&FoundX, &FoundY, img, 2)
        Click FoundX, FoundY, count
}

SearchImage(&FoundX, &FoundY, img, variation := 2) {
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
