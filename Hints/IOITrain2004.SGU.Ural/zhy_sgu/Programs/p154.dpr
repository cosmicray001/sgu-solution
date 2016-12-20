{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p154.in';
    OutFile    = 'p154.out';

Var
    Q , answer : extended;
    NoSolution : boolean;

procedure init;
begin
    assign(INPUT , InFile); ReSet(INPUT);
      readln(Q);
    Close(INPUT);
end;

procedure work;
var
    base , add ,
    tmp        : extended;
begin
    NoSolution := false;
    base := 1;
    add := 1;
    while base < Q do
      begin
          base := base * 5 + 1;
          add := add * 5;
      end;
    while (Q <> 0) and (base <> 0) do
      begin
          tmp := int(Q / base);
          if tmp = 5 then
            begin
                NoSolution := true;
                exit;
            end;
          answer := answer + tmp * add;
          Q := Q - tmp * base;
          base := (base - 1) / 5;
          add := add / 5;
      end;
    if Q <> 0 then
      NoSolution := true
    else
      answer := answer * 5;
end;

procedure out;
begin
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if NoSolution then
        writeln('No Solution')
      else
        if answer = 0 then
          writeln(1)
        else
          writeln(answer : 0 : 0);
    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
