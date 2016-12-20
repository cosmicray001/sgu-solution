{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p199.in';
    OutFile    = 'p199.out';
    Limit      = 100000;

Type
    Tpoint     = record
                     x , y , num , father    : longint;
                 end;
    Tdata      = array[1..Limit] of Tpoint;
    Tposition  = array[1..Limit] of longint;

Var
    data       : Tdata;
    position ,
    num        : Tposition;
    N , answer : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        begin
            read(data[i].x , data[i].y);
            data[i].num := i;
        end;
//    Close(INPUT);
end;

procedure qk_pass(start , stop : longint; var mid : longint);
var
    tmp        : longint;
    key        : Tpoint;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and ((data[stop].x > key.x) or (data[stop].x = key.x) and (data[stop].y < key.y)) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and ((data[start].x < key.x) or (data[start].x = key.x) and (data[start].y > key.y)) do inc(start);
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

function binary_search(y : longint) : longint;
var
    st , ed ,
    mid        : longint;
begin
    binary_search := 0;
    st := 1; ed := answer;
    while st <= ed do
      begin
          mid := (st + ed) div 2;
          if position[mid] < y
            then begin
                     binary_search := mid;
                     st := mid + 1;
                 end
            else ed := mid - 1;
      end;
end;

procedure work;
var
    step , i   : longint;
begin
    qk_sort(1 , N);
    
    answer := 0;
    for i := 1 to N do
      begin
          step := binary_search(data[i].y);
          if step <> 0 then
            data[i].father := num[step];
          inc(step);
          if answer < step
            then begin
                     answer := step;
                     num[step] := i;
                     position[step] := data[i].y;
                 end
            else if position[step] > data[i].y then
                   begin
                       num[step] := i;
                       position[step] := data[i].y;
                   end;
      end;
end;

procedure out;
var
    i , p      : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
      p := num[answer];
      for i := 1 to answer do
        begin
            write(data[p].num);
            p := data[p].father;
            if i = answer
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
