#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Lgp85-Blue-Crystal-Internet-Explorer.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <Array.au3>

Global $Array_Tablica_Pytan[0][2]
Global $Array_Tablica_Filtrow[0][2]
Global $NumerPytania = 1

#Region - GUI_Cisco
$GUI_Cisco = GUICreate("Cisco", 450, 354, -1, -1, $WS_SYSMENU, -1) ; GUI_Cisco
$hGUI_Cisco = WinGetHandle("Cisco") ; Wy�uskanie uchwytu GUI_Cisco
GUISetState(@SW_SHOW, $GUI_Cisco)

; EDIT/INPUT do wyszukiwania pytania
GUICtrlCreateLabel("Filtr:", 10, 24)
$Gui_Cisco_Edit_Filtr = GUICtrlCreateEdit("Tablica jest pusta!", 94, 10, 340, 40, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL) + $WS_VSCROLL)
GUICtrlSetState($Gui_Cisco_Edit_Filtr, $GUI_DISABLE)

GUICtrlCreateLabel("------------------------------------------------------------------------------------------------------------------------------------------", 9, 50, 432, 20, $SS_CENTER)

; EDIT/INPUT do wy�wietlania pe�nego pytania
GUICtrlCreateLabel("Pytanie:", 10, 99)
$Gui_Cisco_Edit_Pytanie = GUICtrlCreateEdit("", 94, 65, 340, 80, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL) + $WS_VSCROLL + $ES_READONLY)
GUICtrlSetState($Gui_Cisco_Edit_Pytanie, $GUI_DISABLE)

; EDIT/INPUT do wy�wietlania odpowiedzi na pytanie
GUICtrlCreateLabel("Odpowied�:", 10, 184)
$Gui_Cisco_Edit_Odpowiedz = GUICtrlCreateEdit("", 94, 150, 340, 80, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL) + $WS_VSCROLL + $ES_READONLY)
GUICtrlSetState($Gui_Cisco_Edit_Odpowiedz, $GUI_DISABLE)

; LABEL licznik Wynik�w
GUICtrlCreateLabel("Pasuj�cych:", 10, 240, 57, 20)
$Gui_Cisco_Label_PasujaceFiltry = GUICtrlCreateLabel("0 / 0", 70, 240, 72, 20)

; Poprzednie i nast�pne wyszukane pytanie oraz filtrowanie
$Gui_Cisco_Button_PoprzedniePytanie = GUICtrlCreateButton("< Poprzednie", 143, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_PoprzedniePytanie, $GUI_DISABLE)

$Gui_Cisco_Button_Filtruj = GUICtrlCreateButton("Filtruj (enter)", 233, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_Filtruj, $GUI_DISABLE)

$Gui_Cisco_Button_NastepnePytanie = GUICtrlCreateButton("Nast�pne >", 323, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_NastepnePytanie, $GUI_DISABLE)

GUICtrlCreateLabel("------------------------------------------------------------------------------------------------------------------------------------------", 9, 258, 432, 20, $SS_CENTER)

