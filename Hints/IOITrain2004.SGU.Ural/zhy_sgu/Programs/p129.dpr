{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p129.in';
    OutFile    = 'p129.out';
    Limit      = 400;
    LimitM     = 1000;
    zero       = 1e-6;

Type
    Tpoint     = record
                     x , y  , angle          : extended;
                 end;
    TLine      = record
                     A , B , C               : extended;
                 end;
    Tedge      = record
                     p1 , p2                 : Tpoint;
                 end;
    Tdata      = array[1..Limit] of Tpoint;
    Tmineral   = array[1..LimitM] of Tedge;
    Tcrossing  = record
                     total    : integer;
                     data     : array[1..2] of Tpoint;
                 end;
    Tanswer    = array[1..LimitM] of extended;

Var
    data       : Tdata;
    mineral    : Tmineral;
    crossing   : Tcrossing;
    answer     : Tanswer;
    N , M      : integer;

procedure init;
var
    i          : integer;
begin
    fillchar(data , sizeof(data) , 0);
    fillchar(mineral , sizeof(mineral) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        with data[i] do
          read(x , y);
      read(M);
      for i := 1 to M do
        with mineral[i] do
          read(p1.x , p1.y , p2.x , p2.y);
//    Close(INPUT);
end;

function dist(p1 , p2 : Tpoint) : extended;
begin
    dist := sqrt(sqr(p1.x - p2.x) + sqr(p1.y - p2.y));
end;

function chkzero(num : extended) : boolean;
begin
    chkzero := (abs(num) <= zero);
end;

procedure qk_pass(start , stop : integer; var mid : integer);
var
    key        : Tpoint;
    tmp        : integer;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (data[stop].angle > key.angle) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (data[start].angle < key.angle) do inc(start);
          data[stop] := data[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    data[start] := key;
end;

procedure qk_sort(start , stop : integer);
var
    mid        : integer;
begin
    if start < stop then
      begin
          qk_pass(start , stop , mid);
          qk_sort(start , mid - 1);
          qk_sort(mid + 1 , stop);
      end;
end;

procedure Convex;
var
    i , minp   : integer;
    len        : extended;
    tmp        : Tpoint;
begin
    minp := 1;
    for i := 2 to N do
      if data[i].y < data[minp].y then
        minp := i;
    tmp := data[1]; data[1] := data[minp]; data[minp] := tmp;

    for i := 2 to N do
      begin
          len := dist(data[1] , data[i]);
          if chkzero(len) then
            data[i].angle := -1
          else
            data[i].angle := (data[1].x - data[i].x) / dist(data[1] , data[i]);
      end;

    qk_sort(2 , N);
end;

function order(p1 , p2 , p3 : Tpoint) : boolean;
begin
    order := chkzero(dist(p1 , p2) + dist(p2 , p3) - dist(p1, p3));
end;

procedure GetLine(p1 , p2 : Tpoint; var L : TLine);
begin
    L.A := p2.y - p1.y; L.B := p1.x - p2.x;
    L.C := p2.x * p1.y - p1.x * p2.y;
end;

function GetCrossing(L1 , L2 : TLine; var p : Tpoint) : boolean;
var
    divisor    : extended;
begin
    fillchar(p , sizeof(p) , 0);
    divisor := L1.A * L2.B - L1.B * L2.A;
    if chkzero(divisor) then
      GetCrossing := false
    else
      begin
          GetCrossing := true;
          p.x := (L2.C * L1.B - L1.C * L2.B) / divisor;
          p.y := -(L2.C * L1.A - L1.C * L2.A) / divisor;
      end;
end;

function process(edge : Tedge) : extended;
var
    i          : integer;
    L1 , L2    : TLine;
    p , left ,
    right      : Tpoint;
    Len1 , Len2 ,
    Len3 , Len4 ,
    tmp ,
    LLen , RLen: extended;
begin
    fillchar(crossing , sizeof(crossing) , 0);
    GetLine(edge.p1 , edge.p2 , L1);
    for i := 1 to N do
      begin
          GetLine(data[i] , data[i mod N + 1] , L2);
          if chkzero(L2.A * edge.p1.x + L2.B * edge.p1.y + L2.C) and
               chkzero(L2.A * edge.p2.x + L2.B * edge.p2.y + L2.C) then
            begin
                process := 0;
                exit;
            end;
            
          if GetCrossing(L1 , L2 , p) and order(data[i] , p , data[i mod N + 1]) then
            if (crossing.total < 2) and
                ((crossing.total = 0) or not (chkzero(crossing.data[1].x - p.x) and chkzero(crossing.data[1].y - p.y))) then
              begin
                  inc(crossing.total);
                  crossing.data[crossing.total] := p;
              end;
      end;

    if crossing.total = 0 then
      process := 0
    else
      begin
          if crossing.total = 1 then
            crossing.data[2] := crossing.data[1];
          left := edge.p1; right := edge.p2;
          for i := 1 to 2 do
            if order(left , right , crossing.data[i]) then
              right := crossing.data[i]
            else
              if order(crossing.data[i] , left , right) then
                left := crossing.data[i];
                
          Len1 := dist(left , edge.p1); Len2 := dist(left , edge.p2);
          if Len1 > Len2 then
            begin
                tmp := Len1; Len1 := Len2; Len2 := tmp;
            end;
          Len3 := dist(left , crossing.data[1]); Len4 := dist(left , crossing.data[2]);
          if Len3 > Len4 then
            begin
                tmp := Len3; Len3 := Len4; Len4 := tmp;
            end;
            
          if Len1 < Len3 then
            LLen := Len3
          else
            LLen := Len1;
          if Len2 > Len4 then
            RLen := Len4
          else
            RLen := Len2;

          if LLen > RLen then
            process := 0
          else
            process := RLen - LLen;
      end;
end;

procedure work;
var
    i          : integer;
begin
    Convex;

    fillchar(answer , sizeof(answer) , 0);
    for i := 1 to M do
      answer[i] := process(mineral[i]);
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to M do
        writeln(answer[i] : 0 : 2);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
