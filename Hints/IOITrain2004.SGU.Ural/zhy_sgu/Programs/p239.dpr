{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p239.in';
    OutFile    = 'p239.out';
    Limit      = 1000;
    LimitLen   = 300;

Type
    lint       = record
                     len      : longint;
                     data     : array[1..LimitLen] of longint;
                 end;
    Tdata      = array[1..Limit] of longint;
    Topt       = array[0..1 , 0..3] of lint;

Var
    data       : Tdata;
    opt        : Topt;
    answer     : lint;
    now , N    : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        read(data[i]);
//    Close(INPUT);
end;

procedure fill1(var num : lint);
begin
    fillchar(num , sizeof(num) , 0);
    num.len := 1;
    num.data[1] := 1;
end;

function get_1(num : longint) : longint;
var
    res        : longint;
begin
    res := 0;
    while num > 0 do
      begin
          if odd(num) then inc(res);
          num := num div 2;
      end;
    get_1 := res;
end;

procedure add(var num1 : lint; const num2 : lint);
var
    i , jw ,
    tmp        : longint;
begin
    i := 1; jw := 0;
    while (i <= num1.len) or (i <= num2.len) or (jw <> 0) do
      begin
          tmp := num1.data[i] + num2.data[i] + jw;
          jw := tmp div 10;
          num1.data[i] := tmp mod 10;
          inc(i);
      end;
    num1.len := i - 1;
end;

procedure work;
var
    i , j , k  : longint;
begin
    fillchar(opt , sizeof(opt) , 0);
    now := 1;
    fill1(opt[now , 0]); fill1(opt[now , 1]);
    for i := 2 to N do
      begin
          now := 1 - now;
          fillchar(opt[now] , sizeof(opt[now]) , 0);
          for j := 0 to 3 do
            for k := 0 to 1 do
              if get_1(j * 2 + k) = data[i - 1] then
                add(opt[now , (j mod 2) * 2 + k] , opt[1 - now , j]);
      end;

    fillchar(answer , sizeof(answer) , 0);
    answer.len := 1;
    for j := 0 to 3 do
      if get_1(j) = data[N] then
        add(answer , opt[now , j]);
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