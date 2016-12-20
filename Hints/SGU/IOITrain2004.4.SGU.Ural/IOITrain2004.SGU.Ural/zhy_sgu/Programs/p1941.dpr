{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p194.in';
    OutFile    = 'p194.out';
    Limit      = 210;
    LimitM     = 20000;

Type
    Trec       = record
                     U , C , F , num         : longint;
                 end;
    Tdata      = array[1..Limit , 1..Limit] of Trec;
    Tneighbour = array[1..Limit] of
                   record
                       tot                   : smallint;
                       data                  : array[1..Limit] of smallint;
                   end;
    Tnum       = array[1..Limit] of longint;
    Tans       = array[1..LimitM] of longint;
    Tvisited   = array[1..Limit] of boolean;
    Tkey       = record
                     num , key               : longint;
                 end;
    Theap      = record
                     tot                     : smallint;
                     data                    : array[1..Limit] of Tkey;
                 end;
    Tindex     = array[1..Limit] of longint;

Var
    data       : Tdata;
    ans        : Tans;
    inner ,
    outer      : Tnum;
    visited    : Tvisited;
    neighbour  : Tneighbour;
    heap       : Theap;
    index      : Tindex;
    S , T , N ,
    M          : longint;
    answer     : boolean;

procedure init;
var
    i , p1 , p2: longint;
begin
    fillchar(data , sizeof(data) , 0);
    fillchar(neighbour , sizeof(neighbour) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        begin
            read(p1 , p2);
            read(data[p1 , p2].U , data[p1 , p2].C);
            data[p1 , p2].C := data[p1 , p2].C - data[p1 , p2].U;
            data[p1 , p2].num := i;
            inc(neighbour[p1].tot); neighbour[p1].data[neighbour[p1].tot] := p2;
            inc(neighbour[p2].tot); neighbour[p2].data[neighbour[p2].tot] := p1;
        end;
//    Close(INPUT);
end;

procedure make_graph;
var
    i , j      : longint;
begin
    fillchar(inner , sizeof(inner) , 0); fillchar(outer , sizeof(outer) , 0);
    for i := 1 to N do
      for j := 1 to N do
        if data[i , j].num <> 0 then
          begin
              inner[j] := inner[j] + data[i , j].U;
              outer[i] := outer[i] + data[i , j].U;
          end;
    S := N + 1; T := N + 2;
    for i := 1 to N do
      if inner[i] > outer[i]
        then begin
                 data[S , i].num := -1;
                 data[S , i].C := inner[i] - outer[i];
                 inc(neighbour[S].tot); neighbour[S].data[neighbour[S].tot] := i;
                 inc(neighbour[i].tot); neighbour[i].data[neighbour[i].tot] := S;
             end
        else begin
                 data[i , T].num := -1;
                 data[i , T].C := outer[i] - inner[i];
                 inc(neighbour[T].tot); neighbour[T].data[neighbour[T].tot] := i;
                 inc(neighbour[i].tot); neighbour[i].data[neighbour[i].tot] := T;
             end;
end;

procedure del_top;
var
    p , next   : longint;
    key        : Tkey;
begin
    key := heap.data[heap.tot];
    dec(heap.tot);
    p := 1;
    while p * 2 <= heap.tot do
      begin
          next := p;
          if heap.data[p * 2].key > key.key then next := p * 2;
          if (p * 2 < heap.tot) and (heap.data[p * 2 + 1].key > key.key) and (heap.data[p * 2 + 1].key > heap.data[p * 2].key) then next := p * 2 + 1;
          if next = p then break;
          heap.data[p] := heap.data[next];
          index[heap.data[p].num] := p;
          p := next;
      end;
    heap.data[p] := key;
    index[heap.data[p].num] := p;
end;

procedure shift(p : longint);
var
    key        : Tkey;
begin
    key := heap.data[p];
    while (p <> 1) and (heap.data[p div 2].key < key.key) do
      begin
          heap.data[p] := heap.data[p div 2];
          index[heap.data[p].num] := p;
          p := p div 2;
      end;
    heap.data[p] := key;
    index[heap.data[p].num] := p;
end;

function extend : boolean;
type
    Tshortest  = array[1..Limit] of
                   record
                       capacity , father     : longint;
                   end;
var
    shortest   : Tshortest;
    i , j , min ,
    k , p      : smallint;
    tmp        : longint;               
begin
    fillchar(shortest , sizeof(shortest) , 0);
    shortest[S].capacity := maxlongint;
    fillchar(visited , sizeof(visited) , 0);
    extend := false;
    fillchar(heap , sizeof(heap) , 0);
    for i := 1 to N do
      begin heap.data[i + 1].num := i; index[i] := i + 1; end;
    heap.data[N + 2].num := N + 2; index[N + 2] := N + 2;
    heap.data[1].key := maxlongint; heap.data[1].num := S; index[S] := 1;
    heap.tot := N + 2;
    for i := 1 to N + 2 do
      begin
          min := heap.data[1].num;

          del_top;
          if shortest[min].capacity = 0 then break;
          visited[min] := true;

          for k := 1 to neighbour[min].tot do
            begin
                j := neighbour[min].data[k];
                if not visited[j] then
                  if data[min , j].C > data[min , j].F
                    then begin
                             if data[min , j].C - data[min , j].F < shortest[min].capacity
                               then tmp := data[min , j].C - data[min , j].F
                               else tmp := shortest[min].capacity;
                             if tmp > shortest[j].capacity then
                               begin
                                   shortest[j].capacity := tmp; shortest[j].father := min;
                                   p := index[j]; heap.data[p].key := tmp;
                                   shift(p);
                               end;
                         end
                    else if data[j , min].F > 0 then
                           begin
                               if data[j , min].F < shortest[min].capacity
                                 then tmp := data[j , min].F
                                 else tmp := shortest[min].capacity;
                               if tmp > shortest[j].capacity then
                                 begin
                                     shortest[j].capacity := tmp; shortest[j].father := min;
                                     p := index[j]; heap.data[p].key := tmp;
                                     shift(p);
                                 end;
                           end;
            end;
      end;

    if shortest[T].capacity <= 0 then exit;

    i := T;
    while i <> S do
      begin
          j := shortest[i].father;
          if data[j , i].num <> 0
            then inc(data[j , i].F , shortest[T].capacity)
            else dec(data[i , j].F , shortest[T].capacity);
          i := j;
      end;
    extend := true;
end;

function dfs(root , last : longint) : longint;
var
    i          : smallint;
    tmp        : longint;
begin
    if (root = T) or (last = 0)
      then dfs := last
      else begin
               visited[root] := true;
               dfs := 0;
               for i := 1 to N + 2 do
                 if not visited[i] and (data[root , i].C > data[root , i].F) then
                   begin
                       if data[root , i].C - data[root , i].F < last
                         then tmp := data[root , i].C - data[root , i].F
                         else tmp := last;
                       tmp := dfs(i , tmp);
                       if tmp <> 0 then
                         begin
                             inc(data[root , i].F , tmp);
                             dfs := tmp;
                             exit;
                         end; 
                   end;
           end;
end;

procedure work;
var
    i , j      : longint;
begin
    Make_Graph;

    fillchar(visited , sizeof(visited) , 0);
    while dfs(S , maxlongint) > 0 do
      fillchar(visited , sizeof(visited) , 0);

    while extend do;

    answer := false;
    for i := 1 to N do
      if data[S , i].num = -1 then
        if data[S , i].C <> data[S , i].F then
          exit;

    answer := true;
    for i := 1 to N do
      for j := 1 to N do
        if data[i , j].num > 0 then
          ans[data[i , j].num] := data[i , j].U + data[i , j].F;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer
        then begin
                 writeln('YES');
                 for i := 1 to M do
                   writeln(ans[i]);
             end
        else writeln('NO');
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
