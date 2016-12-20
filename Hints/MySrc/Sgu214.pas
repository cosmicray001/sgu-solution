{
ID: yuhc(020538)
PROG: Sgu214
}
program Sgu214;
const
  MaxN = 200;
var
  d              :array[1..255,1..255] of longint;
  f              :array[0..MaxN,0..MaxN] of longint;
  s1,s2          :array[0..MaxN,0..MaxN] of string;
  c1,c2,cp1,cp2  :array[1..MaxN] of longint;
  letter,a,b     :string;
  n,i,j,t,la,lb  :longint;
//
procedure opf;
begin
  assign(input,'s214.in');
  reset(input);
  assign(output,'s214.out');
  rewrite(output);
end;
//
procedure clf;
begin
  close(input);
  close(output);
end;
//
begin
  opf;
  readln(letter);
  n := length(letter);
  readln(a);
  readln(b);
  la := length(a);
  lb := length(b);
  for i := 1 to n do
    for j := 1 to n do read(d[ord(letter[i]),ord(letter[j])]);
  //
  for i := 1 to la do
  begin
    c1[i] := maxlongint;
    t := ord(a[i]);
    for j := 1 to n do
      if c1[i] > d[t,ord(letter[j])] then
      begin
        c1[i] := d[t,ord(letter[j])];
        cp1[i] := j;
      end;
  end;
  for i := 1 to lb do
  begin
    c2[i] := maxlongint;
    t := ord(b[i]);
    for j := 1 to n do
      if c2[i] > d[ord(letter[j]),t] then
      begin
        c2[i] := d[ord(letter[j]),t];
        cp2[i] := j;
      end;
  end;
  //
  fillchar(f,sizeof(f),0);
  s1[0,0] := '';
  for i := 1 to la do
    s1[i,0] := s1[i-1,0] + a[i];
  s2[0,0] := '';
  for i := 1 to lb do
    s2[0,i] := s2[0,i-1] + b[i];
  //
  for i := 1 to la do
    for j := 1 to lb do
    begin
      f[i,j] := f[i-1,j-1] + d[ord(a[i]),ord(b[j])];
      s1[i,j] := s1[i-1,j-1] + a[i];
      s2[i,j] := s2[i-1,j-1] + b[j];
      if f[i,j] > f[i-1,j] + c1[i] then
      begin
        f[i,j] := f[i-1,j] + c1[i];
        s1[i,j] := s1[i-1,j] + a[i];
        s2[i,j] := s2[i,j-1] + letter[cp1[i]];
      end;
      if f[i,j] > f[i,j-1] + c2[j] then
      begin
        f[i,j] := f[i,j-1] + c2[j];
        s1[i,j] := s1[i-1,j] + letter[cp2[j]];
        s2[i,j] := s2[i,j-1] + b[j];
      end;
    end;
  writeln(f[la,lb]);
  writeln(s1[la,lb]);
  writeln(s2[la,lb]);
  clf;
end.