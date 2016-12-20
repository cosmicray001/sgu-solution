program Counting;
type
 prime=array[1..20] of record
                        num,times:integer; end;
var
 tp:prime;
 pn,n,m,k,i,t,tot:integer;
 bj:boolean;
//
procedure pack;
var
 i:integer;
begin
 i:=2; pn:=0;
 while k<>1 do
  begin
   if k mod i=0 then
    begin
     inc(pn);
     tp[pn].num:=i;
     tp[pn].times:=0;
     while k mod i=0 do
      begin
       k:=k div i;
       inc(tp[pn].times);
      end;
    end;
   inc(i);
  end;
end;
//
function check:boolean;
var
 i,tmp:integer;
begin
 for i:=1 to pn do
  begin
   tmp:=0;
   while t mod tp[i].num=0 do
    begin
     inc(tmp);
     t:=t div tp[i].num;
    end;
   if tmp*m<tp[i].times then exit(false);
  end;
 check:=true;
end;
//
begin
 assign(input,'count.in');
 reset(input);
 assign(output,'count.out');
 rewrite(output);
 readln(n,m,k);
 pack;
 tot:=0;
 for i:=1 to n do
  begin
   read(t);
   if check then inc(tot);
  end;
 writeln(tot);
 close(input);
 close(output);
end.