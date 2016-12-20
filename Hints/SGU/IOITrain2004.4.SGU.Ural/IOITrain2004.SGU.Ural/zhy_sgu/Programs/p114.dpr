{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p114.in';
    OutFile    = 'p114.out';
    Limit      = 15000;

Type
    Trec       = record
                     X        : extended;
                     P        : integer;
                 end;
    Tdata      = array[1..Limit] of Trec;

Var
    data       : Tdata;
    N , sum ,
    answer     : integer;

procedure init;
var
    i          : integer;
begin
    sum := 0;
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        begin
            read(data[i].X , data[i].P);
            inc(sum , data[i].P);
        end;
//    Close(INPUT);
end;

procedure qk_pass(start , stop : integer; var mid : integer);
var
    key        : Trec;
    tmp        : integer;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (data[stop].X > key.X) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (data[start].X < key.X) do inc(start);
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
    tmp , i    : integer;
begin
    qk_sort(1 , N);
    tmp := 0;
    for i := 1 to N do
      begin
          inc(tmp , data[i].P);
          if tmp * 2 >= sum then
            begin
                answer := i;
                break;
            end;
      end; 
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(data[answer].X : 0 : 5);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
