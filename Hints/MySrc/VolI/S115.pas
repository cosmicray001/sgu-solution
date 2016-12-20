program Calendar;
const
 day:array[1..12] of integer=(31,28,31,30,31,30,31,31,30,31,30,31);
var
 m,n,i,ans:integer;
//
begin
 readln(m,n);
 if (n>12)or((n<13)and(m>day[n])) then writeln('Impossible') else
  begin
   ans:=m;
   for i:=1 to n-1 do inc(ans,day[i]);
   if ans mod 7=0 then writeln(7)
    else writeln(ans mod 7);
  end;
end.