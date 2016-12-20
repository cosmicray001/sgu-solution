{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p207.in';
    OutFile    = 'p207.out';
    Limit      = 1000;

Type
    TX         = array[1..Limit] of longint;
    Tkey       = record
                     num , cost              : longint;
                 end;
    Tdata      = array[1..Limit] of Tkey;

Var
    X , sum    : TX;
    data       : Tdata;
    N , M , Y  : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M , Y);
      for i := 1 to N do
        read(X[i]);
//    Close(INPUT);
end;

procedure qk_pass(start , stop : longint; var mid : longint);
var
    key        : Tkey;
    tmp        : longint;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (data[stop].cost > key.cost) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (data[start].cost < key.cost) do inc(start);
          data[stop] := data[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    data[start] := key;
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
    i , tmp    : longint;
begin
    tmp := M;
    for i := 1 to N do
      begin
          sum[i] := X[i] * M div Y;
          dec(tmp , sum[i]);
          data[i].num := i;
          data[i].cost := X[i] * M - sum[i] * Y;
      end;
    qk_sort(1 , N);
    for i := N downto N - tmp + 1 do
      inc(sum[data[i].num]);
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to N do
        write(sum[i] , ' ');
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
