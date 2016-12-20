{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    InFile     = 'p101.in';
    OutFile    = 'p101.out';
    Limit      = 7;
    LimitPieces= 100;
    LimitPath  = 200;

Type
    Tdata      = array[0..Limit , 0..Limit] of integer;
    Tkey       = record
                     p1 , p2 , num           : integer;
                 end;
    Tdegree    = array[0..Limit] of integer;
    Tdices     = array[1..LimitPieces] of Tkey;
    Tpath      = record
                     total    : integer;
                     data     : array[1..LimitPath] of
                                  record
                                      now , next            : integer;
                                  end;
                 end;

Var
    data , map ,
    index      : Tdata;
    dices      : Tdices;
    degree     : Tdegree;
    path       : Tpath;
    N          : integer;
    noanswer   : boolean;

procedure init;
var
    key        : Tkey;
    i , p      : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
      fillchar(map , sizeof(map) , 0);
      fillchar(data , sizeof(data) , 0);
      fillchar(index , sizeof(index) , 0);
      fillchar(degree , sizeof(degree) , 0);
      for i := 1 to N do
        begin
            readln(key.p1 , key.p2);
            key.num := i;
            p := i;
            while (p > 1) and ((dices[p - 1].p1 > key.p1) or (dices[p - 1].p1 = key.p1) and (dices[p - 1].p2 > key.p2)) do
              begin
                  dices[p] := dices[p - 1];
                  dec(p);
              end;
            dices[p] := key;
            inc(map[key.p1 , key.p2]);
            inc(data[key.p1 , key.p2]);
            inc(data[key.p2 , key.p1]);
        end;
      for i := 1 to N do
        if index[dices[i].p1 , dices[i].p2] = 0 then
          index[dices[i].p1 , dices[i].p2] := i;
//    Close(INPUT);
end;

procedure extend(p : integer);
var
    i , j ,
    next       : integer;
begin
    i := path.data[p].now;
    next := path.data[p].next;
    path.data[p].next := path.total + 1;
    while true do
      begin
          j := 0;
          while (j <= Limit) and (data[i , j] = 0) do
            inc(j);
          if j > Limit then
            break;
          inc(path.total);
          path.data[path.total].now := j;
          path.data[path.total].next := path.total + 1;
          dec(data[i , j]); dec(data[j , i]);
          dec(degree[i]); dec(degree[j]);
          i := j;
      end;
    path.data[path.total].next := next;
end;

procedure work;
var
    i , j , sum ,
    oddp , p ,
    oddsum     : integer;
begin
    noanswer := true;

    oddsum := 0; oddp := -1; 
    for i := 0 to 6 do
      begin
          sum := 0;
          for j := 0 to 6 do
            inc(sum , data[i , j]);
          degree[i] := sum;
          if (sum <> 0) and (oddp = -1) then
            oddp := i;
          if odd(sum) then
            begin
                inc(oddsum);
                if oddsum > 2 then
                  exit;
                oddp := i;
            end;
      end;

    noanswer := false;
    if oddp = -1 then
      exit;
      
    fillchar(path , sizeof(path) , 0);
    path.total := 1; path.data[1].now := oddp;
    p := 1;
    while p <> 0 do
      begin
          while degree[path.data[p].now] <> 0 do
            extend(p);
          p := path.data[p].next;
      end;

    if path.total < N + 1 then
      noanswer := true;
end;

procedure out;
var
    i , p ,
    p1 , p2    : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        writeln('No solution')
      else
        begin
            p := 1;
            for i := 1 to path.total - 1 do
              begin
                  p1 := path.data[p].now;
                  p2 := path.data[path.data[p].next].now;
                  if map[p1 , p2] > 0 then
                    begin
                        writeln(dices[index[p1 , p2]].num , ' +');
                        inc(index[p1 , p2]); dec(map[p1 , p2]);
                    end
                  else
                    begin
                        writeln(dices[index[p2 , p1]].num , ' -');
                        inc(index[p2 , p1]); dec(map[p2 , p1]);
                    end;
                  p := path.data[p].next;
              end;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
