{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p104.in';
    OutFile    = 'p104.out';
    Limit      = 100;

Type
    Tdata      = array[1..Limit , 1..Limit] of integer;
    Topt       = array[1..Limit + 1 , 1..Limit + 1] of
                   record
                       max , next            : integer;
                   end;

Var
    data       : Tdata;
    opt        : Topt;
    N , F      : integer;

procedure init;
var
    i , j      : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(F , N);
      for i := 1 to F do
        for j := 1 to N do
          read(data[i , j]);
//    Close(INPUT);
end;

procedure work;
var
    i , j      : integer;
begin
    fillchar(opt , sizeof(opt) , 0);
    for i := F downto 1 do
      for j := N - (F - i) downto 1 do
        begin
            opt[i , j].max := -maxlongint;
            if opt[i + 1 , j + 1].max + data[i , j] > opt[i , j].max then
              begin
                  opt[i , j].max := opt[i + 1 , j + 1].max + data[i , j];
                  opt[i , j].next := j;
              end;
            if (j < N - (F - i)) and (opt[i , j + 1].max > opt[i , j].max) then
              opt[i , j] := opt[i , j + 1];
        end;
end;

procedure out;
var
    i , p      : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(opt[1 , 1].max);
      p := 1;
      for i := 1 to F do
        begin
            p := opt[i , p].next;
            write(p);
            inc(p);
            if i = N then
              writeln
            else
              write(' ');
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
