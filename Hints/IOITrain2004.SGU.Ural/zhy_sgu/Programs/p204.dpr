{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    InFile     = 'p204.in';
    OutFile    = 'p204.out';
    Minimum    = 1e-12;
    Maximum    = 1e7;

Type
    Tseg       = record
                     a , b    : extended;
                 end;

Var
    b1 , t1 , b2 , t2 ,
    l , ds , df ,
    g , ans    : extended;

procedure init;
begin
    readln(b1 , t1 , b2 , t2 , l , ds , df , g);
end;

procedure solve_equa(A , B , C , l , p1 , p2 : extended; var seg : Tseg);
var
    delta ,
    x1 , x2    : extended;
begin
    seg.A := -1; seg.B := -1;
    delta := B * B - 4 * A * C;
    if delta < 0 then exit;
    delta := sqrt(delta);
    x1 := (-B - delta) / 2 / A; x2 := (-B + delta) / 2 / A;
    if (x1 < 0) or (x2 < 0) then exit;
    if p1 < x1 then seg.A := x1 else seg.A := p1;
    if p2 < x2 then seg.B := p2 else seg.B := x2;
    if (seg.B > l) then seg.B := l;
    if (seg.A > l) or (seg.A > seg.B) then
      begin seg.A := -1; seg.B := -1; end;
end;

procedure add_seg(var seg : Tseg; newseg : Tseg);
begin
    if seg.A < 0
      then seg := newseg
      else if newseg.A < 0
             then exit
             else begin
                      if newseg.A < seg.A then seg.A := newseg.A;
                      if newseg.B > seg.B then seg.B := newseg.B; 
                  end;
end;

procedure Get_Seg(v0 , h1 , h2 , L , m : extended; var seg : Tseg);
var
    newseg     : Tseg;
    p1 , p2 ,
    p3         : extended;
begin
    seg.A := -1; seg.B := -1;
    if m <= h1 + minimum
      then begin
               solve_equa(h1 / m + m / h1 , 2 * (h1 - v0 * v0 / g) , h1 * m , L , 0 , L , newseg);
               add_seg(seg , newseg);
           end
      else if m <= h2 + minimum
             then begin
                      p1 := h1 * m / (m - h1);
                      solve_equa(h1 / m + m / h1 , 2 * (h1 - v0 * v0 / g) , h1 * m , L , 0 , p1 , newseg);
                      add_seg(seg , newseg);
                      p2 := v0 * v0 / g - m;
                      if p1 <= p2
                        then begin newseg.A := p1; newseg.B := p2; end
                        else begin newseg.A := -1; newseg.B := -1; end;
                      if (newseg.B > l) then newseg.B := l;
                      if (newseg.A > l) or (newseg.A > seg.B) then
                        begin newseg.A := -1; newseg.B := -1; end;
                      add_seg(seg , newseg);
                  end
             else begin
                      p1 := h1 * m / (m - h1); p2 := h2 * m / (m - h2);
                      solve_equa(h1 / m + m / h1 , 2 * (h1 - v0 * v0 / g) , h1 * m , L , 0 , p1 , newseg);
                      add_seg(seg , newseg);
                      solve_equa(h2 / m + m / h2 , 2 * (h2 - v0 * v0 / g) , h2 * m , L , p2 , L , newseg);
                      add_seg(seg , newseg);
                      p3 := v0 * v0 / g - m;
                      if p2 >= l then p2 := l;
                      if p3 >= p2 then p3 := p2;
                      if (p3 >= p1) 
                        then begin newseg.A := p1; newseg.B := p3; end
                        else begin newseg.A := -1; newseg.B := -1; end;
                      add_seg(seg , newseg);
                  end;
end;

function cover(seg1 , seg2 : Tseg) : boolean;
var
    p1 , p2    : extended;
begin
    cover := false;
    if seg1.A < 0 then exit;
    if seg2.A < 0 then exit;
    if seg1.A < seg2.A then p1 := seg2.A else p1 := seg1.A;
    if seg1.B < seg2.B then p2 := seg1.B else p2 := seg2.B;
    if p1 <= p2 then cover := true;
end;

procedure work;
var
    start , stop ,
    mid , tmp  : extended;
    seg1 , seg2: Tseg;
begin
    ans := -1;
    start := 0; stop := Maximum;
    while start + minimum <= stop do
      begin
          mid := (start + stop) / 2;
          Get_Seg(mid , b1 , t1 , l , ds , seg1);
          Get_Seg(mid , b2 , t2 , l , df , seg2);
          seg2.a := l - seg2.a; seg2.b := l - seg2.b;
          tmp := seg2.a; seg2.a := seg2.b; seg2.b := tmp;
          if cover(seg1 , seg2)
            then begin
                     ans := mid;
                     stop := mid;
                 end
            else start := mid;
      end;
end;

procedure out;
begin
    if ans < 0
      then writeln(-1)
      else writeln(ans : 0 : 4);
end;

Begin
//    assign(INPUT , InFile); ReSet(INPUT);
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      while not seekeof do
        begin
            init;
            work;
            out;
        end;
//    Close(OUTPUT);
//    Close(INPUT);
End.
