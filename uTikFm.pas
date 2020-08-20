unit uTikFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, Series, TeEngine, TeeProcs, Chart, ComCtrls;

type
  Data = record
    Time: integer;
    Value: double;
  end;

  TTikFm = class(TForm)
    Chart1: TChart;
    Series1: TFastLineSeries;
    Chart2: TChart;
    Series2: TPointSeries;
    MainMenu1: TMainMenu;
    Createpipe1: TMenuItem;
    GAZR1: TMenuItem;
    SBRF1: TMenuItem;
    Loaddata1: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    procedure Start1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure GAZR1Click(Sender: TObject);
    procedure SBRF1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ReadPipeData;
    function OpenTestPipe: boolean;

    { Public declarations }
  end;

const
  DataArrayLen = 100;
var
  TikFm: TTikFm;
  PipeName: string;
  hMapFile: integer;
  DataArray: array of Data;
implementation

{$R *.dfm}


procedure TTikFm.Start1Click(Sender: TObject);
begin
 Timer1.Enabled:=true;
end;

procedure TTikFm.Stop1Click(Sender: TObject);
begin
 Timer1.Enabled:=false;
end;

procedure TTikFm.ReadPipeData();
const
  c :PChar = '123456789';
type
  t1 = integer;
  t2 = ^t1;
var
  buf: PChar;
//  x: PDataArray2;
  y: t2;
  res: boolean;
  num: Cardinal;
  d1: ^data;
  i: integer;
begin
  Move(DataArray[1], DataArray[0], (DataArrayLen-1)*sizeof(Data));


  GetMem(buf, 4);
  GetMem(d1, sizeof(Data));
  if (hMapFile > 0) then begin
     res:=ReadFile(hMapFile, d1^, sizeof(Data), num, nil);
      StatusBar1.Panels[1].Text:='Read ' + intToStr(num) + ' bytes.';
  end;
  DataArray[DataArrayLen-1]:=d1^;

  try
  if (Series1.Count >= 2) then
    Series1.AddXY(d1.Time, d1.Value)
  else begin
    Series1.AddXY(d1.Time-1, d1.Value);
    Series1.AddXY(d1.Time, d1.Value+1);
  end;

  except
  end;
  for i:=0 to DataArrayLen-1 do begin
    if DataArray[i].Time > 0 then
      Series2.AddXY(DataArray[i].Time, DataArray[i].Value);
  end;
  if Series2.Count < 2 then begin
    Series2.AddXY(DataArray[DataArrayLen-1].Time-1, DataArray[DataArrayLen-1].Value-1);
  end;


  FreeMem(buf);
  FreeMem(d1);

{
    buf:=nil;
    buf:=MapViewOfFile(hMapFile, FILE_MAP_ALL_ACCESS, 0, 0, 0);

    if (buf = nil) then
      ShowMessage('DataLoad Error::CreateFileMapping'+IntToStr(GetLastError()));
    CopyMemory(buf, c, sizeof(c));
    try
      CopyMemory(y, buf, sizeof(integer));
//      CopyMemory(Ptr(integer(buf)+n*sizeof(double)), y, n*sizeof(double));
    except
      ShowMessage('DataLoad Error::CopyMemory');
    end;

//     ShowMessage(IntToStr(integer(x[0]));

      UnmapViewOfFile(buf);
 }
end;

function TTikFm.OpenTestPipe: boolean;
var
  buf: PChar;
//  x: PDataArray2;
begin
  hMapFile:=CreateNamedPipe(PChar(PipeName), 3, 0, 255, 1024, 1024, 0, nil );


//   hMapFile:=CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, sizeof(integer), PipeName);

    if (hMapFile<=0) then begin
      ShowMessage('DataLoad Error::CreateFileMapping.' + IntToStr(GetLastError()));
      result:=false;
      exit;
    end else
      StatusBar1.Panels[0].Text:='Pipe create. '+ PipeName;

//    CloseHandle(hMapFile);
  Series1.Clear();
  Series2.Clear();

  SetLength(DataArray, DataArrayLen);
  FillChar(DataArray[0], DataArrayLen*sizeof(Data), 0);
    result:=true;
//  exit;


{
{
    for i:=0 to n-1 do begin
      ob.SetData(double(tmpx^[i]), double(tmpy^[i]), i);
    end;
}
{

//  ob.SetDataMM(integer(tmpx), integer(tmpy), n);
    ob.SetDataMM(n);
  finally
    try
      ob.FinishLoad;
      UnmapViewOfFile(buf);
      CloseHandle(hMapFile);
    except
      ShowMessage('DataLoad Error');
    end;
  end;
  ob:=Unassigned;
 }
end;

procedure TTikFm.GAZR1Click(Sender: TObject);
begin
  PipeName:= '\\.\pipe\MQL5.Pipe.GAZR'+#0;
  if (not OpenTestPipe()) then
    StatusBar1.Panels[0].Text:='Open Pipe failed.';
end;

procedure TTikFm.SBRF1Click(Sender: TObject);
begin
  PipeName:= '\\.\pipe\MQL5.Pipe.SBRF'+#0;
  if (not OpenTestPipe()) then
    StatusBar1.Panels[0].Text:='Open Pipe failed.';
end;

procedure TTikFm.Timer1Timer(Sender: TObject);
begin
//
  ReadPipeData();
end;

procedure TTikFm.FormResize(Sender: TObject);
begin
//
  Chart1.Left:=0;
  Chart1.Top:=0;
  Chart1.Width:=TikFm.ClientWidth;
  Chart1.Height:=TikFm.ClientHeight div 2 - 10;

  Chart2.Left:=0;
  Chart2.Top:=Chart1.Top+Chart1.Height+1;
  Chart2.Width:=TikFm.ClientWidth;
  Chart2.Height:=TikFm.ClientHeight div 2 - 10;

end;

end.
