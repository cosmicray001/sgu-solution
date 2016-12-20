{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p198.in';
    OutFile    = 'p198.out';
    Limit      = 310;
    minimum    = 1e-6;

Type
    Tcircle    = record
                     x , y , r               : extended;
                 end;
    Tdata      = array[1..Limit] of Tcircle;
    Tmap       = array[1..Limit , 1..Limit] of boolean;
    Tvisited   = array[1..Limit] of boolean;
    Tstack     = record
                     top                     : longint;
                     data                    : array[1..Limit] of longint;
                 end;

Var
    data       : Tdata;
    map        : Tmap;
    visited ,
    instack    : Tvisited;
    stack ,
    path       : Tstack;
    startp     : Tcircle;
    N          : longint;
    answer     : boolean;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        read(data[i].x , data[i].y , data[i].r);
      read(startp.x , startp.y , startp.r);
//    Close(INPUT);
end;

function dist(p1 , p2 : Tcircle) : extended;
begin
    dist := sqrt(sqr(p1.x - p2.x) + sqr(p1.y - p2.y));
end;

procedure creat_map;
var
    i , j      : longint;
begin
    fillchar(map , sizeof(map) , 0);
    for i := 1 to N do
      for j := 1 to N do
        if i <> j then
          if data[i].r + data[j].r + startp.r * 2 > dist(data[i] , data[j]) + minimum then
            map[i , j] := true;
end;

function zero(num : extended) : boolean;
begin
    zero := (abs(num) <= minimum);
end;

function cross(p1 , p2 : Tcircle) : extended;
begin
    cross := p1.x * p2.y - p1.y * p2.x;
end;

function in_poly(const path : Tstack; const p : Tcircle) : boolean;
var
    v , p1 , p2: Tcircle;
    b1 , b2 , b3 ,
    ok         : boolean;
    i , sum    : longint;
begin
    v.y := 0; v.x := 1;
    while true do
      begin
          ok := true;
          for i := 1 to path.top do
            begin
                p1 := data[path.data[i]];
                p1.x := p1.x - p.x; p1.y := p1.y - p.y;
                if zero(cross(p1 , v)) then
                  begin
                      ok := false;
                      break;
                  end;
            end;
          if ok then break;
          v.y := v.y + minimum;
          v.x := sqrt(1 - sqr(v.y));
      end;

    sum := 0;
    for i := 1 to path.top do
      begin
          p1 := data[path.data[i]]; p1.x := p1.x - p.x; p1.y := p1.y - p.y;
          p2 := data[path.data[i + 1]]; p2.x := p2.x - p.x; p2.y := p2.y - p.y;
          b1 := (cross(p1 , p2) >= 0); b2 := (cross(p1 , v) >= 0); b3 := (cross(v , p2) >= 0);
          if (b1 = b2) and (b2 = b3) then
            inc(sum);
      end;
    in_poly := odd(sum);
end;

function dfs(root : longint) : boolean;
var
    i , j      : longint;
begin
    dfs := true;
    inc(stack.top); stack.data[stack.top] := root;
    instack[root] := true; visited[root] := true;

    for i := 1 to N do
      if map[root , i] then
        if instack[i]
          then begin
                   path.top := 0;
                   j := stack.top;
                   while stack.data[j] <> i do
                     begin
                         inc(path.top); path.data[path.top] := stack.data[j];
                         dec(j);
                     end;
                   inc(path.top); path.data[path.top] := stack.data[j];
                   path.data[path.top + 1] := path.data[1];
                   if (path.top >= 3) and in_poly(path , startp) then
                     exit;
               end
          else if not visited[i] and dfs(i) then
                 exit;

    stack.data[stack.top] := 0; dec(stack.top);
    instack[root] := false;
    dfs := false;
end;

procedure work;
var
    i          : longint;
begin
    creat_map;

    fillchar(visited , sizeof(visited) , 0);
    fillchar(instack , sizeof(instack) , 0);
    stack.top := 0;
    answer := false;
    for i := 1 to N do
      if not visited[i] then
        if dfs(i) then
          exit;
    answer := true;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer
        then writeln('YES')
        else writeln('NO');
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
