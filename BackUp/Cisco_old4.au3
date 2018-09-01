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
$hGUI_Cisco = WinGetHandle("Cisco") ; Wy³uskanie uchwytu GUI_Cisco
GUISetState(@SW_SHOW, $GUI_Cisco)

; EDIT/INPUT do wyszukiwania pytania
GUICtrlCreateLabel("Filtr:", 10, 24)
$Gui_Cisco_Edit_Filtr = GUICtrlCreateEdit("Tablica jest pusta!", 94, 10, 340, 40, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL) + $WS_VSCROLL)
GUICtrlSetState($Gui_Cisco_Edit_Filtr, $GUI_DISABLE)

GUICtrlCreateLabel("------------------------------------------------------------------------------------------------------------------------------------------", 9, 50, 432, 20, $SS_CENTER)

; EDIT/INPUT do wyœwietlania pe³nego pytania
GUICtrlCreateLabel("Pytanie:", 10, 99)
$Gui_Cisco_Edit_Pytanie = GUICtrlCreateEdit("", 94, 65, 340, 80, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL) + $WS_VSCROLL + $ES_READONLY)
GUICtrlSetState($Gui_Cisco_Edit_Pytanie, $GUI_DISABLE)

; EDIT/INPUT do wyœwietlania odpowiedzi na pytanie
GUICtrlCreateLabel("OdpowiedŸ:", 10, 184)
$Gui_Cisco_Edit_Odpowiedz = GUICtrlCreateEdit("", 94, 150, 340, 80, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL) + $WS_VSCROLL + $ES_READONLY)
GUICtrlSetState($Gui_Cisco_Edit_Odpowiedz, $GUI_DISABLE)

; LABEL licznik Wyników
GUICtrlCreateLabel("Pasuj¹cych:", 10, 240, 57, 20)
$Gui_Cisco_Label_PasujaceFiltry = GUICtrlCreateLabel("0 / 0", 70, 240, 72, 20)

; Poprzednie i nastêpne wyszukane pytanie oraz filtrowanie
$Gui_Cisco_Button_PoprzedniePytanie = GUICtrlCreateButton("< Poprzednie", 143, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_PoprzedniePytanie, $GUI_DISABLE)

$Gui_Cisco_Button_Filtruj = GUICtrlCreateButton("Filtruj (enter)", 233, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_Filtruj, $GUI_DISABLE)

$Gui_Cisco_Button_NastepnePytanie = GUICtrlCreateButton("Nastêpne >", 323, 235, 90, 22)
GUICtrlSetState($Gui_Cisco_Button_NastepnePytanie, $GUI_DISABLE)

GUICtrlCreateLabel("------------------------------------------------------------------------------------------------------------------------------------------", 9, 258, 432, 20, $SS_CENTER)

