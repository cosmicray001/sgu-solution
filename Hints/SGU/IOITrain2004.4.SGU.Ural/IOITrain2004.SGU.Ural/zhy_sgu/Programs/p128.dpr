{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p128.in';
    OutFile    = 'p128.out';
    Limit      = 10000;
    Minimum    = -10001;
    LimitTree  = 32768;
    Base       = LimitTree - 1;

Type
    Tpoint     = record
                     x , y , number          : word;
                 end;
    TSeg       = record
                     start , stop , posi     : word;
                 end;
    Tdata      = array[1..Limit] of Tpoint;
    Tgraph     = array[1..Limit , 'x'..'y'] of word;
    TLines     = array[1..Limit div 2] of TSeg;
    Ttree      = array[1..LimitTree * 2 - 1] of word;
    Trec       = record
                     num , key               : word;
                     sign                    : byte;
                 end;
    Tevent     = array[1..Limit * 3] of Trec;

Var
    data       : Tdata;
    graph      : Tgraph;
    Xseg ,
    Yseg       : TLines;
    tree       : Ttree;
    event      : Tevent;
    noanswer   : boolean;
    N , answer ,
    Xtotal ,
    Ytotal     : integer;

procedure init;
var
    i , p1 , p2: integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        begin
            data[i].number := i;
            read(p1 , p2);
            data[i].x := p1 - minimum;
            data[i].y := p2 - minimum;
        end;
//    Close(INPUT);
end;

procedure qk_pass_x(start , stop : integer; var mid : integer);
var
    tmp        : integer;
    key        : Tpoint;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and ((key.x < data[stop].x) or (key.x = data[stop].x) and (key.y < data[stop].y)) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and ((key.x > data[start].x) or (key.x = data[start].x) and (key.y > data[start].y)) do inc(start);
          data[stop] := data[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    data[start] := key;
end;

procedure qk_sort_x(start , stop : integer);
var
    mid        : integer;
begin
    if start < stop then
      begin
          qk_pass_x(start , stop , mid);
          qk_sort_x(start , mid - 1);
          qk_sort_x(mid + 1 , stop);
      end;
end;

procedure qk_pass_y(start , stop : integer; var mid : integer);
var
    tmp        : integer;
    key        : Tpoint;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and ((key.y < data[stop].y) or (key.y = data[stop].y) and (key.x < data[stop].x)) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and ((key.y > data[start].y) or (key.y = data[start].y) and (key.x > data[start].x)) do inc(start);
          data[stop] := data[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    data[start] := key;
end;

procedure qk_sort_y(start , stop : integer);
var
    mid        : integer;                       
begin
    if start < stop then
      begin
          qk_pass_y(start , stop , mid);
          qk_sort_y(start , mid - 1);
          qk_sort_y(mid + 1 , stop);
      end;
end;

procedure qk_pass_number(start , stop : integer; var mid : integer);
var
    tmp        : integer;
    key        : Tpoint;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (key.number < data[stop].number) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (key.number > data[start].number) do inc(start);
          data[stop] := data[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    data[start] := key;
end;

procedure qk_sort_number(start , stop : integer);
var
    mid        : integer;
begin
    if start < stop then
      begin
          qk_pass_number(start , stop , mid);
          qk_sort_number(start , mid - 1);
          qk_sort_number(mid + 1 , stop);
      end;
end;

procedure qk_pass_event(start , stop : integer; var mid : integer);
var
    key        : Trec;
    tmp        : integer;
begin
    tmp := random(stop - start + 1) + start;
    key := event[tmp]; event[tmp] := event[start];
    while start < stop do
      begin
          while (start < stop) and ((event[stop].key > key.key) or (event[stop].key = key.key) and (event[stop].sign < key.sign)) do dec(stop);
          event[start] := event[stop];
          if start < stop then inc(start);
          while (start < stop) and ((event[start].key < key.key) or (event[start].key = key.key) and (event[start].sign < key.sign)) do inc(start);
          event[stop] := event[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    event[start] := key;
end;

procedure qk_sort_event(start , stop : integer);
var
    mid        : integer;
begin
    if start < stop then
      begin
          qk_pass_event(start , stop , mid);
          qk_sort_event(start , mid - 1);
          qk_sort_event(mid + 1 , stop);
      end;
end;

procedure add_tree(p , step : integer);
begin
    inc(p , base);
    while p <> 0 do
      begin
          tree[p] := tree[p] + step;
          p := p div 2;
      end;
end;

function check_tree(start , stop : integer) : boolean;
begin
    inc(start , base);
    inc(stop , base);
    check_tree := true;
    while start < stop do
      begin
          if (tree[start] > 0) or (tree[stop] > 0) then
            exit;
          start := (start + 1) div 2;
          stop := (stop - 1) div 2
      end;
    if start = stop then
      if tree[start] > 0 then
        exit;
    check_tree := false;
end;

function check : boolean;
var
    i          : integer;
begin
    fillchar(tree , sizeof(tree) , 0);
    for i := 1 to Xtotal do
      begin
          event[i * 2 - 1].num := i; event[i * 2 - 1].key := Xseg[i].start; event[i * 2 - 1].sign := 0;
          event[i * 2    ].num := i; event[i * 2    ].key := Xseg[i].stop;  event[i * 2    ].sign := 2;
      end;
    for i := 1 to Ytotal do
      begin
          event[Xtotal * 2 + i].num := i; event[Xtotal * 2 + i].key := Yseg[i].posi;
          event[Xtotal * 2 + i].sign := 1;
      end;
    qk_sort_event(1 , Xtotal * 2 + Ytotal);

    check := false;
    for i := 1 to Xtotal * 2 + Ytotal do
      if event[i].sign = 1 then
        if check_tree(Yseg[event[i].num].start + 1 , Yseg[event[i].num].stop - 1) then
          exit
        else
      else
        add_tree(Xseg[event[i].num].posi , 1 - event[i].sign);
    check := true;
end;

procedure work;
var
    i , p ,
    nextp      : integer;
begin
    noanswer := false;
    if odd(N) or (N < 4) then
      noanswer := true
    else
      begin
          fillchar(graph , sizeof(graph) , 0);
          answer := 0;
          
          qk_sort_x(1 , N);
          for i := 1 to N do
            if odd(i) then
              if (data[i].x = data[i + 1].x) and (data[i].y <> data[i + 1].y) then
                begin
                    graph[data[i].number , 'y'] := data[i + 1].number;
                    graph[data[i + 1].number , 'y'] := data[i].number;
                    inc(answer , data[i + 1].y - data[i].y);
                end
              else
                begin
                    noanswer := true;
                    exit;
                end;
          qk_sort_y(1 , N);
          for i := 1 to N do
            if odd(i) then
              if (data[i].y = data[i + 1].y) and (data[i].x <> data[i + 1].x) then
                begin
                    graph[data[i].number , 'x'] := data[i + 1].number;
                    graph[data[i + 1].number , 'x'] := data[i].number;
                    inc(answer , data[i + 1].x - data[i].x);
                end
              else
                begin
                    noanswer := true;
                    exit;
                end;
          qk_sort_number(1 , N);
                
          p := 1;
          Xtotal := 0; Ytotal := 0;
          for i := 1 to N do
            if (i <> 1) and (p = 1) then
              begin
                  noanswer := true;
                  exit;
              end
            else
              begin
                  if odd(i) then
                    begin
                        inc(Xtotal);
                        nextp := graph[p , 'x'];
                        if data[p].x < data[nextp].x then
                          begin
                              Xseg[Xtotal].start := data[p].x;
                              Xseg[Xtotal].stop := data[nextp].x;
                          end
                        else
                          begin
                              Xseg[Xtotal].start := data[nextp].x;
                              Xseg[Xtotal].stop := data[p].x;
                          end;
                        Xseg[Xtotal].posi := data[p].y;
                    end
                  else
                    begin
                        inc(Ytotal);
                        nextp := graph[p , 'y'];
                        if data[p].y < data[nextp].y then
                          begin
                              Yseg[Ytotal].start := data[p].y;
                              Yseg[Ytotal].stop := data[nextp].y;
                          end
                        else
                          begin
                              Yseg[Ytotal].start := data[nextp].y;
                              Yseg[Ytotal].stop := data[p].y;
                          end;
                        Yseg[Ytotal].posi := data[p].x;
                    end;
                  p := nextp;
              end;
          if p <> 1 then
            begin
                noanswer := true;
                exit;
            end;

          if not check then
            begin
                noanswer := true;
                exit;
            end;
      end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        writeln(0)
      else
        writeln(answer);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
