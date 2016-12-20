{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p197.in';
    OutFile    = 'p197.out';
    LimitM     = 5;
    Limit      = 1 shl LimitM;
    LimitLen   = 102;

Type
    lint       = record
                     len      : longint;
                     data     : array[1..LimitLen] of longint;
                 end;
    Tmatrix    = array[0..Limit , 0..Limit] of longint;

Var
    N          : lint;
    A , B      : Tmatrix;
    M , P , step ,
    answer     : longint;

procedure init;
var
    c          : char;
    i , tmp    : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      fillchar(N , sizeof(N) , 0);
      read(c);
      while c <> ' ' do
        begin
            inc(N.len);
            N.data[N.len] := ord(c) - ord('0');
            read(c);
        end;
      for i := 1 to N.len div 2 do
        begin
            tmp := N.data[i]; N.data[i] := N.data[N.len - i + 1];
            N.data[N.len - i + 1] := tmp;
        end;
      read(step , P);
//    Close(INPUT);
end;

function check(num1 , num2 : longint) : boolean;
var
    i , last ,
    now        : longint;
begin
    last := 2;
    check := false;
    for i := 1 to step do
      begin
          now := num1 mod 2;
          if (num1 mod 2) <> (num2 mod 2) then
            now := 2;
          if (last <> 2) and (now = last) then exit;
          last := now;
          num1 := num1 div 2; num2 := num2 div 2;
      end;
    check := true;
end;

function zero(const num : lint) : boolean;
begin
    zero := (num.len <= 1) and (num.data[1] = 0);
end;

procedure minus1(var num : lint);
var
    jw , i , tmp
               : longint;
begin
    jw := 1; i := 1;
    while (i <= num.len) and (jw <> 0) do
      begin
          tmp := num.data[i] - jw;
          jw := 0;
          if tmp < 0 then
            begin
                jw := 1;
                inc(tmp , 10);
            end;
          num.data[i] := tmp;
          inc(i);
      end;
    while (num.len > 1) and (num.data[num.len] = 0) do dec(num.len);
end;

procedure div2(var num : lint);
var
    i , last   : longint;
begin
    last := 0;
    for i := num.len downto 1 do
      begin
          last := last * 10 + num.data[i];
          num.data[i] := last div 2;
          last := last mod 2;
      end;
    while (num.len > 1) and (num.data[num.len] = 0) do dec(num.len);
end;

procedure matrix_multi(A , B : Tmatrix; var C : Tmatrix);
var
    i , j , k  : longint;
begin
    fillchar(C , sizeof(C) , 0);
    for i := 0 to M do
      for j := 0 to M do
        for k := 0 to M do
          begin
              C[i , j] := C[i , j] + A[i , k] * B[k , j];
              C[i , j] := C[i , j] mod P;
          end;
end;

procedure work;
var
    i , j      : longint;
begin
    fillchar(A , sizeof(A) , 0);
    fillchar(B , sizeof(B) , 0);
    M := 1 shl step - 1;
    for i := 0 to M do
      for j := 0 to M do
        if check(i , j) then
          B[i , j] := 1;
    for i := 0 to M do
      A[0 , i] := 1;

    minus1(N);
    while not zero(N) do
      begin
          if odd(N.data[1]) then
            matrix_multi(A , B , A);
          matrix_multi(B , B , B);
          div2(N);
      end;

    answer := 0;
    for i := 0 to M do
      begin
          inc(answer , A[0 , i]);
          answer := answer mod P;
      end;
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
