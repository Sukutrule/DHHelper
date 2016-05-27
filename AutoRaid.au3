#include <ImageSearch.au3>
#include <Tesseract.au3>
#include <ButtonConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\Users\Nicolas\Desktop\AutoIT\Koda\DHHelper.kxf
$frmMain = GUICreate("DH Helper", 611, 657, 192, 124)
$btnRaid = GUICtrlCreateButton("Search Raid", 112, 400, 201, 49)
$btnStopRaid = GUICtrlCreateButton("Press ESC to stop", 320, 400, 201, 49)
;~ $btnSize = GUICtrlCreateButton("Window Size", 112, 272, 409, 89)
$txtConsole = GUICtrlCreateInput("", 88, 464, 465, 150, $ES_MULTILINE)
GUICtrlSetState(-1, $GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $minGlory = 10000
Global $intervalSearch = 500
Global $y = 0, $x = 0, $bsPos
Global $windowName = 'Bluestacks App Player'
Global $stopAll = false

HotKeySet("{ESC}", "stopAll")

While 1
   $nMsg = GUIGetMsg()
   Switch $nMsg
   Case $GUI_EVENT_CLOSE
	  Exit

   Case $btnRaid
	  searchBigGlory()
   Case $btnStopRaid
	  stopAll()
;~    Case $btnSize
;~ 	  getWindowSize()
   EndSwitch
WEnd

Func findWhereAmI()
   If (clickImage) Then

   EndIf
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

Func searchBigGlory()
   If ($stopAll) Then
	  Return
   EndIf
   Sleep($intervalSearch)
   Local $text = _TesseractWinCapture($windowName, '', 0, '', 1, 5, 720, 140, 580, 520, 1)
;~    Local $text = _TesseractWinCapture($windowName, '', 0, '', 1, 5, 978, 195, 200, 720, 0)
;~    ConsoleWrite('X from: ' &  $x & ' X to: ' &  $xTo & ' Y from: ' &  $y & ' Y to: ' &  $yTo)
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
EndFunc

Func nextRaid()
   clickImage('images/changeraid2.bmp')
   searchBigGlory()
EndFunc

Func attackRaid()
   clickImage('images/battleraid.bmp', False)
EndFunc

While 1
   Sleep(200)
WEnd