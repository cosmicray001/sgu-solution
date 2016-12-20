{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p170.in';
    OutFile    = 'p170.out';
    Limit      = 5000;

Type
    Tdata      = array[1..Limit] of integer;

Var
    num1 , num2 ,
    len , ans  : integer;
    data1 ,
    data2      : Tdata;

procedure init;
var
    c          : char;
    k          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      num1 := 0;
      k := 0;
      len := 0;
      while not eoln do
        begin
            read(c);
            if c = '+' then
              begin
                  inc(num1);
                  data1[num1] := k;
              end;
            inc(k);
            inc(len);
        end;
      readln;

      num2 := 0;
      k := 0;
      while not eoln do
        begin
            read(c);
            if c = '+' then
              begin
                  inc(num2);
                  data2[num2] := k;
              end;
            inc(k);
            dec(len);
        end;
      readln;
//    Close(INPUT);
end;

procedure work;
var
    i          : integer;
begin
    ans := 0;
    if (num1 = num2) and (len = 0) then
      for i := 1 to num1 do
        inc(ans , abs(data1[i] - data2[i]))
    else
      ans := -1;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(ans);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
