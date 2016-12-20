{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p110.in';
    OutFile    = 'p110.out';
    Limit      = 50;
    LimitTimes = 10;
    zero       = 1e-8;

Type
    Tpoint     = record
                     x , y , z               : extended;
                 end;
    TCircle    = record
                     O                       : Tpoint;
                     R                       : extended;
                 end;
    Tvector    = record
                     start , direct          : Tpoint;
                 end;
    Tpath      = record
                     total                   : integer;
                     data                    : array[1..LimitTimes + 1] of integer;
                 end;
    Tdata      = array[1..Limit] of Tcircle;

Var
    data       : Tdata;
    light      : Tvector;
    path       : Tpath;
    N          : integer;

procedure add(var p1 , p2 : Tpoint; dir : extended);
begin
    p1.x := p1.x + p2.x * dir;
    p1.y := p1.y + p2.y * dir;
    p1.z := p1.z + p2.z * dir;
end;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        with data[i] do
          read(O.x , O.y , O.z , R);
      with light do
        read(start.x , start.y , start.z , direct.x , direct.y , direct.z);
//    Close(INPUT);
end;

function dist(p1 , p2 : Tpoint) : extended;
begin
    dist := sqrt(sqr(p1.x - p2.x) + sqr(p1.y - p2.y) + sqr(p1.z - p2.z));
end;

function equal(A , B : extended) : boolean;
begin
    equal := (abs(A - B) <= zero);
end;

function get_crossing(circle : Tcircle; vector : Tvector; var crossing : Tpoint; var distance : extended) : boolean;
var
    Ostart ,
    cosS , H ,
    Len , tmp  : extended;
    zerostart  : Tpoint;
begin
    add(vector.direct , vector.start , -1);
    add(circle.O , vector.start , -1);
    fillchar(zerostart , sizeof(zerostart) , 0);

    Ostart := dist(circle.O , zerostart);
    cosS := (circle.O.x * vector.direct.x + circle.O.y * vector.direct.y + circle.O.z * vector.direct.z)
      / Ostart / dist(vector.direct , zerostart);

    if cosS < zero then
      get_crossing := false
    else
      begin
          get_crossing := true;
          Len := Ostart * cosS;
          tmp := sqr(Ostart) - sqr(Len);
          if tmp <= zero then
            H := 0
          else
            H := sqrt(tmp);
            
          tmp := sqr(circle.R) - sqr(H);
          if tmp <= -zero then
            begin
                get_crossing := false;
                exit;
            end
          else
            if tmp <= zero then
              tmp := 0;
          distance := Len - sqrt(tmp);

          Len := dist(vector.direct , zerostart);
          if not equal(Len , 0) then
            begin
                vector.direct.x := vector.direct.x * distance / Len;
                vector.direct.y := vector.direct.y * distance / Len;
                vector.direct.z := vector.direct.z * distance / Len;
            end;
          add(vector.direct , vector.start , 1);
          crossing := vector.direct;
      end;
end;

procedure cross_product(v1 , v2 : Tpoint; var v3 : Tpoint);
begin
    v3.x := v1.y * v2.z - v1.z * v2.y;
    v3.y := v1.z * v2.x - v1.x * v2.z;
    v3.z := v1.x * v2.y - v1.y * v2.x;
end;

function dot_product(v1 , v2 : Tpoint) : extended;
begin
    dot_product := v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
end;

procedure getNewVector(circle : Tcircle; light : Tvector; crossing : Tpoint; var newLight : Tvector);
var
    Zvector ,
    Xvector ,
    zeropoint  : Tpoint;
    x , y ,
    distX , distY
               : extended;
begin
    fillchar(zeropoint , sizeof(zeropoint) , 0);
    add(crossing , circle.O , -1);
    add(light.start , light.direct , -1);
    cross_product(light.start , crossing , Zvector);
    cross_product(crossing , Zvector , Xvector);
    if equal(dist(Zvector , zeropoint) , 0) then
      begin
          add(crossing , circle.O , 1);
          newLight.start := crossing;
          newLight.direct := light.start;
          add(newLight.direct , crossing , 1);
          exit;
      end;
    x := -dot_product(Xvector , light.start) / dist(Xvector , zeropoint);
    y := dot_product(crossing , light.start) / dist(crossing , zeropoint);
    distX := dist(Xvector , zeropoint);
    distY := dist(crossing , zeropoint);
    newLight.direct.x := Xvector.x * x / distX + crossing.x * y / distY;
    newLight.direct.y := Xvector.y * x / distX + crossing.y * y / distY;
    newLight.direct.z := Xvector.z * x / distX + crossing.z * y / distY;
    add(crossing , circle.O , 1);
    add(newLight.direct , crossing , 1);
    newLight.start := crossing;
end;

procedure work;
var
    i , min    : integer;
    mincrossing ,
    crossing   : Tpoint;
    mindist ,
    distance   : extended;
begin
    fillchar(path , sizeof(path) , 0);
    while path.total <= LimitTimes do
      begin
          min := 0;
          for i := 1 to N do
            if get_crossing(data[i] , light , crossing , distance) then
              if (min = 0) or (mindist > distance) then
                begin
                    min := i;
                    mindist := distance;
                    mincrossing := crossing;
                end;

          if min <> 0 then
            begin
                inc(path.total);
                path.data[path.total] := min;
                getNewVector(data[min] , light , mincrossing , light);
            end
          else
            break;
      end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if path.total = 0 then
        writeln
      else
        begin
            for i := 1 to path.total - 1 do
              write(path.data[i] , ' ');
            if path.total > LimitTimes then
              writeln('etc.')
            else
              writeln(path.data[path.total]);
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
