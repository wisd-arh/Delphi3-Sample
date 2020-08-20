unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DdeMan, ComObj, ActiveX, TeEngine, Series,
  TeeProcs, Chart, Math, DateUtils, ComCtrls, mSQAprox, uTikFm;

const
  maxN = 999;
type
  DataArray = array [0..maxN] of double;
  PDataArray = ^DataArray;
  SqPoly = record
    a, b, c: double;
  end;

  _3OrdPoly = record
    a, b, c, d: double;
  end;

{  _5OrdPoly = record
    a, b, c, d, e, f: double;
  end;
}
  _2OrdPoly = record
    a, b, c: double;
  end;

  _1OrdPoly = record
    a, b: double;
  end;

  DataArray2 = array [0..0] of integer;
  PDataArray2 = ^DataArray;

  TForm1 = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Chart1: TChart;
    Button3: TButton;
    Memo1: TMemo;
    Series2: TFastLineSeries;
    Series1: TPointSeries;
    CheckBox1: TCheckBox;
    Button4: TButton;
    Timer2: TTimer;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    StatusBar1: TStatusBar;
    Series3: TLineSeries;
    Demo: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button8: TButton;
    Series4: TLineSeries;
    Button9: TButton;
    Timer3: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure DemoClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    { Private declarations }
//    procedure SqAprox(_x, _y: TReal1DArray; N: integer; var poly: SqPoly);
//    function SqCalc(poly: SqPoly; x: double): double;
    function _3OrdCalc(poly: _3Ordpoly; x: double): double;
    function _3OrdPolyConvert(ta: TReal1DArray): _3OrdPoly;


//    function _5OrdCalc(poly: _5Ordpoly; x: double): double;
//    function _5OrdPolyConvert(ta: TReal1DArray): _5OrdPoly;

//    function _2OrdCalc(poly: _2Ordpoly; x: double): double;
//    function _2OrdPolyConvert(ta: TReal1DArray): _2OrdPoly;

    function _1OrdCalc(poly: _1Ordpoly; x: double): double;
    function _1OrdPolyConvert(ta: TReal1DArray): _1OrdPoly;

    function X2Derivative(poly: _3Ordpoly; x: double): double; overload;
    function X1Derivative(poly: _3Ordpoly; x: double): double; overload;

    procedure UpdateDerivatives(poly: _3Ordpoly; x: double); overload;

//    procedure UpdateDerivatives(poly1: _1Ordpoly; poly3: _3Ordpoly; poly1big: _1Ordpoly; x: double; y: double); overload;
    procedure UpdateDerivatives(poly1: _1Ordpoly; poly3: _3Ordpoly; x: double; y: double); overload;

//    function X2Derivative(poly: _5Ordpoly; x: double): double; overload;
//    function X1Derivative(poly: _5Ordpoly; x: double): double; overload;

//    procedure UpdateDerivatives(poly: _5Ordpoly; x: double); overload;

    procedure FL_Messsage(var Message: TWMChar); message WM_USER;

    procedure UpdateChart();

    procedure Slicing(x, y: PReal; N, SlicingN: Integer; var sx: PReal; var sy: PReal);

    function CalcSigma(x, y: PReal; N: Integer; poly: _3OrdPoly): double;

    function SigmaCheck(): boolean;

    procedure UpdateClient(var Message1: integer); message (WM_USER+1);

  public
    { Public declarations }
  end;


var
  Form1: TForm1;
(*
function GetNumber(): double; stdcall; external 'AXDll.dll';
procedure SetNumber(n: double); stdcall; external 'AXDll.dll';

function RegisterActiveObject(punk: pVariant; refclid: TCLSID; dwFlags: integer; out pdwRegister: Integer): integer; stdcall; external 'OleAut32.dll';
*)
implementation

{$R *.dfm}
const
  XScale: double = 1e-6;
  YScale: double = 100000;

var
  x, y: DataArray;
  mod_X, mod_Y: DataArray;
//  p: double;
  ob: OleVariant;
  waitFlag: boolean;
  sigma: double;

  td1: double;
  td2: double;
//  tpa: double;
//  bigX, bigY: PReal;
//  sbigX, sbigY: PReal;
//  bigN: integer;
//  poly1big: _1OrdPoly;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  UpdateChart();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  timer1.Enabled:=true;
//  SetNumber(random(1000));
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  randomize();
  waitFlag:=false;
  td1:=0;
  td2:=0;
  for i:=0 to maxN do begin
    mod_X[i]:=0;
    mod_Y[i]:=0;
  end;

  try
    ob:=GetActiveOleObject('AXDll.CoAX2');
    StatusBar1.Panels[0].Text:='AXDll.CoAX2: online.';
//    label1.Caption:= 'AXDll.CoAX2: online.'
  except
    on EOleSysError do
      try
        ob:=CreateOleObject('AXDll.CoAX2');
        StatusBar1.Panels[0].Text:='AXDll.CoAX2: online.';
//        label1.Caption:= 'AXDll.CoAX2: online.'
      except
      on E: Exception do
        begin
          StatusBar1.Panels[0].Text:='AXDll.CoAX2: error.';
          ShowMessage(E.Message);
        end;
      end;
  end;

{  GetMem(bigX, sizeof(TReal));
  GetMem(bigY, sizeof(TReal));
  FillChar(bigX^, sizeof(TReal), 0);
  FillChar(bigY^, sizeof(TReal), 0);
  GetMem(sbigX, sizeof(TReal));
  GetMem(sbigY, sizeof(TReal));
  FillChar(sbigX^, sizeof(TReal), 0);
  FillChar(sbigY^, sizeof(TReal), 0);
  bigN:=0;
  tpa:=0;
}
  mSQInit();

end;

procedure TForm1.Button2Click(Sender: TObject);
//var
//  res: integer;
begin
  timer1.Enabled:=false;

(*
  try
    ob:=GetActiveOleObject('AXDll.CoAX2');
  except
    on EOleSysError do
      try
        ob:=CreateOleObject('AXDll.CoAX2');
      except
        on E: Exception do  ShowMessage(E.Message);
      end;
  end;


  ob.Hello;
*)
//  ShowMessage(IntToStr(res));
//  ob:=Unassigned;

