{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p142.in';
    OutFile    = 'p142.out';
    Limit      = 500000;
    Base       = 524288 * 2;
    LimitLen   = 19;

Type
    Tdata      = array[1..Limit] of integer;
    Tappeared  = array[0..Base] of boolean;
    Toutdata   = array[1..LimitLen] of char;

Var
    data       : Tdata;
    appeared   : Tappeared;
    outdata    : Toutdata;
    N , answer ,
    outlen     : integer;

procedure init;
var
    i          : integer;
    c          : char;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
      for i := 1 to N do
        begin
            read(c);
            data[i] := ord(c) - ord('a');
        end;
//    Close(INPUT);
end;

procedure work;
var
    i , len , j ,
    package ,
    addbase    : integer;
begin
    fillchar(appeared , sizeof(appeared) , 0);
    len := 0;
    for i := 1 to N do
      begin
          if len < LimitLen then
            inc(len);
          package := 0;
          addbase := 1;
          for j := i downto i - len + 1 do
            begin
                if data[j] = 1 then
                  inc(package , addbase);
                addbase := addbase shl 1;
                appeared[package + addbase] := true;
            end;
      end;
    answer := 2;
    while appeared[answer] do
      inc(answer);
    outlen := 0;
    while answer <> 1 do
      begin
          inc(outlen);
          outdata[outlen] := chr(answer mod 2 + ord('a'));
          answer := answer shr 1;
      end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(outlen);
      for i := outlen downto 1 do
        write(outdata[i]);
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
