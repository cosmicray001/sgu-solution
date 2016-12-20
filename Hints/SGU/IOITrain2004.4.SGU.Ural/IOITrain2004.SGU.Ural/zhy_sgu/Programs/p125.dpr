{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p125.in';
    OutFile    = 'p125.out';
    Limit      = 3;
    dirx       : array[1..4] of integer = (1 , 0 , -1 , 0);
    diry       : array[1..4] of integer = (0 , -1 , 0 , 1);

Type
    Tdata      = array[1..Limit , 1..Limit] of integer;
    Torder     = array[1..Limit * Limit] of
                   record
                       x , y  : integer;
                   end;

Var
    A , B ,
    last       : Tdata;
    order      : Torder;
    N          : integer;

procedure init;
var
    i , j      : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
      for i := 1 to N do
        for j := 1 to N do
          read(B[i , j]);
//    Close(INPUT);
    Case N of
      1        : begin order[1].x := 1; order[1].y := 1; end;
      2        : for i := 1 to N do
                   for j := 1 to N do
                     begin
                         order[(i - 1) * 2 + j].x := i; order[(i - 1) * 2 + j].y := j;
                     end;
      3        : begin
                     order[1].x := 2; order[1].y := 2;
                     order[2].x := 1; order[2].y := 2; order[3].x := 2; order[3].y := 1;
                     order[4].x := 2; order[4].y := 3; order[5].x := 3; order[5].y := 2;
                     order[6].x := 1; order[6].y := 1; order[7].x := 1; order[7].y := 3;
                     order[8].x := 3; order[8].y := 1; order[9].x := 3; order[9].y := 3;
                 end;
    end;
    fillchar(last , sizeof(last) , 0);
    fillchar(A , sizeof(A) , $FF);
    for i := 1 to N do
      for j := 1 to N do
        last[i , j] := ord(i > 1) + ord(i < N) + ord(j > 1) + ord(j < N);
end;

function work(step : integer) : boolean;
var
    i , x , y ,
    dir        : integer;
    ok         : boolean;
begin
    if step > N * N then
      work := true
    else
      begin
          for i := 0 to 9 do
            begin
                for dir := 1 to 4 do
                  begin
                      x := order[step].x + dirx[dir];
                      y := order[step].y + diry[dir];
                      if (x >= 1) and (x <= N) and (y >= 1) and (y <= N) then
                        if A[x , y] >= 0 then
                          begin
                              dec(last[x , y]);
                              dec(last[order[step].x , order[step].y]);
                              if A[x , y] > i then
                                dec(B[order[step].x , order[step].y]);
                              if A[x , y] < i then
                                dec(B[x , y]);
                          end;
                  end;
                ok := true;
                for dir := 1 to 4 do
                  begin
                      x := order[step].x + dirx[dir];
                      y := order[step].y + diry[dir];
                      if (x >= 1) and (x <= N) and (y >= 1) and (y <= N) then
                        if (B[x , y] > last[x , y]) or (B[x , y] < 0) then
                          begin
                              ok := false;
                              break;
                          end;
                  end;
                if (B[order[step].x , order[step].y] > last[order[step].x , order[step].y]) or (B[order[step].x , order[step].y] < 0) then
                  ok := false;
                if ok then
                  begin
                      A[order[step].x , order[step].y] := i;
                      if work(step + 1) then
                        begin
                            work := true;
                            exit;
                        end;
                      A[order[step].x , order[step].y] := -1;
                  end;
                for dir := 1 to 4 do
                  begin
                      x := order[step].x + dirx[dir];
                      y := order[step].y + diry[dir];
                      if (x >= 1) and (x <= N) and (y >= 1) and (y <= N) then
                        if A[x , y] >= 0 then
                          begin
                              inc(last[x , y]);
                              inc(last[order[step].x , order[step].y]);
                              if A[x , y] > i then
                                inc(B[order[step].x , order[step].y]);
                              if A[x , y] < i then
                                inc(B[x , y]);
                          end;
                  end;
            end;
          work := false;
      end;
end;

procedure out;
var
    i , j      : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if A[1 , 1] = -1 then
        writeln('NO SOLUTION')
      else
        for i := 1 to N do
          begin
              for j := 1 to N - 1 do
                write(A[i , j] , ' ');
              writeln(A[i , N]);
          end;
//    Close(OUTPUT);
end;

Begin
    init;
    work(1);
    out;
End.
