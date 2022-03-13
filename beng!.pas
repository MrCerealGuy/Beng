program Beng;

uses
  OWindows, Objects, WinTypes, WinProcs, ODialogs, OStdDlgs,
  Strings, BWCC, OBeng;

const

  InputEditBox1 = 101;
  InputEditBox2 = 102;

type

  TAnwendung = object(TApplication)
    procedure InitMainWindow; virtual;
  end;

  PGameWindow = ^TGameWindow;
  TGameWindow = object(TWindow)
    Name1, Name2: string;
    constructor Init(AParent: PWindowsObject; Title: PChar);
    procedure Verzoegern;
    procedure DrawBMP(DC: HDC; X, Y, BitMap: HBitmap);
    procedure DrawScenario(DC: HDC; X, Y: Integer);
    procedure Kugel_Loeschen(DC: HDC; X, Y: Integer);
    procedure Draw_Explosion(DC: HDC; X, Y: Integer);
    procedure Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); virtual;
    procedure SetUpWindow; virtual;
    function CanClose: Boolean; virtual;
    procedure WMLButtonDown(var Msg: TMessage); virtual wm_First + wm_LButtonDown;
    procedure WMRButtonDown(var Msg: TMessage); virtual wm_First + wm_RButtonDown;
    procedure CMFeuer(var Msg: TMessage); virtual cm_First + cm_Feuer;
    procedure StartNewGame(var Msg: TMessage); virtual cm_First + cm_Neu;
    procedure MakeScenarioGrTal(var Msg: TMessage); virtual cm_First + cm_GrTal;
    procedure MakeScenarioHMond(var Msg: TMessage); virtual cm_First + cm_HMond;
    procedure CMAbout(var Msg: TMessage); virtual cm_First + cm_About;
    procedure CMOptionen(var Msg: TMessage); virtual cm_First + cm_Optionen;
    procedure GetWindowClass(var WndClass: TWndClass); virtual;
    procedure CMBeenden(var Msg: TMessage); virtual cm_First + cm_Beenden;
  end;

{Prozedur zum Beenden des Programmes}
procedure TGameWindow.CMBeenden(var Msg: TMessage);
var
  Antwort: Integer;
begin
  Antwort:=MessageBox(HWindow,'Wollen Sie wirklich beenden?','Spiel beenden', mb_YesNo);
  if Antwort = ID_Yes then Halt;
end;

procedure TGameWindow.GetWindowClass(var WndClass: TWndClass);
begin
  TWindow.GetWindowClass(WndClass);
  WndClass.lpszMenuName := 'Menu_1';
  WndClass.hIcon := LoadIcon(hInstance, 'ICON_1');
  Cursor := LoadCursor(hInstance, 'Cursor_1');
  WndClass.hCursor := Cursor;
end;

procedure TGameWindow.CMOptionen(var Msg: TMessage);
var
  Dialog: TOptionDialog;
begin
  Dialog.Init(@Self,'DIALOG_2');
  Dialog.Execute;
  Dialog.Done;
end;

{Erstellt das Info-Dialog}
procedure TGameWindow.CMAbout(var Msg: TMessage);
var
  Dialog: TDialog;
begin
  Dialog.Init(@Self,'DIALOG_1');
  Dialog.Execute;
  Dialog.Done;
end;

procedure TGameWindow.MakeScenarioGrTal(var Msg: TMessage);
var
  PaintDC: HDC;
  cString: array[0..11] of Char;
begin
  PaintDC:=GetDC(hWindow);
  InvalidateRect(hWindow, nil, True);
  Szenario:=Landschaft1;
  Explosionstyp:=ExplosionGrTal;
  Loeschtyp:=LoeschenGrTal;
  DrawScenario(PaintDC, 0, 0);
  DrawBMP(PaintDC, 90, 80, Kanone1GrTal);
  DrawBMP(PaintDC, 480, 90, Kanone2GrTal);
  DrawBMP(PaintDC, 269, 15, Sonne);
  Punkte1:=0;
  Punkte2:=0;
  Spieler1 := True;
  Feuer:=False;
  Weite1:=5;
  Weite2:=5;
  Hoehe1:=15;
  Hoehe2:=15;
  Geschwindigkeit:=50;
  Str(Punkte1, cString);
  StrCat(cString,' Punkte');
  Stat1^.SetText(cString);
  Str(Punkte2, cString);
  StrCat(cString,' Punkte');
  Stat2^.SetText(cString);
