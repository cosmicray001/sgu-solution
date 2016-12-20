{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p109.in';
    OutFile    = 'p109.out';

Var
    N          : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
//    Close(INPUT);
end;

function number(i , j : integer) : integer;
begin
    number := (i - 1) * N + j;
end;

procedure workout;
var
    i , k , j ,
    cols       : integer;
begin
    if N = 2 then
      begin
          writeln('2 2');
          writeln('3 1 4');
          exit;
      end;
    cols := N;
    if not odd(N) then
      begin
          k := N;
          write(k);
          for i := 1 to N - 1 do
            if i <> 2 then
              write(' ' , i * N , ' ' , (N - 1) * N + i);
          if N <> 2 then
            write(' ' , N * N);
          writeln;
          inc(k);
          writeln(k , ' ' , 2 * N , ' ' , (N - 1) * N + 2 , ' ' , 1 ,
                ' ' , N - 1 , ' ' , (N - 2) * N + 1 , ' ' , (N - 2) * N + N - 1);
          dec(cols);
      end
    else
      begin
          k := N;
          writeln(k , ' ' , 1 , ' ' , N , ' ' , (N - 1) * N + 1 , ' ' , N * N);
      end;
    for i := 2 to cols - 1 do
      begin
          inc(k , 2);
          write(k);
          if i <= cols div 2 then
            for j := i downto 1 do
              write(' ' , number(i - j + 1 , j) , ' ' , number(i - j + 1 , cols - j + 1) ,
                    ' ' , number(cols + j - i , j) , ' ' , number(cols + j - i , cols - j + 1))
          else
            begin
                write(' ' , number(i - cols div 2 , cols div 2 + 1) , ' ' , number(cols div 2 + 1 , i - cols div 2) ,
                      ' ' , number(cols div 2 + 1 , cols - i + cols div 2 + 1) , ' ' , number(cols - i + cols div 2 + 1 , cols div 2 + 1));
                for j := cols div 2 downto i - cols div 2 + 1 do
                  write(' ' , number(i - j + 1 , j) , ' ' , number(i - j + 1 , cols - j + 1) ,
                        ' ' , number(cols + j - i , j) , ' ' , number(cols + j - i , cols - j + 1))
            end;
          writeln;
      end;
end;

Begin
    init;
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      workout;
//    Close(OUTPUT);
End.
