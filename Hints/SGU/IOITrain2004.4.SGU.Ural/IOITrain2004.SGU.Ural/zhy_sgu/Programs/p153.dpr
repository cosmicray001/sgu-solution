{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p153.in';
    OutFile    = 'p153.out';
    Limit      = 9;
    LimitLen   = 3000;

Type
    Tappeared  = array[0..1 shl Limit] of integer;
    Topt       = array[0..LimitLen] of integer;
    Tdata      = array[0..Limit] of integer;

Var
    appeared   : Tappeared;
    opt ,
    modNum     : Topt;
    data       : Tdata;
    N , M ,
    max , total ,
    answer     : integer;

procedure init;
var
    i          : integer;
begin
    fillchar(appeared , sizeof(appeared) , 0);
    fillchar(opt , sizeof(opt) , 0);
    fillchar(data , sizeof(data) , 0);
    read(N , M);
    inc(M);
    max := 1;
    data[1] := 1;
    for i := 2 to M do
      begin
          read(data[i]);
          if data[i] > max then
            max := data[i];
      end;
    for i := 0 to LimitLen do
      modnum[i] := i mod (1 shl Max);
end;

function process(p : integer) : integer;
var
    i          : integer;
begin
    for i := 1 to M do
      if p - data[i] > 0 then
        if opt[p - data[i]] = 0 then
          begin
              process := 1;
              exit;
          end;
    process := 0;
end;

procedure work;
var
    i , mark   : integer;
begin
    opt[1] := 0;
    mark := 0;
    for i := 2 to max do
      begin
          opt[i] := process(i);
          mark := mark shl 1 + opt[i];
      end;
    if N <= max then
      begin
          answer := opt[N];
          exit;
      end;     

    i := max;
    appeared[mark] := i;
    while true do
      begin
          inc(i);
          opt[i] := process(i);
          mark := modnum[mark shl 1 + opt[i]];
          if i = N then
            begin
                answer := opt[i];
                exit;
            end;
          if appeared[mark] <> 0 then
            break;
      end;

    N := (N - appeared[mark]) mod (i - appeared[mark]);
    answer := opt[appeared[mark] + N];
end;

procedure out;
begin
    if answer = 1 then
      writeln('FIRST PLAYER MUST WIN')
    else
      writeln('SECOND PLAYER MUST WIN');
end;

Begin
//    assign(INPUT , InFile); ReSet(INPUT);
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      read(total);
      while total > 0 do
        begin
            init;
            work;
            out;
            dec(total);
        end;
//    Close(OUTPUT);
//    Close(INPUT);
End.
