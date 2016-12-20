{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p149.in';
    OutFile    = 'p149.out';
    Limit      = 10000;

Type
    Tmap       = array[1..Limit] of
                   record
                       father , cost         : integer;
                   end;
    Tdata      = array[1..Limit] of integer;
    Topt       = array[1..Limit] of
                   record
                       best1 , best2 ,
                       p1 , p2               : integer;
                   end;

Var
    map        : Tmap;
    submax     : Tdata;
    opt        : Topt;
    N          : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
      for i := 2 to N do
        with map[i] do
          read(father , cost);
//    Close(INPUT);
end;

procedure work;
var
    i , tmp    : integer;
begin
    fillchar(opt , sizeof(opt) , 0);
    fillchar(submax , sizeof(submax) , 0);
    for i := N downto 2 do
      begin
          tmp := opt[i].best1 + map[i].cost;
          with opt[map[i].father] do
            if (p1 = 0) or (best1 < tmp) then
              begin
                  p2 := p1; best2 := best1;
                  p1 := i; best1 := tmp;
              end
            else
              if (p2 = 0) or (best2 < tmp) then
                begin
                    p2 := i;
                    best2 := tmp;
                end;
      end;

    for i := 2 to N do
      begin
          if opt[map[i].father].p1 <> i then
            tmp := map[i].cost + opt[map[i].father].best1
          else
            tmp := map[i].cost + opt[map[i].father].best2;

          with opt[i] do
            if (p1 = 0) or (best1 < tmp) then
              begin
                  p1 := map[i].father; best1 := tmp;
                  p2 := p1; best2 := best1;
              end
            else
              if (p2 = 0) or (best2 < tmp) then
                begin
                    p2 := map[i].father;
                    best2 := tmp;
                end;
      end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to N do
        writeln(opt[i].best1);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
