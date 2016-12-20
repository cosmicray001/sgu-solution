{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p143.in';
    OutFile    = 'p143.out';
    Limit      = 16000;

Type
    Tedge      = record
                     p1 , p2  : integer;
                 end;
    Tdata      = array[1..Limit * 2] of Tedge;
    Topt       = array[1..Limit] of integer;
    Tprofit    = array[1..Limit] of integer;
    Tvisited   = array[1..Limit] of boolean;
    Tindex     = array[1..Limit] of integer;

Var
    data       : Tdata;
    opt        : Topt;
    profit     : Tprofit;
    visited    : Tvisited;
    index      : Tindex;
    N , answer : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        read(profit[i]);
      for i := 1 to N - 1 do
        begin
            read(data[i].p1 , data[i].p2);
            data[i + N - 1].p1 := data[i].p2;
            data[i + N - 1].p2 := data[i].p1;
        end;
//    Close(INPUT);
end;

procedure qk_pass(start , stop : integer; var mid : integer);
var
    tmp        : integer;
    key        : Tedge;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (data[stop].p1 > key.p1) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (data[start].p1 < key.p1) do inc(start);
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

procedure dfs(root : integer);
var
    p          : integer;
begin
    visited[root] := true;
    p := index[root];
    opt[root] := profit[root];
    while (p <= N * 2 - 2) and (data[p].p1 = root) do
      begin
          if not visited[data[p].p2] then
            begin
                dfs(data[p].p2);
                if opt[data[p].p2] > 0 then
                  inc(opt[root] , opt[data[p].p2]);
            end;
          inc(p);
      end;
end;

procedure work;
var
    i          : integer;
begin
    qk_sort(1 , N * 2 - 2);
    fillchar(index , sizeof(index) , 0);
    for i := 1 to N * 2 - 2 do
      if index[data[i].p1] = 0 then
        index[data[i].p1] := i;

    fillchar(visited , sizeof(visited) , 0);
    fillchar(opt , sizeof(opt) , 0);
    dfs(1);
    answer := -maxlongint;
    for i := 1 to N do
      if answer < opt[i] then
        answer := opt[i];
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
