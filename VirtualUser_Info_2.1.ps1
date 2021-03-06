<#
#	Author: 		Uenes Ferreira
#	Date: 			04/12/2015
#	Description:	Login on Info and navigate through it. If it has any error or delay too big, it stops and open a popup message.
#	Version:		1.2
#>

############# FUNCTIONS #############
function ClickOnMainMenu ($MenuId) {
    $MenuLinks = $doc.getElementById($MenuId).getElementsByTagName("a")
    foreach ($menulink in $menulinks) {
        $menulink.click()
    }
}

function waitingGetReady () {
    $seconds = 0
    while($ie.ReadyState -ne 4) {
        start-sleep -s 1
        $seconds++
    }
    return $seconds
}

function delayTooBig ($seconds) {
    $wshell = New-Object -ComObject Wscript.shell
    $wshell.popup("INFO: Delay of $seconds seconds",0,"Warning",0x1)
}

############# MAIN CODE #############
$IE = new-object -com internetexplorer.application

#openBrowser $server
$IE.navigate2("https://URL")

try {
    $IE.visible=$true
    while($ie.busy) {start-sleep -s 1}

    $doc = $IE.Document
    $username = $doc.getElementById("username")

    if ($username -ne $null) {
        $doc.getElementById("username").value = "username"
        $doc.getElementById("password").value = "pass"
        $LoginButton = $doc.getElementsByName("signIn")

        ForEach ($Login in $LoginButton) {
            $Login.click()
        }
    }
    while($ie.busy) {start-sleep -s 1}
    
    $MainMenus = "mainmenuNWS","mainmenuENT","mainmenuBIO","mainmenuMDL","mainmenuENT","mainmenuSPORTS","mainmenuREC","mainmenuTRA","mainmenuWEA","mainmenuCER","mainmenuGEN"

    while ($true) {
        foreach ($MainMenu in $MainMenus) {
            ClickOnMainMenu $MainMenu
            $secondsWaiting = waitingGetReady
            if ($secondsWaiting -gt 20 ) {delayTooBig($secondsWaiting)}
        }
    }
} catch {
    $wshell = New-Object -ComObject Wscript.shell
    $wshell.popup("INFO: Navigation failed!",0,"Error",0x1)
}
