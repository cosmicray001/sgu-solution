{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    InFile     = 'p216.in';
    OutFile    = 'p216.out';
    Limit      = 10010;

Type
    Tedge      = record
                     x , y    : longint;
                 end;
    Tdata      = array[1..Limit * 2] of Tedge;
    Tnum       = array[1..Limit] of longint;

Var
    data       : Tdata;
    index , children ,
    color , capital ,
    queue , cost
               : Tnum;
    N , M , B ,
    C          : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , B);
      for i := 1 to N - 1 do
        begin
            read(data[i].x , data[i].y);
            data[i + N - 1].x := data[i].y;
            data[i + N - 1].y := data[i].x;
        end;
//    Close(INPUT);
end;

procedure qk_pass_edge(start , stop : longint; var mid : longint);
var
    key        : Tedge;
    tmp        : longint;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (data[stop].x > key.x) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (data[start].x < key.x) do inc(start);
          data[stop] := data[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    data[start] := key;
end;

procedure qk_sort_edge(start , stop : longint);
var
    mid        : longint;
begin
    if start < stop then
      begin
          qk_pass_edge(start , stop , mid);
          qk_sort_edge(start , mid - 1);
          qk_sort_edge(mid + 1 , stop);
      end;
end;

procedure make_data;
var
    i          : longint;
begin
    M := N * 2 - 2;
    qk_sort_edge(1 , M);
    fillchar(index , sizeof(index) , 0);
    for i := 1 to N * 2 - 2 do
      if index[data[i].x] = 0 then
        index[data[i].x] := i;
    index[N + 1] := M + 1;
end;

procedure dfs_children(father , root : longint);
var
    p          : longint;
begin
    p := index[root];
    children[root] := 1;
    while (p <> 0) and (p <= M) and (data[p].x = root) do
      begin
          if data[p].y <> father then
            begin
                dfs_children(root , data[p].y);
                inc(children[root] , children[data[p].y]);
            end;
          inc(p);
      end;
end;

procedure dfs_color(root , fa , col : longint);
var
    p          : longint;
begin
    color[root] := col;
    if root = fa then exit;
    p := index[root];
    while (p <> 0) and (p <= M) and (data[p].x = root) do
      begin
          if (children[root] > children[data[p].y]) then
            dfs_color(data[p].y , fa , col);
          inc(p);
      end;
end;

procedure dfs_answer(fathernode , fathercolor , root : longint);
var
    last , i , j ,
    start , stop ,
    tmp , tot ,
    nowC       : longint;
begin
    start := index[root]; stop := index[root + 1] - 1;
    tot := 1; queue[tot] := root; cost[tot] := fathernode + 1; last := cost[tot];
    for i := start to stop do
      if (children[data[i].y] < children[root]) and (children[data[i].y] < B) then
        begin
            inc(tot); inc(last , children[data[i].y]);
            queue[tot] := data[i].y; cost[tot] := children[data[i].y];
        end;

    i := 1;
    if last >= B
      then while last > 3 * B do
             begin
                 j := i; tmp := 0;
                 while tmp < B do
                   begin
                       inc(tmp , cost[j]);
                       inc(j);
                   end;
                 dec(j);
                 if (i <> 1) or (fathernode = 0)
                   then begin
                            inc(C); capital[C] := root; nowC := C;
                        end
                   else nowC := fathercolor;
                 while i <= j do
                   begin
                       dfs_color(queue[i] , root , nowC);
                       inc(i);
                   end;
                 dec(last , tmp);
             end;

    if (i <> 1) or (fathernode = 0)
      then begin
               inc(C); capital[C] := root; nowC := C;
           end
      else nowC := fathercolor;
    for j := i to tot do
      dfs_color(queue[j] , root , nowC);

    for i := start to stop do
      if (children[data[i].y] < children[root]) and (children[data[i].y] >= B) then
        if last < B
          then begin
                   dfs_answer(last , color[root] , data[i].y);
                   last := B + 1;
               end
          else dfs_answer(0 , 0 , data[i].y);
end;

procedure work;
begin
    make_data;
    fillchar(children , sizeof(children) , 0);
    dfs_children(0 , 1);

    fillchar(color , sizeof(color) , 0); fillchar(capital , sizeof(capital) , 0);
    C := 0;
    dfs_answer(0 , 0 , 1);
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(C);
      for i := 1 to N do write(color[i] , ' ');
      writeln;
      for i := 1 to C do write(capital[i] , ' ');
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
