program Tele_dir;
var
 a:array[0..9] of integer;
 n,k,i,tmp:integer;
//
function work:integer;
var
 i,total:integer;
begin
 total:=2;
 for i:=1 to 9 do
  if i<>8 then
   inc(total,(a[i]+k-1) div k);
 work:=total;
end;
//
begin
 assign(input,'tele.in');
 reset(input);
 assign(output,'tele.out');
 rewrite(output);
 fillchar(a,sizeof(a),0);
 readln(k);
 readln(n);
 for i:=1 to n do
  begin
   readln(tmp);
   inc(a[tmp div 1000]);
  end;
 writeln(work);
 close(input);
 close(output);
end.