; Zarz¹dzanie tablic¹ pytañ
$Gui_Cisco_Button_WyczyscTablicePytan = GUICtrlCreateButton("Wyczyœæ tablice", 69, 274, 100, 22)
$Gui_Cisco_Button_SprawdzTablicePytan = GUICtrlCreateButton("SprawdŸ tablice", 171, 274, 100, 22)
$Gui_Cisco_Button_SprawdzTabliceFiltrow = GUICtrlCreateButton("SprawdŸ filtrowane", 273, 274, 100, 22)
$Gui_Cisco_Button_DodajPytaniaDoTablicySchowek = GUICtrlCreateButton("Dodaj pytania (schowek)", 81, 298, 140, 22)
$Gui_Cisco_Button_DodajPytaniaDoTablicyPlik = GUICtrlCreateButton("Dodaj pytania (plik)", 222, 298, 140, 22)
$Gui_Cisco_Button_UsunPytanieZTablicy = GUICtrlCreateButton("Usuñ pytanie", 375, 274, 56, 46, $BS_MULTILINE)
GUICtrlSetState($Gui_Cisco_Button_UsunPytanieZTablicy, $GUI_DISABLE)
#EndRegion - GUI_Cisco

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
				Case $Zdarzenie[0] = $Gui_Cisco_Button_SprawdzTablicePytan ; Sprawdzenie tablicy pytañ
					SprawdzTablicePytan()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_SprawdzTabliceFiltrow ; Sprawdzanie tablicy filtrów
					SprawdzTabliceFiltrow()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_DodajPytaniaDoTablicySchowek ; Dodawanie pytañ do tablicy ze schowka
					DodajPytaniaDoTablicy(True)
				Case $Zdarzenie[0] = $Gui_Cisco_Button_DodajPytaniaDoTablicyPlik ; Dodawanie pytañ do tablicy z pliku
					DodajPytaniaDoTablicy(False)
				Case $Zdarzenie[0] = $Gui_Cisco_Button_Filtruj ; Filtrowanie pytañ po wyszkukiwaniu
					NowyFiltr()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_PoprzedniePytanie ; Poprzednie pytanie z tablicy filtrów
					PoprzedniePytanie()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_NastepnePytanie ; Nastêpne pytanie z tablicy filtrów
					NastepnePytanie()
				Case $Zdarzenie[0] = $Gui_Cisco_Button_UsunPytanieZTablicy ; Usuwanie aktualnie wyœwietlanego pytania z tablicy
					UsunPytanie()
			EndSelect
	EndSwitch
	__IsConfirmed($Gui_Cisco_Edit_Filtr, "NowyFiltr")
WEnd
#EndRegion - Obs³uga zdarzeñ

#Region - Funkcje
Func WyczyscTablicePytan() ; Czyszczenie tablicy pytañ
	Local $Odpowiedz = MsgBox(1 + 32, "Potwierdzenie", "Czy na pewno wyczyœciæ tablice pytañ i filtrów?") ; Potwierdzenie
	If $Odpowiedz = 1 Then
		While UBound($Array_Tablica_Pytan) <> 0 ;	Usuwanie tablicy pytañ w pêtli dopóki nie bêdzie pusta
			_ArrayDelete($Array_Tablica_Pytan, 0)
		WEnd
		WyczyscTabliceFiltrow()
		WylaczPrzyciski()
	EndIf
EndFunc   ;==>WyczyscTablicePytan

Func PoprzedniePytanie() ; Zmiana licznika pytania na poprzednie
	If $NumerPytania = 0 Then ; Jeœli jest pierwsze, to przeskocz na ostatnie
		$NumerPytania = UBound($Array_Tablica_Filtrow)-1
	Else
		$NumerPytania -= 1 ; Jeœli nie jest pierwsze, to przeskocz na poprzednie
	EndIf

	ZmienPytanie()
EndFunc

Func NastepnePytanie() ; Zmienienie licznika pytania na kolejne
	If $NumerPytania = UBound($Array_Tablica_Filtrow)-1 Then ; Jeœli jest juz ostatnie, to przeskocz na pierwsze
		$NumerPytania = 0
	Else
		$NumerPytania += 1 ; Jeœli nie jest ostatnie, przeskocz na kolejne
	EndIf

	ZmienPytanie()
EndFunc

Func WyczyscTabliceFiltrow() ; Czyszczenie tablicy filtrów
	While UBound($Array_Tablica_Filtrow) <> 0 ;	Usuwanie tablicy filtrów w pêtli dopóki nie bêdzie pusta
		_ArrayDelete($Array_Tablica_Filtrow, 0)
	WEnd
EndFunc   ;==>WyczyscTabliceFiltrow

Func SprawdzTablicePytan() ; Sprawdzanie pytañ, które aktualnie znajduj¹ siê w tablicy pytañ
	_ArrayDisplay($Array_Tablica_Pytan, "Tablica pytañ")
EndFunc   ;==>SprawdzTablicePytan

