;===============================================================================
;
; Description:      Find the position of an image on the desktop
; Syntax:           _ImageSearchArea, _ImageSearch
; Parameter(s):
;                   $findImage - the image to locate on the desktop
;                   $tolerance - 0 for no tolerance (0-255). Needed when colors of
;                                image differ from desktop. e.g GIF
;                   $resultPosition - Set where the returned x,y location of the image is.
;                                     1 for centre of image, 0 for top left of image
;                   $x $y - Return the x and y location of the image
;
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
;
; Note: Use _ImageSearch to search the entire desktop, _ImageSearchArea to specify
;       a desktop region to search
;
;===============================================================================
Func _ImageSearch($findImage, $resultPosition, ByRef $x, ByRef $y, $tolerance)
    Return _ImageSearchArea($findImage, $resultPosition, 0, 0, @DesktopWidth, @DesktopHeight, $x, $y, $tolerance)
EndFunc

Func _ImageSearchArea($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $tolerance)
    If $tolerance > 0 Then $findImage = "*" & $tolerance & " " & $findImage
    $result = DllCall("ImageSearchDLL.dll", "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage)

    ; If error exit
    If @error Or $result[0] = "0" Then Return 0

    ; Otherwise get the x,y location of the match and the size of the image to
    ; compute the centre of search
    $array = StringSplit($result[0], "|")

    $x = Int(Number($array[2]))
    $y = Int(Number($array[3]))
    If $resultPosition == 1 Then
        $x = $x + Int(Number($array[4]) / 2)
        $y = $y + Int(Number($array[5]) / 2)
    EndIf

    Return 1
EndFunc