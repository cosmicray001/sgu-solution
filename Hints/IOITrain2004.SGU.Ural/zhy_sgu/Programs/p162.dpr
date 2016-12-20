{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p162.in';
    OutFile    = 'p162.out';

Type
    Tpoint     = record
                     x , y    : extended;
                 end;

Var
    AB , AC , AD ,
    BC , BD , CD ,
    answer     : extended;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(AB , AC , AD , BC , BD , CD);
//    Close(INPUT);
end;

function tri_area(a , b , c : extended) : extended;
var
    p , sqrnum : extended;
begin
    p := (a + b + c) / 2;
    sqrnum := p * (p - a) * (p - b) * (p - c);
    if sqrnum <= 0 then
      tri_area := 0
    else
      tri_area := sqrt(sqrnum);
end;

procedure work;
var
    A , B , C ,
    midpoint   : Tpoint;
    area , H ,
    sqrnum     : extended;
begin
    A.x := 0; A.y := 0; B.x := AB; B.y := 0;
    area := tri_area(AB , AC , BC);
    C.y := area * 2 / B.x; C.x := sqrt(sqr(AC) - sqr(C.y));
    if abs(sqrt(sqr(C.x - B.x) + sqr(C.y - B.y)) - BC) >= 1e-6 then
      C.x := -C.x; 

    midpoint.x := (sqr(B.x) + sqr(AD) - sqr(BD)) / 2 / B.x;
    if abs(C.y) <= 1e-6 then
      midpoint.y := 0
    else
      midpoint.y := (sqr(AD) - sqr(CD) + sqr(C.x) + sqr(C.y) - 2 * midpoint.x * C.x) / 2 / C.y;
    sqrnum := sqr(AD) - sqr(midpoint.x) - sqr(midpoint.y);
    if sqrnum <= 0 then
      H := 0
    else
      H := sqrt(sqrnum);

    answer := H * area / 3;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer : 0 : 4);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
