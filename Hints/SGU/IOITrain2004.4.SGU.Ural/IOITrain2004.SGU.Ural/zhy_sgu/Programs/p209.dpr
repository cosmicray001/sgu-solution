{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p209.in';
    OutFile    = 'p209.out';
    Limit      = 80;
    LimitP     = 3200;
    LimitM     = 500000;
    minimum    = 1e-8;

Type
    Tpoint     = record
                     x , y                   : extended;
                 end;
    Tsegment   = record
                     p1 , p2                 : Tpoint;
                 end;
    TLine      = record
                     A , B , C               : extended;
                 end;
    Tdata      = array[1..Limit] of
                   record
                       seg                   : Tsegment;
                       L                     : TLine;
                   end;
    Tpoints    = array[1..LimitP] of Tpoint;
    Tedge      = record
                     p1 , p2                 : longint;
                 end;
    Tmap       = array[1..LimitM] of Tedge;
    Tindex     = array[1..LimitP] of longint;
    Tvisited   = array[1..LimitM] of boolean;
    Tanswer    = array[1..LimitP] of extended;


Var
    data       : Tdata;
    points     : Tpoints;
    map        : Tmap;
    index      : Tindex;
    visited    : Tvisited;
    answer     : Tanswer;
    N , Ps , M ,
    tot        : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        with data[i].seg do
          read(p1.x , p1.y , p2.x , p2.y);
//    Close(INPUT);
end;

function zero(num : extended) : boolean;
begin
    zero := abs(num) <= minimum;
end;

procedure Get_Line(p1 , p2 : Tpoint; var L : TLine);
begin
    L.A := p2.y - p1.y; L.B := p1.x - p2.x;
    L.C := p2.x * p1.y - p1.x * p2.y;
end;

function crossing(L1 , L2 : TLine; var p : Tpoint) : boolean;
begin
    crossing := false;
    if zero(L2.A * L1.B - L1.A * L2.B) then exit;
    p.x := (L1.C * L2.B - L2.C * L1.B) / (L2.A * L1.B - L1.A * L2.B);
    p.y := (L1.C * L2.A - L2.C * L1.A) / (L2.B * L1.A - L1.B * L2.A); 
    crossing := true;
end;

function bigger_p(p1 , p2 : Tpoint) : boolean;
begin
    if zero(p1.x - p2.x)
      then bigger_p := p1.y > p2.y
      else bigger_p := p1.x < p2.x;
end;

function same_p(p1 , p2 : Tpoint) : boolean;
begin
    same_p := zero(p1.x - p2.x) and zero(p1.y - p2.y);
end;

procedure qk_pass_points(start , stop : longint; var mid : longint);
var
    key        : Tpoint;
    tmp        : longint;
begin
    tmp := random(stop - start + 1) + start;
    key := points[tmp]; points[tmp] := points[start];
    while start < stop do
      begin
          while (start < stop) and bigger_p(points[stop] , key) do dec(stop);
          points[start] := points[stop];
          if start < stop then inc(start);
          while (start < stop) and bigger_p(key , points[start]) do inc(start);
          points[stop] := points[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    points[start] := key;
end;

procedure qk_sort_points(start , stop : longint);
var
    mid        : longint;
begin
    if start < stop then
      begin
          qk_pass_points(start , stop , mid);
          qk_sort_points(start , mid - 1);
          qk_sort_points(mid + 1 , stop);
      end;
end;

procedure qk_pass_edge(start , stop : longint; var mid : longint);
var
    key        : Tedge;
    tmp        : longint;
begin
    tmp := random(stop - start + 1) + start;
    key := map[tmp]; map[tmp] := map[start];
    while start < stop do
      begin
          while (start < stop) and (map[stop].p1 > key.p1) do dec(stop);
          map[start] := map[stop];
          if start < stop then inc(start);
          while (start < stop) and (map[start].p1 < key.p1) do inc(start);
          map[stop] := map[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    map[start] := key;
end;

procedure qk_sort_edge(start , stop : longint);
var
    mid        : longint;
begin
    if start < stop then
      begin
          qk_pass_edge(start , stop , mid);
          qk_sort_edge(start , mid - 1);
          qk_sort_edge(mid + 1 , stop);
      end;
end;

function cross_product(p1 , p2 , p3 : Tpoint) : extended;
begin
    p2.x := p2.x - p1.x; p2.y := p2.y - p1.y;
    p3.x := p3.x - p1.x; p3.y := p3.y - p1.y;
    cross_product := p2.x * p3.y - p2.y * p3.x;
end;

procedure search(i : longint);
var
    p          : Tpoint;
    j , k , st : longint;
    sum        : extended;
begin
    sum := 0;
    p := points[map[i].p1]; st := i;
    while not visited[i] do
      begin
          sum := sum + abs(cross_product(p , points[map[i].p1] , points[map[i].p2])) / 2;
          visited[i] := true;
          j := index[map[i].p2]; k := i;
          while (j <> 0) and (j <= M) and (map[j].p1 = map[i].p2) do
            begin
                if cross_product(points[map[i].p1] , points[map[i].p2] , points[map[j].p2]) > minimum then
                  if cross_product(points[map[k].p1] , points[map[k].p2] , points[map[j].p2]) > minimum then
                    k := j;
                inc(j);
            end;
          if k = i then exit;
          i := k;
      end;
    if sum <= 1e-8 then exit;
    if i <> st then exit;
    inc(tot);
    answer[tot] := sum;
end;

function in_line(p : Tpoint; L : TLine) : boolean;
var
    tmp        : extended;
begin
    tmp := p.x * L.A + p.y * L.B + L.C;
    in_line := zero(tmp);
end;

procedure qk_pass(start , stop : longint; var mid : longint);
var
    key        : extended;
    tmp        : longint;
begin
    tmp := random(stop - start + 1) + start;
    key := answer[tmp]; answer[tmp] := answer[start];
    while start < stop do
      begin
          while (start < stop) and (answer[stop] > key) do dec(stop);
          answer[start] := answer[stop];
          if start < stop then inc(start);
          while (start < stop) and (answer[start] < key) do inc(start);
          answer[stop] := answer[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    answer[start] := key;
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

procedure work;
var
    i , j , last
               : longint;
    p          : Tpoint;
begin
    Ps := 0;
    for i := 1 to N do
      Get_Line(data[i].seg.p1 , data[i].seg.p2 , data[i].L);
    for i := 1 to N do
      for j := i + 1 to N do
        if crossing(data[i].L , data[j].L , p) then
          begin
              inc(Ps);
              points[Ps] := p;
          end;
    qk_sort_points(1 , Ps);
    i := 1;
    for j := 2 to Ps do
      if not same_p(points[i] , points[j]) then
        begin
            inc(i);
            points[i] := points[j];
        end;
    Ps := i;

    M := 0;
    for i := 1 to N do
      begin
          last := 0;
          for j := 1 to Ps do
            if in_line(points[j] , data[i].L) then
              begin
                  if last <> 0 then
                    begin
                        inc(M); map[M].p1 := last; map[M].p2 := j;
                        inc(M); map[M].p1 := j; map[M].p2 := last;
                    end;
                  last := j;
              end;
      end;
    qk_sort_edge(1 , M);
    fillchar(index , sizeof(index) , 0);
    for i := 1 to M do
      if index[map[i].p1] = 0 then
        index[map[i].p1] := i;

    fillchar(visited , sizeof(visited) , 0);
    tot := 0;
    for i := M downto 1 do
      if not visited[i] then
        search(i);
    qk_sort(1 , tot);
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(tot);
      for i := 1 to tot do
        writeln(answer[i] : 0 : 4);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