Func SprawdzTabliceFiltrow() ; Sprawdzanie pytañ, które aktualnie znajduj¹ siê w tablicy filtrów
	_ArrayDisplay($Array_Tablica_Filtrow, "Tablica filtrów")
EndFunc   ;==>SprawdzTablicePytan

Func DodajPytaniaDoTablicy($Schowek) ; Dodawanie s³ówek do tablicy
	If $Schowek Then
		Local $DodawaneSlowa = ClipGet() ; Dodanie s³ówek do tablicy ze schowka systemowego
	ElseIf not $Schowek Then
		Local $DodawaneSlowa = FileRead(FileOpenDialog("Wybierz...", @ScriptDir, "Baza cisco (*.txt)"))
	EndIf

	If not StringInStr(StringRight($DodawaneSlowa, 5), @CRLF) Then $DodawaneSlowa = $DodawaneSlowa & @CRLF ; Jeœli na koñcu nie ma entera, trzeba go dodaæ
	$DodawaneSlowa = StringReplace($DodawaneSlowa, "	", "") ; Usuwanie tabulatorów
	$DodawaneSlowa = StringReplace($DodawaneSlowa, @CRLF, "†") ; Zamiana nowego wiersza na "+"
	Local $Array_Tablica_Tymczasowa = StringSplit($DodawaneSlowa, "†", 2) ; Pociêcie s³ówka na pary usuwaj¹c +

	For $i = 0 To UBound($Array_Tablica_Tymczasowa) - 2 Step 1 ; Dodawanie par s³ówek do tablicy w³aœciwej, oddzielonych "€"
		_ArrayAdd($Array_Tablica_Pytan, $Array_Tablica_Tymczasowa[$i], 0, "€")
		$Array_Tablica_Pytan[$i][1] = "• " & $Array_Tablica_Pytan[$i][1]
		$Array_Tablica_Pytan[$i][1] = StringReplace($Array_Tablica_Pytan[$i][1], "&", @CRLF & "• ")
	Next

	While UBound($Array_Tablica_Tymczasowa) <> 0 ; Czyszczenie tablicy tymczasowej
		_ArrayDelete($Array_Tablica_Tymczasowa, 0)
	WEnd

	_ArrayDisplay($Array_Tablica_Pytan) ; Wyœwietlenie ca³ej tablicy z wszystkimi s³ówkami
	WlaczPrzyciski()
EndFunc   ;==>DodajPytaniaDoTablicy

Func NowyFiltr() ; Zmiana tablicy filtrów, po zmianie filtru
	WyczyscTabliceFiltrow() ; Czyszczenie tablicy filtrów, bo bêdzie tworzona nowa
	$NumerPytania = 0 ; Wyzerowanie pytania, bo tak
	If GUICtrlRead($Gui_Cisco_Edit_Filtr) = "" Then ; Jeœli nie by³o filtru to wszystkie pytania pasuj¹
		$Array_Tablica_Filtrow = $Array_Tablica_Pytan ; Wiêc tablica filtrów bêdzie ca³¹ tablic¹ pytañ
	Else ; Jeœli by³ filtr
		For $i = 0 To UBound($Array_Tablica_Pytan) - 1
			If StringInStr($Array_Tablica_Pytan[$i][0], GUICtrlRead($Gui_Cisco_Edit_Filtr)) Then ; Jeœli rekord z tablicy pytañ pasuje do filtru, dodaj go do tablicy filtrów
				_ArrayAdd($Array_Tablica_Filtrow, $Array_Tablica_Pytan[$i][0]) ; Dodawanie pytania
				$Array_Tablica_Filtrow[UBound($Array_Tablica_Filtrow)-1][1] = $Array_Tablica_Pytan[$i][1] ; Dodawanie odpowiedzi
			EndIf
		Next
	EndIf

	ZmienPytanie() ; Zmiana pytañ w ramkach i numeru filtru
EndFunc

