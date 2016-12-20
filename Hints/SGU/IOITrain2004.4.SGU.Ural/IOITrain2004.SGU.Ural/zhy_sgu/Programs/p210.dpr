{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p210.in';
    OutFile    = 'p210.out';
    Limit      = 400;

Type
    Tkey       = record
                     num , cost              : longint;
                 end;
    Tdata      = array[1..Limit] of Tkey;
    Tmap       = array[1..Limit , 1..Limit] of boolean;
    Tmatch     = array[1..Limit] of longint;
    Tvisited   = array[1..Limit] of boolean;

Var
    data       : Tdata;
    map        : Tmap;
    mx , my    : Tmatch;
    visited    : Tvisited;
    N          : longint;

procedure init;
var
    i , j , p  : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        begin
            data[i].num := i;
            read(data[i].cost);
        end;
      fillchar(map , sizeof(map) , 0);
      for i := 1 to N do
        begin
            read(j);
            while j > 0 do
              begin
                  read(p);
                  map[i , p] := true;
                  dec(j);
              end;
        end;
//    Close(INPUT);
end;

procedure qk_pass(start , stop : longint; var mid : longint);
var
    key        : Tkey;
    tmp        : longint;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (data[stop].cost > key.cost) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (data[start].cost < key.cost) do inc(start);
          data[stop] := data[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    data[start] := key;
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

function dfs(side , root : longint) : boolean;
var
    i          : longint;
begin
    if side = 1
      then begin
               dfs := false;
               for i := 1 to N do
                 if not visited[i] and map[root , i] then
                   if dfs(3 - side , i) then
                     begin
                         mx[root] := i; my[i] := root;
                         dfs := true;
                         exit;
                     end;
           end
      else begin
               visited[root] := true;
               if my[root] = 0
                 then dfs := true
                 else dfs := dfs(3 - side , my[root]);
           end;
end;

procedure work;
var
    i          : longint;
begin
    qk_sort(1 , N);
    for i := N downto 1 do
      begin
          fillchar(visited , sizeof(visited) , 0);
          dfs(1 , data[i].num);
      end;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to N do
        begin
            write(mx[i]);
            if i = N
              then writeln
              else write(' ');
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
