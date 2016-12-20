{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p118.in';
    OutFile    = 'p118.out';
    Limit      = 1000;

Type
    Tdata      = array[1..Limit] of integer;

Var
    data       : Tdata;
    N , answer ,
    M          : integer;

procedure init;
var
    i          : integer;
begin
    read(N);
    for i := 1 to N do
      read(data[i]);
end;

function Get_Root(num : integer) : integer;
var
    tmp        : integer;
begin
    if num < 10 then
      Get_Root := num
    else
      begin
          tmp := 0;
          while num <> 0 do
            begin
                inc(tmp , num mod 10);
                num := num div 10;
            end;
          Get_Root := Get_Root(tmp);
      end;
end;

procedure work;
var
    i          : integer;
begin
    answer := Get_Root(data[N]);
    for i := N - 1 downto 1 do
      answer := Get_Root((answer + 1) * Get_Root(data[i]));
end;

procedure out;
begin
    writeln(answer);
end;

Begin
//    assign(INPUT , InFile); ReSet(INPUT);
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      readln(M);
      while M > 0 do
        begin
            init;
            work;
            out;
            dec(M);
        end;
//    Close(OUTPUT);
//    Close(INPUT);
End.
