{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p179.in';
    OutFile    = 'p179.out';
    Limit      = 10000;

Type
    Tdata      = array[0..Limit] of integer;

Var
    data , sum : Tdata;
    N          : integer;
    noanswer   : boolean;

procedure init;
var
    c          : char;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      fillchar(data , sizeof(data) , 0);
      fillchar(sum , sizeof(sum) , 0);
      N := 0;
      while not eoln do
        begin
            read(c);
            inc(N);
            if c = '(' then
              data[N] := -1
            else
              data[N] := 1;
        end;
//    Close(INPUT);
end;

procedure work;
var
    i , posi ,
    total      : integer;
begin
    for i := 1 to N do
      sum[i] := sum[i - 1] + data[i];

    posi := -1;
    for i := N downto 1 do
      if (data[i] = -1) and (sum[i - 1] < 0) then
        begin
            posi := i;
            break;
        end;

    if posi = -1 then
      noanswer := true
    else
      begin
          noanswer := false;
          data[i] := 1;
          total := 0;
          for i := 1 to posi do
            if data[i] = -1 then
              inc(total);
          for i := posi + 1 to posi + N div 2 - total do
            data[i] := -1;
          for i := posi + N div 2 - total + 1 to N do
            data[i] := 1;
      end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        write('No solution')
      else
        for i := 1 to N do
          if data[i] = -1 then
            write('(')
          else
            write(')');
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
