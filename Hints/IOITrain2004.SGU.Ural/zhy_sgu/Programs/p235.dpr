{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p235.in';
    OutFile    = 'p235.out';
    Limit      = 300;
    dirx       : array[1..8] of longint = (-1 , -1 , -1 , 0 , 0 , 1 , 1 , 1);
    diry       : array[1..8] of longint = (-1 , 0 , 1 , -1 , 1 , -1 , 0 , 1);

Type
    Tmap       = array[1..Limit , 1..Limit] of smallint;
    Tdata      = array[0..1] of Tmap;
    Tvisited   = array[0..1 , 1..8 , 1..Limit , 1..Limit] of smallint;
    Tmodify    = record
                     tot      : longint;
                     data     : array[1..Limit * 8] of
                                  record
                                      x , y                 : smallint;
                                  end;
                 end;
    Tchanged   = array[1..Limit , 1..Limit] of boolean;

Var
    map ,
    data       : Tdata;
    v          : Tvisited;
    changed    : Tchanged;
    modify     : Tmodify;
    N , M ,
    sx , sy ,
    now , sum ,
    answer     : longint;

procedure init;
var
    i , j      : longint;
    c          : char;
begin
    fillchar(map , sizeof(map) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , M);
      for i := 1 to N do
        begin
            for j := 1 to N do
              begin
                  read(c);
                  case c of
                    '.'       : map[0 , i , j] := 0;
                    'Q'       : begin
                                    map[0 , i , j] := 0;
                                    sx := i; sy := j;
                                end;
                    'W'       : map[0 , i , j] := 2;
                    'B'       : map[0 , i , j] := 1;
                  end;
              end;
            readln;
        end;
      map[1] := map[0];
//    Close(INPUT);
end;

function go(now , x , y : longint) : boolean;
type
    Tpath      = record
                     tot      : longint;
                     data     : array[1..Limit] of
                                  record
                                      x , y                 : longint;
                                  end;
                 end;
var
    i , j , 
    nx , ny ,
    tx , ty ,
    tmp        : longint;
    path       : Tpath;
begin
    go := false;
    for i := 1 to 8 do
      begin
          tmp := v[now , i , x , y];
          nx := x + dirx[i] * tmp; ny := y + diry[i] * tmp;
          path.tot := 0;
          while (nx <= N) and (ny <= N) and (nx >= 1) and (ny >= 1) do
            begin
                inc(path.tot); tmp := path.tot;
                path.data[tmp].x := nx; path.data[tmp].y := ny;
                tx := nx; ty := ny;
                tmp := map[now , nx , ny];
                if tmp = 2 then break;
                if data[now , nx , ny] = 0
                  then begin data[now , nx , ny] := 1; go := true; end;
                if tmp = 1 then
                  begin
                      if not changed[nx , ny] then
                        begin
                            changed[nx , ny] := true;
                            inc(modify.tot); tmp := modify.tot;
                            modify.data[tmp].x := nx;
                            modify.data[tmp].y := ny;
                        end;
                      dec(path.tot);
                      go := true;
                      break;
                  end;
                tmp := v[now , i , tx , ty];
                nx := nx + dirx[i] * tmp; ny := ny + diry[i] * tmp;
                inc(sum);
            end;
          for j := 1 to path.tot do
            if dirx[i] <> 0
              then v[now , i , path.data[j].x , path.data[j].y] := abs(nx - path.data[j].x)
              else v[now , i , path.data[j].x , path.data[j].y] := abs(ny - path.data[j].y);
      end;
end;

procedure work;
var
    i , j ,
    x , y      : longint;
    ok , b1 , b2
               : boolean;
begin
    fillchar(data , sizeof(data) , 0);
    now := 0; data[now , sx , sy] := 1;
    answer := 0;
    ok := false;
    for i := 1 to 8 do
      for x := 1 to N do
        for y := 1 to N do
          begin
              v[0 , i , x , y] := 1;
              v[1 , i , x , y] := 1;
          end;
    for i := 1 to 8 do
      begin
          x := sx + dirx[i]; y := sy + diry[i];
          if (x <= N) and (y <= N) and (x >= 1) and (y >= 1) then
            if map[now , x , y] <> 2 then
              begin
                  ok := true;
                  break;
              end;
      end;
    if not ok then
      begin
          if M = 0 then answer := 1;
          exit;
      end;
    b1 := true;
    for i := 1 to M do
      begin
          b2 := false;
          modify.tot := 0;
          fillchar(changed , sizeof(changed) , 0);
          now := 1 - now;
          for x := 1 to N do
            for y := 1 to N do
              if (data[1 - now , x , y] <> 0) then
                b2 := go(now , x , y) or b2;
          for j := 1 to modify.tot do
            map[now , modify.data[j].x , modify.data[j].y] := 0;
          if not b1 and not b2 and (odd(i) = odd(M)) then break;
          b1 := b2;
      end;
    for x := 1 to N do
      for y := 1 to N do
        if data[now , x , y] <> 0 then
          inc(answer);
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
