{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p136.in';
    OutFile    = 'p136.out';
    Limit      = 10000;
    zero       = 1e-6;

Type
    Tpoint     = record
                     x , y    : extended;
                 end;
    Tdata      = array[1..Limit] of Tpoint;
    Tequa      = record
                     c        : extended;
                     sign     : integer;
                 end;

Var
    data       : Tdata;
    answer     : Tpoint;
    noanswer   : boolean;
    N          : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
      for i := 1 to N do
        with data[i] do
          readln(x , y);
//    Close(INPUT);
end;

procedure work;
var
    x , y      : Tequa;
    i          : integer;
begin
    x.c := 0; x.sign := 1; y.c := 0; y.sign := 1;
    for i := 1 to N do
      begin
          x.sign := -x.sign;
          x.c := 2 * data[i].x - x.c;
          y.sign := -y.sign;
          y.c := 2 * data[i].y - y.c;
      end;

    noanswer := false;
    if (x.sign - 1 = 0) and (y.sign - 1 = 0) then
      if (abs(x.c) <= zero) and (abs(y.c) <= zero) then
        begin
            answer.x := -1;
            answer.y := 1;
        end
      else
        noanswer := true
    else
      begin
          answer.x := -x.c / (x.sign - 1);
          answer.y := -y.c / (y.sign - 1);
      end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        writeln('NO')
      else
        begin
            writeln('YES');
            for i := 1 to N do
              begin
                  writeln(answer.x : 0 : 3 , ' ' , answer.y : 0 : 3);
                  answer.x := 2 * data[i].x - answer.x;
                  answer.y := 2 * data[i].y - answer.y;
              end;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