; Zarz�dzanie tablic� pyta�
$Gui_Cisco_Button_WyczyscTablicePytan = GUICtrlCreateButton("Wyczy�� tablice", 69, 274, 100, 22)
$Gui_Cisco_Button_SprawdzTablicePytan = GUICtrlCreateButton("Sprawd� tablice", 171, 274, 100, 22)
$Gui_Cisco_Button_SprawdzTabliceFiltrow = GUICtrlCreateButton("Sprawd� filtrowane", 273, 274, 100, 22)
$Gui_Cisco_Button_DodajPytaniaDoTablicySchowek = GUICtrlCreateButton("Dodaj pytania (schowek)", 81, 298, 140, 22)
$Gui_Cisco_Button_DodajPytaniaDoTablicyPlik = GUICtrlCreateButton("Dodaj pytania (plik)", 222, 298, 140, 22)
$Gui_Cisco_Button_UsunPytanieZTablicy = GUICtrlCreateButton("Usu� pytanie", 375, 274, 56, 46, $BS_MULTILINE)
GUICtrlSetState($Gui_Cisco_Button_UsunPytanieZTablicy, $GUI_DISABLE)
#EndRegion - GUI_Cisco

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
				Case $Zdarzenie[0] = $Gui_Cisco_Button_SprawdzTablicePytan ; Sprawdzenie tablicy pyta�
					SprawdzTablicePytan()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_SprawdzTabliceFiltrow ; Sprawdzanie tablicy filtr�w
					SprawdzTabliceFiltrow()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_DodajPytaniaDoTablicySchowek ; Dodawanie pyta� do tablicy ze schowka
					DodajPytaniaDoTablicy(True)
				Case $Zdarzenie[0] = $Gui_Cisco_Button_DodajPytaniaDoTablicyPlik ; Dodawanie pyta� do tablicy z pliku
					DodajPytaniaDoTablicy(False)
				Case $Zdarzenie[0] = $Gui_Cisco_Button_Filtruj ; Filtrowanie pyta� po wyszkukiwaniu
					NowyFiltr()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_PoprzedniePytanie ; Poprzednie pytanie z tablicy filtr�w
					PoprzedniePytanie()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_NastepnePytanie ; Nast�pne pytanie z tablicy filtr�w
					NastepnePytanie()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_UsunPytanieZTablicy ; Usuwanie aktualnie wy�wietlanego pytania z tablicy
					UsunPytanie()
			EndSelect
	EndSwitch
	__IsConfirmed($Gui_Cisco_Edit_Filtr, "NowyFiltr")
WEnd
#EndRegion - Obs�uga zdarze�

#Region - Funkcje
Func WyczyscTablicePytan() ; Czyszczenie tablicy pyta�
	Local $Odpowiedz = MsgBox(1 + 32, "Potwierdzenie", "Czy na pewno wyczy�ci� tablice pyta� i filtr�w?") ; Potwierdzenie
	If $Odpowiedz = 1 Then
		While UBound($Array_Tablica_Pytan) <> 0 ;	Usuwanie tablicy pyta� w p�tli dop�ki nie b�dzie pusta
			_ArrayDelete($Array_Tablica_Pytan, 0)
		WEnd
		WyczyscTabliceFiltrow()
		WylaczPrzyciski()
	EndIf
EndFunc   ;==>WyczyscTablicePytan

Func PoprzedniePytanie() ; Zmiana licznika pytania na poprzednie
	If $NumerPytania = 0 Then ; Je�li jest pierwsze, to przeskocz na ostatnie
		$NumerPytania = UBound($Array_Tablica_Filtrow)-1
	Else
		$NumerPytania -= 1 ; Je�li nie jest pierwsze, to przeskocz na poprzednie
	EndIf

	ZmienPytanie()
EndFunc

Func NastepnePytanie() ; Zmienienie licznika pytania na kolejne
	If $NumerPytania = UBound($Array_Tablica_Filtrow)-1 Then ; Je�li jest juz ostatnie, to przeskocz na pierwsze
		$NumerPytania = 0
	Else
		$NumerPytania += 1 ; Je�li nie jest ostatnie, przeskocz na kolejne
	EndIf

	ZmienPytanie()
EndFunc

Func WyczyscTabliceFiltrow() ; Czyszczenie tablicy filtr�w
	While UBound($Array_Tablica_Filtrow) <> 0 ;	Usuwanie tablicy filtr�w w p�tli dop�ki nie b�dzie pusta
		_ArrayDelete($Array_Tablica_Filtrow, 0)
	WEnd
EndFunc   ;==>WyczyscTabliceFiltrow

Func SprawdzTablicePytan() ; Sprawdzanie pyta�, kt�re aktualnie znajduj� si� w tablicy pyta�
	_ArrayDisplay($Array_Tablica_Pytan, "Tablica pyta�")
