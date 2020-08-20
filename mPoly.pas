unit mPoly;

interface
uses
  Ap, mSQAprox, Math;

const
  dispRangeHigh = 29;
  dispRange: array [0..dispRangeHigh] of integer = (120,144,172,207,248,298,358,429,515,619,743,891,1069,1283,1540,1848,2218,2662,3194,3833,4600,5520,6624,7949,9539,11447,13737,16484,19781,23737);

type
  SqPoly = record
    a, b, c: double;
  end;

  _1OrdPoly = record
    a, b: double;
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




//    function _5OrdCalc(poly: _5Ordpoly; x: double): double;
//    function _5OrdPolyConvert(ta: TReal1DArray): _5OrdPoly;

    function _2OrdCalc(poly: _2Ordpoly; x: double): double;
    function _2OrdPolyConvert(ta: TReal1DArray): _2OrdPoly;

    function _1OrdCalc(poly: _1Ordpoly; x: double): double;
    function _1OrdPolyConvert(ta: TReal1DArray): _1OrdPoly;

    function _3OrdCalc(poly: _3Ordpoly; x: double): double;
    function _3OrdPolyConvert(ta: TReal1DArray): _3OrdPoly;

    function X2Derivative(poly: _3Ordpoly; x: double): double;
    function X1Derivative(poly: _3Ordpoly; x: double): double;

    function CalcSigma(x, y: PReal; N: Integer; poly: _3OrdPoly): double;
    function CalcSigma_S(x, y: PReal; N: Integer; poly: _3OrdPoly): double;
    function CalcSigma_SA(x, y: PReal; N: Integer; poly: _3OrdPoly): double;
    function CalcSigma2D(x, y: PReal; N: Integer; poly: _2OrdPoly): double;
    procedure Slicing(x, y: PLongReal; N, SlicingN: Integer; var sx, sy: PREal; tranfer: boolean = true);
    function CalcDisp(x, y: PReal; N: Integer; start: Integer = 0): double;
    function LocalSum(x: PlongReal; n: integer; l: integer  = 3): double; overload;
    function LocalSum(x: PReal; index: integer; len: integer; ambit: integer): double; overload;

    function CalcDispRange(disp: double): integer;
implementation


function _3OrdCalc(poly: _3Ordpoly; x: double): double;
begin
  result:=poly.a*x*x*x + poly.b*x*x + poly.c*x + poly.d;
end;

{
function _5OrdCalc(poly: _5Ordpoly; x: double): double;
begin
  result:=poly.a*x*x*x*x*x + poly.b*x*x*x*x + poly.c*x*x*x + poly.d*x*x + poly.e*x + poly.f;
end;
}

function _3OrdPolyConvert(ta: TReal1DArray): _3OrdPoly;
begin
  result.d:=ta[0];
  result.c:=ta[1];
  result.b:=ta[2];
  result.a:=ta[3];
end;

{
function _5OrdPolyConvert(ta: TReal1DArray): _5OrdPoly;
begin
  result.f:=ta[0];
  result.e:=ta[1];
  result.d:=ta[2];
  result.c:=ta[3];
  result.b:=ta[4];
  result.a:=ta[5];
end;

}

function X1Derivative(poly: _3Ordpoly; x: double): double;
begin
// ax3 + bx2 + cx + d
  result:=3*poly.a*x*x + 2*poly.b*x + poly.c;
end;

function X2Derivative(poly: _3Ordpoly; x: double): double;
begin
// 3ax2 + 2bx  + c;
  result:=6*poly.a*x + 2*poly.b;
end;

 (*
function X1Derivative(poly: _5Ordpoly; x: double): double;
begin
// ax5 + bx4 + cx3 + dx2 + ex + f
  result:=5*poly.a*x*x*x*x + 4*poly.b*x*x*x + 3*poly.c*x*x + 2*poly.d*x + poly.e;

end;

function X2Derivative(poly: _5Ordpoly; x: double): double;
begin
// 5ax4 + 4bx3 + 3cx2 + 2dx + e
  result:=20*poly.a*x*x*x + 12*poly.b*x*x + 6*poly.c*x + 2*poly.d;
end;
*)
function _2OrdCalc(poly: _2Ordpoly; x: double): double;
begin
  result:=poly.a*x*x + poly.b*x + poly.c;
end;

function _2OrdPolyConvert(ta: TReal1DArray): _2OrdPoly;
begin
  result.c:=ta[0];
  result.b:=ta[1];
  result.a:=ta[2];
end;


function _1OrdCalc(poly: _1Ordpoly; x: double): double;
begin
  result:=poly.a*x + poly.b;
