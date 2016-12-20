{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p159.in';
    OutFile    = 'p159.out';
    Limit      = 2010;
    LimitBase  = 36;
    LimitAnswer
               = 10;
    LimitIndex = 10000;

Type
    lint       = record
                     len      : integer;
                     data     : array[1..Limit] of integer;
                 end;
    Tdata      = array[0..1] of
                   record
                       total  : integer;
                       data   : array[1..LimitAnswer] of
                                  record
                                      num , square          : lint;
                                  end;
                   end;
    Tsquares   = array[0..LimitBase] of lint;
    Tindex     = array[0..LimitIndex] of integer;

Var
     data      : Tdata;
     squares   : Tsquares;
     modnum ,
     divnum    : Tindex;
     N , B ,
     now       : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(B , N);
//    Close(INPUT);

    for i := 0 to LimitIndex do
      begin
          modnum[i] := i mod B;
          divnum[i] := i div B;
      end;
end;

procedure times(const num1 : lint; num2 , start : integer; var num3 : lint);
var
    i , jw , tmp
               : integer;
begin
    fillchar(num3 , sizeof(num3) , 0);
    i := 1; jw := 0;
    while (i + start <= Limit) and ((i <= num1.len) or (jw <> 0)) do
      begin
          tmp := num1.data[i] * num2 + jw;
          jw := divnum[tmp];
          num3.data[i + start] := modnum[tmp];
          inc(i);
      end;
    num3.len := i - 1 + start;
    if num3.len > Limit then
      num3.len := Limit;
end;

procedure add(const num1 , num2 , num3 : lint; var num4 : lint);
var
    i , jw ,
    tmp        : integer;
begin
    fillchar(num4 , sizeof(num4) , 0);
    i := 1; jw := 0;
    while (i <= Limit) and ((i <= num1.len) or (i <= num2.len) or (i <= num3.len) or (jw <> 0)) do
      begin
          tmp := num1.data[i] + num2.data[i] + num3.data[i] + jw;
          jw := divnum[tmp];
          num4.data[i] := modnum[tmp];
          inc(i);
      end;
    num4.len := i - 1;
    if num4.len > Limit then
      num4.len := Limit;
end;

procedure work;
var
    i , j , k ,
    p , tmp    : integer;
    sum        : lint;
begin
    fillchar(sum , sizeof(sum) , 0);
    fillchar(data , sizeof(data) , 0);
    now := 0;
    for i := 0 to B - 1 do
      if i * i mod B = i then
        begin
            inc(data[now].total);
            with data[now].data[data[now].total] do
              begin
                  num.len := 1;
                  num.data[1] := i;
                  times(num , i , 0 , square);
              end;
        end;

    for i := 0 to B - 1 do
      begin
          squares[i].len := 0;
          p := i * i;
          while p <> 0 do
            begin
                inc(squares[i].len);
                squares[i].data[squares[i].len] := modnum[p];
                p := divnum[p];
            end;
          if squares[i].len = 0 then
            squares[i].len := 1;
      end;

    for i := 2 to N do
      begin
          for k := 0 to B - 1 do
            begin
                inc(squares[k].len , 2);
                j := squares[k].len - 2;
                for p := 1 to 2 do
                  if (j > 0) and (j + 2 <= Limit) then
                    begin
                        squares[k].data[j + 2] := squares[k].data[j];
                        squares[k].data[j] := 0;
                        dec(j);
                    end;
            end;

          now := 1 - now;
          data[now].total := 0;
          for j := 1 to data[1 - now].total do
            for k := 0 to B - 1 do
              if (data[1 - now].data[j].num.data[1] * 2 * k + data[1 - now].data[j].square.data[i]) mod B = k then
                begin
                    inc(data[now].total);

                    data[now].data[data[now].total].num := data[1 - now].data[j].num;
                    inc(data[now].data[data[now].total].num.len);
                    tmp := data[now].data[data[now].total].num.len;
                    data[now].data[data[now].total].num.data[tmp] := k;

                    times(data[1 - now].data[j].num , 2 * k , i - 1 , sum);
                    add(sum , data[1 - now].data[j].square , squares[k] , data[now].data[data[now].total].square);
                end;
      end;
end;

procedure print(var num : lint);
var
    i          : integer;
begin
    for i := num.len downto 1 do
      if num.data[i] < 10 then
        write(num.data[i])
      else
        write(chr(num.data[i] - 10 + ord('A')));
    writeln;
end;

procedure out;
var
    i , sum    : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      sum := 0;
      for i := 1 to data[now].total do
        if (N = 1) or (data[now].data[i].num.data[N] <> 0) then
          inc(sum);
      writeln(sum);
      for i := 1 to data[now].total do
        if (N = 1) or (data[now].data[i].num.data[N] <> 0) then
          print(data[now].data[i].num);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
