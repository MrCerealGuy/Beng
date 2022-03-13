unit OBeng;

interface

uses
  OWindows, Objects, WinTypes, WinProcs, ODialogs, OStdDlgs,
  Strings, BWCC;

{$R Beng}

const
  cm_Neu      = 101;
  cm_About    = 200;
  cm_Beenden  = 102;
  cm_Feuer    = 199;
  cm_Optionen = 103;
  cm_GrTal    = 104;
  cm_HMond    = 105;
  id_Stat1    = 101;
  id_SBGesch  = 300;
  MaxSpeed    = 100;

var

    Verzoegerung, Geschwindigkeit: LongInt;
    Bild, Landschaft1,
    Kanone1GrTal, Kanone2GrTal,
    Kanone1HMond, Kanone2HMond,
    KugelGrTal, LoeschenGrTal,
    ExplosionGrTal, Sonne,
    Szenario, Landschaft2,
    Loeschtyp, KugelHMond,
    LoeschenHMond, ExplosionHMond,
    Explosionstyp, Erde: HBitMap;
    Stat1, Stat2 : PStatic;
    Spieler1, Feuer: Boolean;
    Grenze1X, Grenze1Y,
    Grenze2X, Grenze2Y : LongInt;
    Weite1, Weite2,
    Hoehe1, Hoehe2,
    VerX, VerY,
    Punkte1, Punkte2: Integer;
    Cursor: hCursor;
    keineNamen: Boolean;
    KugelXY: record
       XStart1, YStart1,
       XStart2, YStart2: Integer;
             end;

type

  TOptionDialog = object(TDialog)
    procedure OK(var Message: TMessage); virtual id_First + id_Ok;
    procedure SetUpWindow; virtual;
    procedure WMHScroll(var Message: TMessage); virtual wm_HScroll;
  end;

implementation

{------------------------TOptionDialog-----------------}

procedure TOptionDialog.SetUpWindow;
begin
  TDialog.SetUpWindow;
  SetScrollRange(GetDlgItem(HWindow, id_SBGesch), sb_Ctl, 1,
    MaxSpeed, False);
  SetScrollPos(GetDlgItem(HWindow, id_SBGesch), sb_Ctl,
    MaxSpeed + 6 - Geschwindigkeit, True);
end;

procedure TOptionDialog.WMHScroll(var Message: TMessage);
const
  PageStep = 5;
var
  Pos: Integer;
  Scroll: HWnd;
begin
  Scroll := HiWord(Message.lParam);
  Pos := GetScrollPos(Scroll, SB_Ctl);
  case Message.wParam of
    sb_LineUp: Dec(Pos);
    sb_LineDown: Inc(Pos);
    sb_PageUp: Dec(Pos, PageStep);
    sb_PageDown: Inc(Pos, PageStep);
    sb_ThumbPosition: Pos := LoWord(Message.lParam);
    sb_ThumbTrack: Pos := LoWord(Message.lParam);
  end;
  SetScrollPos(Scroll, sb_Ctl, Pos, True);
end;

procedure TOptionDialog.OK(var Message: TMessage);
var
  NoError: Bool;
begin
  Geschwindigkeit := 100 + 1 - GetScrollPos(
  GetDlgItem(HWindow, id_SBGesch), sb_Ctl) + 5;
  if NoError then
  begin
    EndDlg(id_Ok);
  end
end;

begin
end.