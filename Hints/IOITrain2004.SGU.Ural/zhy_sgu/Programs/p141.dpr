{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p141.in';
    OutFile    = 'p141.out';

Var
    x1 , x2 ,
    P , K , gcdnum ,
    N1 , N2 ,
    P1 , P2    : int64;
    noanswer   : boolean;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(x1 , x2 , P , K);
//    Close(INPUT);
end;

function eculid(x1 , x2 : int64; var y1 , y2 : int64; P : int64) : boolean;
begin
    if x1 = 0 then
      if P mod x2 = 0 then
        begin
            y1 := 0;
            y2 := P div x2;
            gcdnum := abs(x2);
            eculid := true;
        end
      else
        eculid := false
    else
      if eculid(x2 mod x1  , x1 , y2 , y1 , P) then
        begin
            y1 := y1 - x2 div x1 * y2;
            eculid := true;
        end
      else
        eculid := false;
end;

function check(num : int64; parity : integer) : boolean;
begin
    if parity = -1 then
      check := true
    else
      if (parity = 1) = odd(num) then
        check := true
      else
        check := false;
end;

procedure work;
var
    y1 , y2 ,
    addy1 ,
    addy2 , tk ,
    i , tmp    : int64;
    parity     : integer;
begin
    noanswer := true;
    if not eculid(x1 , x2 , y1 , y2 , P) then
      exit;

    addy1 := x2 div gcdnum;
    addy2 := x1 div gcdnum;
    if not odd(addy1 - addy2) and (odd(y1 + y2) <> odd(K)) then
      exit;

    if not odd(addy1 - addy2) then
      parity := -1
    else
      if odd(y1 + y2) <> odd(K) then
        parity := 1
      else
        parity := 0;

    if addy1 < addy2 then
      tk := y2 div addy2
    else
      tk := -y1 div addy1;

    i := tk - 10;
    while i <= tk + 10 do
      begin
          if check(i , parity) and (abs(y1 + i * addy1) + abs(y2 - i * addy2) <= K) then
            begin
                noanswer := false;
                y1 := y1 + i * addy1;
                y2 := y2 - i * addy2;
                N1 := 0; N2 := 0; P1 := 0; P2 := 0;
                if y1 < 0 then
                  N1 := abs(y1)
                else
                  P1 := y1;
                if y2 < 0 then
                  N2 := abs(y2)
                else
                  P2 := y2;
                tmp := K - N1 - N2 - P1 - P2;
                N1 := N1 + tmp div 2;
                P1 := P1 + tmp div 2;
                exit;
            end;
          i := i + 1;
      end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        writeln('NO')
      else
        begin
            writeln('YES');
            writeln(P1 , ' ' , N1 , ' ' , P2 , ' ' , N2);
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
