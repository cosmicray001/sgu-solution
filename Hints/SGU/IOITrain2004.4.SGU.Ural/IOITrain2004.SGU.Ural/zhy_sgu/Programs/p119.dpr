{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p119.in';
    OutFile    = 'p119.out';
    Limit      = 10000;

Type
    Tpair      = record
                     x , y    : integer;
                 end;
    Tdata      = array[1..Limit] of Tpair;

Var
    data       : Tdata;
    N , A , B ,
    gcdnum ,
    total      : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , A , B);
//    Close(INPUT);
end;

function gcd(A , B : integer) : integer;
begin
    if A = 0 then
      gcd := B
    else
      gcd := gcd(B mod A , A);
end;

procedure qk_pass(start , stop : integer; var mid : integer);
var
    key        : Tpair;
    tmp        : integer;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and ((data[stop].x > key.x) or (data[stop].x = key.x) and (data[stop].y > key.y)) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and ((data[start].x < key.x) or (data[start].x = key.x) and (data[start].y < key.y)) do inc(start);
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

procedure work;
var
    i          : integer;
begin
    gcdnum := gcd(gcd(A , B) , N);
    N := N div gcdnum; A := A div gcdnum; B := B div gcdnum;

    total := 0;
    for i := 0 to N - 1 do
      begin
          inc(total);
          data[total].x := A * i mod N;
          data[total].y := B * i mod N;
      end;
    qk_sort(1 , total);
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(total);
      for i := 1 to total do
        writeln(data[i].x * gcdnum , ' ' , data[i].y * gcdnum);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
