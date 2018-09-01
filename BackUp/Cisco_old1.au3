#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <Array.au3>

Global $Array_Tablica_Pytan[0][2]

#Region - GUI_NIEMIECKI
$GUI_Cisco= GUICreate("Cisco", 450, 354, -1, -1, $WS_SYSMENU, -1) ; GUI_Cisco
$hGUI_Cisco = WinGetHandle("Cisco") ; Wy�uskanie uchwytu GUI_Cisco
GUISetState(@SW_SHOW, $GUI_Cisco)

; EDIT/INPUT do wyszukiwania pytania
GUICtrlCreateLabel("Filtr:", 10, 24)
$Gui_Cisco_Edit_Filtr = GUICtrlCreateEdit("Tablica jest pusta!", 94, 10, 340, 40, BitOR($ES_WANTRETURN,$ES_AUTOVSCROLL) + $WS_VSCROLL)
GUICtrlSetState($Gui_Cisco_Edit_Filtr, $GUI_DISABLE)

GUICtrlCreateLabel("------------------------------------------------------------------------------------------------------------------------------------------", 9, 50, 432, 20, $SS_CENTER)

; EDIT/INPUT do wy�wietlania pe�nego pytania
GUICtrlCreateLabel("Pytanie:", 10, 99)
$Gui_Cisco_Edit_Pytanie = GUICtrlCreateEdit("", 94, 65, 340, 80, BitOR($ES_WANTRETURN,$ES_AUTOVSCROLL) + $WS_VSCROLL + $ES_READONLY)
GUICtrlSetState($Gui_Cisco_Edit_Pytanie, $GUI_DISABLE)

; EDIT/INPUT do wy�wietlania odpowiedzi na pytanie
GUICtrlCreateLabel("Odpowied�:", 10, 184)
$Gui_Cisco_Edit_Odpowiedz = GUICtrlCreateEdit("", 94, 150, 340, 80, BitOR($ES_WANTRETURN,$ES_AUTOVSCROLL) + $WS_VSCROLL + $ES_READONLY)
GUICtrlSetState($Gui_Cisco_Edit_Odpowiedz, $GUI_DISABLE)

; LABEL licznik Wynik�w
GUICtrlCreateLabel("Pasuj�cych:", 10, 240, 57, 20)
$Gui_Cisco_Label_PasujaceFiltry = GUICtrlCreateLabel("0 / 0", 70, 240, 170, 20)

; Poprzednie i nast�pne wyszukane pytanie
$Gui_Cisco_Button_PoprzedniePytanie = GUICtrlCreateButton("< Poprzednie", 123, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_PoprzedniePytanie, $GUI_DISABLE)

$Gui_Cisco_Button_Filtruj = GUICtrlCreateButton("Filtruj", 213, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_Filtruj, $GUI_DISABLE)

$Gui_Cisco_Button_NastepnePytanie = GUICtrlCreateButton("Nast�pne >", 303, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_NastepnePytanie, $GUI_DISABLE)

GUICtrlCreateLabel("------------------------------------------------------------------------------------------------------------------------------------------", 9, 258, 432, 20, $SS_CENTER)

; Zarz�dzanie tablic� pyta�
$Gui_Cisco_Button_WyczyscTablicePytan = GUICtrlCreateButton("Wyczy�� tablice", 120, 274, 100, 22)
$Gui_Cisco_Button_SprawdzTablicePytan = GUICtrlCreateButton("Sprawd� tablice", 222, 274, 100, 22)
$Gui_Cisco_Button_DodajPytaniaDoTablicy = GUICtrlCreateButton("Dodaj pytania", 171, 298, 100, 22)
#EndRegion - GUI_NIEMIECKI

#Region - Obs�uga zdarze�
While 1
	$Zdarzenie = GUIGetMsg(1)

	Switch $Zdarzenie[1]
		Case $hGUI_Cisco ; ZDARZENIA GUI_MAIN
			Select
				Case $Zdarzenie[0] = $GUI_EVENT_CLOSE ; Zamkni�cie programu
					Exit
				Case $Zdarzenie[0] = $Gui_Cisco_Button_WyczyscTablicePytan; Czyszczenie tablicy pyta�
					WyczyscTablicePytan()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_SprawdzTablicePytan ; Sprawdzenie tablicy s��wek
					SprawdzTabliceSlowek()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_DodajPytaniaDoTablicy ; Dodawanie s��wek do tablicy
					;DodajPytaniaDoTablicy()
			EndSelect
	EndSwitch
WEnd
#EndRegion - Obs�uga zdarze�

#Region - Funkcje
Func WyczyscTablicePytan() ; Czyszczenie tablicy pyta�
	Local $Odpowiedz = MsgBox(1 + 32, "Potwierdzenie", "Czy na pewno wyczy�ci� tablic� pyta�?") ; Potwierdzenie
	If $Odpowiedz = 1 Then
		While UBound($Array_Tablica_Pytan) <> 0 ;	Usuwanie tablicy w p�tli dop�ki nie b�dzie pusta
			_ArrayDelete($Array_Tablica_Pytan, 0)
		WEnd
	EndIf

	; ************************* Je�li nie ma pyta�, to po co przyciski maj� dzia�a�? *************************
	GUICtrlSetState($Gui_Cisco_Edit_Filtr, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_PoprzedniePytanie, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_Filtruj, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_NastepnePytanie, $GUI_DISABLE)

	; Wi�c trzeba te� ogarn�� inputy
		GUICtrlSetData($Gui_Cisco_Edit_Filtr, "Tablica jest pusta!")
	GUICtrlSetData($Gui_Cisco_Edit_Pytanie, "")
	GUICtrlSetData($Gui_Cisco_Edit_Odpowiedz, "")
	GUICtrlSetData($Gui_Cisco_Label_PasujaceFiltry, "0 / 0")
EndFunc   ;==>WyczyscTabliceSlowek

Func SprawdzTabliceSlowek() ; Sprawdzanie pyta�, kt�re aktualnie znajduj� si� w tablicy
	_ArrayDisplay($Array_Tablica_Pytan, "Tablica pyta�")
EndFunc   ;==>SprawdzTabliceSlowek

Func __IsConfirmed($Control, $Func)
	If StringInStr(GUICtrlRead($Control), @CRLF) Then ; Searching {enter} in string
        GUICtrlSetData($Control, StringReplace(GUICtrlRead($Control), @CRLF, "")) ; Remove {enter} from string
        Call($Func)
    EndIf
    ;If StringRight(GUICtrlRead($Control), 2) = @CRLF Then  ; Je�li ostatni znak to {enter}, wtedy wywo�aj funkcj� $Func
EndFunc
#EndRegion - Funkcje