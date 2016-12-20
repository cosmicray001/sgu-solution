{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p131.in';
    OutFile    = 'p131.out';
    Limit      = 9;

Type
    Tdata      = array[0..Limit , 0..1 shl Limit] of extended;

Var
    data       : Tdata;
    N , M      : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , M);
//    Close(INPUT);
end;

procedure improve(line , step , high , low , highlast , lowlast : integer);
begin
    if step > M then
      begin
          if highlast + lowlast = 0 then
            data[line , low] := data[line , low] + data[line - 1 , high];
          exit;
      end
    else
      begin
          if (highlast = 0) and (lowlast = 0) then
            begin
                improve(line , step + 1 , high * 2 , low * 2 + 1 , 1 , 0);
                improve(line , step + 1 , high * 2 , low * 2 + 1 , 0 , 1);
                improve(line , step + 1 , high * 2 , low * 2 + 1 , 0 , 0);
            end;
          if lowlast = 0 then
            begin
                improve(line , step + 1 , high * 2 + 1 - highlast , low * 2 + 1 , 0 , 1);
                improve(line , step + 1 , high * 2 + 1 - highlast , low * 2 + 1 , 1 , 1);
            end;
          if highlast = 0 then
            improve(line , step + 1 , high * 2 , low * 2 + lowlast , 1 , 1);
          improve(line , step + 1 , high *  2 + 1 - highlast , low * 2 + lowlast , 0 , 0);
      end;
end;

procedure work;
var
    i          : integer;
begin
    fillchar(data , sizeof(data) , 0);
    data[0 , 1 shl M - 1] := 1;
    for i := 1 to N do
      improve(i , 1 , 0 , 0 , 0 , 0);
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(data[N , 1 shl M - 1] : 0 : 0);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
