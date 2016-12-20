{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $0000400000}
{$MAXSTACKSIZE $001000000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Type
    Tname      = string[10];
    Tdata      = array[1..20000] of Tname;
    Tfather    = array[1..20000] of longint;
    
Var
    i , j , k  : longint;
    f          : text;
    name       : Tname;
    data       : Tdata;
    father     : Tfather;

function find_f(p : longint) : longint;
begin
    if father[p] <= 0
      then find_f := p
      else begin
               father[p] := find_f(father[p]);
               find_f := father[p];
           end;
end;

Begin
    randomize;
    for i := 1 to 2000 do
      begin
          data[i] := '';
          for j := 1 to 10 do
            data[i] := data[i] + char(random(26) + 65);
      end;
    assign(f , 'p215.std'); rewrite(f);
    assign(OUTPUT , 'p215.in'); Rewrite(OUTPUT);
      for i := 1 to 30000 do
        if random(10) = 1
          then begin
                   j := random(2000) + 1;
                   writeln('print ' , data[j]);
                   writeln(f , -father[find_f(j)]);
               end
          else if random(3) <> 1 then
                 begin
                     j := random(2000) + 1; k := random(2000) + 1;
                     writeln('define ' , data[j] , ' ' , data[k]);
                     if father[j] <> 0 then continue;
                     k := find_f(k);
                     if j = k then continue;
                     father[j] := k;
                 end
               else
                 begin
                     j := random(2000) + 1; k := random(2000000) + 1;
                     writeln('define ' , data[j] , ' ' , k);
                     if father[j] <> 0 then continue;
                     father[j] := -k;
                 end;
    Close(OUTPUT);
    close(f);
End.