EndFunc   ;==>SprawdzTablicePytan

Func SprawdzTabliceFiltrow() ; Sprawdzanie pyta�, kt�re aktualnie znajduj� si� w tablicy filtr�w
	_ArrayDisplay($Array_Tablica_Filtrow, "Tablica filtr�w")
EndFunc   ;==>SprawdzTablicePytan

Func DodajPytaniaDoTablicy($Schowek) ; Dodawanie s��wek do tablicy
	If $Schowek Then
		Local $DodawaneSlowa = ClipGet() ; Dodanie s��wek do tablicy ze schowka systemowego
	ElseIf not $Schowek Then
		Local $DodawaneSlowa = FileRead(FileOpenDialog("Wybierz...", @ScriptDir, "Baza cisco (*.txt)"))
	EndIf

	If not StringInStr(StringRight($DodawaneSlowa, 5), @CRLF) Then $DodawaneSlowa = $DodawaneSlowa & @CRLF ; Je�li na ko�cu nie ma entera, trzeba go doda�
	$DodawaneSlowa = StringReplace($DodawaneSlowa, "	", "") ; Usuwanie tabulator�w
	$DodawaneSlowa = StringReplace($DodawaneSlowa, @CRLF, "�") ; Zamiana nowego wiersza na "+"
	Local $Array_Tablica_Tymczasowa = StringSplit($DodawaneSlowa, "�", 2) ; Poci�cie s��wka na pary usuwaj�c +

	For $i = 0 To UBound($Array_Tablica_Tymczasowa) - 2 Step 1 ; Dodawanie par s��wek do tablicy w�a�ciwej, oddzielonych "�"
		_ArrayAdd($Array_Tablica_Pytan, $Array_Tablica_Tymczasowa[$i], 0, "�")
		$Array_Tablica_Pytan[$i][1] = "� " & $Array_Tablica_Pytan[$i][1]
		$Array_Tablica_Pytan[$i][1] = StringReplace($Array_Tablica_Pytan[$i][1], "&", @CRLF & "� ")
	Next

	While UBound($Array_Tablica_Tymczasowa) <> 0 ; Czyszczenie tablicy tymczasowej
		_ArrayDelete($Array_Tablica_Tymczasowa, 0)
	WEnd

	_ArrayDisplay($Array_Tablica_Pytan) ; Wy�wietlenie ca�ej tablicy z wszystkimi s��wkami
	WlaczPrzyciski()
EndFunc   ;==>DodajPytaniaDoTablicy

Func NowyFiltr() ; Zmiana tablicy filtr�w, po zmianie filtru
	WyczyscTabliceFiltrow() ; Czyszczenie tablicy filtr�w, bo b�dzie tworzona nowa
	$NumerPytania = 0 ; Wyzerowanie pytania, bo tak
	If GUICtrlRead($Gui_Cisco_Edit_Filtr) = "" Then ; Je�li nie by�o filtru to wszystkie pytania pasuj�
		$Array_Tablica_Filtrow = $Array_Tablica_Pytan ; Wi�c tablica filtr�w b�dzie ca�� tablic� pyta�
	Else ; Je�li by� filtr
		For $i = 0 To UBound($Array_Tablica_Pytan) - 1
			If StringInStr($Array_Tablica_Pytan[$i][0], GUICtrlRead($Gui_Cisco_Edit_Filtr)) Then ; Je�li rekord z tablicy pyta� pasuje do filtru, dodaj go do tablicy filtr�w
				_ArrayAdd($Array_Tablica_Filtrow, $Array_Tablica_Pytan[$i][0]) ; Dodawanie pytania
				$Array_Tablica_Filtrow[UBound($Array_Tablica_Filtrow)-1][1] = $Array_Tablica_Pytan[$i][1] ; Dodawanie odpowiedzi
			EndIf
		Next
	EndIf

	ZmienPytanie() ; Zmiana pyta� w ramkach i numeru filtru
