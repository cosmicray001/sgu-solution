{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p160.in';
    OutFile    = 'p160.out';
    Limit      = 1000;
    LimitN     = 10000;

Type
    Tlevel     = array[1..LimitN] of integer;
    Tdata      = array[1..Limit] of integer;
    Topt       = array[0..Limit , 0..Limit] of
                   record
                       father , times        : integer;
                       ok                    : boolean;
                   end;
    Tmodnum    = array[0..Limit * Limit] of integer;

Var
    level      : Tlevel;
    data ,
    usetimes   : Tdata;
    opt        : Topt;
    modnum     : Tmodnum;
    N , M ,
    answer     : integer;

procedure init;
var
    i          : integer;
begin
    fillchar(level , sizeof(level) , 0);
    fillchar(data , sizeof(data) , 0);
    fillchar(opt , sizeof(opt) , 0);
    opt[0 , 1].ok := true;
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to N do
        begin
            read(level[i]);
            inc(data[level[i]]);
        end;
//    Close(INPUT);
end;

procedure work;
var
    i , j , k ,
    tmp ,
    power      : integer;
begin
    for i := 0 to M * M do
      modnum[i] := i mod M;

    for i := 1 to M - 1 do
      begin
          power := 1;
          for j := 0 to data[i] do
            begin
                for k := 0 to M - 1 do
                  if opt[i - 1 , k].ok then
                    begin
                        tmp := modnum[k * power];
                        if not opt[i , tmp].ok then
                          begin
                              opt[i , tmp].ok := true;
                              opt[i , tmp].father := k;
                              opt[i , tmp].times := j;
                          end;
                    end;
                power := modnum[power * i];
            end;
      end;

    answer := M - 1;
    while not opt[M - 1 , answer].ok do
      dec(answer); 
end;

procedure out;
var
    step , i   : integer;
begin
    fillchar(usetimes , sizeof(usetimes) , 0);
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
      step := M - 1;
      while step <> 0 do
        begin
            usetimes[step] := opt[step , answer].times;
            answer := opt[step , answer].father;
            dec(step);
        end;
      for i := 1 to N do
        if usetimes[level[i]] > 0 then
          begin
              dec(usetimes[level[i]]);
              write(i , ' ');
          end;
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
