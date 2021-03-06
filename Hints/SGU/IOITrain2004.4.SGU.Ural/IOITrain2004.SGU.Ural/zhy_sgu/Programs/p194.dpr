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
                     U , C , F               : longint;
                 end;
    Tdata      = array[1..Limit , 1..Limit] of Trec;
    Tnum       = array[1..Limit] of longint;
    Tkey       = record
                     num , key               : longint;
                 end;
    Trequest   = array[1..LimitM] of
                   record
                       p1 , p2               : longint;
                   end;

Var
    data       : Tdata;
    inner , outer ,
    remain , height ,
    current    : Tnum;
    request    : Trequest;
    S , T , N ,
    M          : longint;
    answer     : boolean;

procedure init;
var
    i , p1 , p2: longint;
begin
    fillchar(data , sizeof(data) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        begin
            read(p1 , p2);
            read(data[p1 , p2].U , data[p1 , p2].C);
            data[p1 , p2].C := data[p1 , p2].C - data[p1 , p2].U;
            request[i].p1 := p1; request[i].p2 := p2;
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
        begin
            inner[j] := inner[j] + data[i , j].U;
            outer[i] := outer[i] + data[i , j].U;
        end;
    S := N + 1; T := N + 2;
    for i := 1 to N do
      if inner[i] > outer[i]
        then data[S , i].C := inner[i] - outer[i]
        else data[i , T].C := outer[i] - inner[i];
end;

procedure Init_Preflow;
var
    i          : longint;
begin
    fillchar(height , sizeof(height) , 0); fillchar(remain , sizeof(remain) , 0);
    height[S] := N + 2;
    for i := 1 to N do
      begin
          data[S , i].F := data[S , i].C;
          data[i , S].F := -data[S , i].C;
          inc(remain[i] , data[S , i].C);
          dec(remain[S] , data[S , i].C);
      end;
end;

procedure relabel(u : longint);
var
    i , min    : longint;
begin
    min := -1;
    for i := 1 to N + 2 do
      if data[u , i].C > data[u , i].F then
        if (min = -1) or (min > height[i]) then
          min := height[i];
    height[u] := min + 1;
end;

procedure push(u , v : longint);
var
    tmp        : longint;
begin
    if remain[u] < data[u , v].C - data[u , v].F
      then tmp := remain[u]
      else tmp := data[u , v].C - data[u , v].F;
    inc(data[u , v].F , tmp);
    dec(data[v , u].F , tmp);
    dec(remain[u] , tmp);
    inc(remain[v] , tmp);
end;

procedure Discharge(u : longint);
var
    v          : longint;
begin
    while remain[u] > 0 do
      begin
          v := current[u];
          if v > N + 2 then
            begin
                relabel(u);
                current[u] := 1;
                continue;
            end;
          if (data[u , v].C > data[u , v].F) and (height[u] = height[v] + 1)
            then push(u , v)
            else inc(current[u]);
      end;
end;

procedure work;
var
    i , old ,
    j , k      : longint;
    queue      : array[1..Limit] of longint;
begin
    Make_Graph;

    Init_Preflow;
    for i := 1 to N do
      current[i] := 1;

    for i := 1 to N do
      queue[i] := i;
    i := 1;
    while i <= N do
      begin
          k := queue[i];
          old := height[k];
          Discharge(k);
          if height[k] > old
            then begin
                     for j := i downto 2 do
                       queue[j] := queue[j - 1];
                     queue[1] := k;
                     i := 2;
                 end
            else inc(i);
      end;

    answer := false;
    for i := 1 to N do
      if data[S , i].C <> data[S , i].F then
        exit;
    answer := true;
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
                   writeln(data[request[i].p1 , request[i].p2].F
                     + data[request[i].p1 , request[i].p2].U);
             end
        else writeln('NO');
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
