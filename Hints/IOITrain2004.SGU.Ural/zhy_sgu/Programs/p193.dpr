{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p193.in';
    OutFile    = 'p193.out';
    Limit      = 3000;

Type
    lint       = record
                     len      : longint;
                     data     : array[1..Limit] of longint;
                 end;

Var
    N , answer : lint;

procedure init;
var
    c          : char;
    i , tmp    : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      fillchar(N , sizeof(N) , 0);
      while not eoln do
        begin
            read(c);
            if not (c in ['0'..'9']) then break;
            inc(N.len);
            N.data[N.len] := ord(c) - ord('0');
        end;
      for i := 1 to N.len div 2 do
        begin
            tmp := N.data[i]; N.data[i] := N.data[N.len - i + 1];
            N.data[N.len - i + 1] := tmp;
        end;
//    Close(INPUT);
end;

procedure div2(var num : lint);
var
    last , i   : longint;
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

procedure minus1(var num : lint);
var
    jw , i ,
    tmp        : longint;
begin
    i := 1; jw := 1;
    while jw <> 0 do
      begin
          tmp := num.data[i] - jw;
          if tmp < 0
            then begin
                     jw := 1;
                     inc(tmp , 10);
                 end
            else jw := 0;
          num.data[i] := tmp;
          inc(i);
      end;
    while (num.len > 1) and (num.data[num.len] = 0) do dec(num.len);
end;

procedure work;
begin
    if (N.len = 1) and (N.data[1] <= 2) then
      begin
          fillchar(answer , sizeof(answer) , 0);
          answer.len := 1;
          answer.data[1] := 1;
          exit;
      end;
    answer := N;
    div2(answer);
    if not odd(N.data[1]) then
      begin
          minus1(answer);
          if not odd(answer.data[1]) then
            minus1(answer);
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
