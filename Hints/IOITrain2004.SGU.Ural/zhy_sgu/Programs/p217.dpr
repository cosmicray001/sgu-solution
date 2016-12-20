{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p217.in';
    OutFile    = 'p217.out';
    Segment    = 500000;

Var
    R1 , R2 ,
    answer     : extended;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(R1 , R2);
//    Close(INPUT);
end;

function _sqrt(num : extended) : extended;
begin
    _sqrt := sqrt(abs(num));
end;

procedure work;
var
    x , delta ,
    x1 , x2 , midx ,
    y1 , y2 , midy ,
    sum        : extended;
    i          : longint;
begin
    if R1 < R2 then x := R1 else x := R2;
    answer := 0;
    delta := x / Segment;
    for i := 1 to Segment do
      begin
          x1 := delta * (i - 1);
          x2 := delta * i;
          midx := (x1 + x2) / 2;
          y1 := _sqrt((R1 * R1 - x1 * x1) * (R2 * R2 - x1 * x1));
          y2 := _sqrt((R1 * R1 - x2 * x2) * (R2 * R2 - x2 * x2));
          midy := _sqrt((R1 * R1 - midx * midx) * (R2 * R2 - midx * midx));

          sum := delta * (y1 + y2 + midy * 4) / 3;
          answer := answer + sum;
      end;

    answer := answer * 4;
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
