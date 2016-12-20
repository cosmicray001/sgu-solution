{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p147.in';
    OutFile    = 'p147.out';

Var
    N ,
    P1 , Q1 ,
    P2 , Q2 ,
    P3 , Q3 ,
    totalstep ,
    answer     : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , P1 , Q1 , P2 , Q2 , P3 , Q3);
//    Close(INPUT);
end;

procedure swap(var A , B : integer);
var
    tmp        : integer;
begin
    tmp := A; A := B; B := tmp;
end;

function cross(x1 , y1 , x2 , y2 : integer) : boolean;
begin
    if x2 > y2 then
      swap(x2 , y2);
    if (y1 < x2) or (y2 < x1) then
      cross := false
    else
      cross := true;
end;

procedure check(P1 , Q1 , P2 , Q2 , totalStep : integer);
var
    i , dirx , diry ,
    X , Y1 , Y2 ,
    A , B , extra ,
    mid , tmp  : integer;
begin
    dirx := ord(P2 - P1 > 0) * 2 - 1;
    diry := ord(Q2 - Q1 > 0) * 2 - 1;
    A := abs(P1 - P2); B := abs(Q1 - Q2);
    mid := (A - B) div 2;
    tmp := B + mid;
    extra := (A - B) mod 2;

    for i := 1 to totalStep do
      begin
          X := i * dirx + P1;
          if i <= mid then
            Y1 := Q1 - diry * i
          else
            Y1 := Q1 + (i - mid - mid - extra) * diry;

          if i <= tmp then
            Y2 := Q1 + i * diry
          else
            Y2 := Q1 + (tmp + tmp - i + extra) * diry;

          if Y1 > N then
            Y1 := N;
          if Y1 < 1 then
            Y1 := 1;

          if Y2 > N then
            Y2 := N;
          if Y2 < 1 then
            Y2 := 1;

          if (X >= P3 - i) and (X <= P3 + i) then
            if ((X = P3 - i) or (X = P3 + i)) and cross(Q3 - i , Q3 + i , Y1 , Y2) or
              cross(Q3 - i , Q3 - i , Y1 , Y2) or cross(Q3 + i , Q3 + i , Y1 , Y2) then
              begin
                  if (i < answer) or (answer = -1) then
                    answer := i;
                  break;
              end;
      end;
end;

procedure work;
begin
    if abs(P1 - P2) < abs(Q1 - Q2) then
      begin
          swap(P1 , Q1); swap(P2 , Q2); swap(P3 , Q3);
      end;
    totalstep := abs(P2 - P1) - 1;
    answer := -1;

    check(P1 , Q1 , P2 , Q2 , (totalStep - 1) div 2);
    check(P2 , Q2 , P1 , Q1 , (totalStep - 1) div 2);
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer = -1 then
        begin
            writeln('NO');
            writeln(totalstep);
        end
      else
        begin
            writeln('YES');
            writeln(answer);
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
