{
ID: yuhc(020538)
PROG: beauty
LANG: PASCAL
}
program beauty;
type
  Tpoint = record
    s,b,num,pre :longint;
  end;
var
  data          :array[0..100000] of Tpoint;
  f,num       :array[0..100000] of longint;
  n,i,l         :longint;
  t             :Tpoint;
//
procedure opf;
begin
  assign(input,'beauty.in');
  reset(input);
  assign(output,'beauty.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
procedure init;
begin
  readln(n);
  for i := 1 to n do
    with data[i] do
    begin
      readln(s,b);
      num := i;
    end;
end;
//
procedure qsort(l,r :longint);
var
  i,j,mid,mib :longint;
begin
  i := l; j := r; mid := data[(i+j) shr 1].s; mib := data[(i+j) shr 1].b;
  repeat
    while (data[i].s < mid) or ((data[i].s = mid) and (data[i].b > mib)) do inc(i);
    while (data[j].s > mid) or ((data[j].s = mid) and (data[j].b < mib)) do dec(j);
    if i <= j then
    begin
      t := data[i]; data[i] := data[j]; data[j] := t;
      inc(i); dec(j);
    end;
  until i > j;
  if i < r then qsort(i,r);
  if j > l then qsort(l,j);
end;
//
function binary(y :longint) :longint;
var
  st,ed,mid :longint;
begin
  binary := 0;
  st := 1; ed := l;
  while st <= ed do
  begin
    mid := (st + ed) shr 1;
    if f[mid] < y then
    begin
      binary := mid;
      st := mid + 1;
    end
      else ed := mid - 1;
  end;
end;
//
procedure lis;
var
  i,step :integer;
begin
  l := 0;
  for i := 1 to n do
  begin
    step := binary(data[i].b);
    if step <> 0 then data[i].pre := num[step];
    inc(step);
    if l < step
      then begin
             inc(l);
             num[step] := i;
             f[step] := data[i].b;
           end
      else if f[step] > data[i].b then
           begin
             num[step] := i;
             f[step] := data[i].b;
           end;
  end;
end;
//
procedure print;
var
  x :longint;
begin
  writeln(l);
  x := num[l];
  for i := 1 to l do
  begin
    write(data[x].num);
    x := data[x].pre;
    if i = l then writeln else write(' ');
  end;
end;
//
begin
  opf;
  init;
  qsort(1,n);
  //for i := 1 to n do writeln('X=',data[i].s,'  Y=',data[i].b,'  Num=',data[i].num);
  lis;
  print;
  clf;
end.
