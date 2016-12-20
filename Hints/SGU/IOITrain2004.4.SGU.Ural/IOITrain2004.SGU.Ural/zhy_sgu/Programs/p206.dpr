{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p206.in';
    OutFile    = 'p206.out';
    Limit      = 400;
    LimitP     = 60;

Type
    Tdata      = array[1..Limit] of
                   record
                       x , y , cost          : longint;
                   end;
    Tmap       = array[1..LimitP , 1..LimitP] of longint;
    Tcost      = array[1..Limit , 1..Limit] of longint;
    Tlevel     = array[1..Limit] of longint;
    Tvisited   = array[1..Limit] of boolean;

Var
    data       : Tdata;
    map        : Tmap;
    cost       : Tcost;
    lx , ly ,
    mx , my ,
    fx , fy    : Tlevel;
    cx , cy    : Tvisited;
    N , M , P  : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        with data[i] do
          read(x , y , cost);
//    Close(INPUT);
end;

function Find_Edge(start , stop , target , number : longint) : boolean;
var
    i , tmp    : longint;
begin
    if stop = target
      then Find_Edge := true
      else begin
               Find_Edge := false;
               for i := 1 to N do
                 if (i <> start) and (map[stop , i] <> 0) then
                   if Find_Edge(stop , i , target , number) then
                     begin
                         Find_Edge := true;
                         tmp := data[map[stop , i]].cost - data[number].cost;
                         if tmp > 0 then
                           cost[map[stop , i] , number - N + 1] := tmp;
                         break;
                     end;
           end;
end;

procedure Build_Graph;
var
    i          : longint;
begin
    for i := 1 to N - 1 do
      with data[i] do
        begin
            map[x , y] := i;
            map[y , x] := i;
        end;
        
    if M - N + 1 > N - 1
      then P := M - N + 1
      else P := N - 1;
    for i := N to M do
      Find_Edge(0 , data[i].x , data[i].y , i);
end;

procedure work;
var
    i , j , k ,
    root , min : longint;
begin
    Build_Graph;

    fillchar(lx , sizeof(lx) , 0);
    fillchar(ly , sizeof(ly) , 0);
    for i := 1 to P do
      for j := 1 to P do
        if cost[i , j] > lx[i] then
          lx[i] := cost[i , j];

    fillchar(mx , sizeof(mx) , 0);
    fillchar(my , sizeof(my) , 0);
    for i := 1 to P do
      if mx[i] = 0 then
        begin
            fillchar(fx , sizeof(fx) , 0); fillchar(fy , sizeof(fy) , 0);
            fillchar(cx , sizeof(cx) , 0); fillchar(cy , sizeof(cy) , 0);
            cx[i] := true;
            root := 0;
            while true do
              begin
                  for j := 1 to P do
                    if cx[j] and (root = 0) then
                      for k := 1 to P do
                        if not cy[k] and (lx[j] + ly[k] = cost[j , k]) then
                          begin
                              cy[k] := true; fy[k] := j;
                              if my[k] = 0
                                then begin root := k; break; end
                                else begin cx[my[k]] := true; fx[my[k]] := k; end;
                          end;
                  if root <> 0 then break;
                  min := maxlongint;
                  for j := 1 to P do
                    if cx[j] then
                      for k := 1 to P do
                        if not cy[k] and (min > lx[j] + ly[k] - cost[j , k]) then
                          min := lx[j] + ly[k] - cost[j , k];
                  for j := 1 to P do if cx[j] then dec(lx[j] , min);
                  for k := 1 to P do if cy[k] then inc(ly[k] , min);
              end;
            while root <> 0 do
              begin
                  j := fy[root];
                  mx[j] := root;
                  my[root] := j;
                  root := fx[j];
              end;
        end;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to N - 1 do
        writeln(data[i].cost - lx[i]);
      for i := N to M do
        writeln(data[i].cost + ly[i - N + 1]);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
