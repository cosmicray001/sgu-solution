{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p112.in';
    OutFile    = 'p112.out';
    Limit      = 100;
    LimitLen   = 220;

Type
    lint       = record
                     len , sign              : integer;
                     data                    : array[1..LimitLen] of integer;
                 end;

Var
    A , B      : integer;
    power1 ,
    power2 ,
    answer     : lint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(A , B);
//    Close(INPUT);
end;

procedure times(num1 , num2 : lint; var num3 : lint);
var
    i , j , tmp ,
    jw         : integer;
begin
    fillchar(num3 , sizeof(num3) , 0);
    for i := 1 to num1.len do
      begin
          jw := 0; j := 1;
          while (jw <> 0) or (j <= num2.len) do
            begin
                tmp := num1.data[i] * num2.data[j] + jw + num3.data[i + j - 1];
                jw := tmp div 10;
                num3.data[i + j - 1] := tmp mod 10;
                inc(j);
            end;
          if i + j - 2 > num3.len then
            num3.len := i + j - 2;
      end;
end;

procedure Get_Power(A , B : integer; var power : lint);
var
    tmp        : lint;
begin
    fillchar(power , sizeof(power) , 0);
    power.len := 1; power.data[1] := 1;
    fillchar(tmp , sizeof(tmp) , 0);
    while A <> 0 do
      begin
          inc(tmp.len);
          tmp.data[tmp.len] := A mod 10;
          A := A div 10;
      end;
    while B <> 0 do
      begin
          if odd(B) then
            times(tmp , power , power);
          B := B div 2;
          if B <> 0 then
            times(tmp , tmp , tmp);
      end;
end;

function bigger(var num1 , num2 : lint) : boolean;
var
    i          : integer;
begin
    if num1.len <> num2.len then
      bigger := (num1.len > num2.len)
    else
      begin
          for i := num1.len downto 1 do
            if num1.data[i] <> num2.data[i] then
              begin
                  bigger := (num1.data[i] > num2.data[i]);
                  exit;
              end;
          bigger := false;
      end;
end;

procedure minus(num1 , num2 : lint; var num3 : lint);
var
    i , jw , tmp
               : integer;
begin
    jw := 0;
    for i := 1 to num1.len do
      begin
          tmp := num1.data[i] - num2.data[i] - jw;
          if tmp < 0 then
            begin
                inc(tmp , 10);
                jw := 1;
            end
          else
            jw := 0;
          num3.data[i] := tmp;
      end;
    i := num1.len;
    while (i > 1) and (num3.data[i] = 0) do
      dec(i);
    num3.len := i;
end;

procedure work;
begin
    Get_Power(A , B , power1);
    Get_Power(B , A , power2);
    if bigger(Power2 , Power1) then
      begin
          minus(Power2 , Power1 , answer);
          answer.sign := -1;
      end
    else
      begin
          minus(Power1 , Power2 , answer);
          answer.sign := 1;
      end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer.sign = -1 then
        write('-');
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
