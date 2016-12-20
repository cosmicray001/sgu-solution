{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p134.in';
    OutFile    = 'p134.out';
    Limit      = 16000;

Type
    Tedge      = record
                     p1 , p2  : integer;
                 end;
    Tdata      = array[1..Limit * 2] of Tedge;
    Tchildren  = array[1..Limit] of integer;
    Tanswer    = record
                     min , total             : integer;
                     data                    : array[1..Limit] of integer;
                 end;
    Tindex     = array[1..Limit] of integer;
    Tvisited   = array[1..Limit] of boolean;

Var
    data       : Tdata;
    children   : Tchildren;
    answer     : Tanswer;
    index      : Tindex;
    visited    : Tvisited;
    N , M      : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N - 1 do
        begin
            read(data[i].p1 , data[i].p2);
            data[i + N - 1].p1 := data[i].p2;
            data[i + N - 1].p2 := data[i].p1;
        end;
      M := (N - 1) * 2;
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
    p , max    : integer;
begin
    if not visited[root] then
      begin
          visited[root] := true;
          p := index[root];
          children[root] := 1;
          max := 0;
          while (p <= M) and (data[p].p1 = root) do
            begin
                if not visited[data[p].p2] then
                  begin
                      dfs(data[p].p2);
                      inc(children[root] , children[data[p].p2]);
                      if max < children[data[p].p2] then
                        max := children[data[p].p2];
                  end;
                inc(p);
            end;
          if max < N - children[root] then
            max := N - children[root];
          if (answer.total = 0) or (max < answer.min) then
            begin
                answer.min := max;
                answer.total := 1;
                answer.data[1] := root;
            end
          else
            if max = answer.min then
              begin
                  inc(answer.total);
                  answer.data[answer.total] := root;
              end;
      end;
end;

procedure qk_pass_answer(start , stop : integer; var mid : integer);
var
    tmp , key  : integer;
begin
    tmp := random(stop - start + 1) + start;
    key := answer.data[tmp]; answer.data[tmp] := answer.data[start];
    while start < stop do
      begin
          while (start < stop) and (answer.data[stop] > key) do dec(stop);
          answer.data[start] := answer.data[stop];
          if start < stop then inc(start);
          while (start < stop) and (answer.data[start] < key) do inc(start);
          answer.data[stop] := answer.data[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    answer.data[start] := key;
end;

procedure qk_sort_answer(start , stop : integer);
var
    mid        : integer;
begin
    if start < stop then
      begin
          qk_pass_answer(start , stop , mid);
          qk_sort_answer(start , mid - 1);
          qk_sort_answer(mid + 1 , stop);
      end;
end;

procedure work;
var
    i          : integer;
begin
    qk_sort(1 , M);
    fillchar(index , sizeof(index) , 0);
    for i := 1 to M do
      if index[data[i].p1] = 0 then
        index[data[i].p1] := i;
    fillchar(answer , sizeof(answer) , 0);
    fillchar(visited , sizeof(visited) , 0);

    dfs(1);
    qk_sort_answer(1 , answer.total);
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer.min , ' ' , answer.total);
      for i := 1 to answer.total - 1 do
        write(answer.data[i] , ' ');
      writeln(answer.data[answer.total]);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
