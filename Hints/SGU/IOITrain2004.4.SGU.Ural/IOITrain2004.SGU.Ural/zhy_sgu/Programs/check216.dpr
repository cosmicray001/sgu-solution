{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    InFile     = 'p216.in';
    ChkFile    = 'p216.out';
    Limit      = 1000;

Type
    Tdata      = array[1..Limit , 1..Limit] of boolean;
    Tnum       = array[1..Limit] of longint;

Var
    data       : Tdata;
    color , sum ,
    capital    : Tnum;
    N , B , C  : longint;

procedure init;
var
    i , p1 , p2: longint;
begin
    fillchar(data , sizeof(data) , 0);
    assign(INPUT , InFile); ReSet(INPUT);
      read(N , B);
      for i := 1 to N - 1 do
        begin
            read(p1 , p2);
            data[p1 , p2] := true;
            data[p2 , p1] := true;
        end;
    Close(INPUT);

    assign(INPUT , ChkFile); ReSet(INPUT);
      read(C);
      for i := 1 to N do
        read(color[i]);
      for i := 1 to C do
        read(capital[i]);
    Close(INPUT);
end;

procedure message(s : string);
begin
    writeln(s);
    halt;
end;

function dfs(p1 , p2 , target : longint) : boolean;
var
    i          : longint;
begin
    dfs := false;
    if p2 = target then
      begin
          dfs := true;
          exit;
      end;
    for i := 1 to N do
      if data[p2 , i] and (i <> p1) and (color[i] = color[target]) then
        if dfs(p2 , i , target) then
          begin
              dfs := true;
              exit;
          end;
end;

procedure work;
var
    i          : longint;
begin
    fillchar(sum , sizeof(sum) , 0);
    for i := 1 to N do
      if (color[i] > C) or (color[i] < 1)
        then message('Wrong Answer')
        else inc(sum[color[i]]);
    for i := 1 to C do
      if (sum[i] > 3 * B) or (sum[i] < B) then
        message('Wrong Answer');

    for i := 1 to N do
      if not dfs(0 , capital[color[i]] , i) then
        message('Wrong Answer');

    message('Accepted');
end;

Begin
    init;
    work;
End.
