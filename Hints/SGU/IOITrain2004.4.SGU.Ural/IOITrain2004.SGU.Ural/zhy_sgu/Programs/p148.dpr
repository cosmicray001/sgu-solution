{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p148.in';
    OutFile    = 'p148.out';
    Limit      = 15000;

Type
    Tdata      = array[1..Limit] of
                   record
                       now , total , cost    : integer;
                   end;
    Tsubnum    = record
                     number , data           : integer;
                 end;
    Tsub       = array[1..Limit] of Tsubnum;
    Tvisited   = array[1..Limit] of boolean;

Var
    data       : Tdata;
    sub        : Tsub;
    visited    : Tvisited;
    N , bestcost ,
    beststart  : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
      for i := 1 to N do
        readln(data[i].now , data[i].total , data[i].cost);
//    Close(INPUT);
end;

procedure qk_pass(start , stop : integer; var mid : integer);
var
    tmp        : integer;
    key        : Tsubnum;
begin
    tmp := random(stop - start + 1) + start;
    key := sub[tmp]; sub[tmp] := sub[start];
    while start < stop do
      begin
          while (start < stop) and (sub[stop].data > key.data) do dec(stop);
          sub[start] := sub[stop];
          if start < stop then inc(start);
          while (start < stop) and (sub[start].data < key.data) do inc(start);
          sub[stop] := sub[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    sub[start] := key;
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
    subsum , i ,
    p , nowcost ,
    minus      : integer;
begin
    subsum := 0;
    nowcost := 0;
    for i := 1 to N do
      begin
          inc(subsum , data[i].now);
          sub[i].number := i;
          sub[i].data := subsum - data[i].total;
          if sub[i].data <= 0 then
            begin
                inc(nowcost , data[i].cost);
                visited[i] := true;
            end
          else
            visited[i] := false;
      end;
    bestcost := nowcost; beststart := 1;
    qk_sort(1 , N);

    p := 1;
    minus := 0;
    for i := 2 to N do
      begin
          inc(minus , data[i - 1].now);
          if visited[i - 1] then
            dec(nowcost , data[i - 1].cost);
          while (p <= N) and (sub[p].data - minus <= 0) do
            begin
                if (sub[p].number >= i) and not visited[sub[p].number] then
                  begin
                      inc(nowcost , data[sub[p].number].cost);
                      visited[sub[p].number] := true;
                  end;
                inc(p);
            end;
          if nowcost < bestcost then
            begin
                beststart := i;
                bestcost := nowcost;
            end;
      end;
end;

procedure out;
var
    subsum , i : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      subsum := 0;
      for i := beststart to N do
        begin
            inc(subsum , data[i].now);
            if subsum <= data[i].total then
              writeln(i);
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
