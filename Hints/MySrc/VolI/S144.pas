program Meeting;
var
  x,y :longint;
  t   :extended;
begin
  read(x,y);
  y := y - x;
  readln(t);
  t := t / 60;
  writeln((1 - ( (y-t)*(y-t) ) / (y*y) ) : 0 : 7);
end.