EndFunc

Func ZmienPytanie()
	If UBound($Array_Tablica_Filtrow) <> 0 Then ; Je�li s� pasuj�ce wyniki
		GUICtrlSetData($Gui_Cisco_Edit_Pytanie, $Array_Tablica_Filtrow[$NumerPytania][0]) ; Wy�wietl pierwsze pytanie
		GUICtrlSetData($Gui_Cisco_Edit_Odpowiedz, $Array_Tablica_Filtrow[$NumerPytania][1]) ; Wy�wietl odpowied� na pierwsze pytanie
		GUICtrlSetData($Gui_Cisco_Label_PasujaceFiltry, $NumerPytania+1 & " / " & UBound($Array_Tablica_Filtrow)) ; Ustaw odpowiednio licznik
	Else ; Je�li nie ma pasuj�cych wynik�w
		GUICtrlSetData($Gui_Cisco_Edit_Pytanie, "�adne pytanie nie pasuje do filtru!")
		GUICtrlSetData($Gui_Cisco_Edit_Odpowiedz, "�adne pytanie nie pasuje do filtru!")
		GUICtrlSetData($Gui_Cisco_Label_PasujaceFiltry, "0 / 0")
	EndIf
EndFunc

Func UsunPytanie()

EndFunc

Func WlaczPrzyciski() ; W��czanie przycisk�w, zeby mozna by�o filtrowa� wyniki
	If GUICtrlRead($Gui_Cisco_Edit_Filtr) = "Tablica jest pusta!" Then GUICtrlSetData($Gui_Cisco_Edit_Filtr, "") ; Jezeli filtr nie by� ustawiony, to czy�cimy okienko filtru

	GUICtrlSetState($Gui_Cisco_Edit_Filtr, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Edit_Pytanie, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Edit_Odpowiedz, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Button_PoprzedniePytanie, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Button_Filtruj, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Button_NastepnePytanie, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Button_UsunPytanieZTablicy, $GUI_ENABLE)

	NowyFiltr() ; Zmiana tablicy filtr�w
EndFunc   ;==>WlaczPrzyciski

Func WylaczPrzyciski() ; Wy��czanie przycisk�w, zeby nie narobi� ba�aganu
	; ************************* Je�li nie ma pyta�, to po co przyciski maj� dzia�a�? *************************
	GUICtrlSetState($Gui_Cisco_Edit_Filtr, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Edit_Pytanie, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Edit_Odpowiedz, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_PoprzedniePytanie, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_Filtruj, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_NastepnePytanie, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_UsunPytanieZTablicy, $GUI_DISABLE)

	; Wi�c trzeba te� ogarn�� inputy
	GUICtrlSetData($Gui_Cisco_Edit_Filtr, "Tablica jest pusta!")
	GUICtrlSetData($Gui_Cisco_Edit_Pytanie, "")
	GUICtrlSetData($Gui_Cisco_Edit_Odpowiedz, "")
	GUICtrlSetData($Gui_Cisco_Label_PasujaceFiltry, "0 / 0")
EndFunc

Func __IsConfirmed($Control, $Func) ; Je�li w EDIT wci�ni�to enter wywo�aj ustalon� funkcj�
	If StringInStr(GUICtrlRead($Control), @CRLF) Then ; Szukanie {enter} w ci�gu znak�w EDITa
		GUICtrlSetData($Control, StringReplace(GUICtrlRead($Control), @CRLF, "")) ; Usuni�cie {enter} z ci�gu znak�w
		Call($Func)
	EndIf
	;If StringRight(GUICtrlRead($Control), 2) = @CRLF Then  ; Je�li ostatni znak to {enter}, wtedy wywo�aj funkcj� $Func
EndFunc   ;==>__IsConfirmed
#EndRegion - Funkcje
