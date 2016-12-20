{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p181.in';
    OutFile    = 'p181.out';
    Limit      = 2000;

Type
    Tnum       = array[0..Limit] of longint;

Var
    visited ,
    path       : Tnum;
    A ,
    alpha , beta ,
    gamma , M ,
    K , answer : longint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(A , alpha , beta , gamma , M , K);
//    Close(INPUT);
end;

procedure work;
var
    i , len ,
    more       : longint;
begin
    fillchar(visited , sizeof(visited) , 0);
    fillchar(path , sizeof(path) , 0);
    i := 1;
    path[0] := A;
    while true do
      begin
          path[i] := ((path[i - 1] * path[i - 1]) mod M * alpha + path[i - 1] * beta + gamma) mod M;
          if visited[path[i]] <> 0 then break;
          visited[path[i]] := i;
          inc(i);
      end;
    if k <= i then begin answer := path[k]; exit; end;
    len := i - visited[path[i]];
    more := (k - i) mod len;
    i := visited[path[i]];
    answer := path[i + more];
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
