{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Var
    P , M , C ,
    K , R , V  : longint;
Begin
    readln(P , M , C , K , R , V);
    P := P div K;
    M := M div R;
    C := C div V;
    if M < P then P := M;
    if C < P then P := C;
    writeln(P);
End.