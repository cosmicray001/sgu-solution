{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$I-}
Var
    s          : string;
    data       : array[1..100] of
                   record
                       p1 , p2               : integer;
                       visited               : boolean;
                   end;
    N , i , p ,
    p1 , p2    : integer;
    now , tmp  : integer;
    c          : char;

procedure error;
begin
    writeln('Wrong Answer');
    halt(1);
end;

Begin
    assign(INPUT , 'p101.in'); ReSet(INPUT);
      readln(N);
      for i := 1 to N do
        with data[i] do
          begin
              readln(p1 , p2);
              visited := false;
          end;
    Close(INPUT);

    assign(INPUT , 'p101.std'); ReSet(INPUT);
      readln(s);
    Close(INPUT);
    now := -1;
    assign(INPUT , 'p101.out'); ReSet(INPUT);
    if s = 'No solution' then
      begin
          readln(s);
          if s <> 'No solution' then
            error;
      end
    else
      for i := 1 to N do
        begin
            read(p);
            if ioresult <> 0 then
              error;
            read(c);
            readln(c);
            if (p < 1) or (p > N) or data[p].visited then
              error;
            data[p].visited := true;
            p1 := data[p].p1; p2 := data[p].p2;
            if c in ['+' , '-'] then
              if c = '-' then
                begin
                    tmp := p1;
                    p1 := p2;
                    p2 := tmp;
                end
              else
            else
              error;
            if (now = -1) or (now = p1) then
              now := p2
            else
              error;
        end;
    Writeln('Accepted');
    Close(INPUT);
End.
