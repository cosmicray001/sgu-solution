{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p233.in';
    OutFile    = 'p233.out';
    minimum    = 1e-6;

Var
    XS , YS , R ,
    X1 , Y1 ,
    X2 , Y2 ,
    aX1 , aY1 ,
    aX2 , aY2  : extended;
    N          : longint;

procedure init;
begin
    readln(XS , YS , R , X1 , Y1 , X2 , Y2);
    dec(N);
end;

procedure Rotate(var x , y : extended; sinA , cosA : extended);
var
    d , nx , ny: extended;
begin
    d := sqrt(sqr(x) + sqr(y));
    if abs(d) <= minimum then exit;
    x := x / d; y := y / d;
    ny := y * cosA - sinA * x;
    nx := x * cosA + y * sinA;
    x := nx * d; y := ny * d;
end;

function calc_alpha(x1 , y1 , x2 , y2 , x3 , y3 : extended) : extended;
var
    a , b , c  : extended;
begin
    a := sqr(x1 - x3) + sqr(y1 - y3);
    b := sqr(x1 - x2) + sqr(y1 - y2);
    c := sqr(x2 - x3) + sqr(y2 - y3);
    calc_alpha := (b + c - a) / 2 * sqrt(b * c);
end;

procedure work;
var
    sinA , cosA ,
    d , y0 , x0 , p ,
    A , B , C , delta ,
    alpha1 , alpha2 
               : extended;
begin
    X1 := X1 - XS; X2 := X2 - XS;
    Y1 := Y1 - YS; Y2 := Y2 - YS;
    sinA := Y1 - Y2; cosA := X1 - X2;
    d := sqrt(sqr(sinA) + sqr(cosA));
    sinA := sinA / d; cosA := cosA / d;
    Rotate(X1 , Y1 , sinA , cosA);
    Rotate(X2 , Y2 , sinA , cosA);

    y0 := (y1 + y2) / 2; x0 := (x1 + x2) / 2;
    p := sqr(x0 - x2) + y0 * y0 - R * R - x0 * x0;
    A := 4 * (y0 * y0 - R * R);
    B := -4 * y0 * p; C := p * p - 4 * R * R * x0 * x0;
    delta := B * B - 4 * A * C;
    delta := sqrt(delta);
    aY1 := (-B + delta) / 2 / A; aY2 := (-B - delta) / 2 / A;
    aX1 := x0; aX2 := x0;

    d := sqrt(sqr(aX1) + sqr(aY1));
    aX1 := aX1 / d * R; aY1 := aY1 / d * R;
    d := sqrt(sqr(aX2) + sqr(aY2));
    aX2 := aX2 / d * R; aY2 := aY2 / d * R;
    alpha1 := calc_alpha(X1 , Y1 , aX1 , aY1 , X2 , Y2);
    alpha2 := calc_alpha(X1 , Y1 , aX2 , aY2 , X2 , Y2);
    if alpha1 > alpha2 then
      begin aX1 := aX2; aY1 := aY2; end;

    Rotate(aX1 , aY1 , -sinA , cosA);
    aX1 := aX1 + XS; aY1 := aY1 + YS;
end;

procedure out;
begin
    writeln(aX1 : 0 : 6 , ' ' , aY1 : 0 : 6);
end;

Begin
//    assign(INPUT , InFile); ReSet(INPUT);
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      readln(N);
      while N > 0 do
        begin
            init;
            work;
            out;
        end;
//    Close(OUTPUT);
//    Close(INPUT);
End.
