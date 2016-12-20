{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p229.in';
    OutFile    = 'p229.out';
    Limit      = 20;

Type
    Tdata      = array[-Limit..Limit * 2 , -Limit..Limit * 2] of longint;
    Tgraph     = array[1..Limit * Limit] of
                   record
                       p1 , p2               : longint;
                   end;
    Tvisited   = array[1..Limit * Limit] of boolean;
    Tposition  = array[1..Limit * Limit] of
                   record
                       x , y                 : longint;
                   end;

Var
    A , B ,
    ans        : Tdata;
    graph      : Tgraph;
    visited    : Tvisited;
    position   : Tposition;
    N , M      : longint;
    answer     : boolean;

procedure init;
var
    i , j      : longint;
    c          : char;
begin
    fillchar(A , sizeof(A) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N); M := 0;
      for i := 1 to N do
        begin
            for j := 1 to N do
              begin
                  read(c);
                  if c = '1' then
                    begin
                        inc(M);
                        A[i , j] := M;
                        position[M].x := i; position[M].y := j;
                    end;
              end;
            readln;
        end;
//    Close(INPUT);
end;

procedure Right_Rotate(A : Tdata; var B : Tdata);
var
    i , j      : longint;
begin
    fillchar(B , sizeof(B) , 0);
    for i := 1 to N do
      for j := 1 to N do
        B[j , N - i + 1] := A[i , j];
end;

function check(x , y : longint) : boolean;
var
    i , j ,
    p1 , p2    : longint;
begin
    check := false;
    if odd(M) then exit;
    fillchar(graph , sizeof(graph) , 0);
    for i := 1 to N do
      for j := 1 to N do
        if (A[i , j] <> 0) and (B[i + x , j + y] <> 0) then
          begin
              p1 := A[i , j]; p2 := B[i + x , j + y];
              if p1 = p2
                then exit
                else begin
                         graph[p1].p1 := p2; graph[p2].p2 := p1;
                     end;
          end;
    for i := 1 to M do
      if graph[i].p1 + graph[i].p2 = 0 then
        exit;

    fillchar(visited , sizeof(visited) , 0);
    fillchar(ans , sizeof(ans) , 0);
    for i := 1 to M do
      if not visited[i] and (graph[i].p1 <> 0) and (graph[i].p2 = 0) then
        begin
            j := i;
            while true do
              begin
                  ans[position[j].x , position[j].y] := 1;
                  visited[j] := true;
                  visited[graph[j].p1] := true;
                  j := graph[graph[j].p1].p1;
                  if j = 0 then break;
                  if graph[j].p1 = 0 then exit;
              end;
        end;
    for i := 1 to M do
      if not visited[i] then
        begin
            j := i;
            while true do
              begin
                  ans[position[j].x , position[j].y] := 1;
                  visited[j] := true;
                  if visited[graph[j].p1] then exit;
                  visited[graph[j].p1] := true;
                  j := graph[graph[j].p1].p1;
                  if visited[j] then break;
              end;
        end;
    check := true;
end;

procedure process;
var
    i , j      : longint;
begin
    answer := true;
    for i := 1 - N to N - 1 do
      for j := 1 - N to N - 1 do
        if check(i , j) then
          exit;
    answer := false;
end;

procedure work;
begin
    B := A;
    process;
    if answer then exit;
    Right_Rotate(B , B);
    process;
    if answer then exit;
    Right_Rotate(B , B);
    process;
    if answer then exit;
end;

procedure out;
var
    i , j      : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer
        then begin
                 writeln('YES');
                 for i := 1 to N do
                   begin
                       for j := 1 to N do
                         write(ans[i , j]);
                       writeln;
                   end;
             end
        else writeln('NO');
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
