{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p106.in';
    OutFile    = 'p106.out';

Var
    A , B , C ,
    x1 , x2 ,
    y1 , y2 ,
    answer     : int64;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(A , B , C , x1 , x2 , y1 , y2);
//    Close(INPUT);
end;

function get_root(A , B , C : int64; var x , y , gcdnum : int64) : boolean;
var
    tx , ty    : int64;
begin
    if A = 0 then
      if C mod B = 0 then
        begin
            gcdnum := B;
            x := 0;
            y := C div B;
            get_root := true;
        end
      else
        get_root := false
    else
      if get_root(B mod A , A , C , tx , ty , gcdnum) then
        begin
            y := tx;
            x := ty - (B div A) * tx;
            get_root := true;
        end
      else
        get_root := false;
end;

procedure work;
var
    rootx ,
    rooty ,
    gcdnum ,
    addx , addy ,
    addstep    : int64;
    lowx , highx ,
    lowy , highy ,
    tmp        : extended;
    success    : boolean;
begin
    if (A = 0) and (B = 0) then
      answer := int64(x2 - x1 + 1) * int64(y2 - y1 + 1) * ord(C = 0)
    else
      if (A = 0) or (B = 0) then
        begin
            if A = 0 then
              begin
                  A := B;
                  x1 := y1; x2 := y2;
              end;
            if -C mod A <> 0 then
              answer := 0
            else
              if (-C div A >= x1) and (-C div A <= x2) then
                answer := 1
              else
                answer := 0;
        end
      else
        begin
            success := get_root(A , B , -C , rootx , rooty , gcdnum);
            if success then
              begin
                  addstep := abs(int64(A) * B div gcdnum);
                  addx := addstep div A;
                  addy := addstep div B;

                  lowx := (x1 - rootx) / addx; highx := (x2 - rootx) / addx;
                  if lowx > highx then
                    begin
                        tmp := lowx; lowx := highx; highx := tmp;
                    end;

                  lowy := -(y1 - rooty) / addy; highy := -(y2 - rooty) / addy;
                  if lowy > highy then
                    begin
                        tmp := lowy; lowy := highy; highy := tmp;
                    end;

                  if lowy > lowx then lowx := lowy;
                  if highy < highx then highx := highy;
                  highx := highx - int(lowx) + 10;
                  lowx := lowx - int(lowx) + 10;

                  if int(lowx) >= lowx - 1e-5 then
                    lowx := int(lowx)
                  else
                    lowx := int(lowx) + 1;
                  highx := int(highx);

                  if lowx > highx then
                    answer := 0
                  else
                    answer := round(highx - lowx) + 1;
              end
            else
              answer := 0;
        end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