(*
  try
    ob:=CreateOleObject('AXDll.CoAX2');
  except
    on E: Exception do  ShowMessage(E.Message);
  end;
*)
//  RegisterActiveObject(@ob, ProgIDToClassID('AXDll.CoAX2'), 1
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  msQDeInit();
{  FreeMem(bigX);
  FreeMem(bigY);
  FreeMem(sbigX);
  FreeMem(sbigY);
}
(*
  try
    ob:=GetActiveOleObject('AXDll.CoAX2');
    ob.Unload;
  except
    on E: Exception do  ShowMessage(E.Message);
  end;
 *)
end;

procedure TForm1.Button3Click(Sender: TObject);
{var
    X : TReal1DArray;
    Y : TReal1DArray;
    N : AlglibInteger;
    I : AlglibInteger;
    T : Double;
    S : Spline1DInterpolant;
    Err : Double;
    MaxErr : Double;
}
begin

    //
    // Interpolation by natural Cubic spline.
    //
(*
    Write(Format('INTERPOLATION BY NATURAL CUBIC SPLINE'#13#10''#13#10'',[]));
    Write(Format('F(x)=sin(x), [0, pi], 3 nodes'#13#10''#13#10'',[]));
    Write(Format('     x   F(x)   S(x)  Error'#13#10'',[]));
*)
    //
    // Create spline
    //
 {   N := 30;
    SetLength(X, N);
    SetLength(Y, N);
    I:=0;
    while I<=N-1 do
    begin
        X[I] := Pi*I/(N-1);
        Y[I] := Sin(X[I]);

        Series1.AddXY(X[i], Y[i]);
        Inc(I);
    end;
    Spline1DBuildCubic(X, Y, N, 2, 0.0, 2, 0.0, S);
 }
    //
    // Output results
    //
{    T := 0;
    MaxErr := 0;
    while AP_FP_Less(T,0.999999*Pi) do
    begin
        Series2.AddXY(T, Spline1DCalc(S, T));
        Err := AbsReal(Spline1DCalc(S, T)-Sin(T));
        MaxErr := Max(Err, MaxErr);
        Memo1.Lines.Add(Format('%6.3f %6.3f %6.3f %6.3f'#13#10'',[
            T,
            Sin(T),
            Spline1DCalc(S, T),
            Err]));
        T := Min(Pi, T+0.025);
    end;
}
(*    Err := AbsReal(Spline1DCalc(S, Pi)-Sin(Pi));
    MaxErr := Max(Err, MaxErr);
    Write(Format('%6.3f %6.3f %6.3f %6.3f'#13#10''#13#10'',[
        Pi,
        Sin(Pi),
        Spline1DCalc(S, Pi),
        Err]));
    Write(Format('max|error| = %0.3f'#13#10'',[
        MaxErr]));
    Write(Format('Try other demos (spline1d_linear, spline1d_hermite) and compare errors...'#13#10''#13#10''#13#10'',[]));
*)
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  i: integer;
begin
  if (random(4) < 3) then exit;

  for i:=0 to maxN-1 do begin
    mod_X[i]:=mod_X[i+1];
    mod_Y[i]:=mod_Y[i+1];
  end;
  mod_X[maxN]:=MilliSecondOfTheDay(Now());
  mod_Y[maxN]:=Max(mod_Y[maxN-1], 1.45) + random(1000)/1000.0 - random(1000)/1000.0;
  try
    ob.BeginLoad;
    for i:=0 to maxN do begin
      ob.SetData(mod_X[i], mod_Y[i], i);
(*
    ob.GetData(i, tx, ty);
    if (x[i] <> tx) or (y[i] <> ty) then
      ShowMessage('DataLoad Error');
 *)
    end;

  finally
    try
      ob.FinishLoad;
    except
      ShowMessage('DataLoad Error');
    end;
  end;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Timer2.Enabled:= not Timer2.Enabled;
  if (Timer2.Enabled = true) then
    Button4.Caption:='Stop'
  else
    Button4.Caption:='Modeling';


end;

procedure TForm1.Button5Click(Sender: TObject);
(*const
n=25;{сюда поставьте 8}
type
TArrayXY = array[1..2,1..n] of real;
TArray = array[1..n] of real;
//var

// SumX,SumY,SumX2,SumXY,SumX3,SumX4,SumX2Y,SumLnY,SumXLnY  : real;
// OPRlin,OPRkvadr,OPRa1,OPRa2,OPRa3  :real;
// a1lin,a2lin,a1kvadr,a2kvadr,a3kvadr,a1exp,a2exp,cexp :real;
 //Xsr,Ysr,S1,S2,S3,Slin,Skvadr,Sexp  :real;
// Kkor,KdetLin,KdetKvadr,KdetExp :real;
// i:byte;


// tx, ty: double;
const
ArrayXY:TArrayXY=((12.85,12.32,11.43,10.59,10.21,9.65,9.63,9.22,8.44,8.07,7.74,7.32,7.08,6.87,5.23,5.02,4.65,4.53,3.24,2.55,1.86,1.76,1.11,0.99,0.72) , (154.77, 145.59,108.37,100.76,98.32,81.43,80.97,79.04,61.76,60.54,55.86,47.63,48.03,36.85,25.65,24.98,22.87,20.32,9.06,6.23,3.91,3.22,1.22,1.10,0.53));
*)
 begin
(*
 SumX:=0.0;
 SumY:=0.0;
 SumXY:=0.0;
 SumX2:=0.0;
 SumX3:=0.0;
 SumX4:=0.0;
 SumX2Y:=0.0;
 SumLnY:=0.0;
 SumXLnY:=0.0;
 { Вычисление сумм x, y, x*y, x^2, x^3, x^4, (x^2)*y, Ln(y), x*Ln(y) }
 for i:=1 to n do
  begin
   SumX:=SumX+ArrayXY[1,i];
   SumY:=SumY+ArrayXY[2,i];
   SumXY:=SumXY+ArrayXY[1,i]*ArrayXY[2,i];
   SumX2:=SumX2+sqr(ArrayXY[1,i]);
   SumX3:=SumX3+ArrayXY[1,i]*ArrayXY[1,i]*ArrayXY[1,i];
   SumX4:=SumX4+sqr(ArrayXY[1,i])*sqr(ArrayXY[1,i]);
   SumX2Y:=SumX2Y+sqr(ArrayXY[1,i])*ArrayXY[2,i];
   SumLnY:=SumLnY+ln(ArrayXY[2,i]);
   SumXLnY:=SumXLnY+ArrayXY[1,i]*ln(ArrayXY[2,i])
  end;
 { Вычисление коэффициентов }
{ OPRlin:=0.0;
 a1lin:=0.0;
 a2lin:=0.0;

 a1kvadr:=0.0;
 OPRkvadr:=0.0;
 a2kvadr:=0.0;
 a2kvadr:=0.0;
{
 a1exp:=0.0;
 a2exp:=0.0;
}
 OPRlin:=n*SumX2-SumX*SumX;
 a1lin:=(SumX2*SumY-SumX*SumXY)/OPRlin;
 a2lin:=(n*SumXY-SumX*SumY)/OPRlin;
 OPRkvadr:=n*SumX2*SumX4+SumX*SumX3*SumX2+SumX2*SumX*SumX3-     SumX2*SumX2*SumX2-n*SumX3*SumX3-SumX*SumX*SumX4;
 a1kvadr:=(SumY*SumX2*SumX4+SumX*SumX2Y*SumX3+SumX2*SumXY*SumX3- SumX2*SumX2*SumX2Y-SumY*SumX3*SumX3-SumX*SumXY*SumX4)/OPRkvadr;
 a2kvadr:=(n*SumXY*SumX4+SumY*SumX3*SumX2+SumX2*SumX*SumX2Y-SumX2*SumX2*SumXY-n*SumX3*SumX2Y-SumY*SumX*SumX4)/OPRkvadr;
 a3kvadr:=(n*SumX2*SumX2Y+SumX*SumXY*SumX2+SumY*SumX*SumX3-SumY*SumX2*SumX2-n*SumXY*SumX3-SumX*SumX*SumX2Y)/OPrkvadr;
 a2exp:=(n*SumXLnY-SumX*SumLnY)/OPRlin;
 cexp:=(SumX2*SumLnY-SumX*SumXLnY)/OPRlin;
 a1exp:=exp(cexp);
 { Вычисление средних арифметических x и y }
 Xsr:=SumX/n;
 Ysr:=SumY/n;
 S1:=0.0;
 S2:=0.0;
 S3:=0.0;
 Slin:=0.0;
 Skvadr:=0.0;
 Sexp:=0.0;
 Kkor:=0.0;
 KdetLin:=0.0;
 KdetKvadr:=0.0;
 KdetExp:=0.0;

for i:=1 to n do
  begin
   S1:=S1+(ArrayXY[1,i]-Xsr)*(ArrayXY[2,i]-Ysr);
   S2:=S2+sqr(ArrayXY[1,i]-Xsr);
   S3:=S3+sqr(ArrayXY[2,i]-Ysr);
   Slin:=Slin+sqr(a1lin+a2lin*ArrayXY[1,i]-ArrayXY[2,i]);
Skvadr:=Skvadr+sqr(a1kvadr+a2kvadr*ArrayXY[1,i]+a3kvadr*ArrayXY[1,i]*ArrayXY[1,i]-ArrayXY[2,i]);
   Sexp:=Sexp+sqr(a1exp*exp(a2exp*ArrayXY[1,i])-ArrayXY[2,i]);
  end;
 { Вычисление коэффициентов корреляции и детерминированности }

 for i:=1 to n do begin
    Series1.AddXY(ArrayXY[1, i], ArrayXY[2, i]);

    tx:=ArrayXY[1, i];
    ty:=a3kvadr*tx*tx+a2kvadr*tx+a1kvadr;
    Series2.AddXY(tx, ty);

    ty:=a1lin+a2lin*tx;
    Series3.AddXY(tx, ty);

    ty:=exp(a2exp*tx)*a1exp + cexp;
    Series4.AddXY(tx, ty);
 end;
 Kkor:=S1/sqrt(S2*S3);
 KdetLin:=1-Slin/S3;
 KdetKvadr:=1-Skvadr/S3;
 KdetExp:=1-Sexp/S3;
 { Вывод результатов }
 Memo1.Lines.Add('Линейная функция');
 Memo1.Lines.Add(Format('a1=%8.5f',[a1lin]));
 Memo1.Lines.Add(Format('a2=%8.5f',[a2lin]));
 Memo1.Lines.Add('Квадратичная функция');
 Memo1.Lines.Add(Format('a1=%8.5f',[a1kvadr]));
 Memo1.Lines.Add(Format('a2=%8.5f',[a2kvadr]));
 Memo1.Lines.Add(Format('a3=%8.5f',[a3kvadr]));
 Memo1.Lines.Add('Экспоненциальная функция');
 Memo1.Lines.Add(Format('a1=%8.5f',[a1exp]));
 Memo1.Lines.Add(Format('a2=%8.5f',[a2exp]));
 Memo1.Lines.Add(Format('c=%8.5f',[cexp]));
 Memo1.Lines.Add(Format('Xcp=%8.5f',[Xsr]));
 Memo1.Lines.Add(Format('Ycp=%8.5f',[Ysr]));
 Memo1.Lines.Add(Format('Коэффициент корреляции %8.5f',[Kkor]));
 Memo1.Lines.Add(Format('Коэффициент детерминированности (линейная аппроксимация) %8.5f',[KdetLin]));
 Memo1.Lines.Add(Format('Коэффициент детерминированности (квадратическая аппроксимация) %8.5f',[KdetKvadr]));
 Memo1.Lines.Add(Format('Коэффициент детерминированности (экспоненциальная аппроксимация) ',[KdetExp]));
*)

end;
(*
procedure TForm1.SqAprox(_x, _y: TReal1DArray; N: integer; var poly: SqPoly);
var
  SumX,SumY,SumX2,SumXY,SumX3,SumX4,SumX2Y,SumLnY,SumXLnY  : Extended;
//  ,OPRa1,OPRa2,OPRa3
  OPRlin,OPRkvadr:Extended;

//  ,a1exp,a2exp,cexp

  a1lin,a2lin,a1kvadr,a2kvadr,a3kvadr:double;
//  Xsr,Ysr,S1,S2,S3,Slin,,Sexp
//  Skvadr:double;
//  Kkor,KdetLin,KdetKvadr,KdetExp :double;
  i:integer;

begin
 SumX:=0.0;
 SumY:=0.0;
 SumXY:=0.0;
 SumX2:=0.0;
 SumX3:=0.0;
 SumX4:=0.0;
 SumX2Y:=0.0;
 SumLnY:=0.0;
 SumXLnY:=0.0;
 { Вычисление сумм x, y, x*y, x^2, x^3, x^4, (x^2)*y, Ln(y), x*Ln(y) }
 for i:=0 to n-1 do
  begin
   SumX:=SumX+_X[i];
   SumY:=SumY+_Y[i];
   SumXY:=SumXY+_X[i]*_Y[i];
   SumX2:=SumX2+sqr(_X[i]);
   SumX3:=SumX3+_X[i]*_X[i]*_X[i];
   SumX4:=SumX4+sqr(_X[i])*sqr(_X[i]);
   SumX2Y:=SumX2Y+sqr(_X[i])*_Y[i];
   SumLnY:=SumLnY+ln(_Y[i]);
   SumXLnY:=SumXLnY+_X[i]*ln(_Y[i])
  end;

 { Вычисление коэффициентов }
   OPRlin:=0.0;
   a1lin:=0.0;
   a2lin:=0.0;
   a1kvadr:=0.0;
   OPRkvadr:=0.0;
   a2kvadr:=0.0;
   a2kvadr:=0.0;
//   a1exp:=0.0;
//   a2exp:=0.0;

   OPRlin:=n*SumX2-SumX*SumX;
   a1lin:=(SumX2*SumY-SumX*SumXY)/OPRlin;
   a2lin:=(n*SumXY-SumX*SumY)/OPRlin;
{
 OPRkvadr:=0.00001 + n*SumX2*SumX4+SumX*SumX3*SumX2+SumX2*SumX*SumX3-     SumX2*SumX2*SumX2-n*SumX3*SumX3-SumX*SumX*SumX4;
 a1kvadr:=(SumY*SumX2*SumX4+SumX*SumX2Y*SumX3+SumX2*SumXY*SumX3- SumX2*SumX2*SumX2Y-SumY*SumX3*SumX3-SumX*SumXY*SumX4)/OPRkvadr;
 a2kvadr:=(n*SumXY*SumX4+SumY*SumX3*SumX2+SumX2*SumX*SumX2Y-SumX2*SumX2*SumXY-n*SumX3*SumX2Y-SumY*SumX*SumX4)/OPRkvadr;
 a3kvadr:=(n*SumX2*SumX2Y+SumX*SumXY*SumX2+SumY*SumX*SumX3-SumY*SumX2*SumX2-n*SumXY*SumX3-SumX*SumX*SumX2Y)/OPrkvadr;

}

   poly.a:= a1lin;//a3kvadr;
   poly.b:=  a2lin;// a2kvadr;
   poly.c:=a1kvadr;

(*
   a2exp:=(n*SumXLnY-SumX*SumLnY)/OPRlin;
   cexp:=(SumX2*SumLnY-SumX*SumXLnY)/OPRlin;
   a1exp:=exp(cexp);
*)
   { Вычисление средних арифметических x и y }
(*
   Xsr:=SumX/n;
   Ysr:=SumY/n;
   S1:=0.0;
   S2:=0.0;
   S3:=0.0;
   Slin:=0.0;
   Skvadr:=0.0;
   Sexp:=0.0;
   Kkor:=0.0;
   KdetLin:=0.0;
   KdetKvadr:=0.0;
   KdetExp:=0.0;

  for i:=0 to n-1 do
    begin
     S1:=S1+(X[i]-Xsr)*(Y[i]-Ysr);
     S2:=S2+sqr(X[i]-Xsr);
     S3:=S3+sqr(Y[i]-Ysr);
     Slin:=Slin+sqr(a1lin+a2lin*X[i]-Y[i]);
     Skvadr:=Skvadr+sqr(a1kvadr+a2kvadr*X[i]+a3kvadr*X[i]*X[i]-Y[i]);
     Sexp:=Sexp+sqr(a1exp*exp(a2exp*X[i])-Y[i]);
    end;
 { Вычисление коэффициентов корреляции и детерминированности }

 Kkor:=S1/sqrt(S2*S3);
 KdetLin:=1-Slin/S3;
 KdetKvadr:=1-Skvadr/S3;
 KdetExp:=1-Sexp/S3;
 *)
(*
end;

function TForm1.SqCalc(poly: SqPoly; x: double): double;
begin
  result:=poly.a*x*x+poly.b*x+poly.c;
end;
 *)
procedure TForm1.Button6Click(Sender: TObject);
var
  tx, ty: PReal;
  ta: TReal1DArray;
  i, tN: integer;
  tpoly: _3OrdPoly;
begin
{  SetLength(tx, maxN+1);
  SetLength(ty, maxN+1);
}

  GetMem(tx, sizeof(TReal));
  GetMem(ty, sizeof(TReal));
  SetLength(ta, maxN+1);

  tN:=0;
  for i:=0 to maxN do begin
    if (Abs(x[i])>0) then begin
      tx[tN]:=x[i];
      ty[tN]:=y[i];
      Inc(tN);
    end;
  end;

  SQA(tx, ty, tN, ta);
  tpoly.d:=ta[0];
  tpoly.c:=ta[1];
  tpoly.b:=ta[2];
  tpoly.a:=ta[3];
{
  Series2.Clear();
  for i:=0 to tN-1 do begin
    Series2.AddXY(tx[i], _3OrdCalc(tpoly, tx[i]));
  end;}
end;

function TForm1._3OrdCalc(poly: _3Ordpoly; x: double): double;
begin
  result:=poly.a*x*x*x + poly.b*x*x + poly.c*x + poly.d;
end;

{
function TForm1._5OrdCalc(poly: _5Ordpoly; x: double): double;
begin
  result:=poly.a*x*x*x*x*x + poly.b*x*x*x*x + poly.c*x*x*x + poly.d*x*x + poly.e*x + poly.f;
end;
}

function TForm1._3OrdPolyConvert(ta: TReal1DArray): _3OrdPoly;
begin
  result.d:=ta[0];
  result.c:=ta[1];
  result.b:=ta[2];
  result.a:=ta[3];
end;

{
function TForm1._5OrdPolyConvert(ta: TReal1DArray): _5OrdPoly;
begin
  result.f:=ta[0];
  result.e:=ta[1];
  result.d:=ta[2];
  result.c:=ta[3];
  result.b:=ta[4];
  result.a:=ta[5];
end;

}
procedure TForm1.UpdateDerivatives(poly: _3Ordpoly; x: double);
var
  d1, d2: double;
//  td1, td2: double;

begin
//  ob.SetDerivatives(X1Derivative(poly, x), X2Derivative(poly, x));

  d1:=X1Derivative(poly, x);
  d2:=X2Derivative(poly, x);

  StatusBar1.Panels[2].Text:='d1: ' + FloatToStrF(d1, ffGeneral, 4, 4);
  StatusBar1.Panels[3].Text:='d2: ' + FloatToStrF(d2, ffGeneral, 4, 4);

  try
    if (SigmaCheck() = false) then begin
      d1:=0;
      d2:=0;
    end;
    ob.SetDerivatives(d1, d2);
{    ob.GetDerivatives(td1, td2);
    if ((Abs(td1 - d1) > 0.00001) or (Abs(td2 - d2) > 0.00001)) then
      memo1.Lines.Add('UPDer::Err');
}
//    Memo1.Lines.Add(Format('%5.8f  %5.8f', [td1, td2]));
  except
  end;
end;

function TForm1.X1Derivative(poly: _3Ordpoly; x: double): double;
begin
// ax3 + bx2 + cx + d
  result:=3*poly.a*x*x + 2*poly.b*x + poly.c;
end;

function TForm1.X2Derivative(poly: _3Ordpoly; x: double): double;
begin
// 3ax2 + 2bx  + c;
  result:=6*poly.a*x + 2*poly.b;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  csi: TStartupInfo;
  lpProcessInformation: TProcessInformation;
begin
  ZeroMemory(@csi, sizeof(TStartupInfo));
  csi.cb:=sizeof(TStartupInfo);

//  winexec('C:\Program Files\FxPro - MetaTrader\terminal.exe', SW_SHOWNORMAL);
{CreateProcess(lpApplicationName: PChar; lpCommandLine: PChar;
  lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
  bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
  lpCurrentDirectory: PChar; const lpStartupInfo: TStartupInfo;
  var lpProcessInformation: TProcessInformation): BOOL; stdcall;}
  CreateProcess('C:\Program Files\FxPro - MetaTrader 4\terminal.exe', '', nil, nil, false,
    CREATE_DEFAULT_ERROR_MODE or NORMAL_PRIORITY_CLASS, nil, 'C:\Program Files\FxPro - MetaTrader\',
    csi, lpProcessInformation);

end;
(*
procedure TForm1.UpdateDerivatives(poly: _5Ordpoly; x: double);
var
  d1, d2: double;
  td1, td2: double;

begin
//  ob.SetDerivatives(X1Derivative(poly, x), X2Derivative(poly, x));

  d1:=X1Derivative(poly, x);
  d2:=X2Derivative(poly, x);

  StatusBar1.Panels[2].Text:='d1: ' + FloatToStrF(d1, ffGeneral, 4, 4);
  StatusBar1.Panels[3].Text:='d2: ' + FloatToStrF(d2, ffGeneral, 4, 4);
  try
    ob.SetDerivatives(d1, d2);
{    ob.GetDerivatives(td1, td2);
    if ((Abs(td1 - d1) > 0.00001) or (Abs(td2 - d2) > 0.00001)) then
      memo1.Lines.Add('UPDer::Err');
}
//    Memo1.Lines.Add(Format('%5.8f  %5.8f', [td1, td2]));
  except
  end;

end;
 *)
 (*
function TForm1.X1Derivative(poly: _5Ordpoly; x: double): double;
begin
// ax5 + bx4 + cx3 + dx2 + ex + f
  result:=5*poly.a*x*x*x*x + 4*poly.b*x*x*x + 3*poly.c*x*x + 2*poly.d*x + poly.e;

end;

function TForm1.X2Derivative(poly: _5Ordpoly; x: double): double;
begin
// 5ax4 + 4bx3 + 3cx2 + 2dx + e
  result:=20*poly.a*x*x*x + 12*poly.b*x*x + 6*poly.c*x + 2*poly.d;
end;

 *)
{
function TForm1._2OrdCalc(poly: _2Ordpoly; x: double): double;
begin
  result:=poly.a*x*x + poly.b*x + poly.c;
end;

function TForm1._2OrdPolyConvert(ta: TReal1DArray): _2OrdPoly;
begin
  result.c:=ta[0];
  result.b:=ta[1];
  result.a:=ta[2];
end;
}
function TForm1._1OrdCalc(poly: _1Ordpoly; x: double): double;
begin
  result:=poly.a*x + poly.b;
end;

function TForm1._1OrdPolyConvert(ta: TReal1DArray): _1OrdPoly;
begin
  result.b:=ta[0];
  result.a:=ta[1];
end;

procedure TForm1.DemoClick(Sender: TObject);
begin
  if (CheckBox1.Checked) then
    Timer1.Interval:=301
  else
    Timer1.Interval:=60;
end;

procedure TForm1.FL_Messsage(var Message: TWMChar);
begin
//  if (Timer1.Enabled) then
  if (CheckBox2.Checked) then
    UpdateChart;
end;

procedure TForm1.UpdateChart;
const
  visStep = 11;
  slicingN = 100;
var
  i: integer;
//  s: string;
  tx, ty: PReal;
  ta1, ta3: TReal1DArray;
//  , ta3s, ta1s: TReal1DArray; //ta, ta5, ta2,
  sx, sy: PReal;
  n: Integer;
//  newX: double;
//  poly : Spline1DInterpolant;
//  P : BarycentricInterpolant;
//  poly1: SqPoly;
  poly3: _3OrdPoly; // , poly3s

  poly1: _1OrdPoly; //, poly1s
//  poly2: _2OrdPoly;
//  poly5: _5OrdPoly;
  tmpx, tmpy: PDataArray;
  tmpn: integer;
begin
  i:=0;
  ob.IsLoading(i);
  if (i = 1) then begin
    if (waitFlag = false) then
      StatusBar1.Panels[1].Text:='waiting...';
    waitFlag:=true;

    //    Label2.Caption:='waiting...';
//    Form1.Update;
//    Application.ProcessMessages;
    Exit;
  end else begin
    if (waitFlag = true) then
      StatusBar1.Panels[1].Text:='';
    waitFlag:=false;
//    Label2.Caption:='';
//    Form1.Update;
  end;

  GetMem(tx, sizeof(TReal));
  GetMem(ty, sizeof(TReal));
  GetMem(sx, sizeof(TReal));
  GetMem(sy, sizeof(TReal));
//  Timer1.Enabled:=false;
(*  i:=1;
  while (i = 1) do begin
    i:=0;
    ob.IsLoading(i);
    if (i = 1) then begin
      StatusBar1.Panels[1].Text:='waiting...';
//      Label2.Caption:='waiting...';
      Form1.Update;
      Application.ProcessMessages;
      Sleep(100);
    end;
  end;
*)

  if (Series1.XValues.Count > 0) then
    Series1.Clear();
  if (Series2.XValues.Count > 0) then
    Series2.Clear();
  if (Series3.XValues.Count > 0) then
    Series3.Clear();
  if (Series4.XValues.Count > 0) then
    Series4.Clear();
{  Series4.Clear();
  Series5.Clear();
  Series6.Clear();
}


{  SetLength(tx, maxN+1);
  SetLength(ty, maxN+1);
}
  SetLength(ta3, maxN+1);
  SetLength(ta1, maxN+1);
{
  SetLength(ta3s, maxN+1);
  SetLength(ta1s, maxN+1);
  SetLength(sx, maxN+1);
  SetLength(sy, maxN+1);
}
//  SetLength(ta5, maxN+1);

  N:=0;
  try
    ob.BeginRead;

// Старый механизм передачи
//    for i:=0 to maxN do begin
//      ob.GetData(i, x[i], y[i]);
//      x[i]:=x[i]*XScale;
//      y[i]:=y[i]*YScale;

/// Новый
    GetMem(tmpx, (maxN+1)*sizeof(double));
    GetMem(tmpy, (maxN+1)*sizeof(double));
    ob.GetDataMM(integer(tmpx), integer(tmpy), tmpn);
    for i:=0 to tmpn-1 do begin
///      x[i]:=tmpx^[i]*XScale;
///      y[i]:=tmpy^[i]*YScale;

/////////////////




//    s:='x['+IntToStr(i)+']=' + FloatToStr(x[i]) + ', ' + 'y['+IntToStr(i)+']=' + FloatToStr(y[i]);
//    ShowMessage(s);

//старый
//      if (x[i] > 0) then begin
      if (tmpx^[i] > 0) then begin
//старый
//          Series1.AddXY(x[i], y[i]);
//        tx[N]:=x[i];
//        ty[N]:=y[i];
        tx[N]:=tmpx^[i]*XScale;
        ty[N]:=tmpy^[i]*YScale;
//        if ((not ((i=999)and(N=0)))and(CheckBox3.Checked)) then

        if (CheckBox3.Checked) then
          Series1.AddXY(tx[N], ty[N]);
        Inc(N);

//      Series1.Add(y[i]);
//    StatusBar1.Panels[1].Text:=s;//'loading...';
////      Label2.Caption:=s;//'loading...';
//      Form1.Update;
      end;
//    Form1.Refresh;
    end;
{    if (bigN < mSQAprox.maxN) then begin
      bigX[bigN]:=tx[N-1];
      bigY[bigN]:=ty[N-1];
      Inc(bigN);
    end else begin
      CopyMemory(bigX, Ptr(Integer(bigX)+sizeof(Extended)), sizeof(TReal)-sizeof(Extended));
      CopyMemory(bigY, Ptr(Integer(bigY)+sizeof(Extended)), sizeof(TReal)-sizeof(Extended));
      bigX[mSQAprox.maxN-1]:=tx[N-1];
      bigY[mSQAprox.maxN-1]:=ty[N-1];
    end;
}
    FreeMem(tmpx);
    FreeMem(tmpy);
    ob.FinishRead;
  except
    on E: Exception do begin
      ob.FinishRead;
      ShowMessage(E.Message);
    end;
  end;
  if (N = 0) then begin
    Freemem(tx);
    Freemem(ty);
    Freemem(sx);
    Freemem(sy);
{    SetLength(tx, 0);
    SetLength(ty, 0);
}
    SetLength(ta3, 0);
    SetLength(ta1, 0);
//    SetLength(ta5, 0);
//    Timer1.Enabled:=true;
    exit;
  end;
// Заглушка против ошибки компонента.
  if (N = 1) then
    Series1.Clear();

  if (N > 300) then
    Slicing(tx, ty, N, slicingN, sx, sy);

//  Memo1.Lines.Add('---------');
//  for i:=0 to slicingN-1 do begin
//    Series4.AddXY(sx[i], sy[i]);
//    Memo1.Lines.Add(FloatToStr(sy[i]));
//  end;
///  Memo1.Lines.Add('N='+Inttostr(N));
(*
// получить из библиотеки.
  p:=GetNumber();
  StatusBar1.Panels[1].Text:=FloatToStr(p);
//  label1.Caption := FloatToStr(p);
  Form1.Refresh;

  Form1.Update;
 *)
{
  if (N > 3) then
    label1.Caption:=FloatToStr(tx[N-1]-tx[0]);
}
//  try
//  if (CheckBox3.Checked = true) then begin
  StatusBar1.Panels[5].Text:='N: ' + IntTostr(N);
//  end;
  if ((N > 300) and (CheckBox1.Checked)) then begin

//    PolynomialBuild(tx, ty, N, P);
//    SqAprox(tx, ty, N, poly1);

//    SQA(tx, ty, N, ta2, 2);
//    poly2:=_2OrdPolyConvert(ta2);
//    SQA(tx, ty, N, ta5, 5);
//    poly5:=_5OrdPolyConvert(ta5);
{
    SQA(tx, ty, N, ta3);
    poly3:=_3OrdPolyConvert(ta3);
    SQA(tx, ty, N, ta1, 1);
    poly1:=_1OrdPolyConvert(ta1);
}

    SQA(sx, sy, slicingN, ta3);
    poly3:=_3OrdPolyConvert(ta3);
    SQA(sx, sy, slicingN, ta1, 1);
    poly1:=_1OrdPolyConvert(ta1);
{
    if (bigN = mSQAprox.maxN) then begin
      Slicing(bigX, bigY, bigN, slicingN, sbigX, sbigY);
      SQA(sbigX, sbigY, slicingN, ta1, 1);
      poly1big:=_1OrdPolyConvert(ta1);
    end else poly1big.a:=0;
}


//    sigma:=CalcSigma(tx, ty, N, poly3);
    sigma:=CalcSigma(sx, sy, slicingN, poly3);

// взаимоисключаемы
//    UpdateDerivatives(poly2, tx[N-1]);
//    UpdateDerivatives(poly3, tx[N-1]);
    UpdateDerivatives(poly1, poly3, tx[N-1]-tx[0], ty[N-1]);
//    Spline1DBuildCubic(tx, ty, N, 2, 0.0, 2, 0.0, poly);

//    if N > 3 then

// зАМенить на постоянное число шагов.
    if (CheckBox3.Checked) then begin
      StatusBar1.Panels[4].Text:='E: ' + FloatToStrF(sigma, ffFixed, 8, 3);
      for i:=0 to visStep do begin
//      Series2.AddXY(tx[i], Spline1DCalc(poly, tx[i]));
//      Series2.AddXY(tx[0] + i*(tx[N-1] - tx[0])/(N-1), Spline1DCalc(poly, tx[0] + i*(tx[N-1] - tx[0])/(N-1)));
//      Series2.AddXY(tx[0] + i*(tx[N-1] - tx[0])/(N-1), BarycentricCalc(P, tx[0] + i*(tx[N-1] - tx[0])/(N-1)));
//      Series2.AddXY(tx[0] + i*(tx[N-1] - tx[0])/(N-1), SqCalc(poly1, tx[0] + i*(tx[N-1] - tx[0])/(N-1)));

//      Series2.AddXY(tx[0] + i*(tx[N-1] - tx[0])/(N-1), poly1.a  + poly1.b*(tx[0] + i*(tx[N-1] - tx[0])/(N-1)));


//      Series2.AddXY(tx[0] + i*(tx[N-1] - tx[0])/19, _3OrdCalc(poly2, tx[0] + i*(tx[N-1] - tx[0])/19));
//      Series2.AddXY(tx[i], _3OrdCalc(poly2, tx[i]));
//      Series2.AddXY(tx[0] + i*(tx[N-1] - tx[0])/19, _2OrdCalc(poly2, tx[0] + i*(tx[N-1] - tx[0])/19));
{
        Series3.AddXY(tx[0] + i*(tx[N-1] - tx[0])/visStep, _3OrdCalc(poly3, tx[0] + i*(tx[N-1] - tx[0])/visStep));
        Series2.AddXY(tx[0] + i*(tx[N-1] - tx[0])/visStep, _1OrdCalc(poly1, tx[0] + i*(tx[N-1] - tx[0])/visStep));
}
        Series3.AddXY(tx[0] + i*(tx[N-1] - tx[0])/visStep, _3OrdCalc(poly3, sx[0] + i*(sx[SlicingN-1] - sx[0])/visStep));
//        Series2.AddXY(tx[0] + i*(tx[N-1] - tx[0])/visStep, _1OrdCalc(poly1, sx[0] + i*(sx[SlicingN-1] - sx[0])/visStep));

{      Series5.AddXY(tx[0] + i*(tx[N-1] - tx[0])/visStep, _3OrdCalc(poly3s, tx[0] + i*(tx[N-1] - tx[0])/visStep));

      Series6.AddXY(tx[0] + i*(tx[N-1] - tx[0])/visStep, _1OrdCalc(poly1s, tx[0] + i*(tx[N-1] - tx[0])/visStep));
}
      end;
      Series2.AddXY(tx[0], _1OrdCalc(poly1, sx[0]));
      Series2.AddXY(tx[N-1], _1OrdCalc(poly1, sx[SlicingN-1]));
{      if (bigN = mSQAprox.maxN) then begin
        Series4.AddXY(tx[0], _1OrdCalc(poly1big, sx[0]));
        Series4.AddXY(tx[N-1], _1OrdCalc(poly1big, sx[SlicingN-1]));
      end;
      }
    end;
// Прогноз
//    newX:=tx[N-1]+200;
//    Series2.AddXY(newX, Spline1DCalc(poly, newX));
  end;


{  SetLength(tx, 0);
  SetLength(ty, 0);
}
  FreeMem(tx);
  FreeMem(ty);
  Freemem(sx);
  Freemem(sy);
  SetLength(ta3, 0);
  SetLength(ta1, 0);
//  SetLength(ta5, 0);

//  except
//  end;

//  StatusBar1.Panels[0].Text:='';//s;//'loading...';
////    Label2.Caption:='';//s;//'loading...';

//  Timer1.Enabled:=true;

end;

//procedure TForm1.UpdateDerivatives(poly1: _1Ordpoly; poly3: _3Ordpoly;
//  poly1big: _1Ordpoly; x, y: double);
procedure TForm1.UpdateDerivatives(poly1: _1Ordpoly; poly3: _3Ordpoly; x, y: double);
var
  d1, d2: double;
//  td1, td2: double;

  p3Value, p1Value: double;

//  forecast1, forecast2: double;
  hipN: double;
//  f: TextFile;
//  Delta: double;
begin
{ forecast1:=0;
  forecast2:=0;

  d1:=X1Derivative(poly3, x);
  d2:=X2Derivative(poly3, x);

  if (CheckBox3.Checked) then begin
    StatusBar1.Panels[2].Text:='d1: ' + FloatToStrF(d1, ffFixed, 8, 3);
    StatusBar1.Panels[3].Text:='d2: ' + FloatToStrF(d2, ffFixed, 8, 3);
  end;

  p3Value:=_3OrdCalc(poly3, x);
  p1Value:=_1OrdCalc(poly1, x);

  if ((d1>0)and(d2>0)and(poly1.a>0)and(p3Value >p1Value)and(p1Value>y)) then
    begin
//      Memo1.Lines.Add(FloatToStr(y));
      forecast1:=1;
    end;


  if ((d1<0)and(d2<0)and(poly1.a<0)and(p3Value < p1Value)and(p1Value<y)) then
    begin
//      Memo1.Lines.Add(FloatToStr(y));
      forecast2:=1;
    end;

  if (SigmaCheck() = false) then begin
    forecast1:=0;
    forecast2:=0;
  end;
  try
    ob.SetDerivatives(forecast1, forecast2, Sigma, (p3Value-p1Value), poly1.a);
  except
  end;
}

  hipN:=0;
{
  if ((tpa < 0) and (poly1big.a > 0)) then begin
// sigma not used
    hipN:=14;
    ob.SetDerivatives(hipN, 0, 0, 0, 0);
    tpa:=poly1big.a;

    AssignFile(f, 'c:\1.txt');
    Reset(f);
    Writeln(f, DateTimeToStr(Now()));
    CloseFile(f);
    exit;
  end;
  tpa:=poly1big.a;
}
  d1:=X1Derivative(poly3, x);
  d2:=X2Derivative(poly3, x);

  if (SigmaCheck() = false) then begin
    ob.SetDerivatives(0, 0, 0, 0, 0);
    td1:=d1;
    td2:=d2;
    exit;
  end;

  p3Value:=_3OrdCalc(poly3, x);
  p1Value:=_1OrdCalc(poly1, x);

  if ((d1 > 0) and (d2 > 0) and (poly1.a > 0) and (p3Value > p1Value) and (p1Value >y)) then
    hipN:=7;

  if (td1 > 0) and (d1 < 0) then
    hipN:=3;

// Гипотеза 2 // Sell
//      if (tx1 > 0) and (tx2 < 0) and (cx1 < 0) and (cx2 < 0) then
  if (td1 > 0) and (td2 < 0) and (d1 < 0) and (d2 < 2) then
    hipN:=2;

// Гипотеза 8 // SELL
//      if ((cx1 > 0) and (poly1.a > 0) and (p3V > p1V) and (p1V > y[N-1])) then
  if ((d1 > 0) and (poly1.a > 0) and (p3Value > p1Value) and (p1Value > y)) then
    hipN:=8;

// Гипотеза 19 // SELL
  if ((d1 < 0) and (poly1.a > 0) and (td1 > 0)) then
    hipN:=19;

  ob.SetDerivatives(hipN, 0, Sigma, (p3Value-p1Value), poly1.a);

  td1:=d1;
  td2:=d2;

  if (CheckBox3.Checked) then begin
    StatusBar1.Panels[2].Text:='d1: ' + FloatToStrF(d1, ffFixed, 8, 3);
    StatusBar1.Panels[3].Text:='d2: ' + FloatToStrF(d2, ffFixed, 8, 3);
  end;
end;

procedure TForm1.Slicing(x, y: PReal; N, SlicingN: Integer; var sx,
  sy: PReal);

var
  i, c, k, l: integer;
  step, count: integer;
  mx, my: double;
begin
  step:=N div SlicingN;
  if (step  < 1) then exit;
  count:=1;
  c:=0;
  mx:=0;
  my:=0;
  k:=0;
  l:=0;
  for i:=0 to N-1 do begin
    mx:=mx+x[i];
    my:=my+y[i];
    Inc(c);
    Inc(l);
    if (c >= step*count) then begin
      sx[k]:=mx/l;
      sy[k]:=my/l;
      mx:=0;
      my:=0;
      l:=0;
      Inc(k);
      Inc(count);
    end;
  end;

  if (step*(count-1) < N) then begin
    sx[k]:=mx/l;
    sy[k]:=my/l;
  end;

//Перенос в начало координат.
  mx:=sx[0];
  for i:=0 to SlicingN-1 do begin
    sx[i]:=sx[i]-mx;
  end;
end;

function TForm1.CalcSigma(x, y: PReal; N: Integer;
  poly: _3OrdPoly): double;

var
  i: integer;
  tp: double;
  te: double;
begin
//Ошибка зависит от первичного масштабирования массивов с данными!
  te:=0.0;
  for i:=0 to N-1 do begin
    tp:=_3OrdCalc(poly, x[i]);
    te:=te+sqr(y[i]-tp);
  end;
  result:=sqrt(te/N); // /YScale
end;

function TForm1.SigmaCheck: boolean;
const
  SigmaValue = 15;
begin
  result:=false;
  if (Sigma < SigmaValue) then
    result:=true;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  a, b: PDataArray;
  i, c: integer;
begin
  GetMem(a, (maxN+1)*sizeof(double));
//  GetMem(b, (maxN+1)*sizeof(double));
  for i:=0 to maxN do begin
    a[i]:=random(1000);
    Series1.Add(a^[i]);
  end;

  c:=integer(a);
////////////////////////////////

  b:=Pointer(c);

  for i:=0 to maxN do begin
    Series2.Add(b^[i]);
  end;

//  FreeMem(a);
  FreeMem(b);
end;

procedure TForm1.UpdateClient(var Message1: integer);
begin
//
  ShowMessage('Helllo');
end;


procedure TForm1.Button9Click(Sender: TObject);
begin
  //Timer3.Enabled:=not Timer3.Enabled;

//  StatusBar1.Panels[2].Text:='Timer ' + BoolToStr(Timer3.Enabled, true);
  TikFm.Show();
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
//  ReadPipeData();
end;


end.
