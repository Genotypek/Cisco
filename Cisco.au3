#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Lgp85-Blue-Crystal-Internet-Explorer.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <Array.au3>
#include <String.au3>
#include <GDIPlus.au3>

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

; Zarz�dzanie miejscem wy�wietlania pytania
$GUI_Cisco_Radio_ObrazekGora = GUICtrlCreateRadio("", 30, 275, 12, 12)
$GUI_Cisco_Radio_ObrazekLewo = GUICtrlCreateRadio("", 10, 290, 12, 12)
$GUI_Cisco_Radio_ObrazekBrak = GUICtrlCreateRadio("", 30, 290, 12, 12)
$GUI_Cisco_Radio_ObrazekPrawo = GUICtrlCreateRadio("", 50, 290, 12, 12)
$GUI_Cisco_Radio_ObrazekDol = GUICtrlCreateRadio("", 30, 305, 12, 12)
GUICtrlSetState($GUI_Cisco_Radio_ObrazekDol, $GUI_CHECKED)
#EndRegion - GUI_Cisco

#Region - GUI_Ilustracja
$GUI_Ilustracja = GUICreate("Ilustracja", 0, 0, 0, 0, $WS_POPUP, -1, $GUI_Cisco)
$GUI_Ilustracja_Obraz = GUICtrlCreatePic(Null, 0, 0, 0, 0, $SS_BITMAP)
#EndRegion - GUI_Ilustracja

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
	PozycjaObrazka()
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
		$NumerPytania = UBound($Array_Tablica_Filtrow) - 1
	Else
		$NumerPytania -= 1 ; Je�li nie jest pierwsze, to przeskocz na poprzednie
	EndIf

	ZmienPytanie()
EndFunc   ;==>PoprzedniePytanie

Func NastepnePytanie() ; Zmienienie licznika pytania na kolejne
	If $NumerPytania = UBound($Array_Tablica_Filtrow) - 1 Then ; Je�li jest juz ostatnie, to przeskocz na pierwsze
		$NumerPytania = 0
	Else
		$NumerPytania += 1 ; Je�li nie jest ostatnie, przeskocz na kolejne
	EndIf

	ZmienPytanie()
EndFunc   ;==>NastepnePytanie

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
EndFunc   ;==>SprawdzTabliceFiltrow

Func DodajPytaniaDoTablicy($Schowek) ; Dodawanie pyta� do tablicy
	If $Schowek Then ; Je�li wybrano dodawanie przez schowek
		Local $DodawaneSlowa = ClipGet() ; Dodanie pyta� do tablicy ze schowka systemowego
	ElseIf Not $Schowek Then ; Je�li wybrano dodawanie nie przez schowek
		Local $DodawaneSlowa = FileRead(FileOpenDialog("Wybierz...", @ScriptDir, "Baza cisco (*.txt)")) ; Dodanie pyta� ze wskazanego pliku
	EndIf

	If Not StringInStr(StringRight($DodawaneSlowa, 5), @CRLF) Then $DodawaneSlowa = $DodawaneSlowa & @CRLF ; Je�li na ko�cu nie ma entera, trzeba go doda�
	$DodawaneSlowa = StringReplace($DodawaneSlowa, "	", "") ; Usuwanie tabulator�w
	$DodawaneSlowa = StringReplace($DodawaneSlowa, @CRLF, "�") ; Zamiana nowego wiersza na "�"
	Local $Array_Tablica_Tymczasowa = StringSplit($DodawaneSlowa, "�", 2) ; Poci�cie s��wka na pary usuwaj�c �

	For $i = 0 To UBound($Array_Tablica_Tymczasowa) - 2 Step 1 ; Dodawanie par s��wek do tablicy w�a�ciwej, oddzielonych "�"
		_ArrayAdd($Array_Tablica_Pytan, $Array_Tablica_Tymczasowa[$i], 0, "�") ; �amanie par wyraz�w poprzez "�"
		$Array_Tablica_Pytan[UBound($Array_Tablica_Pytan) - 1][0] = StringReplace($Array_Tablica_Pytan[UBound($Array_Tablica_Pytan) - 1][0], "&", @CRLF) ; �amanie wiersza w pytaniu za pomoc� "&"
		$Array_Tablica_Pytan[UBound($Array_Tablica_Pytan) - 1][1] = "� " & $Array_Tablica_Pytan[UBound($Array_Tablica_Pytan) - 1][1] ; Dodanie na pocz�tku do pierwszego pytania punktora
		$Array_Tablica_Pytan[UBound($Array_Tablica_Pytan) - 1][1] = StringReplace($Array_Tablica_Pytan[UBound($Array_Tablica_Pytan) - 1][1], "&", @CRLF & "� ") ; �amanie wiersza w odpowiedzi za pomoc� "&"
	Next

	While UBound($Array_Tablica_Tymczasowa) <> 0 ; Czyszczenie tablicy tymczasowej
		_ArrayDelete($Array_Tablica_Tymczasowa, 0)
	WEnd

	;_ArrayDisplay($Array_Tablica_Pytan) ; Wy�wietlenie ca�ej tablicy z wszystkimi s��wkami
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
				$Array_Tablica_Filtrow[UBound($Array_Tablica_Filtrow) - 1][1] = $Array_Tablica_Pytan[$i][1] ; Dodawanie odpowiedzi
			EndIf
		Next
	EndIf

	ZmienPytanie() ; Zmiana pyta� w ramkach i numeru filtru
