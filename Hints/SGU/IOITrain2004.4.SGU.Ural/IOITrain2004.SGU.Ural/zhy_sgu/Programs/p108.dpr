{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p108.in';
    OutFile    = 'p108.out';
    Limit      = 1000;
    LimitRequest
               = 5000;

Type
    Tdata      = array[1..Limit] of boolean;
    Tsingle    = record
                     request , number ,
                     answer                  : integer;
                 end;
    Trequest   = array[1..LimitRequest] of Tsingle;

Var
    data       : Tdata;
    request    : Trequest;
    N , K ,
    total      : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , K);
      for i := 1 to K do
        begin
            read(request[i].request);
            request[i].number := i;
        end;
//    Close(INPUT);
end;

procedure qk_pass(start , stop : integer; var mid : integer);
var
    tmp        : integer;
    key        : Tsingle;
begin
    tmp := random(stop - start + 1) + start;
    key := request[tmp]; request[tmp] := request[start];
    while start < stop do
      begin
          while (start < stop) and (request[stop].request > key.request) do dec(stop);
          request[start] := request[stop];
          if start < stop then inc(start);
          while (start < stop) and (request[start].request < key.request) do inc(start);
          request[stop] := request[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    request[start] := key;
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
const
    Base       = 10000;
type
    Tsub       = array[0..Base] of integer;
var
    i , tmp , p ,
    sum , now  : integer;
    sub        : Tsub;
begin
    qk_sort(1 , K);

    for i := 0 to Base do
      begin
          sum := 0;
          tmp := i;
          while tmp <> 0 do
            begin
                inc(sum , tmp mod 10);
                tmp := tmp div 10;
            end;
          sub[i] := sum;
      end;

    fillchar(data , sizeof(data) , 0);
    now := 1;
    total := 0;
    p := 1;
    for i := 1 to N do
      begin
          if not data[now] then
            begin
                inc(total);
                while (p <= K) and (request[p].request = total) do
                  begin
                      request[p].answer := i;
                      inc(p);
                  end;
            end;
          sum := sub[i div Base] + sub[i mod base];
          tmp := now + sum;
          while tmp > Limit do
            dec(tmp , Limit);
          data[tmp] := true;
          data[now] := false;
          if now = Limit then
            now := 1
          else
            inc(now);
      end;
end;

procedure out;
type
    Toutarr    = array[1..LimitRequest] of integer;
var
    outarr     : Toutarr;
    i          : integer;
begin
    for i := 1 to K do
      outarr[request[i].number] := request[i].answer;

//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(total);
      for i := 1 to K - 1 do
        write(outarr[i] , ' ');
      if K <> 0 then
        writeln(outarr[K])
      else
        writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
