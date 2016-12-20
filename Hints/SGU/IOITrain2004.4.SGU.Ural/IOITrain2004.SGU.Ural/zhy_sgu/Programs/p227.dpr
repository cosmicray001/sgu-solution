{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Uses
    Math;

Const
    InFile     = 'p227.in';
    OutFile    = 'p227.out';
    Limit      = 50;
    LimitC     = 5000;
    minimum1   = 1e-5;
    minimum2   = 1e-10;

Type
    Tpoint     = record
                     x , y                   : extended;
                 end;
    Tcircle    = record
                     p1 , p2 , p3 , O        : Tpoint;
                     a1 , a2 , a3 , R        : extended;
                 end;
    Tdata      = array[1..Limit] of Tcircle;
    Tpoints    = array[1..LimitC] of Tpoint;

Var
    data       : Tdata;
    points     : Tpoints;
    N , M      : longint;
    answer     : boolean;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        with data[i] do
          read(p1.x , p1.y , p2.x , p2.y , p3.x , p3.y);
//    Close(INPUT);
end;

function zero1(num : extended) : boolean;
begin
    zero1 := abs(num) <= minimum1;
end;

function zero2(num : extended) : boolean;
begin
    zero2 := abs(num) <= minimum2;
end;

procedure Get_Angle(O , p : Tpoint; var a : extended);
var
    cosA , d   : extended;
begin
    p.x := p.x - O.x; p.y := p.y - O.y;
    d := sqrt(sqr(p.x) + sqr(p.y));
    cosA := p.x / d;
    a := arccos(cosA);
    if p.y < 0 then
      a := 2 * pi - a;
end;

procedure process_arc(var C : Tcircle);
var
    LA1 , LB1 , LC1 ,
    LA2 , LB2 , LC2 ,
    tmp        : extended;
begin
    with C do
      begin
          LA1 := 2 * (p2.x - p1.x); LB1 := 2 * (p2.y - p1.y);
          LC1 := sqr(p1.x) + sqr(p1.y) - sqr(p2.x) - sqr(p2.y);
          LA2 := 2 * (p3.x - p1.x); LB2 := 2 * (p3.y - p1.y);
          LC2 := sqr(p1.x) + sqr(p1.y) - sqr(p3.x) - sqr(p3.y);
          O.x := (LC2 * LB1 - LC1 * LB2) / (LA1 * LB2 - LA2 * LB1);
          O.y := (LC2 * LA1 - LC1 * LA2) / (LB1 * LA2 - LB2 * LA1);
      end;
    Get_Angle(C.O , C.p1 , C.a1);
    Get_Angle(C.O , C.p2 , C.a2);
    Get_Angle(C.O , C.p3 , C.a3);
    C.R := sqrt(sqr(C.O.x - C.p1.x) + sqr(C.O.y - C.p1.y));
    if C.a1 > C.a2 then begin tmp := C.a1; C.a1 := C.a2; C.a2 := tmp; end;
    if not ((C.a1 < C.a3) and (C.a3 < C.a2)) then begin tmp := C.a1; C.a1 := C.a2; C.a2 := tmp; end;
end;

function in_arc_sub(a , a1 , a2 : extended) : boolean;
begin
    if a >= 2 * pi then a := a - 2 * pi;
    if a < 0 then a := a + 2 * pi;
    if a1 < a2
      then in_arc_sub := (a1 <= a + minimum2) and (a <= a2 + minimum2)
      else in_arc_sub := (a >= a1 - minimum2) or (a <= a2 + minimum2);
end;

function in_arc(a , a1 , a2 : extended; sign : longint) : longint;
var
    dir        : extended;
begin
    in_arc := 0;
    if not in_arc_sub(a , a1 , a2) then exit;
    if sign = 1 then dir := minimum1 else dir := -minimum1;
    in_arc := 1;
    if in_arc_sub(a + dir , a1 , a2) then in_arc := 2;
end;

procedure add_p(x , y : extended; C1 , C2 : Tcircle);
var
    p          : Tpoint;
    a          : extended;
begin
    p.x := x; p.y := y;
    Get_angle(C1.O , p , a);
    if not in_arc_sub(a , C1.a1 , C1.a2) then exit;
    Get_angle(C2.O , p , a);
    if not in_arc_sub(a , C2.a1 , C2.a2) then exit;
    inc(M);
    points[M].x := x; points[M].y := y;
end;

procedure solve_equa(x1 , y1 , r1 , x2 , y2 , r2 : extended; inverse : longint; cir1 , cir2 : Tcircle);
var
    A , B , C , t ,
    A1 , B1 , C1 ,
    delta ,
    nx1 , ny1 ,
    nx2 , ny2  : extended;
begin
    A := 2 * (x2 - x1); B := 2 * (y2 - y1);
    C := -(r1 * r1 - r2 * r2 + x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1);
    t := C + A * x1;
    A1 := A * A + B * B; B1 := 2 * (t * B - A * A * y1);
    C1 := t * t + A * A * y1 * y1 - A * A * r1 * r1;
    delta := B1 * B1 - 4 * A1 * C1;
    if delta < -minimum2 then exit;
    delta := sqrt(abs(delta));
    ny1 := (-B1 + delta) / 2 / A1; ny2 := (-B1 - delta) / 2 / A1;
    nx1 := - (B * ny1 + C) / A; nx2 := - (B * ny2 + C) / A;
    if inverse = 1
      then begin add_p(ny1 , nx1 , cir1 , cir2); add_p(ny2 , nx2 , cir1 , cir2); end
      else begin add_p(nx1 , ny1 , cir1 , cir2); add_p(nx2 , ny2 , cir1 , cir2); end;
end;

function cross(C1 , C2 : Tcircle) : boolean;
begin
    if zero2(C1.O.x - C2.O.x) and zero2(C1.O.y - C2.O.y)
      then begin
               cross := true;
               if not zero2(C1.R - C2.R) then exit;
               cross := false;
               case in_arc(C1.a1 , C2.a1 , C2.a2 , 1) of
                 1            : add_p(C1.p1.x , C1.p1.y , C1 , C2);
                 2            : exit;
               end;
               case in_arc(C1.a2 , C2.a1 , C2.a2 , 0) of
                 1            : add_p(C1.p2.x , C1.p2.y , C1 , C2);
                 2            : exit;
               end;
               case in_arc(C2.a1 , C1.a1 , C1.a2 , 1) of
                 1            : add_p(C2.p1.x , C2.p1.y , C1 , C2);
                 2            : exit;
               end;
               case in_arc(C2.a2 , C1.a1 , C1.a2 , 0) of
                 1            : add_p(C2.p2.x , C2.p2.y , C1 , C2);
                 2            : exit;
               end;
               cross := true;
           end
      else begin
               cross := true;
               if zero2(C1.O.x - C2.O.x)
                 then solve_equa(C1.O.y , C1.O.x , C1.R , C2.O.y , C2.O.x , C2.R , 1 , C1 , C2)
                 else solve_equa(C1.O.x , C1.O.y , C1.R , C2.O.x , C2.O.y , C2.R , 0 , C1 , C2);
           end;
end;

function bigger(p1 , p2 : Tpoint) : boolean;
begin
    if zero1(p1.x - p2.x)
      then bigger := p2.y < p1.y - minimum1
      else bigger := p2.x < p1.x - minimum1;
end;

procedure qk_pass(start , stop : longint; var mid : longint);
var
    tmp        : longint;
    key        : Tpoint;
begin
    tmp := random(stop - start + 1) + start;
    key := points[tmp]; points[tmp] := points[start];
    while start < stop do
      begin
          while (start < stop) and bigger(points[stop] , key) do dec(stop);
          points[start] := points[stop];
          if start < stop then inc(start);
          while (start < stop) and bigger(key , points[start]) do inc(start);
          points[stop] := points[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    points[start] := key;
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

function same_p(p1 , p2 : Tpoint) : boolean;
begin
    same_p := zero1(p1.x - p2.x) and zero1(p1.y - p2.y);
end;

procedure work;
var
    i , j      : longint;
begin
    M := 0;
    for i := 1 to N do
      process_arc(data[i]);

    answer := false;
    for i := 1 to N do
      for j := i + 1 to N do
        if not cross(data[i] , data[j]) then
          exit;

    answer := true;
    qk_sort(1 , M);
    i := 0; j := 1;
    while j <= M do
      begin
          if (i = 0) or not same_p(points[i] , points[j]) then
            begin inc(i); points[i] := points[j]; end;
          inc(j);
      end;
    M := i;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if not answer
        then writeln('Infinity')
        else begin
                 writeln(M);
                 for i := 1 to M do
                   writeln(points[i].x : 0 : 3 , ' ' , points[i].y : 0 : 3);
             end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
