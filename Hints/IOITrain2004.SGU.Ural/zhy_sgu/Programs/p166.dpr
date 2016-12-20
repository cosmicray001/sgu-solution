{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p166.in';
    OutFile    = 'p166.out';
    Limit      = 20480;
    LimitLen   = 1000;

Type
    Tpoint     = ^Tnode;
    Tnode      = record
                     ch                      : char;
                     position                : word;
                     next                    : Tpoint;
                 end;
    TPointLine = ^TLine;
    TLine      = record
                     node                    : Tpoint;
                     prev , next             : TPointLine;
                 end;
    Tcommand   = array[1..Limit] of char;
    Tcursor    = record
                     x , y    : integer;
                 end;
    TarrLine   = array[0..LimitLen] of char;

Var
    command    : Tcommand;
    cursor     : Tcursor;
    nowLine ,
    data       : TPointLine;
    arrLine    : TarrLine;
    N          : integer;
    noanswer   : boolean;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      N := 0;
      while not eoln do
        begin
            inc(N);
            read(command[N]);
            if command[N] = 'Q' then
              break;
        end;
      if (N = 0) or (command[N] <> 'Q') then
        noanswer := true
      else
        noanswer := false;
//    Close(INPUT);
end;

procedure InitalizeLine(var nodep : Tpoint);
begin
    new(nodep);
    nodep^.ch := #0;
    nodep^.position := 0;
    nodep^.next := NIL;
end;

procedure addpoint(Line : TpointLine; addp : Tpoint);
var
    p          : Tpoint;
begin
    p := Line.node;
    while (p^.next <> NIL) and (p^.next^.position < addp^.position) do
      p := p^.next;
    addp^.next := p^.next;
    p^.next := addp;
    p := addp^.next;
    while p <> NIL do
      begin
          inc(p^.position);
          p := p^.next;
      end;
end;

procedure Enter(Line : TpointLine; position : integer);
var
    p , tp     : Tpoint;
    newLine    : TpointLine;
begin
    p := Line.node;
    while (p^.next <> NIL) and (p^.next^.position < position) do
      p := p^.next;

    tp := p^.next;
    while tp <> NIL do
      begin
          dec(tp^.position , position - 1);
          tp := tp^.next;
      end;

    new(newLine);
    InitalizeLine(newLine^.node);
    newLine^.node^.next := p^.next;
    newLine^.prev := Line;
    newLine^.next := Line^.next;
    if Line^.next <> NIL then
      Line^.next^.prev := newLine;
    Line^.next := newLine;

    if p^.position <> position - 1 then
      begin
          new(p^.next);
          p^.next^.ch := ' ';
          p^.next^.position := position - 1;
          p^.next^.next := NIL;
      end
    else
      p^.next := NIL;
end;

procedure GetEnd(Line : TpointLine; var position : integer);
var
    p          : Tpoint;
begin
    p := Line^.node;
    while p^.next <> NIL do
      p := p^.next;
    position := p^.position;
end;

function DelChar(Line : TpointLine; position , sign : integer) : integer;
var
    p , tp     : Tpoint;
    tmpLine    : TpointLine;
begin
    DelChar := 0;
    p := Line^.node;
    while (p^.next <> NIL) and (p^.next.position < position) do
      p := p^.next;
    if p^.next = NIL then
      if Line^.next <> NIL then
        begin
            if sign = 2 then
              exit;
            if sign = 1 then
              begin
                  position := p^.position + 1;
                  DelChar := position;
              end;
            if p^.position <> position - 1 then
              begin
                  new(p^.next);
                  p^.next^.ch := ' ';
                  p^.next^.position := position - 1;
                  p := p^.next;
              end;
            p^.next := Line^.next^.node^.next;
            tmpLine := Line^.next;
            Line^.next := tmpLine^.next;
            tmpLine^.next^.prev := Line;
            dispose(tmpLine);

            p := p^.next;
            while p <> NIL do
              begin
                  inc(p^.position , position - 1);
                  p := p^.next;
              end;
        end
      else
    else
      begin
          tp := p^.next;
          p^.next := p^.next^.next;
          dispose(tp);
          p := p^.next;
          while p <> NIL do
            begin
                dec(p^.position);
                p := p^.next;
            end;
      end;
end;

procedure BackSpace(var Line : TpointLine; var position : integer);
begin
    if position = 1 then
      if Line^.prev <> NIL then
        begin
            Line := Line^.prev;
            position := DelChar(Line , LimitLen + 1 , 1);
        end
      else
    else
      begin
          DelChar(Line , position - 1 , 2);
          dec(position);
      end;
end;

procedure work;
var
    i          : integer;
    p          : Tpoint;
begin
    if noanswer then
      exit;

    new(data);
    cursor.x := 1; cursor.y := 1;
    InitalizeLine(data^.node);
    data^.prev := NIL;
    data^.next := NIL;
    nowLine := data;

    for i := 1 to N - 1 do
      case command[i] of
        'a'..'z' , ' '        : begin
                                    New(p);
                                    p.ch := command[i];
                                    p.position := cursor.y;
                                    AddPoint(nowLine , p);
                                    inc(cursor.y);
                                end;
        'L'                   : begin
                                    if cursor.y > 1 then
                                      dec(cursor.y);
                                end;
        'R'                   : begin
                                    inc(cursor.y);
                                end;
        'U'                   : begin
                                    if nowLine^.prev <> NIL then
                                      begin
                                          dec(cursor.x);
                                          nowLine := nowLine^.prev;
                                      end;
                                end;
        'D'                   : begin
                                    if nowLine^.next <> NIL then
                                      begin
                                          inc(cursor.x);
                                          nowLine := nowLine^.next;
                                      end;
                                end;
        'N'                   : begin
                                    Enter(nowLine , cursor.y);
                                    nowLine := nowLine^.next;
                                    inc(cursor.x);
                                    cursor.y := 1;
                                end;
        'E'                   : begin
                                    GetEnd(nowLine , cursor.y);
                                    inc(cursor.y);
                                end;
        'H'                   : begin
                                    cursor.y := 1;
                                end;
        'X'                   : begin
                                    DelChar(nowLine , cursor.y , 0);
                                end;
        'B'                   : begin
                                    BackSpace(nowLine , cursor.y);
                                end;
      end;
end;

procedure out;
var
    p          : Tpoint;
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      nowLine := Data;
      while nowLine <> NIL do
        begin
            fillchar(arrLine , sizeof(arrLine) , 32);
            p := nowLine^.node;
            while p^.next <> NIL do
              begin
                  arrLine[p^.next^.position] := p^.next^.ch;
                  p := p^.next;
              end;
            for i := 1 to p^.position do
              write(arrLine[i]);
            if nowLine^.next <> NIL then
              writeln;
            nowLine := nowLine^.next;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
