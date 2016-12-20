{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p190.in';
    OutFile    = 'p190.out';
    Limit      = 40;
    dirx       : array[1..4] of longint = (-1 , 1 , 0 , 0);
    diry       : array[1..4] of longint = (0 , 0 , -1 , 1);

Type
    Tdata      = array[1..Limit , 1..Limit] of boolean;
    Tpoint     = record
                     x , y    : longint;
                 end;
    Tmatch     = array[1..Limit , 1..Limit] of Tpoint;

Var
    data ,
    covered ,
    visited    : Tdata;
    match      : Tmatch;
    N , M      : longint;
    answer     : boolean;

procedure init;
var
    i , p1 , p2: longint;
begin
    fillchar(data , sizeof(data) , true);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        begin
            read(p1 , p2);
            data[p1 , p2] := false;
        end;
//    Close(INPUT);
end;

function dfs(x , y : longint) : boolean;
var
    i , nx , ny: longint;
begin
    dfs := false;
    if visited[x , y] then exit;
    visited[x , y] := true;
    if not odd(x + y)
      then begin
               for i := 1 to 4 do
                 begin
                     nx := x + dirx[i]; ny := y + diry[i];
                     if (nx >= 1) and (nx <= N) and (ny >= 1) and (ny <= N) and data[nx , ny] then
                       if dfs(nx , ny) then
                         begin
                             match[x , y].x := nx; match[x , y].y := ny;
                             match[nx , ny].x := x; match[nx , ny].y := y;
                             covered[x , y] := true; covered[nx , ny] := true;
                             dfs := true;
                             exit;
                         end;
                 end;
           end
      else if not covered[x , y]
             then dfs := true
             else dfs := dfs(match[x , y].x , match[x , y].y);
end;

procedure work;
var
    i , j      : longint;
begin
    answer := false;
    if odd(N * N - M) then exit;

    fillchar(match , sizeof(match) , 0);
    fillchar(covered , sizeof(covered) , 0);
    for i := 1 to N do
      for j := 1 to N do
        if data[i , j] and not covered[i , j] and not odd(i + j) then
          begin
              fillchar(visited , sizeof(visited) , 0);
              if not dfs(i , j) then
                exit;
          end;
    answer := true;
end;

procedure out;
type
    Tpath      = record
                     tot      : longint;
                     data     : array[1..Limit * Limit] of Tpoint;
                 end;
var
    p1 , p2    : Tpath;
    i , j      : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer
        then begin
                 writeln('Yes');
                 p1.tot := 0; p2.tot := 0;
                 for i := 1 to N do
                   for j := 1 to N do
                     if data[i , j] then
                       if match[i , j].y = j + 1
                         then begin
                                  inc(p1.tot);
                                  p1.data[p1.tot].x := i; p1.data[p1.tot].y := j;
                              end
                         else if match[i , j].x = i + 1
                                then begin
                                         inc(p2.tot);
                                         p2.data[p2.tot].x := i; p2.data[p2.tot].y := j;
                                     end;
                 writeln(p2.tot);
                 for i := 1 to p2.tot do
                   writeln(p2.data[i].x , ' ' , p2.data[i].y);
                 writeln(p1.tot);
                 for i := 1 to p1.tot do
                   writeln(p1.data[i].x , ' ' , p1.data[i].y);
             end
        else writeln('No');
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
