program Simple_Prob;
var
 n, i, j :longint;
 a, b, d :array [-1..1002] of longint;
 ch      :char;
//
function work(n, k, m :longint) :boolean;
var
  i, t :longint;
begin
  t := 0;
  for i:=n downto 0 do
   begin
    d[i] := b[i] * k + t;
     t := d[i] div 10;
     d[i] := d[i] mod 10;
    end;
  d[-1] := t;
  for i:=-1 to n do
   if d[i] > a[i + m - n] then
    begin
     work := false;
     exit;
    end else
  if d[i] < a[i + m - n] then
   begin
    work := true;
    exit;
   end;
 work := true;
end;
//
begin
 assign(input,'simple.in');
 reset(input);
 n := 0;
 fillchar(b, sizeof(b), 0);
 fillchar(a, sizeof(a), 0);
 while not eoln do
  begin
   inc(n);
   read(ch);
   a[n] := ord(ch) - 48;
  end;
 if odd(n) then
  begin
   for i:=n downto 1 do
   a[i + 1] := a[i];
   a[1] := 0;
   inc(n);
  end;
 //
 for i:=1 to n div 2 do
  begin
   b[i - 1] := b[i - 1] * 2;
   if b[i - 1] > 9 then
    begin
     inc(b[i - 2]);
     b[i - 1] := b[i - 1] - 10;
    end;
   for j:=9 downto 0 do
    begin
     b[i] := j;
     if work(i, j, i * 2) then
      begin
       write(j);
       break;
       end;
    end;
   for j:=i * 2 downto i - 1 do
    begin
     dec(a[j], d[j - i]);
     if a[j] < 0 then
      begin
       inc(a[j], 10);
       dec(a[j - 1]);
      end;
    end;
   end;
 close(input);
end.
