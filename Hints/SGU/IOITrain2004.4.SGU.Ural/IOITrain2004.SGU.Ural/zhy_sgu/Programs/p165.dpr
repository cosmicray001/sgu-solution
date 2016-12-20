{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p165.in';
    OutFile    = 'p165.out';
    Limit      = 6001;
    C          = 5000;

Type
    Tdata      = record
                     total    : integer;
                     data     : array[1..Limit] of
                                  record
                                      number , position     : integer;
                                  end;
                 end;
    Tanswer    = array[1..Limit] of integer;

Var
    nagetive ,
    positive   : Tdata;
    answer     : Tanswer;

procedure init;
var
    i , tmp , N: integer;
    num        : extended;
begin
    fillchar(nagetive , sizeof(nagetive) , 0);
    fillchar(positive , sizeof(positive) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        begin
            read(num);
            tmp := round(num * 1e6) - 2000000;
            if tmp < 0 then
              begin
                  inc(nagetive.total);
                  nagetive.data[nagetive.total].number := tmp;
                  nagetive.data[nagetive.total].position := i;
              end
            else
              begin
                  inc(positive.total);
                  positive.data[positive.total].number := tmp;
                  positive.data[positive.total].position := i;
              end;
        end;
//    Close(INPUT);
    nagetive.data[nagetive.total + 1].number := -2 * C - 1;
    positive.data[positive.total + 1].number := 2 * C + 1;
end;

procedure work;
var
    i , now ,
    p1 , p2    : integer;
begin
    now := 0;
    p1 := 1; p2 := 1;
    for i := 1 to nagetive.total + positive.total do
      if now + positive.data[p1].number <= C then
        begin
            answer[i] := positive.data[p1].position;
            inc(now , positive.data[p1].number);
            inc(p1);
        end
      else
        begin
            answer[i] := nagetive.data[p2].position;
            inc(now , nagetive.data[p2].number);
            inc(p2);
        end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln('yes');
      for i := 1 to positive.total + nagetive.total - 1 do
        write(answer[i] , ' ');
      if positive.total + nagetive.total > 0 then
        writeln(answer[positive.total + nagetive.total])
      else
        writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
