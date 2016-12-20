{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p224.in';
    OutFile    = 'p224.out';
    Limit      = 10;

Type
    Tdata      = array[1..Limit] of longint;
    Tvisited   = array[1..Limit] of boolean;

Var
    visited    : Tvisited;
    data       : Tdata;
    N , K ,
    answer     : longint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , K);
//    Close(INPUT);
end;

procedure dfs(i , K : longint);
var
    j , p      : longint;
    ok         : boolean;
begin
    if K > N - i + 1 then exit;
    if i > N then
      begin
          inc(answer);
          exit;
      end;
    dfs(i + 1 , K);
    if K > 0 then
      for j := 1 to N do
        if not visited[j] then
        begin
            ok := true;
            for p := 1 to i - 1 do
              if (data[p] <> 0) and (abs(data[p] - j) = abs(p - i)) then
                begin
                    ok := false;
                    break;
                end;
            if ok then
              begin
                  data[i] := j;
                  visited[j] := true;
                  dfs(i + 1 , K - 1);
                  data[i] := 0;
                  visited[j] := false;
              end;
        end;
end;

procedure work;
begin
    answer := 0;
    fillchar(data , sizeof(data) , 0);
    fillchar(visited , sizeof(visited) , 0);
    dfs(1 , K);
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
