{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p187.in';
    OutFile    = 'p187.out';
    LimitM     = 2000;

Type
    Tsegment   = record
                     start , stop            : longint;
                 end;
    Tseg       = array[1..LimitM * 2 + 1] of Tsegment;
    Trequest   = array[1..LimitM] of
                   record
                       start , stop          : longint;
                   end;
    Tcursor    = record
                     p , exc                 : longint;
                 end;

Var
    seg        : Tseg;
    request    : Trequest;
    N , M ,
    total      : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to M do
        read(request[i].start , request[i].stop);
//    Close(INPUT);
end;

procedure find(num : longint; var p : Tcursor);
begin
    p.p := 1;
    while num > abs(seg[p.p].start - seg[p.p].stop) + 1 do
      begin
          dec(num , abs(seg[p.p].start - seg[p.p].stop) + 1);
          inc(p.p);
      end;
    p.exc := num;
    if num = 0 then p.p := 0;
end;

procedure spilt(p : Tcursor; code : longint);
var
    i , dir    : longint;
begin
    if (p.p <> 0) and (p.exc <> abs(seg[p.p].start - seg[p.p].stop) + 1) then
      begin
          for i := total downto p.p do
            seg[i + 1] := seg[i];
          inc(total);
          if seg[p.p].start <= seg[p.p].stop then dir := 1 else dir := -1;
          seg[p.p].stop := seg[p.p].start + dir * (p.exc - 1);
          seg[p.p + 1].start := seg[p.p].stop + dir;
          if code = 1 then inc(p.p);
      end;
end;

procedure swap(p1 , p2 : longint);
var
    tmp        : Tsegment;
begin
    tmp := seg[p1];
    seg[p1] := seg[p2];
    seg[p2] := tmp;
end;

procedure work;
var
    i , j ,
    tmp        : longint;
    p1 , p2    : Tcursor;
begin
    fillchar(seg , sizeof(seg) , 0);
    seg[1].start := 1; seg[1].stop := N; 
    total := 1;

    for i := 1 to M do
      begin
          find(request[i].start - 1 , p1);
          spilt(p1 , 1);
          find(request[i].stop , p2);
          spilt(p2 , 2);
          inc(p1.p);
          for j := 0 to (p2.p - p1.p + 1) div 2 - 1 do
            swap(p1.p + j , p2.p - j);
          for j := p1.p to p2.p do
            begin
                tmp := seg[j].start;
                seg[j].start := seg[j].stop;
                seg[j].stop := tmp;
            end;
      end;
end;

procedure out;
var
    i , j      : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to total do
        if seg[i].start <= seg[i].stop then
          for j := seg[i].start to seg[i].stop do
            write(j , ' ')
        else
          for j := seg[i].start downto seg[i].stop do
            write(j , ' ');
      writeln;  
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
