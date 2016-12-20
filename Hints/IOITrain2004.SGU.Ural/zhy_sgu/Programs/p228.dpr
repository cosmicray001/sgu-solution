{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p228.in';
    OutFile    = 'p228.out';
    Limit      = 150;
    zero       = 1e-6;

Type
    Tpoint     = record
                     x , y    : extended;
                 end;
    Tdata      = array[1..Limit] of Tpoint;

Var
    data ,
    answer     : Tdata;
    N , N1 , N2: integer;

procedure init;
begin
    fillchar(data , sizeof(data) , 0);
    fillchar(answer , sizeof(answer) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , N1 , N2);
      with answer[N1] do
        read(x , y);
      with answer[N2] do
        read(x , y);
//    Close(INPUT);
end;

procedure change(var source , target : Tpoint; Base1 , Base2 : Tpoint; SinW , CosW : extended);
var
    LenS , SinS ,
    CosS ,
    NewSin , NewCos
               : extended;
begin
    source.x := source.x - Base1.x; source.y := source.y - Base1.y;
    LenS := sqrt(sqr(source.x) + sqr(source.y));
    if abs(LenS) > zero then
      begin
          SinS := source.y / LenS; CosS := source.x / LenS;
          NewSin := SinS * CosW + SinW * CosS; NewCos := CosS * CosW - SinS * SinW;
          source.y := LenS * NewSin; source.x := LenS * newCos;
      end;
    source.x := source.x + Base2.x; source.y := source.y + Base2.y;
    target := source;
end;

procedure work;
var
    i          : integer;
    SinP1 , CosP1 ,
    SinP2 , CosP2 ,
    LenP1 , LenP2 ,
    SinW , CosW ,
    ratio      : extended;
    p1 , p2 ,
    Base1 ,
    Base2      : Tpoint;
begin
    for i := 1 to N do
      begin
          data[i].x := sin(2 * pi / N * (i - 1));
          data[i].y := cos(2 * pi / N * (i - 1));
      end;

    p1.x := data[N2].x - data[N1].x; p1.y := data[N2].y - data[N1].y;
    p2.x := answer[N2].x - answer[N1].x; p2.y := answer[N2].y - answer[N1].y;
    LenP1 := sqrt(sqr(p1.x) + sqr(p1.y)); LenP2 := sqrt(sqr(p2.x) + sqr(p2.y));
    SinP1 := p1.y / LenP1; CosP1 := p1.x / LenP1;
    SinP2 := p2.y / LenP2; CosP2 := p2.x / LenP2;
    SinW := SinP2 * CosP1 - SinP1 * CosP2;
    CosW := CosP1 * CosP2 + SinP1 * SinP2;

    ratio := LenP2 / LenP1;
    for i := 1 to N do
      begin
          data[i].x := data[i].x * ratio; data[i].y := data[i].y * ratio;
      end;
    Base1 := data[N1]; Base2 := answer[N1];
    for i := 1 to N do
      Change(data[i] , answer[i] , Base1 , Base2 , SinW , CosW);
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to N do
        writeln(answer[i].x : 0 : 6 , ' ' , answer[i].y : 0 : 6);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.