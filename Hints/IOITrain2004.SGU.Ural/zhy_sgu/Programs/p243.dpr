{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p243.in';
    OutFile    = 'p243.out';
    Limit      = 5;
    LimitPieces= Limit * Limit;
    LimitLen   = 20;

Type
    Tpoint     = record
                     x , y    : longint;
                 end;
    Tpiece     = record
                     tot      : longint;
                     data     : array[1..LimitPieces] of Tpoint;
                 end;
    Tpieces    = record
                     tot      : longint;
                     sign     : char;
                     data     : array[1..4] of Tpiece;
                 end;
    Tdata      = array[1..LimitPieces] of Tpieces;
    Tsource    = array['A'..'Z'] of Tpiece;
    Tmap       = array[1..Limit , 1..Limit] of char;
    Tvisited   = array[1..LimitPieces] of boolean;

Var
    data       : Tdata;
    source     : Tsource;
    map        : Tmap;
    visited    : Tvisited;
    N , M      : longint;

procedure init;
var
    i , j      : longint;
    c          : char;
begin
    fillchar(data , sizeof(data) , 0);
    fillchar(source , sizeof(source) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
      for i := 1 to LimitLen do
        begin
            for j := 1 to LimitLen do
              begin
                  read(c);
                  if c = '.' then continue;
                  inc(source[c].tot);
                  source[c].data[source[c].tot].x := i;
                  source[c].data[source[c].tot].y := j;
              end;
            readln;
        end;
//    Close(INPUT);
end;

procedure regular(var now : Tpiece);
var
    i , j      : longint;
    tmp        : Tpoint;
begin
    for i := 1 to now.tot do
      for j := now.tot downto i + 1 do
        if (now.data[j].x < now.data[j - 1].x) or
          ((now.data[j].x = now.data[j - 1].x) and (now.data[j].y < now.data[j - 1].y)) then
          begin
              tmp := now.data[j];
              now.data[j] := now.data[j - 1];
              now.data[j - 1] := tmp;
          end;
    for i := now.tot downto 1 do
      begin
          dec(now.data[i].x , now.data[1].x);
          dec(now.data[i].y , now.data[1].y);
      end;
end;

function same(p1 , p2 : Tpiece) : boolean;
var
    i          : longint;
begin
    same := false;
    if p1.tot <> p2.tot then exit;
    for i := 1 to p1.tot do
      if (p1.data[i].x <> p2.data[i].x) or (p1.data[i].y <> p2.data[i].y) then
        exit;
    same := true;
end;

procedure turn(var now : Tpiece);
var
    i          : longint;
    newp       : Tpiece;
begin
    fillchar(newp , sizeof(newp) , 0);
    for i := 1 to now.tot do
      begin
          newp.data[i].x := now.data[i].y;
          newp.data[i].y := -now.data[i].x;
      end;
    newp.tot := now.tot;
    now := newp;
    regular(now);
end;

procedure pre_process;
var
    i , j      : longint;
    ok         : boolean;
    c          : char;
    now        : Tpiece;
begin
    for c := 'A' to 'Z' do
      if source[c].tot <> 0 then
        begin
            inc(M);
            data[M].sign := c;
            now := source[c];
            regular(now);
            for i := 1 to 4 do
              begin
                  ok := true;
                  for j := 1 to data[M].tot do
                    if same(now , data[M].data[j]) then
                      begin
                          ok := false;
                          break;
                      end;
                  if ok then
                    begin
                        inc(data[M].tot);
                        data[M].data[data[M].tot] := now;
                    end;
                  turn(now);
              end;
        end;
end;

function canfill(x , y : longint; now : Tpiece) : boolean;
var
    i , nx , ny: longint;
begin
    canfill := false;
    for i := 1 to now.tot do
      begin
          nx := x + now.data[i].x;
          ny := y + now.data[i].y;
          if (nx < 1) or (ny < 1) or (nx > N) or (ny > N) or (map[nx , ny] <> #0) then
            exit;
      end;
    canfill := true;
end;

procedure fill(x , y : longint; now : Tpiece; sign : char);
var
    i , nx , ny: longint;
begin
    for i := 1 to now.tot do
      begin
          nx := x + now.data[i].x;
          ny := y + now.data[i].y;
          map[nx , ny] := sign;
      end;
end;

function dfs(x , y : longint) : boolean;
var
    nx , ny ,
    i , j      : longint;
begin
    nx := x; ny := y + 1;
    if ny > N then
      begin nx := x + 1; ny := 1; end;
    if x > N
      then dfs := true
      else if map[x , y] = #0
            then begin
                     dfs := true;
                     for i := 1 to M do
                       if not visited[i] then
                         for j := 1 to data[i].tot do
                           if canfill(x , y , data[i].data[j]) then
                             begin
                                 fill(x , y , data[i].data[j] , data[i].sign);
                                 visited[i] := true;
                                 if dfs(nx , ny) then
                                   exit;
                                 visited[i] := false;
                                 fill(x , y , data[i].data[j] , #0);
                             end;
                     dfs := false;
                 end
            else dfs := dfs(nx , ny);
end;

procedure work;
begin
    pre_process;
    fillchar(map , sizeof(map) , 0);
    fillchar(visited , sizeof(visited) , 0);
    dfs(1 , 1);
end;

procedure out;
var
    i , j      : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to N do
        begin
            for j := 1 to N do
              write(map[i , j]);
            writeln;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
