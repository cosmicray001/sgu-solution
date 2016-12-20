{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p156.in';
    OutFile    = 'p156.out';
    Limit      = 10000;
    LimitM     = 100000;

Type
    Tedge      = record
                     p1 , p2  : integer;
                 end;
    Tgraph     = array[1..LimitM * 2] of Tedge;
    Tdata      = array[0..Limit] of integer;
    Tpath      = record
                     total    : integer;
                     data     : array[1..Limit * 2] of
                                  record
                                      point , next , mark   : integer;
                                  end;
                 end;
    Tmap       = array[1..Limit] of
                   record
                       p1 , p2               : integer;
                   end;
    Trec       = record
                     num , color             : integer;
                 end;
    Tsort      = array[1..Limit] of Trec;

Var
    graph      : Tgraph;
    index ,
    degree ,
    visited ,
    color ,
    colorindex ,
    colortotal : Tdata;
    path       : Tpath;
    map        : Tmap;
    sort       : Tsort;
    NoAnswer   : boolean;
    N , M , tot ,
    colored    : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        begin
            read(graph[i * 2 - 1].p1 , graph[i * 2 - 1].p2);
            graph[i * 2].p1 := graph[i * 2 - 1].p2;
            graph[i * 2].p2 := graph[i * 2 - 1].p1;
        end;
      M := M * 2;
//    Close(INPUT);
end;

procedure qk_pass(var graph : Tgraph; start , stop : integer; var mid : integer);
var
    key        : Tedge;
    tmp        : integer;
begin
    tmp := random(stop - start + 1) + start;
    key := graph[tmp]; graph[tmp] := graph[start];
    while start < stop do
      begin
          while (start < stop) and (graph[stop].p1 > key.p1) do dec(stop);
          graph[start] := graph[stop];
          if start < stop then inc(start);
          while (start < stop) and (graph[start].p1 < key.p1) do inc(start);
          graph[stop] := graph[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    graph[start] := key;
end;

procedure qk_sort(var graph : Tgraph; start , stop : integer);
var
    mid        : integer;
begin
    if start < stop then
      begin
          qk_pass(graph , start , stop , mid);
          qk_sort(graph , start , mid - 1);
          qk_sort(graph , mid + 1 , stop);
      end;
end;

procedure dfs(root : integer);
var
    p          : integer;
begin
    visited[root] := 1;
    inc(tot);
    p := index[root];
    while (p <> 0) and (p <= M) and (graph[p].p1 = root) do
      begin
          if visited[graph[p].p2] = 0 then
            dfs(graph[p].p2);
          inc(p);
      end;
end;

procedure qk_pass_color(start , stop : integer; var mid : integer);
var
    key        : Trec;
    tmp        : integer;
begin
    tmp := random(stop - start + 1) + start;
    key := sort[tmp]; sort[tmp] := sort[start];
    while start < stop do
      begin
          while (start < stop) and (sort[stop].color > key.color) do dec(stop);
          sort[start] := sort[stop];
          if start < stop then inc(start);
          while (start < stop) and (sort[start].color < key.color) do inc(start);
          sort[stop] := sort[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    sort[start] := key;
end;

procedure qk_sort_color(start , stop : integer);
var
    mid        : integer;
begin
    if start < stop then
      begin
          qk_pass_color(start , stop , mid);
          qk_sort_color(start , mid - 1);
          qk_sort_color(mid + 1 , stop);
      end;
end;

procedure addpoint(p , mark : integer);
begin
    inc(path.total);
    path.data[path.total].point := p;
    path.data[path.total].next := path.total + 1;
    path.data[path.total].mark := mark;
end;

procedure del_color(p : integer);
var
    tmp        : Trec;
    target ,
    source     : integer;
begin
    dec(colortotal[color[p]]);
    source := colorindex[color[p]];
    while sort[source].num <> p do inc(source);
    target := colortotal[color[p]] + colorindex[color[p]];
    tmp := sort[source]; sort[source] := sort[target]; sort[target] := tmp;
end;

procedure find_circle(start : integer);
var
    p , last   : integer;
begin
    p := start;
    last := 0;
    if degree[p] = 2 then
      repeat
          addpoint(p , 0);
          if map[p].p1 = last then
            begin
                last := p;
                p := map[p].p2;
            end
          else
            begin
                last := p;
                p := map[p].p1;
            end;
      until (degree[p] <> 2) or (p = start);
    repeat
      if (p = start) and (degree[p] = 2) then
        break;
      del_color(p);
      addpoint(p , 1);
      last := p;
      p := map[p].p1;
      while degree[p] = 2 do
       begin
           addpoint(p , 0);
           if map[p].p1 = last then
             begin
                 last := p;
                 p := map[p].p2;
             end
           else
             begin
                 last := p;
                 p := map[p].p1;
             end;
       end;
      addpoint(p , 2);
      del_color(p);
      if colortotal[color[p]] <> 0 then
        p := sort[colorindex[color[p]]].num;
    until (color[start] <> 0) and (color[start] = color[p]) or (start = p);
end;

procedure work;
var
    i , p      : integer;
begin
    noanswer := true;
    qk_sort(graph , 1 , M);
    fillchar(index , sizeof(index) , 0);
    fillchar(degree , sizeof(degree) , 0);
    for i := 1 to M do
      begin
          if index[graph[i].p1] = 0 then
            index[graph[i].p1] := i;
          inc(degree[graph[i].p1]);
      end;

    fillchar(visited , sizeof(visited) , 0);
    tot := 0;
    dfs(1);
    if tot <> N then
      exit;

    fillchar(color , sizeof(color) , 0);
    fillchar(map , sizeof(map) , 0);
    fillchar(sort , sizeof(sort) , 0);
    fillchar(colorindex , sizeof(colorindex) , 0);
    tot := 0; colored := 0;
    for i := 1 to N do
      if degree[i] > 2 then
        begin
            if color[i] = 0 then
              begin
                  inc(tot);
                  color[i] := tot;
              end;
            p := index[i];
            while (p <> 0) and (p <= M) and (graph[p].p1 = i) do
              begin
                  if degree[graph[p].p2] > 2 then
                    color[graph[p].p2] := color[i]
                  else
                    map[i].p1 := graph[p].p2;
                  inc(p);
              end;
        end
      else
        if degree[i] = 2 then
          begin
              map[i].p1 := graph[index[i]].p2;
              map[i].p2 := graph[index[i] + 1].p2;
          end;
    for i := 1 to N do
      if color[i] <> 0 then
        begin
            inc(colored);
            sort[colored].num := i;
            sort[colored].color := color[i];
            inc(colortotal[color[i]]);
        end;
    qk_sort_color(1 , colored);
    for i := 1 to N do
      if (sort[i].color > 0) and (colorindex[sort[i].color] = 0) then
        colorindex[sort[i].color] := i;
    for i := 1 to tot do
      if odd(colortotal[i]) then
        exit;

    fillchar(path , sizeof(path) , 0);
    i := 1;
    while i <= N do
      if degree[i] = 2 then
        inc(i)
      else
        break;
    if i <= N then
      find_circle(i)
    else
      find_circle(1);
    path.data[path.total].next := 0;
    p := 1;
    while p <> 0 do
      begin
          if (colortotal[color[path.data[p].point]] > 0) and (path.data[p].mark = 2) then
            begin
                i := path.data[p].next;
                path.data[p].next := path.total + 1;
                find_circle(sort[colorindex[color[path.data[p].point]]].num);
                path.data[path.total].next := i;
            end;
          p := path.data[p].next;
      end;
    NoAnswer := false;
end;

procedure out;
var
    p          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if NoAnswer then
        writeln(-1)
      else
        begin
            p := 1;
            write(path.data[p].point);
            repeat
              p := path.data[p].next;
              if p <> 0 then
                write(' ' , path.data[p].point);
            until p = 0;
            writeln;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
