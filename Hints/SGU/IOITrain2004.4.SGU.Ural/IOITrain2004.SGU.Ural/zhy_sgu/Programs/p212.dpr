{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p212.in';
    OutFile    = 'p212.out';
    Limit      = 1500;
    LimitM     = 300000;

Type
    Tedge      = record
                     p1 , p2 , C , F , num   : longint;
                 end;
    Tdata      = array[1..LimitM] of Tedge;
    Tnum       = array[1..Limit] of longint;
    Tfilled    = array[1..Limit] of boolean;
    Tpoints    = array[1..Limit] of longint;

Var
    data ,
    tmp        : Tdata;
    index , count ,
    level , remain ,
    C          : Tnum;
    filled     : Tfilled;
    points     : Tpoints;
    N , M , L ,
    Source , 
    Target     : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M , L);
      for i := 1 to N do
        begin
            read(level[i]);
            if level[i] = 1
              then source := i
              else if level[i] = L then target := i;
        end;
      fillchar(data , sizeof(data) , 0);
      for i := 1 to M do
        begin
            read(data[i].p1 , data[i].p2 , data[i].C);
            data[i].num := i;
        end;
//    Close(INPUT);
end;

procedure pre_process;
var
    i          : longint;
begin
    fillchar(count , sizeof(count) , 0);
    for i := 1 to M do inc(count[data[i].p1]);
    index[1] := 1;
    for i := 2 to N do index[i] := index[i - 1] + count[i - 1];
    for i := 1 to M do
      begin
          tmp[index[data[i].p1]] := data[i];
          inc(index[data[i].p1]);
      end;
    index[1] := 1;
    for i := 2 to N do index[i] := index[i - 1] + count[i - 1];
    data := tmp;
end;

procedure qk_pass(start , stop : longint; var mid : longint);
var
    key , tmp  : longint;
begin
    tmp := random(stop - start + 1) + start;
    key := points[tmp]; points[tmp] := points[start];
    while start < stop do
      begin
          while (start < stop) and (level[points[stop]] > level[key]) do dec(stop);
          points[start] := points[stop];
          if start < stop then inc(start);
          while (start < stop) and (level[points[start]] < level[key]) do inc(start);
          points[stop] := points[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    points[start] := key;
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

procedure Greedy;
var
    i , j , p ,
    num        : longint;
begin
    for i := 1 to N do points[i] := i;
    qk_sort(1 , N);

    fillchar(remain , sizeof(remain) , 0);
    fillchar(C , sizeof(C) , 0);
    remain[source] := maxlongint; C[source] := maxlongint;
    for i := 1 to N - 1 do
      begin
          p := points[i];
          j := index[p];
          while (j <= M) and (data[j].p1 = p) do
            begin
                if remain[p] > data[j].C
                  then begin
                           dec(remain[p] , data[j].C);
                           data[j].F := data[j].C;
                           inc(remain[data[j].p2] , data[j].F);
                           inc(C[data[j].p2] , data[j].F);
                       end
                  else begin
                           data[j].F := remain[p];
                           remain[p] := 0;
                           inc(remain[data[j].p2] , data[j].F);
                           inc(C[data[j].p2] , data[j].F);
                           break;
                       end;
                inc(j);
            end;
      end;

    remain[target] := 0;
    for i := N - 1 downto 1 do
      begin
          p := points[i];
          j := index[p];
          while (j <= M) and (data[j].p1 = p) do
            begin
                if remain[data[j].p2] < data[j].F
                  then num := remain[data[j].p2]
                  else num := data[j].F;
                if num > C[p] - remain[p] then
                  num := C[p] - remain[p];
                inc(remain[p] , num);
                dec(remain[data[j].p2] , num); dec(data[j].F , num);
                if C[p] = remain[p] then break;
                inc(j);
            end;
      end;
end;

function dfs(root , last : longint) : longint;
var
    i , next   : longint;
begin
    if root = target then
      begin
          dfs := last;
          exit;
      end;
    dfs := 0;
    if filled[root] then exit;
    i := index[root];
    while (i <= M) and (data[i].p1 = root) do
      begin
          if data[i].C = data[i].F then
            begin
                inc(index[root]); inc(i);
                continue;
            end;
          if data[i].C - data[i].F < last
            then next := dfs(data[i].p2 , data[i].C - data[i].F)
            else next := dfs(data[i].p2 , last);
          if next = 0 then
            begin
                inc(index[root]); inc(i);
                continue;
            end;
          inc(data[i].F , next);
          if data[i].C = data[i].F then inc(index[root]);
          dfs := next;
          exit;
      end;
    filled[root] := true;
end;

procedure work;
var
    i          : longint;
begin
    pre_process;

    Greedy;
    
    fillchar(filled , sizeof(filled) , 0);
    while not filled[source] do
      dfs(source , maxlongint);

    for i := 1 to M do
      tmp[data[i].num].F := data[i].F;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to M do
        writeln(tmp[i].F);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
