{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p174.in';
    OutFile    = 'p174.out';
    Limit      = 200000;

Type
    Tpoint     = record
                     x , y                   : longint;
                 end;
    Tseg       = record
                     p1 , p2                 : Tpoint;
                 end;
    Tdata      = array[1..Limit] of Tseg;
    Tpoints    = array[1..Limit * 2] of Tpoint;
    Tfather    = array[1..Limit * 2] of longint;

Var
    data       : Tdata;
    father     : Tfather;
    points     : Tpoints;
    N , answer ,
    tot        : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        read(data[i].p1.x , data[i].p1.y , data[i].p2.x , data[i].p2.y);
//    Close(INPUT);
end;

procedure qk_pass(start , stop : longint; var mid : longint);
var
    key        : Tpoint;
    tmp        : longint;
begin
    tmp := random(stop - start + 1) + start;
    key := points[tmp]; points[tmp] := points[start];
    while start < stop do
      begin
          while (start < stop) and ((points[stop].x > key.x) or (points[stop].x = key.x) and (points[stop].y > key.y)) do dec(stop);
          points[start] := points[stop];
          if start < stop then inc(start);
          while (start < stop) and ((points[start].x < key.x) or (points[start].x = key.x) and (points[start].y < key.y)) do inc(start);
          points[stop] := points[start];
          if start < stop then dec(stop);
      end;
    points[start] := key;
    mid := start;
end;

procedure qk_sort(start , stop : longint);
var
    mid        : longint;
begin
    if start < stop then
      begin
          qk_pass(start , stop , mid);
          qk_sort(start , mid - 1);
          qk_sort(mid + 1 , stop);
      end;
end;

function binary_find(p : Tpoint) : longint;
var
    st , ed ,
    mid        : longint;
begin
    st := 1; ed := tot;
    binary_find := 0;
    while st <= ed do
      begin
          mid := (st + ed) div 2;
          if (points[mid].x = p.x) and (points[mid].y = p.y)
            then begin
                     binary_find := mid;
                     exit;
                 end
            else if (points[mid].x < p.x) or (points[mid].x = p.x) and (points[mid].y < p.y)
                   then st := mid + 1
                   else ed := mid - 1; 
      end;
end;

function find_root(x : longint) : longint;
begin
    if father[x] = 0
      then find_root := x
      else begin
               father[x] := find_root(father[x]);
               find_root := father[x];
           end;
end;

procedure work;
var
    i , x , y ,
    fx , fy    : longint;
begin
    answer := 0; tot := 0;
    for i := 1 to N do
      begin
          points[i] := data[i].p1;
          points[i + N] := data[i].p2;
      end;
    qk_sort(1 , N * 2);
    tot := 0;
    for i := 1 to N * 2 do
      if (tot = 0) or (points[i].x <> points[tot].x) or (points[i].y <> points[tot].y) then
        begin
            inc(tot);
            points[tot] := points[i];
        end;

    fillchar(father , sizeof(father) , 0);
    for i := 1 to N do
      begin
          x := binary_find(data[i].p1);
          y := binary_find(data[i].p2);
          fx := find_root(x);
          fy := find_root(y);
          if fx = fy
            then begin answer := i; exit; end
            else father[fx] := fy;
      end;
    answer := 0;
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
