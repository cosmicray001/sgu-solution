{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p158.in';
    OutFile    = 'p158.out';
    Limit      = 300;

Type
    Tdata      = array[1..Limit] of integer;

Var
    doors ,
    people     : Tdata;
    N , M , L ,
    answer ,
    posi       : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(L , M);
      L := L * 2;
      for i := 1 to M do
        begin
            read(people[i]);
            people[i] := people[i] * 2;
        end;
      read(N);
      doors[1] := 0;
      for i := 2 to N do
        begin
            read(doors[i]);
            doors[i] := doors[i] * 2;
        end;
//    Close(INPUT);
end;

function calc(S : integer) : integer;
var
    sum , i , p: integer;
begin
    sum := 0;
    p := 1;
    for i := 1 to M do
      begin
          while (p < N) and (abs(doors[p + 1] + S - people[i]) < abs(doors[p] + S - people[i])) do
            inc(p);
          inc(sum , abs(doors[p] + S - people[i]));
      end;
    calc := sum;
end;

procedure work;
var
    i , j , S ,
    dist       : integer;
begin
    answer := -1;
    for i := 1 to N - 1 do
      for j := 1 to M do
        begin
            S := people[j] - (doors[i] + doors[i + 1]) div 2;
            if (S >= 0) and (S + doors[N] <= L) then
              begin
                  dist := calc(S);
                  if dist > answer then
                    begin
                        answer := dist;
                        posi := S;
                    end;
              end;
        end;

    dist := Calc(0);
    if dist > answer then
      begin
          answer := dist;
          posi := 0;
      end;

    dist := Calc(L - doors[N]);
    if dist > answer then
      begin
          answer := dist;
          posi := L - doors[N];
      end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(posi / 2 : 0 : 2 , ' ' , answer / 2 : 0 : 2);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
