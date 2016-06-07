#include <ImageSearch.au3>
#include <Tesseract.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GuiConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\Users\Nicolas\Desktop\koda autoit gui\Forms\Deck Heroes Helper.kxf
$Form1 = GUICreate("Deck Heroes Helper", 583, 450, 192, 124)
$mainTabs = GUICtrlCreateTab(0, 0, 585, 457)
$tabRaids = GUICtrlCreateTabItem("Raids")
$grpBasic = GUICtrlCreateGroup("Basic Values", 8, 24, 569, 105)
$txtMinGlory = GUICtrlCreateInput("", 112, 48, 89, 21)
GUICtrlSetTip(-1, "Minimum value to find while searching")
$Label1 = GUICtrlCreateLabel("Minimum Glory:", 16, 48, 95, 20, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$chkAutoAttack = GUICtrlCreateCheckbox("Auto Attack", 208, 40, 97, 33)
GUICtrlSetFont(-1, 11, 400, 0, "MS Sans Serif")
$Label5 = GUICtrlCreateLabel("Decrease searching by:", 16, 96, 147, 20, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Input1 = GUICtrlCreateInput("", 168, 96, 57, 21)
$Label6 = GUICtrlCreateLabel("after", 227, 97, 30, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label7 = GUICtrlCreateLabel("searches, to a minimum of", 310, 98, 158, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Input2 = GUICtrlCreateInput("", 258, 98, 49, 21)
$chkEnableDecrease = GUICtrlCreateCheckbox("Enable Decreasing glory", 18, 70, 177, 25)
GUICtrlSetFont(-1, 11, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "Make sure to have a team that can auto everything")
$Input3 = GUICtrlCreateInput("", 470, 98, 49, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$grpAdvanced = GUICtrlCreateGroup("Advanced Values", 7, 135, 569, 105)
$txtSearchInterval = GUICtrlCreateInput("Input1", 127, 159, 89, 21)
$Label2 = GUICtrlCreateLabel("Search Interval:", 15, 159, 96, 20, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$btnSearchRaid = GUICtrlCreateButton("Start Searching", 464, 400, 107, 33)
$Label3 = GUICtrlCreateLabel("To stop searching, press ESC button", 8, 408, 177, 17)
$txtConsole = GUICtrlCreateEdit("", 8, 256, 569, 129)
GUICtrlSetState(-1, $GUI_DISABLE)
$tabGW = GUICtrlCreateTabItem("Guild Wars")
$Label4 = GUICtrlCreateLabel("Some day...", 32, 56, 60, 17)
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $minGlory = 10000
Global $intervalSearch = 500
Global $autoAttackRaid = false
Global $y = 0, $x = 0, $bsPos
Global $windowName = 'Bluestacks App Player'
Global $stopAll = false

GUICtrlSetData($txtMinGlory, $minGlory, "append")

HotKeySet("{ESC}", "stopAll")

While 1
   $nMsg = GUIGetMsg()
   Switch $nMsg
   Case $GUI_EVENT_CLOSE
	  Exit
   Case $btnSearchRaid
	  startRaidSearch()
;~    Case $btnSize
;~ 	  getWindowSize()
   EndSwitch
WEnd

Func findWhereAmI()
   If (clickImage) Then

   EndIf
EndFunc

Func startRaidSearch()
   $autoAttackRaid = IsChecked($chkAutoAttack)
   $minGlory = GUICtrlRead($txtMinGlory)
   searchBigGlory()
EndFunc

Func getWindowSize()
   $size = WinGetClientSize($windowName)
   $windowWidth = $size[0]
   $windowHeight = $size[1]
   GUICtrlSetData($txtConsole, 'Width: ' & $size[0] & ' | Height: ' & $size[1], "append")
   If ($windowWidth / $windowHeight > 1.6586) Then
;~ 	  height
   Else
	  $windowRealHeight = $windowWidth / 1.6666666666666
	  $windowHeightBlackSpace = ($windowHeight - $windowRealHeight) / 2
	  $windowRealWidth = $windowWidth
	  $windowWidthBlackSpace = 0

	  $ssWidth = $windowWidth / 24
	  $ssHeight = $windowRealHeight / 24
	  $ssStartLeft = $windowWidth / 8
	  $ssStartTop = $windowHeightBlackSpace + ($windowHeight / 12.5)
	  $ssEndRight = $windowWidth - $ssStartLeft - $ssWidth
	  $ssEndBottom = $windowHeight - $ssStartTop - $ssHeight
	  ConsoleWrite('Width: ' & $size[0] & ' | Height: ' & $size[1] & @LF)
	  ConsoleWrite('$ssWidth: ' & $ssWidth & ' | $ssHeight: ' & $ssHeight & @LF)
	  ConsoleWrite('$ssStartLeft: ' & $ssStartLeft & ' | $ssStartTop: ' & $ssStartTop & @LF)
	  ConsoleWrite('$ssEndRight: ' & $ssEndRight & ' | $ssEndBottom: ' & $ssEndBottom & @LF)
	  ConsoleWrite('$windowRealHeight: ' & $windowRealHeight & ' | $windowHeightBlackSpace: ' & $windowHeightBlackSpace & @LF)
	  ConsoleWrite('$windowRealWidth: ' & $windowRealWidth & ' | $windowWidthBlackSpace: ' & $windowWidthBlackSpace & @LF)
;~ 	  _TesseractWinCapture($windowName, '', 0, '', 1, 5, $ssStartLeft, $ssStartTop, $ssEndRight, 700, 1)
   EndIf
EndFunc

Func clickImage($image, $doClick = True)
   findBluestacksWindow()
   Local $search = _ImageSearchArea($image, 1, $bsPos[0],  $bsPos[1],  $bsPos[2],  $bsPos[3], $x, $y, 0)
   If $search = 1 Then
	  If $doClick Then
		 MouseMove($x, $y, 10)
		 MouseClick($MOUSE_CLICK_LEFT)
	  EndIf
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func findBluestacksWindow()
   ;~ WinActivate($windowName)
   $bsPos = WinGetPos($windowName)
EndFunc

Func stopAll()
    $stopAll = Not $stopAll
EndFunc

Func searchRaids()
   clickImage('images/collos2.bmp')
   clickImage('images/raid.bmp')
   clickImage('images/findraid2.bmp')
EndFunc

Func IsChecked($control)
   Return BitAnd(GUICtrlRead($control),$GUI_CHECKED) = $GUI_CHECKED
EndFunc

Func searchBigGlory()
   If ($stopAll) Then
	  Return
   EndIf
   Sleep($intervalSearch)
   Local $text = _TesseractWinCapture($windowName, '', 0, '', 1, 5, 720, 140, 580, 520, 0)
   Local $thisGlory = 0
   $thisGlory = Number(StringReplace($text, 'Glory Points: ', ''))
   addToConsole('Glory: ' & $thisGlory)
   If ($thisGlory <= $minGlory) Then
	  nextRaid()
   Else
	  addToConsole('Attack, you fool!')
	  attackRaid()
   EndIf
EndFunc

Func addToConsole($text)
   GUICtrlSetData($txtConsole, $text & @CRLF, "append")
   ConsoleWrite($text & @CRLF)
EndFunc

Func nextRaid()
   clickImage('images/changeraid2.bmp')
   searchBigGlory()
EndFunc

Func attackRaid()
   clickImage('images/battleraid.bmp', $autoAttackRaid)
EndFunc