unit mSQAprox;

interface
uses
  Dialogs, Math, Windows;
const
  maxN = 600;
  longmaxN = 80000;

type
  TReal1DArray        = array of Double;

  TReal = array [0..maxN-1] of Extended;
  PReal = ^TReal;
  TLongReal = array [0..longmaxN-1] of Extended;
  PLongReal = ^TLongReal;
//  TTReal = array ^[0..maxN-1, 0..maxN-1] of Extended;
  TTReal = array [0..maxN-1] of PReal;
  PPREal = ^TTReal;
//  PPREal = array ^[0..maxN-1] of PReal;


  procedure mSQInit();
  procedure mSQDeInit();

  procedure readmatrix(_x, _y: Preal; N: integer);
  procedure SQA(_x, _y: PReal; N: integer; var _a: TReal1DArray; _Dimention: integer = 3);

  function myPower(x: extended; k: integer): extended;
implementation

//#include <stdio.h>
//#include <process.h>
//#include <math.h>


//float *a, *b, *x, *y, **sums;

var
{
  a, b, x, y: array of extended;
  sums: array of array of extended;
}

  a, b, x, y: PReal;
  sums: PPReal;

  len: integer;
  _N, _K: integer;

//int N, K;

//N - number of data points
//K - polinom power
//K<=N

// char filename^[256];

//  filename: string;


// FILE* InFile=NULL;
//  InFile: integer;

