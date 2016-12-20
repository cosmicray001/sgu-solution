//Writeln on 2009/02/02
program Equation;
var
  a,b,c,x1,x2,y1,y2,x,y,ans :int64;
//
function ex_gcd(a,b :int64; var x,y :int64) :int64;
var
  t :int64;
begin
  if b = 0 then
   begin
    ex_gcd := a;
    x := 1;
    y := 0;
    exit;
   end;
  ex_gcd := ex_gcd(b, a mod b, x, y);
  t := x;
  x := y;
  y := t - (a div b)*y;
end;
//
procedure initial;
begin
  assign(input,'equal.in');
  reset(input);
  read(a,b,c,x1,x2,y1,y2);
  close(input);
  c := -c; //ax+by=-c
  if (a = 0) and (b = 0) then
    if c <> 0 then writeln(0)
      else writeln( (x2-x1+1) * (y2-y1+1) );
  if (a = 0) and (b <> 0) then
    if (c mod b = 0) and (c div b >= y1) and (c div b <= y2) then
      writeln(1) else writeln(0);
  if (b = 0) and (a <> 0) then
    if (c mod a = 0) and (c div a >= x1) and (c div a <= x2) then
      writeln(1) else writeln(0);
  if (a = 0) or (b = 0) then halt;
end;
//
function min(a,b :int64) :int64;
begin
  if a > b then min := b else min := a;
end;
//
function max(a,b :int64) :int64;
begin
  if a < b then max := b else max :=a;
end;
//
procedure calc(lx,rx,x,q :int64; var l,r :int64);
begin
  if q > 0 then
   begin
    lx := lx - x;
    rx := rx - x;
   end
  else
   begin
     l := x - rx;
     r := x - lx;
    lx := l;
    rx := r;
    q := -q;
   end;
  l := lx div q;
  r := rx div q;
  if (lx >= 0) and (lx mod q <> 0) then inc(l);
  if (rx <  0) and (rx mod q <> 0) then dec(r);
end;
//
procedure work;
var
  t,a0,b0,l1,r1,l2,r2  :int64;
begin
  t := ex_gcd(abs(a), abs(b), x, y);
  if a < 0 then x := -x;
  if b < 0 then y := -y;
  //
  if c mod t <>0 then
   begin
    writeln(0);
    halt;
   end;
  b0 := -a div t; // x = x0 + (-b0) *t
  a0 :=  b div t; // y = y0 +   a0  *t
  x := x * c div t;
  y := y * c div t;
  //
  calc(x1,x2,x,a0,l1,r1);
  calc(y1,y2,y,b0,l2,r2);
  //
  ans := min(r1,r2) - max(l1,l2);
  if ans >= 0 then inc(ans)
    else ans := 0;
end;
//
begin
  initial;
  work;
  writeln(ans);
end.

Case 1
3 2 5
-1 0
-1 0
Case 2
6 7 -20
-10 10
-10 10
Case 3
4 6 -20
-20 20
-20 20