EndFunc   ;==>NowyFiltr

Func ZmienPytanie()
	Local $LinkIlustracji

	If UBound($Array_Tablica_Filtrow) <> 0 Then ; Je�li s� pasuj�ce wyniki
		If StringRegExp($Array_Tablica_Filtrow[$NumerPytania][0], "http.://") Or StringRegExp($Array_Tablica_Filtrow[$NumerPytania][0], "http://") Then ; Je�li w pytaniu jest link to:
			Local $Array_Pomocnicza = _StringBetween($Array_Tablica_Filtrow[$NumerPytania][0], "http", " ") ; Znajd� link
			$LinkIlustracji = "http" & $Array_Pomocnicza[0] ; Zapisz go w zmiennej
		Else
			$LinkIlustracji = Null ; Je�li nie ma, to zmienna jest pusta
		EndIf
		If $LinkIlustracji <> Null Then GUICtrlSetData($Gui_Cisco_Edit_Pytanie, StringReplace($Array_Tablica_Filtrow[$NumerPytania][0], $LinkIlustracji & " ", "")) ; Wy�wietl pierwsze pytanie bez linku ilustracji
		If $LinkIlustracji = Null Then GUICtrlSetData($Gui_Cisco_Edit_Pytanie, $Array_Tablica_Filtrow[$NumerPytania][0]) ; Wy�wietl pierwsze pytanie
		GUICtrlSetData($Gui_Cisco_Edit_Odpowiedz, $Array_Tablica_Filtrow[$NumerPytania][1]) ; Wy�wietl odpowied� na pierwsze pytanie
		GUICtrlSetData($Gui_Cisco_Label_PasujaceFiltry, $NumerPytania + 1 & " / " & UBound($Array_Tablica_Filtrow)) ; Ustaw odpowiednio licznik
	Else ; Je�li nie ma pasuj�cych wynik�w
		GUICtrlSetData($Gui_Cisco_Edit_Pytanie, "�adne pytanie nie pasuje do filtru!")
		GUICtrlSetData($Gui_Cisco_Edit_Odpowiedz, "�adne pytanie nie pasuje do filtru!")
		GUICtrlSetData($Gui_Cisco_Label_PasujaceFiltry, "0 / 0")
		$LinkIlustracji = Null
	EndIf
	PokazIlustracje($LinkIlustracji)
EndFunc   ;==>ZmienPytanie

Func UsunPytanie()
	Local $index = _ArraySearch($Array_Tablica_Pytan, $Array_Tablica_Filtrow[$NumerPytania][0])
	_ArrayDelete($Array_Tablica_Pytan, $index)
	If UBound($Array_Tablica_Pytan) <> 0 Then
		NowyFiltr()
	Else
		WyczyscTabliceFiltrow()
		WylaczPrzyciski()
	EndIf
EndFunc   ;==>UsunPytanie

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
EndFunc   ;==>WylaczPrzyciski

Func __IsConfirmed($Control, $Func) ; Je�li w EDIT wci�ni�to enter wywo�aj ustalon� funkcj�
	If StringInStr(GUICtrlRead($Control), @CRLF) Then ; Szukanie {enter} w ci�gu znak�w EDITa
		GUICtrlSetData($Control, StringReplace(GUICtrlRead($Control), @CRLF, "")) ; Usuni�cie {enter} z ci�gu znak�w
		Call($Func)
	EndIf
	;If StringRight(GUICtrlRead($Control), 2) = @CRLF Then  ; Je�li ostatni znak to {enter}, wtedy wywo�aj funkcj� $Func
