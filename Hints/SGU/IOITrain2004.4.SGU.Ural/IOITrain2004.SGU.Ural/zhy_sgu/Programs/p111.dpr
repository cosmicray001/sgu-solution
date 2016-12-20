{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p111.in';
    OutFile    = 'p111.out';
    Limit      = 1202;

Type
    lint       = record
                     len	: integer;
                     data	: array[1..Limit] of integer;
    	  end;

Var
    N ,
    result     : lint;

procedure init;
var
    i , j      : integer;
    c          : char;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      fillchar(N , sizeof(N) , 0);
      while not eoln do
        begin
            inc(N.len);
            read(c);
            N.data[N.len] := ord(c) - 48;
        end;
      for i := 1 to N.len div 2 do
        begin
            j := N.data[i];
            N.data[i] := N.data[N.len - i + 1];
            N.data[N.len - i + 1] := j;
        end;
//    Close(INPUT);
end;

procedure plus(n1 , n2 : lint; var n3 : lint);
var
    i , temp ,
    jw         : integer;
begin
    fillchar(n3 , sizeof(n3) , 0); i := 1; jw := 0;
    while (i <= n1.len) or (i <= n2.len) or (jw <> 0) do
      begin
          temp := n1.data[i] + n2.data[i] + jw;
          jw := temp div 10;
          n3.data[i] := temp mod 10;
          inc(i);
      end;
    n3.len := i - 1;
end;

procedure add(var n1 : lint; n2 , start : integer);
var
    i          : integer;
begin
    i := start;
    while n2 <> 0 do
      begin
          inc(n1.data[i] , n2);
          n2 := n1.data[i] div 10;
          n1.data[i] := n1.data[i] mod 10;
          inc(i);
      end;
    if i - 1 > n1.len then n1.len := i - 1;
end;

procedure minus(n1 , n2 : lint; var n3 : lint);
var
    i , temp ,
    jw         : integer;
begin
    fillchar(n3 , sizeof(n3) , 0); jw := 0;
    for i := 1 to n1.len do
      begin
          temp := n1.data[i] - n2.data[i] - jw;
          if temp < 0 then
            begin
                jw := 1;
                temp := temp + 10;
            end
          else
            jw := 0;
          n3.data[i] := temp;
      end;
    n3.len := n1.len;
    while (n3.len > 0) and (n3.data[n3.len] = 0) do dec(n3.len);
end;

procedure times(n1 , n2 : lint; var n3 : lint);
var
    i , j ,
    temp , jw  : integer;
begin
    fillchar(n3 , sizeof(n3) , 0);
    for i := 1 to n1.len do
      begin
          jw := 0; j := 1;
          while (j <= n2.len) or (jw <> 0) do
            begin
                temp := n1.data[i] * n2.data[j] + n3.data[i + j - 1] + jw;
                jw := temp div 10;
                n3.data[i + j - 1] := temp mod 10;
                inc(j);
            end;
          if n3.len < i + j - 2 then
            n3.len := i + j - 2;
      end;
end;

function bigger(n1 , n2 : lint; stop : integer) : boolean;
var
    i , j      : integer;
begin
    if n1.len <> (n2.len - stop + 1) then
      bigger := (n1.len > n2.len - stop + 1)
    else
      begin
          j := n2.len;
          for i := n1.len downto 1 do
            if n1.data[i] <> n2.data[j] then
              begin
                  bigger := (n1.data[i] > n2.data[j]);
                  exit;
              end
            else
              dec(j);
          bigger := false;
      end;
end;

procedure move(var num : lint; step : integer);
var
    i          : integer;
begin
    for i := num.len downto 1 do
      num.data[i + step] := num.data[i];
    for i := 1 to step do
      num.data[i] := 0;
    inc(num.len , step);
end;

procedure work;
var
    i , start ,
    next       : integer;
    temp , t2  : lint;
begin
    if odd(N.len) then start := N.len div 2 + 1 else start := N.len div 2;
    result.len := start;
    fillchar(temp , sizeof(Temp) , 0);
    for i := start downto 1 do
      begin
          move(temp , 1);
          next := 1;
          fillchar(t2 , sizeof(t2) , 0);
          while next <= 9 do
            begin
                temp.data[1] := next;
                plus(temp , t2 , t2);
                add(t2 , next - 1 , 1);
                if bigger(t2 , N , i * 2 - 1) then
                  break;
                inc(next);
            end;
          temp.data[1] := next - 1;
          result.data[i] := next - 1;
          if next < 10 then minus(t2 , temp , t2);
          move(t2 , (i - 1) * 2);
          if next < 10 then add(N , next , (i * 2 - 1));
          minus(N , t2 , N);
          add(temp , next - 1 , 1);
      end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := result.len downto 1 do
        write(result.data[i]);
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.