end;

procedure TGameWindow.MakeScenarioHMond(var Msg: TMessage);
var
  PaintDC: HDC;
  cString: array[0..11] of Char;
begin
  PaintDC:=GetDC(hWindow);
  InvalidateRect(hWindow, nil, True);
  Szenario:=Landschaft2;
  DrawScenario(PaintDC, 0, 0);
  Explosionstyp:=ExplosionHMond;
  Loeschtyp:=LoeschenHMond;
  DrawBMP(PaintDC, 33, 380, Kanone1HMond);
  DrawBMP(PaintDC, 501, 380, Kanone2HMond);
  Punkte1:=0;
  Punkte2:=0;
  Spieler1 := True;
  Feuer:=False;
  Weite1:=10;
  Weite2:=10;
  Hoehe1:=30;
  Hoehe2:=30;
  Geschwindigkeit:=50;
  Str(Punkte1, cString);
  StrCat(cString,' Punkte');
  Stat1^.SetText(cString);
  Str(Punkte2, cString);
  StrCat(cString,' Punkte');
  Stat2^.SetText(cString);
end;

procedure TGameWindow.StartNewGame(var Msg: TMessage);
var
  PaintDC: HDC;
  cString: array[0..11] of Char;
  Dialog: TDialog;
begin
  PaintDC:=GetDc(HWindow);
  if Szenario = Landschaft1 then
  begin
    Szenario:=Landschaft1;
    DrawScenario(PaintDC, 0, 0);
    DrawBMP(PaintDC, 90, 80, Kanone1GrTal);
    DrawBMP(PaintDC, 480, 90, Kanone2GrTal);
    DrawBMP(PaintDC, 269, 15, Sonne);
  end;
  if Szenario = Landschaft2 then
  begin
    Szenario:=Landschaft2;
    DrawScenario(PaintDC, 0, 0);
    DrawBMP(PaintDC, 33, 380, Kanone1HMond);
    DrawBMP(PaintDC, 501, 380, Kanone2HMond);
  end;
  Punkte1:=0;
  Punkte2:=0;
  Spieler1 := True;
  Feuer:=False;
  Geschwindigkeit:=50;
  Str(Punkte1, cString);
  StrCat(cString,' Punkte');
  Stat1^.SetText(cString);
  Str(Punkte2, cString);
  StrCat(cString,' Punkte');
  Stat2^.SetText(cString);
end;

procedure TGameWindow.Verzoegern;
var
  a, b: Integer;
begin
  for a:=0 to Verzoegerung do b:=Random(a);
end;

constructor TGameWindow.Init(AParent: PWindowsObject; Title: PChar);
var
  Dialog: TDialog;
  CS1: array[0..20] of Char;
  CS2: array[0..20] of Char;
begin
  TWindow.Init(AParent, Title);
  Attr.Menu:=LoadMenu(hInstance,'MENU_1');
  Attr.X := 80;
  Attr.Y := 60;
  Attr.W := 640;
  Attr.H := 480;
  Attr.Style := WS_Caption or WS_SysMenu or WS_MinimizeBox;
  Randomize;
  Stat1 := New(PStatic,
    Init(@Self, id_Stat1, ' 0 Punkte', 0, 0, 80, 17, 0));
  Stat2 := New(PStatic,
    Init(@Self, id_Stat1, ' 0 Punkte', 560, 0, 80, 17, 0));
 StrPCopy(CS1, Name1);
 SetDlgItemText(HWindow, InputEditBox1, CS1);
 StrPCopy(CS2, Name2);
 SetDlgItemText(HWindow, InputEditBox2, CS2);
 Dialog.Init(@Self,'DIALOG_4');  {Willkommen zu Beng !}
 Dialog.Execute;
 Dialog.Done;
end;

procedure TGameWindow.DrawBMP(DC: HDC; X, Y, BitMap: HBitMap);
var
  MemDC: HDC;
  bm: TBitMap;
  MadeDC: Boolean;
