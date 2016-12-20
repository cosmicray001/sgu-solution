{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p122.in';
    OutFile    = 'p122.out';
    Limit      = 1000;

Type
    Tgather    = array[1..Limit] of boolean;
    Tdata      = array[1..Limit] of Tgather;
    Tpath      = record
                     total    : integer;
                     data     : array[1..Limit] of integer;
                 end;

Var
    data       : Tdata;
    gather ,
    connect    : Tgather;
    path       : Tpath;
    N          : integer;

procedure init;
var
    i , p      : integer;
begin
    fillchar(data , sizeof(data) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
      for i := 1 to N do
        begin
            while not eoln do
              begin
                  read(p);
                  if p <> i then
                    data[i , p] := true;
              end;
            readln;
        end;
//    Close(INPUT);
end;

function Left_Extend_Sub : boolean;
var
    i , j      : integer;
begin
    for i := 1 to N do
      if not gather[i] and data[path.data[1] , i] then
        begin
            for j := path.total downto 1 do
              path.data[j + 1] := path.data[j];
            inc(path.total);
            path.data[1] := i;
            Left_Extend_Sub := true;
            gather[i] := true;
            for j := 1 to N do
              if data[i , j] then
                connect[j] := true;
            exit;
        end;
    Left_Extend_Sub := false;
end;

function Right_Extend_Sub : boolean;
var
    i , j      : integer;
begin
    for i := 1 to N do
      if not gather[i] and data[path.data[path.total] , i] then
        begin
            inc(path.total);
            path.data[path.total] := i;
            Right_Extend_Sub := true;
            gather[i] := true;
            for j := 1 to N do
              if data[i , j] then
                connect[j] := true;
            exit;
        end;
    Right_Extend_Sub := false;
end;

procedure Extend;
var
    change1 ,
    change2    : boolean;
begin
    repeat
      change1 := false;
      change2 := false;
      while Left_Extend_Sub do
        change1 := true;
      while Right_Extend_Sub do
        change2 := true;
    until not change1 and not change2;
end;

procedure Cycle;
var
    i , j , tmp: integer;
begin
    for i := path.total - 1 downto 1 do
      if data[path.data[1] , path.data[i + 1]] and data[path.data[i] , path.data[path.total]] then
        begin
            for j := 1 to (path.total - i) div 2 do
              begin
                  tmp := path.data[j + i];
                  path.data[j + i] := path.data[path.total - j + 1];
                  path.data[path.total - j + 1] := tmp;
              end;
            exit;
        end;
end;

procedure Addpoint;
var
    i , p , sum ,
    j          : integer;
    tmp        : Tpath;
begin
    i := 1;
    while gather[i] or not connect[i] do
      inc(i);

    p := 1;
    while not data[i , path.data[p]] do
      inc(p);

    fillchar(tmp , sizeof(tmp) , 0);
    sum := 0;
    for j := p + 1 to path.total do
      begin
          inc(sum);
          tmp.data[sum] := path.data[j];
      end;
    for j := 1 to p do
      begin
          inc(sum);
          tmp.data[sum] := path.data[j];
      end;
    inc(sum);
    tmp.data[sum] := i;
    tmp.total := sum;
    path := tmp;

    gather[i] := true;
    for j := 1 to N do
      if data[i , j] then
        connect[j] := true;
end;

procedure work;
begin
    fillchar(gather , sizeof(gather) , 0);
    fillchar(path , sizeof(path) , 0);
    path.total := 1;
    path.data[1] := 1;
    gather[1] := true;
    Connect := data[1];

    while path.total < N do
      begin
          Extend;
          Cycle;
          if path.total < N then
            Addpoint;
      end;
    Cycle;
end;

procedure out;
var
    i , p      : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      p := 1;
      while path.data[p] <> 1 do
        inc(p);
      for i := p to path.total do
        write(path.data[i] , ' ');
      for i := 1 to p - 1 do
        write(path.data[i] , ' ');
      writeln(1);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
