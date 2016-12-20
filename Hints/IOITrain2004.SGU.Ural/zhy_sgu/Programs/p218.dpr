{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p218.in';
    OutFile    = 'p218.out';
    Limit      = 500;
    LimitValue = 1000000;

Type
    Tdata      = array[1..Limit , 1..Limit] of longint;
    Tmatch     = array[1..Limit] of longint;
    Tvisited   = array[1..Limit] of boolean;

Var
    data       : Tdata;
    mx , my ,
    ans        : Tmatch;
    visited    : Tvisited;
    N , answer : longint;

procedure init;
var
    i , j      : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        for j := 1 to N do
          read(data[i , j]);
//    Close(INPUT);
end;

function extend(bound , side , root : longint) : boolean;
var
    i          : longint;
begin
    if side = 1
      then begin
               extend := false;
               for i := 1 to N do
                 if not visited[i] and (data[root , i] <= bound) then
                   if extend(bound , 3 - side , i) then
                     begin
                         extend := true;
                         mx[root] := i; my[i] := root;
                         exit;
                     end;
           end
      else begin
               visited[root] := true;
               if my[root] = 0
                 then extend := true
                 else extend := extend(bound , 3 - side , my[root]);
           end; 
end;

function check(bound : longint) : boolean;
var
    i          : longint;
begin
    fillchar(mx , sizeof(mx) , 0); fillchar(my , sizeof(my) , 0);
    check := false;
    for i := 1 to N do
      begin
          fillchar(visited , sizeof(visited) , 0);
          if not extend(bound , 1 , i) then
            exit;
      end;
    check := true;
end;

procedure work;
var
    start , stop ,
    mid        : longint;
begin
    start := -LimitValue;
    stop := LimitValue;
    while start <= stop do
      begin
          mid := (start + stop) div 2;
          if check(mid)
            then begin
                     answer := mid;
                     ans := mx;
                     stop := mid - 1;
                 end
            else start := mid + 1;
      end;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
      for i := 1 to N do
        writeln(i , ' ' , ans[i]);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
