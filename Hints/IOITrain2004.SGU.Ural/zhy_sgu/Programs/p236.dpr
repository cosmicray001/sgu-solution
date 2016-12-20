{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p236.in';
    OutFile    = 'p236.out';
    Limit      = 50;
    LimitStop  = 101;
    minimum    = 1e-6;

Type
    Tdata      = array[1..Limit , 1..Limit] of
                   record
                       C , T                 : longint;
                       cost                  : extended;
                   end;
    Tshortest  = array[1..Limit] of
                   record
                       shortest              : extended;
                       father                : longint;
                   end;
    Tpath      = record
                     tot                     : longint;
                     data                    : array[1..Limit] of longint;
                 end;
    Tvisited   = array[1..Limit] of boolean;

Var
    shortest   : Tshortest;
    data       : Tdata;
    path       : Tpath;
    visited    : Tvisited;
    answer     : extended;
    N , startp ,
    notpath    : longint;

procedure init;
var
    M , i ,
    p1 , p2    : longint;
begin
    fillchar(data , sizeof(data) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        begin
            read(p1 , p2);
            read(data[p1 , p2].C , data[p1 , p2].T);
        end;
//    Close(INPUT);
end;

function check(bound : extended) : boolean;
var
    i , j , k  : longint;
    found      : boolean;
begin
    for i := 1 to N do
      for j := 1 to N do
        if data[i , j].C <> 0 then
          data[i , j].cost := data[i , j].T * bound - data[i , j].C;
    fillchar(shortest , sizeof(shortest) , 0);
    check := false;
    for k := 1 to N + 1 do
      begin
          found := false;
          for i := 1 to N do
            for j := 1 to N do
              if data[i , j].C <> 0 then
                if data[i , j].cost + shortest[i].shortest < shortest[j].shortest then
                  begin
                      shortest[j].shortest := shortest[i].shortest + data[i , j].cost;
                      shortest[j].father := i;
                      startp := j;
                      found := true;
                  end;
          if not found then exit;
      end;
    check := true;
end;

procedure work;
var
    start , stop ,
    mid        : extended;
begin
    start := 0; stop := LimitStop;
    path.tot := 0;
    if not check(0) then exit;
    while start + minimum <= stop do
      begin
          mid := (start + stop) / 2;
          if check(mid)
            then begin
                     answer := mid;
                     start := mid;
                 end
            else stop := mid;
      end;

    check(answer);
    fillchar(visited , sizeof(visited) , 0);
    while not visited[startp] do
      begin
          visited[startp] := true;
          inc(path.tot);
          path.data[path.tot] := startp;
          startp := shortest[startp].father;
      end;
    notpath := 1;
    while path.data[notpath] <> startp do inc(notpath);
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if path.tot <> 0 then
        begin
            writeln(path.tot - notpath + 1);
            for i := path.tot downto notpath do
              write(path.data[i] , ' ');
            writeln;
        end
      else
        writeln(0);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