begin
  if DC = 0 then
  begin
    DC := GetDC(HWindow);
    MadeDC := True;
  end
  else
  MadeDC := False;
  MemDC := CreateCompatibleDC(DC);
  SelectObject(MemDC, BitMap);
  GetObject(Landschaft1, SizeOf(bm), @bm);
  BitBlt(DC, X, Y, bm.bmWidth, bm.bmHeight, MemDC, 0, 0, SRCCopy);
  DeleteDC(MemDC);
  if MadeDC then ReleaseDC(HWindow, DC);
end;

procedure TGameWindow.DrawScenario(DC: HDC; X, Y: Integer);
begin
  Bild:=Szenario;
  DrawBMP(DC, X, Y, Bild);
end;

procedure TGameWindow.Kugel_Loeschen(DC: HDC; X, Y: Integer);
begin
  Bild:=Loeschtyp;
  DrawBMP(DC, X, Y, Bild);
end;

procedure TGameWindow.Draw_Explosion(DC: HDC; X, Y: Integer);
begin
  Bild:=Explosionstyp;
  DrawBMP(DC, X, Y, Bild);
end;

procedure TGameWindow.Paint(PaintDC: HDC; var PaintInfo: TPaintStruct);
var
  a, b: Integer;
  Dialog: TDialog;
procedure SzenarioInit;  {Szenario zeichnen}
begin
  if Szenario = Landschaft1 then
  begin
    DrawScenario(PaintDC, 0, 0);
    DrawBMP(PaintDC, 90, 80, Kanone1GrTal);
    DrawBMP(PaintDC, 480, 90, Kanone2GrTal);
    if keineNamen=False then
    begin
      Dialog.Init(@Self,'DIALOG_3');
      Dialog.Execute;
      Dialog.Done;
      keineNamen:=True;
    end;
  end;
  if Szenario = Landschaft2 then
  begin
    DrawBMP(PaintDC, 80, 25, Erde);
    DrawScenario(PaintDC, 0, 0);
    DrawBMP(PaintDC, 33, 380, Kanone1HMond);
    DrawBMP(PaintDC, 501, 380, Kanone2HMond);
    if keineNamen=False then
    begin
      Dialog.Init(@Self,'DIALOG_3');
      Dialog.Execute;
      Dialog.Done;
      keineNamen:=True;
    end;
  end;
end;

begin
  SzenarioInit;
end;

{Prozedur zur Initialisierung}
procedure TGameWindow.SetUpWindow;
begin
  TWindow.SetUpWindow;
  Landschaft1 := LoadBitMap(hInstance, 'Landschaft1');
  Landschaft2 := LoadBitMap(hInstance, 'Landschaft2');
  Kanone1GrTal    := LoadBitMap(hInstance, 'Kanone_1GrTal');
  Kanone2GrTal    := LoadBitMap(hInstance, 'Kanone_2GrTal');
  Kanone1HMond    := LoadBitMap(hInstance, 'Kanone_1HMond');
  Kanone2HMond    := LoadBitMap(hInstance, 'Kanone_2HMond');
  KugelGrTal      := LoadBitMap(hInstance, 'KugelGrTal');
  LoeschenGrTal   := LoadBitMap(hInstance, 'LöschenGrTal');
  LoeschenHMond   := LoadBitMap(hInstance, 'LöschenHMond');
  KugelHMond      := LoadBitMap(hInstance, 'KugelHMond');
  ExplosionGrTal  := LoadBitMap(hInstance, 'ExplosionGrTal');
  ExplosionHMond  := LoadBitMap(hInstance, 'ExplosionHMond');
  Sonne           := LoadBitMap(hInstance, 'Sonne');
  Erde            := LoadBitMap(hInstance, 'Erde');
  Spieler1 := True;
  Feuer:=False;
  Weite1:=5;
  Weite2:=5;
  Hoehe1:=15;
  Hoehe2:=15;
  Verzoegerung:=10000;
  Geschwindigkeit:=50;
  Punkte1:=0;
  Punkte2:=0;
  Szenario:=Landschaft1;
  Loeschtyp:=LoeschenGrTal;
  Explosionstyp:=ExplosionGrTal;
  keineNamen:=False;
  Name1:='Spieler 1';
  Name2:='Spieler 2';
end;

function TGameWindow.CanClose: Boolean;
var
  Antwort: Integer;
begin
  CanClose:=True;
  Antwort:=MessageBox(HWindow,'Wollen Sie wirklich beenden?',
                      'Spiel beenden', mb_YesNo);
  if Antwort = ID_No then CanClose:=False;
