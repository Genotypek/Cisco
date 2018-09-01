#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <Array.au3>

Global $Array_Tablica_Pytan[0][2]

#Region - GUI_NIEMIECKI
$GUI_Cisco= GUICreate("Cisco", 450, 354, -1, -1, $WS_SYSMENU, -1) ; GUI_Cisco
$hGUI_Cisco = WinGetHandle("Cisco") ; Wy³uskanie uchwytu GUI_Cisco
GUISetState(@SW_SHOW, $GUI_Cisco)

; EDIT/INPUT do wyszukiwania pytania
GUICtrlCreateLabel("Filtr:", 10, 24)
$Gui_Cisco_Edit_Filtr = GUICtrlCreateEdit("Tablica jest pusta!", 94, 10, 340, 40, BitOR($ES_WANTRETURN,$ES_AUTOVSCROLL) + $WS_VSCROLL)
GUICtrlSetState($Gui_Cisco_Edit_Filtr, $GUI_DISABLE)

GUICtrlCreateLabel("------------------------------------------------------------------------------------------------------------------------------------------", 9, 50, 432, 20, $SS_CENTER)

; EDIT/INPUT do wyœwietlania pe³nego pytania
GUICtrlCreateLabel("Pytanie:", 10, 99)
$Gui_Cisco_Edit_Pytanie = GUICtrlCreateEdit("", 94, 65, 340, 80, BitOR($ES_WANTRETURN,$ES_AUTOVSCROLL) + $WS_VSCROLL + $ES_READONLY)
GUICtrlSetState($Gui_Cisco_Edit_Pytanie, $GUI_DISABLE)

; EDIT/INPUT do wyœwietlania odpowiedzi na pytanie
GUICtrlCreateLabel("OdpowiedŸ:", 10, 184)
$Gui_Cisco_Edit_Odpowiedz = GUICtrlCreateEdit("", 94, 150, 340, 80, BitOR($ES_WANTRETURN,$ES_AUTOVSCROLL) + $WS_VSCROLL + $ES_READONLY)
GUICtrlSetState($Gui_Cisco_Edit_Odpowiedz, $GUI_DISABLE)

; LABEL licznik Wyników
GUICtrlCreateLabel("Pasuj¹cych:", 10, 240, 57, 20)
$Gui_Cisco_Label_PasujaceFiltry = GUICtrlCreateLabel("0 / 0", 70, 240, 170, 20)

; Poprzednie i nastêpne wyszukane pytanie
$Gui_Cisco_Button_PoprzedniePytanie = GUICtrlCreateButton("< Poprzednie", 123, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_PoprzedniePytanie, $GUI_DISABLE)

$Gui_Cisco_Button_Filtruj = GUICtrlCreateButton("Filtruj", 213, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_Filtruj, $GUI_DISABLE)

$Gui_Cisco_Button_NastepnePytanie = GUICtrlCreateButton("Nastêpne >", 303, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_NastepnePytanie, $GUI_DISABLE)

GUICtrlCreateLabel("------------------------------------------------------------------------------------------------------------------------------------------", 9, 258, 432, 20, $SS_CENTER)

; Zarz¹dzanie tablic¹ pytañ
$Gui_Cisco_Button_WyczyscTablicePytan = GUICtrlCreateButton("Wyczyœæ tablice", 120, 274, 100, 22)
$Gui_Cisco_Button_SprawdzTablicePytan = GUICtrlCreateButton("SprawdŸ tablice", 222, 274, 100, 22)
$Gui_Cisco_Button_DodajPytaniaDoTablicy = GUICtrlCreateButton("Dodaj pytania", 171, 298, 100, 22)
#EndRegion - GUI_NIEMIECKI

#Region - Obs³uga zdarzeñ
While 1
	$Zdarzenie = GUIGetMsg(1)

	Switch $Zdarzenie[1]
		Case $hGUI_Cisco ; ZDARZENIA GUI_MAIN
			Select
				Case $Zdarzenie[0] = $GUI_EVENT_CLOSE ; Zamkniêcie programu
					Exit
				Case $Zdarzenie[0] = $Gui_Cisco_Button_WyczyscTablicePytan; Czyszczenie tablicy pytañ
					WyczyscTablicePytan()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_SprawdzTablicePytan ; Sprawdzenie tablicy s³ówek
					SprawdzTabliceSlowek()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_DodajPytaniaDoTablicy ; Dodawanie s³ówek do tablicy
					;DodajPytaniaDoTablicy()
			EndSelect
	EndSwitch
WEnd
#EndRegion - Obs³uga zdarzeñ

#Region - Funkcje
Func WyczyscTablicePytan() ; Czyszczenie tablicy pytañ
	Local $Odpowiedz = MsgBox(1 + 32, "Potwierdzenie", "Czy na pewno wyczyœciæ tablicê pytañ?") ; Potwierdzenie
	If $Odpowiedz = 1 Then
		While UBound($Array_Tablica_Pytan) <> 0 ;	Usuwanie tablicy w pêtli dopóki nie bêdzie pusta
			_ArrayDelete($Array_Tablica_Pytan, 0)
		WEnd
	EndIf

	; ************************* Jeœli nie ma pytañ, to po co przyciski maj¹ dzia³aæ? *************************
	GUICtrlSetState($Gui_Cisco_Edit_Filtr, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_PoprzedniePytanie, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_Filtruj, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_NastepnePytanie, $GUI_DISABLE)

	; Wiêc trzeba te¿ ogarn¹æ inputy
		GUICtrlSetData($Gui_Cisco_Edit_Filtr, "Tablica jest pusta!")
	GUICtrlSetData($Gui_Cisco_Edit_Pytanie, "")
	GUICtrlSetData($Gui_Cisco_Edit_Odpowiedz, "")
	GUICtrlSetData($Gui_Cisco_Label_PasujaceFiltry, "0 / 0")
EndFunc   ;==>WyczyscTabliceSlowek

Func SprawdzTabliceSlowek() ; Sprawdzanie pytañ, które aktualnie znajduj¹ siê w tablicy
	_ArrayDisplay($Array_Tablica_Pytan, "Tablica pytañ")
EndFunc   ;==>SprawdzTabliceSlowek

Func __IsConfirmed($Control, $Func)
	If StringInStr(GUICtrlRead($Control), @CRLF) Then ; Searching {enter} in string
        GUICtrlSetData($Control, StringReplace(GUICtrlRead($Control), @CRLF, "")) ; Remove {enter} from string
        Call($Func)
    EndIf
    ;If StringRight(GUICtrlRead($Control), 2) = @CRLF Then  ; Jeœli ostatni znak to {enter}, wtedy wywo³aj funkcjê $Func
EndFunc
#EndRegion - Funkcje