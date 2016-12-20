//Writeln on 2009/01/27
program Broken_Line;
type
 edges     =record
  x,y      :integer;
 end;
var
 e         :array[1..10001,1..2] of edges;
 i,k       :integer;
 tp,p      :edges;
//
function horiz(a,b :edges) :boolean;
begin
 horiz := a.y=b.y;
end;
//
function corner(a,b :edges) :boolean;
begin
 corner := ( (a.y = p.y) and (a.x < p.x) ) or
           ( (b.y = p.y) and (b.x < p.x) );
end;
//
function multi(p1, p2, p0 :edges) :double;
begin
 multi := (p1.x-p0.x) * (p2.y-p0.y) - (p2.x-p0.x) * (p1.y-p0.y);
end;
//
function max(a,b :longint) :longint;
begin
 if a<b then max := b else max := a;
end;
//
function min(a,b :longint) :longint;
begin
 if a>b then min := b else min := a;
end;
//
function border(a,b :edges) :boolean;
begin
 border := ( min(a.x,b.x) <= p.x ) and
           ( max(a.x,b.x) >= p.x ) and
           ( min(a.y,b.y) <= p.y ) and
           ( max(a.y,b.y) >= p.y ) and
           ( multi(a,b,p) = 0 );
end;
//
function cross(a1,a2,b1,b2 :edges) :boolean;
begin
 cross := ( max(a1.x,a2.x) >= min(b1.x,b2.x) ) and
          ( max(a1.y,a2.y) >= min(b1.y,b2.y) ) and
          ( max(b1.x,b2.x) >= min(a1.x,a2.x) ) and
          ( max(b1.y,b2.y) >= min(a1.y,a2.y) ) and
          ( multi(b1,a2,a1) * multi(a2,b2,a1) >= 0 ) and
          ( multi(a1,b2,b1) * multi(b2,a2,b1) >= 0 );
end;
//
function work :integer;
var
 sum,i :integer;
begin
 sum:=0;
 for i:=1 to k do
  if border(e[i][1],e[i][2]) then
   begin
    work := 3;
    exit;
   end
  else
   begin
    if horiz(e[i][1],e[i][2]) then continue;
    if corner(e[i][1],e[i][2]) then
     begin
      if e[i][2].y = p.y then inc(sum);
     end
     else
    if cross(e[i][1],e[i][2],p,tp) then inc(sum);
   end;
 //
 if odd(sum) then work := 1
  else work := 2;
end;
//
begin
 assign(input,'line.in');
 reset(input);
 assign(output,'line.out');
 rewrite(output);
 readln(k);
 for i:=1 to k do
  begin
   readln(e[i][1].x,e[i][1].y,e[i][2].x,e[i][2].y);
   if e[i][1].y<e[i][2].y then
    begin
     tp:=e[i][1]; e[i][1]:=e[i][2]; e[i][2]:=tp;
    end;
  end;
 readln(p.x,p.y);
 tp.x :=-10001;
 tp.y := p.y;
 //
 case work of
  1 : writeln('INSIDE');
  2 : writeln('OUTSIDE');
  3 : writeln('BORDER');
 end;
 close(input);
 close(output);
end.