Func ZmienPytanie()
	If UBound($Array_Tablica_Filtrow) <> 0 Then ; Jeœli s¹ pasuj¹ce wyniki
		GUICtrlSetData($Gui_Cisco_Edit_Pytanie, $Array_Tablica_Filtrow[$NumerPytania][0]) ; Wyœwietl pierwsze pytanie
		GUICtrlSetData($Gui_Cisco_Edit_Odpowiedz, $Array_Tablica_Filtrow[$NumerPytania][1]) ; Wyœwietl odpowiedŸ na pierwsze pytanie
		GUICtrlSetData($Gui_Cisco_Label_PasujaceFiltry, $NumerPytania+1 & " / " & UBound($Array_Tablica_Filtrow)) ; Ustaw odpowiednio licznik
	Else ; Jeœli nie ma pasuj¹cych wyników
		GUICtrlSetData($Gui_Cisco_Edit_Pytanie, "¯adne pytanie nie pasuje do filtru!")
		GUICtrlSetData($Gui_Cisco_Edit_Odpowiedz, "¯adne pytanie nie pasuje do filtru!")
		GUICtrlSetData($Gui_Cisco_Label_PasujaceFiltry, "0 / 0")
	EndIf
EndFunc

Func UsunPytanie()

EndFunc

Func WlaczPrzyciski() ; W³¹czanie przycisków, zeby mozna by³o filtrowaæ wyniki
	If GUICtrlRead($Gui_Cisco_Edit_Filtr) = "Tablica jest pusta!" Then GUICtrlSetData($Gui_Cisco_Edit_Filtr, "") ; Jezeli filtr nie by³ ustawiony, to czyœcimy okienko filtru

	GUICtrlSetState($Gui_Cisco_Edit_Filtr, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Edit_Pytanie, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Edit_Odpowiedz, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Button_PoprzedniePytanie, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Button_Filtruj, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Button_NastepnePytanie, $GUI_ENABLE)
	GUICtrlSetState($Gui_Cisco_Button_UsunPytanieZTablicy, $GUI_ENABLE)

	NowyFiltr() ; Zmiana tablicy filtrów
EndFunc   ;==>WlaczPrzyciski

Func WylaczPrzyciski() ; Wy³¹czanie przycisków, zeby nie narobiæ ba³aganu
	; ************************* Jeœli nie ma pytañ, to po co przyciski maj¹ dzia³aæ? *************************
	GUICtrlSetState($Gui_Cisco_Edit_Filtr, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Edit_Pytanie, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Edit_Odpowiedz, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_PoprzedniePytanie, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_Filtruj, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_NastepnePytanie, $GUI_DISABLE)
	GUICtrlSetState($Gui_Cisco_Button_UsunPytanieZTablicy, $GUI_DISABLE)

	; Wiêc trzeba te¿ ogarn¹æ inputy
	GUICtrlSetData($Gui_Cisco_Edit_Filtr, "Tablica jest pusta!")
	GUICtrlSetData($Gui_Cisco_Edit_Pytanie, "")
	GUICtrlSetData($Gui_Cisco_Edit_Odpowiedz, "")
	GUICtrlSetData($Gui_Cisco_Label_PasujaceFiltry, "0 / 0")
EndFunc

Func __IsConfirmed($Control, $Func) ; Jeœli w EDIT wciœniêto enter wywo³aj ustalon¹ funkcjê
	If StringInStr(GUICtrlRead($Control), @CRLF) Then ; Szukanie {enter} w ci¹gu znaków EDITa
		GUICtrlSetData($Control, StringReplace(GUICtrlRead($Control), @CRLF, "")) ; Usuniêcie {enter} z ci¹gu znaków
		Call($Func)
	EndIf
	;If StringRight(GUICtrlRead($Control), 2) = @CRLF Then  ; Jeœli ostatni znak to {enter}, wtedy wywo³aj funkcjê $Func
EndFunc   ;==>__IsConfirmed
#EndRegion - Funkcje
