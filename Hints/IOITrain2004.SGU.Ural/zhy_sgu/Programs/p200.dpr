{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p200.in';
    OutFile    = 'p200.out';
    Limit      = 100;
    LimitLen   = 40;

Type
    Tnum       = array[1..Limit] of longint;
    Tdata      = array[1..Limit , 1..Limit] of longint;
    lint       = record
                     len      : longint;
                     data     : array[1..LimitLen] of longint;
                 end;

Var
    prime ,
    num        : Tnum;
    data       : Tdata;
    answer     : lint;
    N , M , tot: longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        read(num[i]);
//    Close(INPUT);
end;

function check(num : longint) : boolean;
var
    i          : longint;
begin
    check := false;
    for i := 1 to tot do
      if sqr(prime[i]) <= num
        then begin
                 if num mod prime[i] = 0 then
                   exit;
             end
        else break;
    check := true;
end;

procedure GetPrime;
var
    i          : longint;
begin
    tot := 0; i := 2;
    while tot < N do
      begin
          if check(i) then
            begin
                inc(tot);
                prime[tot] := i;
            end;
          inc(i);
      end;
end;

procedure MakeData;
var
    i , j      : longint;
begin
    fillchar(data , sizeof(data) , 0);
    for i := 1 to N do
      for j := 1 to M do
        while num[j] mod prime[i] = 0 do
          begin
              data[i , j] := 1 - data[i , j];
              num[j] := num[j] div prime[i];
          end;
end;

function find(i : longint; var p1 , p2 : longint) : boolean;
var
    j , k      : longint;
begin
    for j := i to N do
      for k := i to M do
        if data[j , k] = 1 then
          begin
              p1 := j; p2 := k;
              find := true;
              exit;
          end;
    find := false;
end;

procedure swap_line(p1 , p2 : longint);
var
    i , tmp    : longint;
begin
    for i := 1 to M do
      begin
          tmp := data[p1 , i]; data[p1 , i] := data[p2 , i]; data[p2 , i] := tmp;
      end;
end;

procedure swap_col(p1 , p2 : longint);
var
    i , tmp    : longint;
begin
    for i := 1 to N do
      begin
          tmp := data[i , p1]; data[i , p1] := data[i , p2]; data[i , p2] := tmp;
      end;
end;

procedure add(num1 , num2 : lint; var num3 : lint);
var
    i , jw ,
    tmp        : longint;
begin
    fillchar(num3 , sizeof(num3) , 0);
    i := 1; jw := 0;
    while (i <= num1.len) or (i <= num2.len) or (jw <> 0) do
      begin
          tmp := num1.data[i] + num2.data[i] + jw;
          jw := tmp div 10;
          num3.data[i] := tmp mod 10;
          inc(i);
      end;
    num3.len := i - 1;
end;

procedure work;
var
    i , p1 , p2: longint;
    power      : lint;
begin
    GetPrime;
    MakeData;

    i := 1;
    while (i <= N) and (i <= M) do
      begin
          if not find(i , p1 , p2) then break;
          swap_line(i , p1);
          swap_col(i , p2);
          for p1 := i + 1 to N do
            if data[p1 , i] = 1 then
              for p2 := i to M do
                data[p1 , p2] := data[p1 , p2] xor data[i , p2];
          inc(i);
      end;
    i := M - i + 1;

    fillchar(answer , sizeof(answer) , 0); answer.len := 1;
    fillchar(power , sizeof(power) , 0); power.len := 1; power.data[1] := 1;
    while i > 0 do
      begin
          add(answer , power , answer);
          add(power , power , power);
          dec(i);
      end;
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