end;

{Prozedur zur Eingabe von "Weite"}
procedure TGameWindow.WMLButtonDown(var Msg: TMessage); {Eingabe für Weite}
var
  InputText: array[0..5] of Char;
  ErrorPos: Integer;
begin
  if Spieler1 then
  begin
    Str(Weite1, InputText);
    if Application^.ExecDialog(New(PInputDialog,
       Init(@Self, 'Spieler 1', 'Weite:',
       InputText, SizeOf(InputText)))) = id_Ok then
       begin
         Val(InputText, Weite1, ErrorPos);
         if Weite1 < 0 then
         MessageBox(HWindow,'Weite muss größer sein als 0!',
                    'Fehler',mb_OK or mb_IconExclamation);
       end;
  end
  else
  begin
    Str(Weite2, InputText);
    if Application^.ExecDialog(New(PInputDialog,
       Init(@Self, 'Spieler 2', 'Weite:',
       InputText, SizeOf(InputText)))) = id_Ok then
       begin
         Val(InputText, Weite2, ErrorPos);
         if Weite2 < 0 then
         MessageBox(HWindow,'Weite muss größer sein als 0!',
                    'Fehler',mb_OK or mb_IconExclamation);
       end;
  end;
end;

{Prozedur zur Eingabe von "Höhe"}
procedure TGameWindow.WMRButtonDown(var Msg: TMessage); {Eingabe für Höhe}
var
  InputText: array[0..5] of Char;
  ErrorPos: Integer;
begin
  if Spieler1 then
  begin
    Str(Hoehe1, InputText);
    if Application^.ExecDialog(New(PInputDialog,
       Init(@Self, 'Spieler 1', 'Höhe:',
       InputText, SizeOf(InputText)))) = id_Ok then
       begin
         Val(InputText, Hoehe1, ErrorPos);
         if Hoehe1 < 0 then
         MessageBox(HWindow,'Höhe muss größer sein als 0!',
                    'Fehler',mb_OK or mb_IconExclamation);
       end;
  end
  else
  begin
    Str(Hoehe2, InputText);
    if Application^.ExecDialog(New(PInputDialog,
       Init(@Self, 'Spieler 2', 'Höhe:',
       InputText, SizeOf(InputText)))) = id_Ok then
       begin
         Val(InputText, Hoehe2, ErrorPos);
         if Hoehe2 < 0 then
         MessageBox(HWindow,'Hoehe muss größer sein als 0!',
                    'Fehler',mb_OK or mb_IconExclamation);
       end;
  end;
end;

procedure TGameWindow.CMFeuer(var Msg: TMessage);
var
  PaintDC: HDC;
  a: Integer;

procedure Korrektur(Szenario: HBitMap);
begin
  if Szenario = Landschaft1 then
  begin
     DrawBMP(PaintDC, 480, 90, Kanone2GrTal); {Korrektur}
     DrawBMP(PaintDC, 269, 15, Sonne); {Korrektur}
  end;
  if Szenario = Landschaft2 then
  begin
    DrawBMP(PaintDC, 501, 380, Kanone2HMond); {Korrektur}
    DrawBMP(PaintDC, 80, 25, Erde); {Korrektur}
  end;
end;

procedure Kugel_VerschiebenUm(VerX, VerY: Integer);
var
  X, Y, a: Integer;
  cString: array[0..11] of Char;
