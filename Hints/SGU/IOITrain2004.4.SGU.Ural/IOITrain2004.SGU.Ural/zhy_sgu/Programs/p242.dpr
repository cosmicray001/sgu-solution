{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p242.in';
    OutFile    = 'p242.out';
    Limit      = 200;

Type
    Tdata      = array[1..Limit , 1..Limit] of boolean;
    Tmatch     = array[1..2 , 1..Limit] of longint;
    Tvisited   = array[1..2 , 1..Limit] of boolean;

Var
    data       : Tdata;
    match      : Tmatch;
    visited    : Tvisited;
    N , K      : longint;

procedure _noanswer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln('NO');
//    Close(OUTPUT);
    halt(0);
end;

procedure init;
var
    i , tot , p: longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , K);
      if K > N * 2 then _noanswer;
      for i := 1 to N do
        begin
            read(tot);
            while tot > 0 do
              begin
                  read(p);
                  data[p * 2 - 1 , i] := true;
                  data[p * 2 , i] := true;
                  dec(tot);
              end;
        end;
//    Close(INPUT);
end;

function dfs(side , root : longint) : boolean;
var
    i          : longint;
begin
    visited[side , root] := true;
    if side = 1
      then begin
               dfs := true;
               for i := 1 to N do
                 if not visited[2 , i] and data[root , i] then
                   if dfs(2 , i) then
                     begin
                         match[1 , root] := i;
                         match[2 , i] := root;
                         exit;
                     end;
               dfs := false;
           end
      else if match[2 , root] = 0
             then dfs := true
             else dfs := dfs(1 , match[2 , root]);
end;

procedure work;
var
    i          : longint;
begin
    fillchar(match , sizeof(match) , 0);
    for i := 1 to K * 2 do
      if match[1 , i] = 0 then
        begin
            fillchar(visited , sizeof(visited) , 0);
            if not dfs(1 , i) then
              _noanswer;
        end;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln('YES');
      for i := 1 to K do
        writeln(2 , ' ' , match[1 , 2 * i - 1] , ' ' , match[1 , 2 * i]);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
