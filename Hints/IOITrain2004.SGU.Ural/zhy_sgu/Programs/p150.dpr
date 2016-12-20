{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p150.in';
    OutFile    = 'p150.out';
    zero       = 1e-7;

Type
    Tpoint     = record
                     x , y    : integer;
                 end;

Var
    p1 , p2 ,
    ansp       : Tpoint;
    N          : integer;
    nosolution : boolean;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(p1.x , p1.y , p2.x , p2.y , N);
//    Close(INPUT);
end;

procedure work;
var
    singlestep ,
    start , stop ,
    tmp        : extended;
    i ,
    xdir ,
    ydir , p ,
    intst ,
    inten , t2 : integer;
    changed    : boolean;
begin
    if (p2.y = p1.y) or (p2.x = p1.x) then
      begin
          nosolution := true;
          exit;
      end;
    singlestep := abs(p2.y - p1.y) / abs(p2.x - p1.x);
    xdir := abs(p2.x - p1.x) div (p2.x - p1.x);
    ydir := abs(p2.y - p1.y) div (p2.y - p1.y);
    i := p1.x;
    p := 0;
    nosolution := false;
    while i <> p2.x do
      begin
          start := abs(i - p1.x) * singlestep * ydir + p1.y;
          stop := abs(i + 1 - p1.x) * singlestep * ydir + p1.y;
          changed := false;
          if start < stop then
            begin
                tmp := start; start := stop; stop := tmp;
                changed := true;
            end;
          intst := trunc(start + 2);
          while intst >= start - zero do
            dec(intst);
          inc(intst);
          inten := trunc(stop - 2);
          while inten <= stop + zero do
            inc(inten);
          dec(inten);
          if changed then
            begin
                t2 := intst; intst := inten; inten := t2;
            end;
          if p + abs(inten - intst) >= N then
            begin
                ansp.x := i;
                if xdir = -1 then
                  dec(ansp.x);
                ansp.y := (N - p - 1) * ydir + intst;
                if ydir = -1 then
                  dec(ansp.y);
                exit;
            end
          else
            inc(p , abs(inten - intst));
          inc(i , xdir);
      end;
    nosolution := true;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if nosolution then
        writeln('no solution')
      else
        writeln(ansp.x , ' ' , ansp.y);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
