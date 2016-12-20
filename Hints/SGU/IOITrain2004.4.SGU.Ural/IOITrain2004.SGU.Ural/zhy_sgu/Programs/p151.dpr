{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p151.in';
    OutFile    = 'p151.out';
    Zero       = 1e-14;
    Zero2      = 1e-7;

Type
    Tpoint     = record
                     x , y    : extended;
                 end;

Var
    A , B , M  : extended;
    p1 , p2 ,
    p3         : Tpoint;
    noanswer   : boolean;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(A , B , M);
//    Close(INPUT);
end;

procedure work;
begin
    M := M * M;
    p1.x := 0; p1.y := 0;
    p2.x := A; p2.y := 0;
    if A = 0 then
      p3.x := 0
    else
      p3.x := (4 * M - A * A - B * B) / 2 / A;

    if B * B - p3.x * p3.x < 0 then
      p3.y := 0
    else
      p3.y := sqrt(B * B - p3.x * p3.x);
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        writeln('Mission impossible')
      else
        begin
            writeln(p1.x : 0 : 5 , ' ' , p1.y : 0 : 5);
            writeln(p2.x : 0 : 5 , ' ' , p2.y : 0 : 5);
            writeln(p3.x : 0 : 5 , ' ' , p3.y : 0 : 5);
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    if (M < abs(A - B) / 2) or (M > (A + B) / 2) then
      noanswer := true
    else
      begin
          noanswer := false;
          work;
      end;
    out;
End.
