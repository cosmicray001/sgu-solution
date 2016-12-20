{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p186.in';
    OutFile    = 'p186.out';
    Limit      = 100;

Type
    Tdata      = array[1..Limit] of longint;

Var
    data       : Tdata;
    N , answer : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        read(data[i]);
//    Close(INPUT);
end;

procedure qk_pass(start , stop : longint; var mid : longint);
var
    key , tmp  : longint;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (data[stop] > key) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (data[start] < key) do inc(start);
          data[stop] := data[start];
          if start < stop then dec(stop);
      end;
    data[start] := key;
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

procedure work;
var
    start ,
    stop       : longint;
begin
    qk_sort(1 , N);
    answer := 0; start := 1; stop := N;
    while start < stop do
      begin
          inc(answer);
          dec(data[start]);
          inc(data[stop - 1] , data[stop] + 1);
          dec(stop);
          if data[start] = 0 then inc(start);
      end;
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
