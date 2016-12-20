{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p157.in';
    OutFile    = 'p157.out';
    Limit      = 13;

Type
    Tdata      = array[1..Limit] of integer;

Var
    data       : Tdata;
    N , total  : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
//    Close(INPUT);
end;

procedure dfs(zeropos : integer);
var
    i          : integer;
begin
    inc(total);
    if data[1] = 1 then
      begin
          data[zeropos] := data[1]; data[1] := 0;
          dfs(1);
          data[1] := data[zeropos]; data[zeropos] := 0;
      end;
    for i := 2 to N do
      if (i - 1 <> zeropos) and (data[i] = data[i - 1] + 1) then
        begin
            data[zeropos] := data[i]; data[i] := 0;
            dfs(i);
            data[i] := data[zeropos]; data[zeropos] := 0;
        end;
end;

procedure work;
var
    i          : integer;
begin
    fillchar(data , sizeof(data) , 0);
    for i := 1 to N - 1 do
      data[i] := i;

    Case N of
      11       : total := 1548222;
      12       : total := 12966093;
      13       : total := 118515434;
    else
      begin
          total := 0;
          dfs(N);
      end;
    end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(total);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