(*
procedure count_num_lines();
//var
//  nelf: integer;
begin
//  nelf:=0;
(*
  repeat
    nelf:=0;


  until
*)
//end;

(*
void count_num_lines(){
   //count number of lines in input file - number of equations
   int nelf=0;       //non empty line flag
   do{
       nelf = 0;
       while(fgetc(InFile)!='\n' && !feof(InFile)) nelf=1;
       if(nelf) N++;
   }while(!feof(InFile));
}

*)

(*
void freematrix(){
   //free memory for matrixes
   int i;
   for(i=0; i<K+1; i++){
       delete ^[] sums^[i];
   }
   delete ^[] a;
   delete ^[] b;
   delete ^[] x;
   delete ^[] y;
   delete ^[] sums;
}
*)

(*
void allocmatrix(){
   //allocate memory for matrixes
   int i,j,k;
   a = new float^[K+1];
   b = new float^[K+1];
   x = new float^[N];
   y = new float^[N];
   sums = new float*^[K+1];
   if(x==NULL || y==NULL || a==NULL || sums==NULL){
       printf("\nNot enough memory to allocate. N=%d, K=%d\n", N, K);
       exit(-1);
   }
   for(i=0; i<K+1; i++){
       sums^[i] = new float^[K+1];
       if(sums^[i]==NULL){
	   printf("\nNot enough memory to allocate for %d equations.\n", K+1);
       }
   }
   for(i=0; i<K+1; i++){
       a^[i]=0;
       b^[i]=0;
       for(j=0; j<K+1; j++){
	   sums^[i]^[j] = 0;
       }
   }
   for(k=0; k<N; k++){
       x^[k]=0;
       y^[k]=0;
   }
}

*)
(*
void readmatrix(){
   int i=0,j=0, k=0;
   //read x, y matrixes from input file
   for(k=0; k<N; k++){
       fscanf(InFile, "%f", &x^[k]);
       fscanf(InFile, "%f", &y^[k]);
   }
   //init square sums matrix
   for(i=0; i<K+1; i++){
     for(j=0; j<K+1; j++){
	       sums^[i]^[j] = 0;
	       for(k=0; k<N; k++){
	         sums^[i]^[j] += pow(x^[k], i+j);
	       }
      }
   }
   //init free coefficients column
   for(i=0; i<K+1; i++){
       for(k=0; k<N; k++){
	   b^[i] += pow(x^[k], i) * y^[k];
       }
   }
}

*)

procedure readmatrix(_x, _y: Preal; N: integer);
var
  i, j, k: integer;

begin
  _N:=N;
{
  for i:=0 to _N-1 do begin
    x^[i]:=_x[i];
    y^[i]:=_y[i];

  end;
}
{  CopyMemory(x, _x, N*sizeof(extended));
  CopyMemory(y, _y, N*sizeof(extended));
}
  x:=_x;
  y:=_y;

  for i:=0 to _K do begin
    for j:=0  to _K do begin
      sums^[i]^[j]:=0;
      for k:=0 to _N-1 do
        sums^[i]^[j]:=sums^[i]^[j] + myPower(x^[k], i+j);

    end;
  end;

  for i:=0 to _K do begin
    b^[i]:=0;
    for k:=0 to _N-1 do
      b^[i]:=b^[i] + y^[k]*myPower(x^[k], i);
  end;
end;

(*
void printresult(){
   //print polynom parameters
   int i=0;
   printf("\n");
   for(i=0; i<K+1; i++){
       printf("a^[%d] = %f\n", i, a^[i]);
   }
}

*)

(*
void diagonal(){
   int i, j, k;
   float temp=0;
   for(i=0; i<K+1; i++){
       if(sums^[i]^[i]==0){
	   for(j=0; j<K+1; j++){
	       if(j==i) continue;
	       if(sums^[j]^[i] !=0 && sums^[i]^[j]!=0){
		   for(k=0; k<K+1; k++){
		       temp = sums^[j]^[k];
		       sums^[j]^[k] = sums^[i]^[k];
		       sums^[i]^[k] = temp;
		   }
		   temp = b^[j];
		   b^[j] = b^[i];
		   b^[i] = temp;
		   break;
	       }
	   }
       }
   }
}
*)
procedure diagonal();
var
  i, j, k: integer;
  temp: extended;
begin
//  temp:=0;
  for i:=0 to _K do begin
    if (sums^[i]^[i] = 0) then begin
      for j:=0 to _K do begin
        if (j = 1) then continue;
        if (sums^[j]^[i] <> 0) and (sums^[i]^[j] <> 0) then begin
          for k:=0 to _K do begin
            temp:=sums^[j]^[k];
            sums^[j]^[k]:=sums^[i]^[k];
            sums^[i]^[k]:=temp;
          end;
          temp:=b^[j];
          b^[j]:=b^[i];
          b^[i]:=temp;
          break;
        end;
      end;
    end;
  end;

end;
(*
void cls(){
   for(int i=0; i<25; i++) printf("\n");
}

*)

procedure SQA(_x, _y: PReal; N: integer; var _a: TReal1DArray; _Dimention: integer = 3);
var
  i, j, k: integer;
  M, s: extended;
begin
//  i:=0;
//  j:=0;
//  k:=0;
(*
  SetLength(a, 1000);
  SetLength(b, 1000);
  SetLength(x, 1000);
  SetLength(y, 1000);
  SetLength(sums, 1000);
*)
{  Fillchar(a, 1000*SizeOf(extended), 0);
  Fillchar(b, 1000*SizeOf(extended), 0);
  Fillchar(x, 1000*SizeOf(extended), 0);
  Fillchar(y, 1000*SizeOf(extended), 0);

}
  {
  for i:=0 to 999 do begin
//    SetLength(sums^[i], 1000);
    a^[i]:=0;
    b^[i]:=0;
    x^[i]:=0;
    y^[i]:=0;
}
(*
  Fillchar(a^[0], 1000*SizeOf(extended), 0);
  Fillchar(b^[0], 1000*SizeOf(extended), 0);
  Fillchar(x^[0], 1000*SizeOf(extended), 0);
  Fillchar(y^[0], 1000*SizeOf(extended), 0);

   for j:=0 to 999 do begin
//      sums^[i, j]:=0;
      FillChar(sums^[j]^[0], 1000*SizeOf(extended), 0);
//    end

//    FillChar(sums^[i], 1000*SizeOf(extended), 0);
  end;
*)


  Fillchar(a^, len, 0);
{  Fillchar(b^, len, 0);
//  Fillchar(x^, len, 0);
//  Fillchar(y^, len, 0);

  for i:=0 to maxN-1 do
    FillChar(sums^[i]^, len, 0);
}

//  Move(zlen^, a^, len);
//  CopyMemory(b, zlen, len);
{  for i:=0 to maxN-1 do
    CopyMemory(sums[i], zlen, len);
}

// ¬вод _N;

// ¬вод _K;
   _K:=_Dimention;

//  allocmatrix();

// ¬вод матриц X, Y;

  readmatrix(_x, _y, N);

  diagonal();


  for k:=0 to _K do begin
    for i:=k+1 to _K do begin
      if (sums^[k]^[k]=0) then begin
	       ShowMessage('\nSolution is not exist.\n');
	       exit;
      end;
      M:=sums^[i]^[k]/sums^[k]^[k];
      for j:=k to _K do
        sums^[i]^[j]:=sums^[i]^[j] - M*sums^[k]^[j];

  	  b^[i]:=b^[i] - M*b^[k];
    end;
  end;

  for i:=_K downto 0 do begin
    s:=0;
    for j:=i to _K do
	    s:= s + sums^[i]^[j]*a^[j];
    a^[i]:= (b^[i] - s)/sums^[i]^[i];
  end;
//  printresult();

  for i:=0 to _K do
    _a[i]:=a^[i];

end;

(*
void main(){
   int i=0,j=0, k=0;
   cls();
   do{
       printf("\nInput filename: ");
       scanf("%s", filename);
       InFile = fopen(filename, "rt");
   }while(InFile==NULL);

   count_num_lines();
   printf("\nNumber of points: N=%d", N);
   do{
       printf("\nInput power of approximation polinom K<N: ");
       scanf("%d", &K);
   }while(K>=N);
   allocmatrix();
   rewind(InFile);
   //read data from file
   readmatrix();
   //check if there are 0 on main diagonal and exchange rows in that case
   diagonal();
   fclose(InFile);
   //printmatrix();
   //process rows

   for(k=0; k<K+1; k++){
     for(i=k+1; i<K+1; i++){
	   if(sums^[k]^[k]==0){
	       printf("\nSolution is not exist.\n");
	       return;
	   }
	   float M = sums^[i]^[k] / sums^[k]^[k];
	   for(j=k; j<K+1; j++){
	       sums^[i]^[j] -= M * sums^[k]^[j];
	   }
	   b^[i] -= M*b^[k];
       }
   }


   //printmatrix();
   for(i=(K+1)-1; i>=0; i--){
       float s = 0;
       for(j = i; j<K+1; j++){
	   s = s + sums^[i]^[j]*a^[j];
       }
       a^[i] = (b^[i] - s) / sums^[i]^[i];
   }
   printresult();
   freematrix();
}
*)

procedure mSQInit();
var
  i: integer;
begin
  len:=sizeof(TReal);

  GetMem(a, len);
  GetMem(b, len);

//  GetMem(x, len);
//  GetMem(y, len);

  GetMem(sums, len);

  for i:=0 to maxN-1 do
    GetMem(sums^[i], len);

//  Fillchar(x^, len, 0);
//  Fillchar(y^, len, 0);



{  SetLength(a, 1000);
  SetLength(b, 1000);
  SetLength(x, 1000);
  SetLength(y, 1000);
  SetLength(sums, 1000);
  for i:=0 to 999 do
    SetLength(sums^[i], 1000);
}
end;

procedure mSQDeInit();
var
  i: integer;
begin
  FreeMem(a);
  FreeMem(b);

//  FreeMem(x);
//  FreeMem(y);
  for i:=0 to maxN-1 do
    FreeMem(sums^[i]);

  FreeMem(sums);

end;

function myPower(x: extended; k: integer): extended;
//var
//  i: integer;
begin
  if k = 0 then
    Result := 1.0
  else
    if k = 1 then
      Result := x
    else
      if k = 2 then
        result:=x*x
      else
        if k = 3 then
          result:=x*x*x
        else begin
(*          result:=x;
          for i:=0 to k-2 do
            result:=result*x;
*)
          Result := 1;
          while k > 0 do begin
            if k mod 2 = 1 then
              Result := Result * x;

            k := k shr 1;
            x := x * x;
          end;

        end;

(*

  if (k = 0) then begin
    result:=1.0;
    exit;
  end;
  if (k = 1) then begin
    result:=x;
    exit;
  end;

  if (k = 2) then begin
    result:=x*x;
    exit;
  end;

  if (k = 3) then begin
    result:=x*x*x;
    exit;
  end;
*)
end;

function myPower2(x: extended; k: integer): extended;
begin
    if k = 0 then
      Result := 1
    else
      if k = 1 then
        Result := x
      else
        begin
          Result := 1;
          while k > 0 do
          begin
            if k mod 2 = 1 then
              Result := Result * x;

            k := k shr 1;
            x := x * x;
          end;
        end;
end;

end.