end;

function _1OrdPolyConvert(ta: TReal1DArray): _1OrdPoly;
begin
  result.b:=ta[0];
  result.a:=ta[1];
end;

function CalcSigma(x, y: PReal; N: Integer;
  poly: _3OrdPoly): double;

var
  i: integer;
  tp: double;
  te: double;
begin
  te:=0.0;
  for i:=0 to N-1 do begin
    tp:=_3OrdCalc(poly, x[i]);
    te:=te+sqr(y[i]-tp);
  end;
  result:=sqrt(te/N); // /YScale
end;

function CalcSigma_S(x, y: PReal; N: Integer;
  poly: _3OrdPoly): double;

var
  i: integer;
  tp: double;
  te: double;
begin
  te:=0.0;
  for i:=0 to N-1 do begin
    tp:=_3OrdCalc(poly, x[i]);
    te:=te+abs((y[i]-tp)/y[i]);
  end;
  result:=te/N; // /YScale
end;

function CalcSigma_SA(x, y: PReal; N: Integer;
  poly: _3OrdPoly): double;

var
  i: integer;
  tp: double;
  te: double;
  y_s: double;
begin
  te:=0.0;
  y_s:=0.0;
  for i:=0 to N-1 do begin
    y_s:=y_s+y[i];
    tp:=_3OrdCalc(poly, x[i]);
    te:=te+sqr(y[i]-tp);
  end;
  y_s:=y_s/N;
  result:=sqrt(te/N)/y_s; // /YScale
end;

procedure Slicing(x, y: PLongReal; N, SlicingN: Integer; var sx, sy: PREal; tranfer: boolean = true);
var
  i, c, k, l: integer;
  step, count: integer;
  mx, my: double;
begin
// ошибка шагов больше чем SlicingN
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
  if (tranfer) then begin
    mx:=sx[0];
    for i:=0 to SlicingN-1 do begin
      sx[i]:=sx[i]-mx;
    end;
  end;
end;

function CalcSigma2D(x, y: PReal; N: Integer;
  poly: _2OrdPoly): double;

var
  i: integer;
  tp: double;
  te: double;
begin
  te:=0.0;
  for i:=0 to N-1 do begin
    tp:=_2OrdCalc(poly, x[i]);
    te:=te+sqr(y[i]-tp);
  end;
  result:=sqrt(te/N); // /YScale
end;

function CalcDisp(x, y: PReal; N: Integer; start: Integer = 0): double;
var
  i: integer;
  s, s2: double;
begin
  s:=0;
  s2:=0;

  if (start >= N) then begin
    result:=0;
    exit;
  end;

  for i:=start to N-1 do begin
    s:=s+y[i];
    s2:=s2+y[i]*y[i];
  end;

  s:=s/(N-start);
  result:=s2/(N-start) - s*s;
end;

function LocalSum(x: PlongReal; n: integer; l: integer = 3): double;
var
  i: integer;
begin
  result:=0;
  if (n-l) >= 0 then begin
    result:=x[n];
    for i:=1 to l do
     result:=result+x[n+i]*(1/i)+x[n-l-1+i]*(1/(1+l-i));
  end;
end;

function LocalSum(x: PReal; index: integer; len: integer; ambit: integer): double;
var
  i: integer;
  l_ind, r_ind: integer;
begin
  result:=0;

  l_ind:=Max(0, index-ambit-1);
  r_ind:=Min(len-1, index+ambit);

  for i:=l_ind to index-1 do
    result:=result+x[i]*(1/(index-i));

  result:=result+x[index];
  for i:=index+1 to r_ind do
    result:=result+x[i]*(1/(i-index));
end;

function LocalRange(disp: double; left, right: integer): integer;
var
  sred: integer;
begin
//  result:=-1;
  if (left = right) then begin
    if (disp <= dispRange[right]) then
      result:= right
    else
      result:= -1;
    exit;
  end;

// left <> right
  if ((left + 1) = right) then begin
    if ((disp <= dispRange[right])and(disp >= dispRange[left])) then
      result:= right
    else
      result:= -1;
    exit;
  end;

  sred:=floor((right+left)/2);
  if (dispRange[sred] < disp) then begin
    result:=LocalRange(disp, sred, right);
  end else begin
    result:=LocalRange(disp, left, sred);
  end;

end;

function CalcDispRange(disp: double): integer;
begin
  if (disp <= dispRange[0]) then
    result:=0
  else
    if (disp > dispRange[dispRangeHigh]) then
      result:=dispRangeHigh
    else
      result:=LocalRange(disp, 0, dispRangeHigh);
end;

end.