begin
  PaintDC:=GetDC(HWindow);
  if Spieler1 then
  begin
    X:=KugelXY.XStart1;
    Y:=KugelXY.YStart1;
  end
  else
  begin
    X:=KugelXY.XStart2;
    Y:=KugelXY.YStart2;
  end;
  if Szenario = Landschaft1 then
  DrawBMP(PaintDC, X+VerX, Y+VerY, KugelGrTal);
  if Szenario = Landschaft2 then
  DrawBMP(PaintDC, X+VerX, Y+VerY, KugelHMond);
  for a:=0 to Geschwindigkeit do
  Verzoegern;
  Kugel_Loeschen(PaintDC, X+VerX, Y+VerY);
  KugelXY.XStart1:=KugelXY.XStart1+VerX;
  KugelXY.YStart1:=KugelXY.YStart1+VerY;
  KugelXY.XStart2:=KugelXY.XStart2+VerX;
  KugelXY.YStart2:=KugelXY.YStart2+VerY;
  if Spieler1 then
    begin
      if (KugelXY.XStart1 >= Grenze1X) and (KugelXY.YStart1 >= Grenze1Y) then
      begin
        Draw_Explosion(PaintDC, KugelXY.XStart1, KugelXY.YStart1);
        for a:=0 to Geschwindigkeit do
          Verzoegern;
        Kugel_Loeschen(PaintDC, KugelXY.XStart1, KugelXY.YStart1);
        Punkte1:=Punkte1+5;
        Str(Punkte1, cString);
        StrCat(cString,' Punkte');
        Stat1^.SetText(cString);
        Spieler1:=False;
      end;
    end
    else
    begin
      if (KugelXY.XStart2 <= Grenze2X) and (KugelXY.YStart2 >= Grenze2Y) then
      begin
        Draw_Explosion(PaintDC, KugelXY.XStart2, KugelXY.YStart2);
        for a:=0 to Geschwindigkeit do
          Verzoegern;
        Kugel_Loeschen(PaintDC, KugelXY.XStart2, KugelXY.YStart2);
        Punkte2:=Punkte2+5;
        Str(Punkte2, cString);
        StrCat(cString,' Punkte');
        Stat2^.SetText(cString);
        Spieler1:=True;
      end;
    end;
end;

begin
  if Szenario=Landschaft1 then
  begin
    KugelXY.XStart1:=180;
    KugelXY.YStart1:=85;
    KugelXY.XStart2:=460;
    KugelXY.YStart2:=100;
    Grenze1X:= 450;
    Grenze1Y:= 140;
    Grenze2X:= 170;
    Grenze2Y:= 90;
  end;
  if Szenario=Landschaft2 then
  begin
    KugelXY.XStart1:=115;
    KugelXY.YStart1:=400;
    KugelXY.XStart2:=497;
    KugelXY.YStart2:=400;
    Grenze1X:= 0;
    Grenze1Y:= 380;
    Grenze2X:= 640;
    Grenze2Y:= 380;
  end;
  if Spieler1 then
  begin
    for a:=0 to Weite1 do
    begin
      Kugel_VerschiebenUm(+10,-1*Hoehe1);
      Korrektur(Szenario);
      if (KugelXY.XStart1>=Grenze1X) and (KugelXY.YStart1 >= Grenze1Y) then Exit;
    end;
    for a:=0 to 5 do
    begin
      Kugel_VerschiebenUm(+10,0);
      Korrektur(Szenario);
      if (KugelXY.XStart1>=Grenze1X) and (KugelXY.YStart1 >= Grenze1Y) then Exit;
    end;
    for a:=Weite1 to 20*Weite1 do
    begin
      Kugel_VerschiebenUm(+10,+1*Hoehe1);
      Korrektur(Szenario);
      if (KugelXY.XStart1>=Grenze1X) and (KugelXY.YStart1 >= Grenze1Y) then Exit;
    end;
    Spieler1:=False;
  end
  else
  begin
    for a:=0 to Weite2 do
    begin
      Kugel_VerschiebenUm(-10,-1*Hoehe2);
      Korrektur(Szenario);
      if (KugelXY.XStart2<=Grenze2X) and (KugelXY.YStart2 >= Grenze2Y) then Exit;
    end;
    for a:=0 to 5 do
    begin
      Kugel_VerschiebenUm(-10,0);
      Korrektur(Szenario);
      if (KugelXY.XStart2<=Grenze2X) and (KugelXY.YStart2 >= Grenze2Y) then Exit;
    end;
    for a:=Weite2 to 20*Weite2 do
    begin
      Kugel_VerschiebenUm(-10,+1*Hoehe2);
      Korrektur(Szenario);
      if (KugelXY.XStart2<=Grenze2X) and (KugelXY.YStart2 >= Grenze2Y) then Exit;
    end;
  Spieler1:=True;
  Exit;
  end;
end;

{-----------------------------TAnwendung----------------------------------}

procedure TAnwendung.InitMainWindow;
begin
  MainWindow := New(PGameWindow, Init(nil, 'Beng!  -Testversion-  von A.Zahnleiter'));
end;

{-----------------------------Main Program--------------------------------}

var
  App: TAnwendung;
begin
  App.Init('Beng');
  App.Run;
  App.Done;
end.
