{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p175.in';
    OutFile    = 'p175.out';

Var
    N , q ,
    answer     : longint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , q);
//    Close(INPUT);
end;

function dfs(N , q : longint) : longint;
var
    K          : longint;
begin
    if N = 1 then
      begin
          dfs := 1;
          exit;
      end;
    K := N div 2;
    if q <= K then
      dfs := N - K + dfs(K , K - q + 1)
    else
      dfs := dfs(N - K , N - K - (q - K) + 1);
end;

procedure work;
begin
    answer := dfs(N , q);
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
