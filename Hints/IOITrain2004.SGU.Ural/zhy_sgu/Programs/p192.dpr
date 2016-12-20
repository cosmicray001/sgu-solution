{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p192.in';
    OutFile    = 'p192.out';
    Limit      = 310;
    minimum    = 1e-6;

Type
    Tpoint     = record
                     x , y                   : real;
                 end;
    TLine      = record
                     A , B , C               : real;
                 end;
    Tsegment   = record
                     p1 , p2                 : Tpoint;
                     index , color           : smallint;
                 end;
    Tdata      = array[1..Limit] of Tsegment;
    Tqueue     = array[1..Limit] of longint;
    Tkey       = record
                     sign                    : byte;
                     n1 , n2                 : smallint;
                     x                       : real;
                 end;
    Tevent     = array[1..Limit * Limit div 2] of Tkey;
    Tsum       = array[1..3] of real;

Var
    data       : Tdata;
    queue      : Tqueue;
    event      : Tevent;
    sum        : Tsum;
    N , M ,
    tot        : longint;

function zero(num : real) : boolean;
begin
    zero := (abs(num) <= minimum);
end;

procedure init;
var
    i          : longint;
    tmp        : Tpoint;
    c          : char;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      fillchar(data , sizeof(data) , 0);
      readln(N);
      i := 1;
      while i <= N do
        begin
            read(data[i].p1.x , data[i].p1.y , data[i].p2.x , data[i].p2.y);
            if zero(data[i].p1.x - data[i].p2.x) then
              begin
                  dec(N);
                  readln;
                  continue;
              end;
            if data[i].p1.x > data[i].p2.x then
              begin
                  tmp := data[i].p1; data[i].p1 := data[i].p2; data[i].p2 := tmp;
              end;
            read(c);
            while c = ' ' do read(c);
            Case c of
              'R'             : data[i].color := 1;
              'G'             : data[i].color := 2;
              'B'             : data[i].color := 3;
            end;
            readln;
            inc(i);
        end;
//    Close(INPUT);
end;

procedure Get_Line(p1 , p2 : Tpoint; var L : TLine);
begin
    L.A := p2.y - p1.y; L.B := p1.x - p2.x;
    L.C := p2.x * p1.y - p1.x * p2.y;
end;

function crossing(sg1 , sg2 : Tsegment; var x : real) : boolean;
var
    L1 , L2    : TLine;
begin
    Get_Line(sg1.p1 , sg1.p2 , L1);
    Get_Line(sg2.p1 , sg2.p2 , L2);
    crossing := false;
    if (L1.A * sg2.p1.x + L1.B * sg2.p1.y + L1.C) * (L1.A * sg2.p2.x + L1.B * sg2.p2.y + L1.C) >= 0 then exit;
    if (L2.A * sg1.p1.x + L2.B * sg1.p1.y + L2.C) * (L2.A * sg1.p2.x + L2.B * sg1.p2.y + L2.C) >= 0 then exit;
    x := (L1.C * L2.B - L2.C * L1.B) / (L2.A * L1.B - L1.A * L2.B);
    crossing := true;
end;

procedure qk_pass(start , stop : longint; var mid : longint);
var
    key        : Tkey;
    tmp        : longint;
begin
    tmp := random(stop - start + 1) + start;
    key := event[tmp]; event[tmp] := event[start];
    while start < stop do
      begin
          while (start < stop) and ((event[stop].x > key.x) or (event[stop].x = key.x) and (data[event[stop].n1].index < data[key.n1].index))  do dec(stop);
          event[start] := event[stop];
          if start < stop then inc(start);
          while (start < stop) and ((event[start].x < key.x) or (event[start].x = key.x) and (data[event[start].n1].index > data[key.n1].index)) do inc(start);
          event[stop] := event[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    event[start] := key;
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

procedure pre_process;
var
    i , j      : longint;
    x          : real;
begin
    M := 0;
    for i := 1 to N do
      for j := i + 1 to N do
        if crossing(data[i] , data[j] , x) then
          begin
              inc(M);
              event[M].sign := 3; event[M].n1 := i; event[M].n2 := j;
              event[M].x := x;
          end;
    for i := 1 to N do
      begin
          inc(M);
          event[M].sign := 1; event[M].n1 := i; event[M].x := data[i].p1.x;
          inc(M);
          event[M].sign := 2; event[M].n1 := i; event[M].x := data[i].p2.x;
      end;
    qk_sort(1 , M);
end;

function upper(sg1 , sg2 : Tsegment; x : real) : boolean;
var
    L1 , L2    : TLine;
    y1 , y2    : real;
begin
    Get_Line(sg1.p1 , sg1.p2 , L1);
    y1 := -(L1.A * x + L1.C) / L1.B;
    Get_Line(sg2.p1 , sg2.p2 , L2);
    y2 := -(L2.A * x + L2.C) / L2.B;
    if zero(y1 - y2)
      then upper := (-L1.A / L1.B > -L2.A / L2.B)
      else upper := (y1 > y2);
end;

procedure _insert(p : longint; x : real);
var
    i          : longint;
begin
    i := tot;
    while i > 0 do
      if upper(data[queue[i]] , data[p] , x)
        then begin
                 queue[i + 1] := queue[i];
                 data[queue[i + 1]].index := i + 1;
                 dec(i);
             end
        else break;
    inc(tot);
    queue[i + 1] := p;
    data[queue[i + 1]].index := i + 1;
end;

procedure _delete(p : longint);
var
    i , tmp    : longint;
begin
    tmp := p;
    p := data[p].index;
    data[tmp].index := 0;
    for i := p + 1 to tot do
      begin
          queue[i - 1] := queue[i];
          data[queue[i - 1]].index := i - 1;
      end;
    dec(tot);
end;

procedure _swap(p1 , p2 : longint; x : real);
var
    tmp        : longint;
begin
    p1 := data[p1].index; p2 := data[p2].index;
    if (p1 = 0) or (p2 = 0) then exit;
    if (p1 < p2) xor upper(data[queue[p1]] , data[queue[p2]] , x) then exit;
    tmp := queue[p1]; queue[p1] := queue[p2]; queue[p2] := tmp;
    data[queue[p1]].index := p1;
    data[queue[p2]].index := p2;
end;

procedure work;
var
    i , j      : longint;
    tmp        : smallint;
begin
    pre_process;

    fillchar(sum , sizeof(sum) , 0);
    for i := 1 to M do
      begin
          if (i = 1) or not zero(event[i - 1].x - event[i].x) then
            begin
                j := i;
                while (j <= M) and zero(event[i].x - event[j].x) do
                  begin
                      if (event[j].sign = 3) and (data[event[j].n1].index < data[event[j].n2].index) then
                        begin
                            tmp := event[j].n1; event[j].n1 := event[j].n2; event[j].n2 := tmp;
                        end;
                      inc(j);
                  end;
                dec(j);
                qk_sort(i , j);
            end;
          case event[i].sign of
            1      : _insert(event[i].n1 , event[i].x);
            2      : _delete(event[i].n1);
            3      : _swap(event[i].n1 , event[i].n2 , event[i].x);
          end;
          if (tot > 0) and (i < M) then
            sum[data[queue[1]].color] := sum[data[queue[1]].color] + event[i + 1].x - event[i].x;
      end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln('R ' , sum[1] : 0 : 2);
      writeln('G ' , sum[2] : 0 : 2);
      writeln('B ' , sum[3] : 0 : 2);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
