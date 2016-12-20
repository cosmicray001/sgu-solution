{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p152.in';
    OutFile    = 'p152.out';
    Limit      = 10000;

Type
    Tdata      = array[1..Limit + 1] of integer;

Var
    data , answer ,
    up , low   : Tdata;
    N , sum    : integer;
    noanswer   : boolean;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      sum := 0;
      readln(N);
      for i := 1 to N do
        begin
            read(data[i]);
            inc(sum , data[i]);
        end;
//    Close(INPUT);
end;

procedure work;
var
    i , now    : integer;
begin
    fillchar(up , sizeof(up) , 0);
    fillchar(low , sizeof(low) , 0);
    for i := N downto 1 do
      if data[i] * 100 mod sum = 0 then
        begin
            up[i] := up[i + 1] + trunc(data[i] * 100 / sum);
            low[i] := low[i + 1] + trunc(data[i] * 100 / sum);
        end
      else
        begin
            up[i] := up[i + 1] + trunc(data[i] * 100 / sum) + 1;
            low[i] := low[i + 1] + trunc(data[i] * 100 / sum);
        end;

    if (up[1] < 100) or (low[1] > 100) then
      noanswer := true
    else
      begin
          noanswer := false;
          now := 0;
          for i := 1 to N do
            begin
                answer[i] := data[i] * 100 div sum;
                if data[i] * 100 mod sum <> 0 then
                  if now + answer[i] + up[i + 1] < 100 then
                    inc(answer[i]);
                inc(now , answer[i]);
            end;
      end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        writeln('No solution')
      else
        begin
            for i := 1 to N do
              write(answer[i] , ' ');
            writeln;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