EndFunc   ;==>__IsConfirmed

Func __IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>__IsChecked

Func PokazIlustracje($Url) ; Sprawdza, czy do pytania ma zosta� wy�wietlona ilustracja i j� pokazuje b�d� chowa
	If $Url <> Null Then ; Je�li link nie jest pusty, to:
		$hInet = InetGet($Url, @ScriptDir & "\bazy\obraz.jpg", 0, 0) ; Pobranie obrazka
		_GDIPlus_Startup() ; Uruchomienie GDI, by zmieni� rozszerzenie i pobra� rozmiary obrazka
		$hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\bazy\obraz.jpg") ; Odczytanie obrazu
		$sCLSID = _GDIPlus_EncodersGetCLSID("BMP") ; Ustalenie nowego rozszerzenia
		_GDIPlus_ImageSaveToFileEx($hImage, @ScriptDir & "\bazy\obraz.bmp", $sCLSID) ; Zapis obrazu z nowym rozszerzeniem
		Local $Widith = _GDIPlus_ImageGetWidth($hImage) ; Pobranie szeroko�ci
		Local $Height = _GDIPlus_ImageGetHeight($hImage) ; Pobranie wysoko�ci
		_GDIPlus_ImageDispose($hImage) ; Usuni�cie obrazka z pami�ci
		_GDIPlus_Shutdown() ; Wy��czenie GDI
		Local $PosIlustracje = WinGetPos($GUI_Ilustracja)
		WinMove($GUI_Ilustracja, "", $PosIlustracje[0], $PosIlustracje[1], $Widith, $Height) ; Ustawienie wielko�ci POPUP'a
		GUICtrlSetPos($GUI_Ilustracja_Obraz, 0, 0, $Widith, $Height) ; Ustawienie rozmiaru obrazka
		GUICtrlSetImage($GUI_Ilustracja_Obraz, @ScriptDir & "\bazy\obraz.bmp") ; Zmiana obrazka na w�a�ciwy
		GUISetState(@SW_SHOW, $GUI_Ilustracja) ; Pokazanie okna
	Else ; Je�li link jest pusty to:
		GUISetState(@SW_HIDE, $GUI_Ilustracja) ; Schowanie okna
	EndIf
EndFunc   ;==>PokazIlustracje

Func PozycjaObrazka() ; Ustala pozycj� obrazka na ekranie wzgl�dem programu
	Local $x, $y, $Widith, $Height
	Local $PosCisco = WinGetPos($GUI_Cisco)
	Local $PosIlustracje = WinGetPos($GUI_Ilustracja)

	If __IsChecked($GUI_Cisco_Radio_ObrazekGora) Then ; Na g�rze
		$x = ($PosCisco[0] + $PosCisco[2] / 2) - $PosIlustracje[2] / 2
		$y = $PosCisco[1] - $PosIlustracje[3]
	ElseIf __IsChecked($GUI_Cisco_Radio_ObrazekLewo) Then ; Po lewej
		$x = $PosCisco[0] - $PosIlustracje[2]
		$y = ($PosCisco[1] + $PosCisco[3] / 2) - $PosIlustracje[3]/2
	ElseIf __IsChecked($GUI_Cisco_Radio_ObrazekPrawo) Then ; Po prawej
		$x = ($PosCisco[0] + $PosCisco[2])
		$y = ($PosCisco[1] + $PosCisco[3] / 2) - $PosIlustracje[3]/2
	ElseIf __IsChecked($GUI_Cisco_Radio_ObrazekDol) Then ; Na dole
		$x = ($PosCisco[0] + $PosCisco[2] / 2) - $PosIlustracje[2] / 2
		$y = $PosCisco[1] + $PosCisco[3]
	ElseIf __IsChecked($GUI_Cisco_Radio_ObrazekBrak) Then ; Brak obrazka
		$x = 99999
		$y = 99999
	EndIf

	WinMove($GUI_Ilustracja, "", $x, $y) ; Ustawienie pozycji na wyliczon�
EndFunc   ;==>PozycjaObrazka
#EndRegion - Funkcje

