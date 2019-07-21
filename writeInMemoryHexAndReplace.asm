link l1:ct 					\\ wyjscie znqacznikow rejestru
link l2:rdm					\\ gotowosc pamieci
equ cs:r8					\\ blok rownowaznikow, zamienia cs na r8
equ ip:r12			
equ pom1:r13				\\ rejestry pomocnicze
equ pom2:r14
equ rr:r15

accept cs:ABF5h				\\ rejestr rozkazow
accept ip:CACAh				\\ adres fizyczny to - B8A1Ah	ABF50h+CACAh

dw B8A1Ah:BABAh				\\ rezerwowanie pamieci i wpisanie BABA

macro mov reg1, reg2:{or reg1,reg2,z;}		\\ z rejestru 1 kopiuj do rejestru 2, pobieraz reg2 -> suma logiczna z 0, potem do reg1

{mov pom1, cs;}				\\ z cs kopiuj do pom1
{mov rq, ip;}

{cjs nz, obadrfiz;}			\\ wywolanie podrogramu z arg nz - zawsze spelniony	

{mov nil, pom1;oey;ewl;}	\\ przesun pom1 do nikad, oey - wystawienie na magistrale danych, ewl - z magistrali zapisz do 16 mlodszych bitow
{mov nil, pom2;oey;ewh;}	\\ przesun pom1 do nikad, oey - wystawienie na magistrale danych, ewh - z magistrali zapisz do 16 starszych bitow
{R; mov rr,bus_d;cjp rdm,cp;}	\\ R - odczytaj, mov - rr,bus_d skopiuj z magistrali do rr (r15 tutaj), cjp - skok warunkowy, rdm - sygnal gotowosci pamieci, cp - dopoki pamiec nie wystawi na magistrale wroc do adresu 

\\\\\\\\\\\\\\\\\\\\\\\\\\\

{mov ip,CAC9h;}
{mov pom1, cs;}				\\ z cs kopiuj do pom1
{mov rq, ip;}
{cjs nz, obadrfiz;}	
{mov nil, pom1;oey;ewl;}	\\ przesun pom1 do nikad, oey - wystawienie na magistrale danych, ewl - z magistrali zapisz do 16 mlodszych bitow
{mov nil, pom2;oey;ewh;}	\\ przesun pom1 do nikad, oey - wystawienie na magistrale danych, ewh - z magistrali zapisz do 16 starszych bitow
{add rr,rr,0010h,z;}		\\ dodaj rejestru rr 0010h
{W; mov nil, rr; oey;cjp rdm,cp;}	\\ zapisz do rejestru rr , cjp skok warunkowy jak pamiec poda na magistrale


{end;}

\\ tworzenie podprogramu

obadrfiz					\\ zamiana adresu lgicznego na fizyczny
{load rm, z;}				\\ zerowanie rejestru znacznikow
{xor pom2, pom2, pom2;}		\\ zerowanie pom2

{push nz,3;}				\\ petla 4 razy
{sll pom1;}					\\ przesuniecie w lewo o 1 bit
{sl.25 pom2;}				\\ zgranie z rm do pom2 i przesuniecie 0 1 bit w lewo pom2, wykonaj 4 razy, aby przesun
{rfct;}						\\ koniec petli
{add pom1, pom1, rq,z;load rm,flags;}	\\ dodanie do pom1 pom1 + rq i zapoamietaj q pom1
{add pom2,pom2,z,rm_c;}					\\ 
{crtn nz;}	
{mov pom1, cs;}				\\ z cs kopiuj do pom1
{mov rq, ip;}				\\ koniec podprogramu, nz - zawsze spelniony

\\ bez petli , wpisane 4 razy
\\{sll pom1;}					\\ przesuniecie w lewo o 1 bit
\\{sl.25 pom2;}				\\ zgranie z rm do pom2 i przesuniecie 0 1 bit w lewo pom2
\\{sll pom1;}					\\ przesuniecie w lewo o 1 bit
\\{sl.25 pom2;}				\\ zgranie z rm do pom2 i przesuniecie 0 1 bit w lewo pom2
\\{sll pom1;}					\\ przesuniecie w lewo o 1 bit
\\{sl.25 pom2;}				\\ zgranie z rm do pom2 i przesuniecie 0 1 bit w lewo pom2

{end;} 
\\ zwiekszamy ip o jeden aby odczytac wiekszy lub dolny adres {mov ip, CACB;}