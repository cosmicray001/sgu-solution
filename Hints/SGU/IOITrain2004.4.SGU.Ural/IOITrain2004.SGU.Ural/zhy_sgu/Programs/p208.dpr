{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
Const
    InFile     = 'p208.in';
    OutFile    = 'p208.out';
    Limit      = 20;
    LimitLen   = 200;

Type
    Tvisited   = array[1..Limit , 1..Limit] of boolean;
    Tcount     = array[1..Limit * Limit] of longint;
    lint       = record
                     len      : longint;
                     data     : array[1..LimitLen] of longint;
                 end;

Var
    visited    : Tvisited;
    count      : Tcount;
    answer     : lint;
    N , M , sum: longint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
//    Close(INPUT);
end;

procedure change(var x , y : longint; times : longint);
var
    nx , ny    : longint;
begin
    if times >= 2 then
      begin
          x := N - x + 1; y := M - y + 1;
          dec(times , 2);
      end;
    if times <> 0 then
      begin
          ny := N - x + 1;
          nx := y;
          x := nx; y := ny;
      end;
end;

procedure check(dx , dy , times : longint);
var
    i , j , tot ,
    x , y      : longint;
begin
    inc(sum);
    fillchar(visited , sizeof(visited) , 0); tot := 0;
    for i := 1 to N do
      for j := 1 to M do
        if not visited[i , j] then
          begin
              inc(tot);
              x := i; y := j;
              while not visited[x , y] do
                begin
                    visited[x , y] := true;
                    x := (x + dx - 1) mod N + 1;
                    y := (y + dy - 1) mod M + 1;
                    change(x , y , times);
                end;
          end;
    inc(count[tot]);
end;

procedure add(num1 , num2 : lint; var num3 : lint);
var
    i , jw ,
    tmp        : longint;
begin
    i := 1; jw := 0;
    fillchar(num3 , sizeof(num3) , 0);
    while (i <= num1.len) or (i <= num2.len) or (jw <> 0) do
      begin
          tmp := num1.data[i] + num2.data[i] + jw;
          jw := tmp div 10;
          num3.data[i] := tmp mod 10;
          inc(i);
      end;
    num3.len := i - 1;
end;

procedure divide(var num1 : lint; num2 : longint);
var
    last , i   : longint;
begin
    last := 0;
    for i := num1.len downto 1 do
      begin
          last := last * 10 + num1.data[i];
          num1.data[i] := last div num2;
          last := last mod num2;
      end;
    while (num1.len > 1) and (num1.data[num1.len] = 0) do dec(num1.len); 
end;

procedure work;
var
    i , j      : longint;
    power      : lint;
begin
    fillchar(count , sizeof(count) , 0);
    sum := 0;
    for i := 0 to N - 1 do
      for j := 0 to M - 1 do
        begin
            check(i , j , 0);
            check(i , j , 2);
            if N = M then
              begin
                  check(i , j , 1);
                  check(i , j , 3);
              end;
        end;

    fillchar(power , sizeof(power) , 0);
    power.len := 1; power.data[1] := 1;
    for i := 1 to N * M do
      begin
          add(power , power , power);
          for j := 1 to count[i] do
            add(answer , power , answer);
      end;
    divide(answer , sum);
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := answer.len downto 1 do
        write(answer.data[i]);
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
