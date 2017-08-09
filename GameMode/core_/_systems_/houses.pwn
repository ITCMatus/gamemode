
#define FIX_file_inc 0
#define FIXES_Single 1

#include <YSF>         // https://github.com/kurta999/YSF
#include <a_cmd>       // https://github.com/urShadow/Pawn.CMD
#include <a_samp>      // https://github.com/Zeex/pawn
#include <a_fixes>     // https://github.com/Open-GTO/sa-mp-fixes
#include <sscanf2>
#include <a_times>     // https://github.com/udan11/samp-plugin-timerfix
#include <a_mysql>	   // https://github.com/pBlueG/SA-MP-MySQL
#include <a_stream>    // https://github.com/samp-incognito/samp-streamer-plugin

#include "core_/_utils_/defines.pwn"
#include "core_/_utils_/variables.pwn"
#include "core_/_utils_/functions.pwn"

#include "core_/_server_/maps.pwn"
#include "core_/_server_/vehicles.pwn"
#include "core_/_server_/register.pwn"
#include "core_/_server_/textdraw.pwn"
#include "core_/_server_/anti-proxy.pwn"

#include "core_/_systems_/interior.pwn"

#include "core_/_commands_/admin.pwn"
#include "core_/_commands_/player.pwn"

main()
{
	print("*================================*");
	print("|   Year:        2017            |");
	print("|   Author:      CMatus          |");
	print("|   Game Mode:   Retro 0.30      |");
	print("*================================*");
}

/*================================================================================*/

public OnGameModeInit()
{
    SetGameModeText("Retro 0.30");
	SetWeather(36);
	SetWorldTime(17);
	UsePlayerPedAnims();
	EnableStuntBonusForAll(0); 
	DisableInteriorEnterExits();

	SetTimer_("ServerTime", 60000,45025, -1);
    
    return true;
}

/*================================================================================*/
public OnPlayerRequestSpawn(playerid){ return false;}
public OnPlayerSpawn(playerid)
{ 
	if(Player[playerid][LoggedIn])
	{
		SetPosition(playerid,Player[playerid][Pos_X],Player[playerid][Pos_Y],Player[playerid][Pos_Z],Player[playerid][Pos_A]);
		SetPlayerSkin(playerid, Player[playerid][Skin]);
	}
	return true;
}

/*================================================================================*/

public OnPlayerText(playerid, text[])
{
	if(!Player[playerid][LoggedIn]){ SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Pros�m prihl�ste sa na svoj ��et."); return false; }
	else
	{
		new 
			text
		if(strcmp("@%d", "", false))
		{

		}
	}
	return true;
}

/*================================================================================*/

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
		++Player[killerid][Kills]; 
		++Player[playerid][Deaths];
	}
	return true;
}
/*================================================================================*/

public OnPlayerUpdate(playerid)
{
	SetPlayerScore(playerid, GetPlayerMoneys(playerid));
	return true;
}

/*================================================================================*/

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(!Player[playerid][LoggedIn]){ SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !"); return false; }
	if(Control[playerid][CMDSpam] > GetPlayerTimer(playerid))
	{
		SendClientMessage(playerid, X11_RED, "�| SERVER |� "WHITE"M��ete pou�i� jeden pr�kaz za dve sekundy.");
		return false;
	}
	return true;
}

/*================================================================================*/

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags) 
{ 
    if(result == -1){ SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !"); return false; }
    Control[playerid][CMDSpam] = GetPlayerTimer(playerid)+2;
    return true; 
}  

/*================================================================================*/

forward ServerTime(playerid);
public ServerTime(playerid)
{
	if(Player[playerid][LoggedIn])
	{ 
		DynServerMins++;
	        
		if     (DynServerMins == 60) DynServerHour++, DynServerMins = 0;
		else if(DynServerHour == 24) DynServerHour = 0;
		SetPlayerTime(playerid, DynServerHour, DynServerMins);
	
		new 
	    	hour,minute,string[6];	
		gettime              (hour, minute);
		format               (string, sizeof string, "%s%d:%s%d", (hour < 10) ? ("0") : (""), hour, (minute < 10) ? ("0") : (""), minute);
		TextDrawSetString    (TimeTXD, string);
	}
	return true;
}

/*
{ "San_Francisco_1", -3000, -2999.9998779296875, -1164, 1569, 0xFF0000FF },
{ "San_Francisco_2", -1164, -3000.0084838867188, 142, 504.46649169921875, 0xFF0000FF },
{ "Las_Vegas_1", -2994, 1568.9998779296875, 3000, 2997.9998779296875, 0xFF0000FF },
{ "Las_Vegas_2", -1164, 503, 3000.0001525878906, 1569, 0xFF0000FF },
{ "Los_Angeles", 142, -3000.0001220703125, 2999.9999084472656, 502.9998779296875, 0xFF0000FF },
*/

/*
===========================================================================
VIP Standard Gamer: 
- Dostane peniaze do banky + 100 000
- Zlat� karta v banke (Mo�n� dosta� aj bez vip ale �a�ko)
- + 30% k platu
- Akcie na skiny, zbrane... -30% 
- VIP CHAT
- VIP Vozidla  
- Z�kladne Farby + �peci�lna Farba Silver

Cena: 
- SMS 29K� /1� - 30 Dn�
- Bankov� prevod - 0.80�

VIP: ProGamer 
- Dostane peniaze do banky + 220 000
- Platinov� karta v banke (IBA ProGamer)
- + 50% k platu
- Akcie - 45%
- VIP Vozidla
- V�ber farieb + �peci�lna Farba GOLD

Cena: 
- SMS 69K� /2.5� - 60 Dn�
- Bankov� prevod - 2�

===========================================================================

Hr�� zalo�� banku. ale mus� ma� minim�lne 1 000 000 na budovu + 2 000 000 na vklad na ��et a celkovo odohran�ch 200 hod�n.
Hr�� m��e ma� v svojej banke �ubovoln� mno�stvo klientov. 

Z�robok pre bank�ra: 
- invest�ciou zvereneck�ho fondu. Hr�� dostane z fondu 5%.
- Vytunelova� banku +1% z banky - 1%/3% z fondu (Ka�d� hodinu a� pok�m nedojdu rezervy)

Doplnky ku banke: 
- Internet Banking (platba z zvereneck�ho fondu ) nad + 10 000 000 Cena: 100 000
- Ochrana pred vykradnut�m ( 0 - 100 SBS v z�vyslosti na budovu ) Cena: - 1 000 na osobu
- Firewall ( Platba z zvereneck�ho fondu ) - 500 000 ( Hackersk� pravdepodobnos� sa zn�i o 80% )
- lep�ia budova ( Platba z zvereneck�ho fondu ) Nad +10 000 000 Cena: 2 000 000

===========================================================================

30.06.2017 v0.0.4
- Pridan� Anti Proxy. 
- Preroben� registr�cia.
- Pridan� Dizajnov� menu pri registr�ci�. 
- Pridan� hudba v logine.

01.07.2017 v0.0.9
- Oprava Registra 
- Pridan� /info
- anti cmd spam
- pridane vozidla po mape
- Pr�kazy

02.07.2017 v0.1.3
- Mapy
- Nastavenie servera
- Pridan� �as TD
- Dynamick� �as

04.07.2017 v0.15
- Debug
- Interiors

05.07.2017 v0.30
- Admin Pr�kazy ( Ban, setlvl, admins, gw, allunlock, get, kick, playsound, disarm, goto, hp, spam, cas, pocasie)
- Anti Money.
*/