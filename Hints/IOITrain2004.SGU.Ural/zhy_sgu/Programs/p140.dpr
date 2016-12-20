{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p140.in';
    OutFile    = 'p140.out';
    Limit      = 100;

Type
    Tdata      = array[1..Limit] of integer;

Var
    data , gcd_num ,
    answer     : Tdata;
    N , P , B  : integer;
    noanswer   : boolean;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , P , B);
      for i := 1 to N do
        begin
            read(data[i]);
            data[i] := data[i] mod P;
        end;
//    Close(INPUT);
end;

function gcd(A , B : integer) : integer;
begin
    if A = 0 then
      gcd := B
    else
      gcd := gcd(B mod A , A);
end;

procedure eculid(A , B : integer; var x , y : integer; C : integer);
begin
    if A = 0 then
      begin
          x := 0;
          y := C div B;
      end
    else
      begin
          eculid(B mod A , A , y , x , C);
          x := x - B div A * y;
      end;
end;

procedure cycle(var num : integer; T : integer);
begin
    num := num mod T;
    if num < 0 then
      inc(num , T);
end;

procedure work;
var
    i , last ,
    x , y      : integer;
begin
    gcd_num[1] := data[1];
    for i := 2 to N do
      gcd_num[i] := gcd(gcd_num[i - 1] , data[i]);
    if B mod gcd(gcd_num[N] , P) = 0 then
      begin
          noanswer := false;
          eculid(gcd_num[N] , P , x , y , B);
          cycle(x , P);
          last := x * gcd_num[N];
          for i := N downto 2 do
            begin
                eculid(gcd_num[i - 1] , data[i] , x , y , last);
                cycle(x , P);
                cycle(y , P);
                answer[i] := y;
                last := x * gcd_num[i - 1];
            end;
          if data[1] = 0 then
            answer[1] := 0
          else
            answer[1] := last div data[1]; 
      end
    else
      noanswer := true;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        writeln('NO')
      else
        begin
            writeln('YES');
            for i := 1 to N - 1 do
              write(answer[i] , ' ');
            writeln(answer[N]);
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
