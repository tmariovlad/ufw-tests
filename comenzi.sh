#############################
#SETARI INITIALE
sudo csf -x #dezactivare csf
sudo ufw disable #in caz ca nu e deja dezactivat
sudo ufw reset #sterge toate regulile precendente care poate sunt gresite
sudo ufw allow ssh #inainte sa-l pornim trebuie sa permitem conexiunile ssh (ca sa nu ramanem fara acces ssh)
sudo ufw enable #sa-l activam ca sa il putem testa
sudo ufw status verbose #sa testam daca e activ si doar ssh este permis
	#Status: active
	#Logging: on (low)
	#Default: deny (incoming), allow (outgoing), disabled (routed)
	#New profiles: skip
	#
	#To                         Action      From
	#--                         ------      ----
	#22                         ALLOW IN    Anywhere
	#22 (v6)                    ALLOW IN    Anywhere (v6)


#############################
#BLOCARE IP LA OUTPUT (sa nu putem trimite pachete catre el)
ping 8.8.8.8 #verificam daca deocamdata functioneaza ping-ul
sudo ufw deny out from any to 8.8.8.8 # blocam orice pachet care iese din oricare IP al VPS-ului nostru catre IP-ul 8.8.8.8
##Comanda precedenta e identica cu:
##sudo ufw deny out to 8.8.8.8
ping 8.8.8.8 #verificam daca deocamdata nu mai functioneaza ping-ul
## Ar trebui sa afiseze 'Operation not permitted' daca e blocat la output



#############################
#STERGERE REGULA
sudo ufw status numbered #afisam toate regulile cu id-ul fiecareia
	#Status: active
	#
	#     To                         Action      From
	#     --                         ------      ----
	#[ 1] 22                         ALLOW IN    Anywhere
	#[ 2] 8.8.8.8                    DENY OUT    Anywhere                   (out)
	#[ 3] 22 (v6)                    ALLOW IN    Anywhere (v6)
sudo ufw delete 2 # stergem regula 2 care blocheaza ip-ul 8.8.8.8
sudo ufw status numbered #verificam daca s-a sters
	#Status: active
	#
	#     To                         Action      From
	#     --                         ------      ----
	#[ 1] 22                         ALLOW IN    Anywhere
	#[ 2] 22 (v6)                    ALLOW IN    Anywhere (v6)
	
	
	
#############################
#BLOCARE IP LA INPUT (sa nu putem primi pachete de la el)
 
## Pe site-ul http://www.adminkit.net/telnet.aspx putem sa vedem daca se pot face conexiuni catre portul vps-ului de ssh
## Enter Host name or IP address-> IP-ul masinii (ip a | grep global)
## Port number -> 22 (portul ssh folosit la vps)
## cand nu e blocat apare 'Connection Status : Connection to [ip/host] on port [port] was successfull'

sudo ufw insert 1 deny from 5.189.132.0/24 to any # blocam orice pachet care intra in oricare IP al VPS-ului nostru de la clasa de IP folosita de adminkit.net 5.189.132.0/24 (5.189.132.0 -> 5.189.132.255  ) in format CIDR (http://www.ipaddressguide.com/cidr)
## am adaugat 'insert 1' pentru ca vrem sa fie adaugata regula 'mai sus' de regula care permite conexiunile ssh (ufw allow ssh), daca nu faceam asta era selectata regula care permite conexiuni ssh (pentru ca era prima) si nu mai testa restul regulilor
## Testam din nou pe site-ul http://www.adminkit.net/telnet.aspx
## Ar trebui sa afiseze 'Connection Status : Connection Failed ' daca e blocat site-ul la input

##REVENIRE LA SETARI INITIALE 
sudo ufw disable #in caz ca nu e deja dezactivat
sudo ufw reset #sterge toate regulile precendente care poate sunt gresite
sudo csf -e #reactivare csf
