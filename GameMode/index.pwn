
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

#include "core_/_systems_/jobs.pwn"
#include "core_/_systems_/interior.pwn"

#include "core_/_commands_/admin.pwn"
#include "core_/_commands_/player.pwn"

main()
{
	print("*==================================*");
	print("|   Year:        2017              |");
	print("|   Author:      CMatus            |");
	print("|   Game Mode:   Blood Money 0.42  |");
	print("*==================================*");
}

/*================================================================================*/

public OnGameModeInit()
{
    SetGameModeText("Blood Money 0.42");
	SetWeather(0);
	SetWorldTime(17);
	UsePlayerPedAnims();
	EnableStuntBonusForAll(0); 
	DisableInteriorEnterExits();

	SetTimer_("ServerTime", 60_000,45_025, -1);
    
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
		SetPlayerColor(playerid, Player[playerid][Colour]);
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

public OnPlayerText(playerid, text[])
{
	if(!Player[playerid][LoggedIn]){ SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nem��te p�sa� do chatu."); return false; }
	else
	{
		new
			string[129],
			buffer[4],
			targetid,
			i;
		
		strcpy(string, text);
		while(i < 128)
		{
			if(string[i] == 64)
			{
				if(string[i + 1] > 47 && string[i + 1] < 58)
				{
					new j = i + 1;
					while(string[j] > 47 && string[j] < 58) j++;
					strmid(buffer, string, i + 1, j);
					targetid = strval(buffer);

					strdel(string, i, j);
					strins(string, PlayerName(targetid), i);
				}
			}
			i++;
		}
		SendPlayerMessageToAll(playerid, string);
	}
	return false;
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

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(!Player[playerid][LoggedIn]){ SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !"); return false; }
	if(Control[playerid][CMDSpam] > gettime())
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
    Control[playerid][CMDSpam] = gettime()+2;
    return true; 
}  

/*================================================================================*/

forward ServerTime(playerid);
public ServerTime(playerid)
{
	if(Player[playerid][LoggedIn])
	{ 
		++DynServerMins;
	        
		if     (DynServerMins == 60) ++DynServerHour, DynServerMins = 0;
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

forward LoadMoney(playerid);
public LoadMoney(playerid) return SetPlayerMoneys(playerid,Player[playerid][Cash]);

/*================================================================================*/

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{ 
		case D_Login:
        {
            if(!response) return Kick(playerid);
            
            new 
                Hash[250];

            WP_Hash(Hash,sizeof(Hash),inputtext);
            if(!strcmp(Hash,Player[playerid][Password],false))
            {               
                cache_set_active(Player[playerid][Player_Cache]);

                cache_get_value_int  (0, "ID",       Player[playerid][ID]);
                cache_get_value_int  (0, "ADMIN",    Player[playerid][Admin]);
                cache_get_value_int  (0, "KILLS",    Player[playerid][Kills]);
                cache_get_value_int  (0, "DEATHS",   Player[playerid][Deaths]);
                cache_get_value_int  (0, "GTIME",    Player[playerid][GTime]);
                cache_get_value_int  (0, "PMSONG",   Player[playerid][PMSong]);
                cache_get_value_int  (0, "REGISTRED",Player[playerid][Registred]);
                cache_get_value_int  (0, "BANTIME",  Player[playerid][BanTime]);
                cache_get_value_int  (0, "SKIN",     Player[playerid][Skin]);
                cache_get_value_int  (0, "COLOUR",   Player[playerid][Colour]);
                cache_get_value_int  (0, "CASH",     Player[playerid][Cash]);
                cache_get_value_float(0, "HEALTH",   Player[playerid][Healt]);
                cache_get_value_float(0, "ARMOUR",   Player[playerid][Armor]);
                cache_get_value_float(0, "POS_X",    Player[playerid][Pos_X]);
                cache_get_value_float(0, "POS_Y",    Player[playerid][Pos_Y]);
                cache_get_value_float(0, "POS_Z",    Player[playerid][Pos_Z]);
                cache_get_value_float(0, "POS_A",    Player[playerid][Pos_A]);
               
                cache_delete(Player[playerid][Player_Cache]);
                Player[playerid][Player_Cache] = MYSQL_INVALID_CACHE;
 
                Player[playerid][LoggedIn] = 1;
                Control[playerid][GTime]   = gettime();

                ServerTime(playerid);
                SpawnPlayer(playerid);
                SetPlayerTimer_(playerid, "advertising", 300_000, 225_000, -1);
                SetPosition(playerid,Player[playerid][Pos_X],Player[playerid][Pos_Y],Player[playerid][Pos_Z]);
                SetPlayerHealth(playerid, Player[playerid][Healt]);
                SetPlayerArmour(playerid, Player[playerid][Armor]);
                TextDrawShowForPlayer(playerid, TimeTXD);
                StopAudioStreamForPlayer(playerid);

                SetPlayerTimerEx_(playerid, "LoadMoney", 1700, 2000, 1, "i",playerid);
                SendClientMessageToAllf(X11_GREY, "�| SERVER |� Hr�� %s pri�iel na server.",PlayerName(playerid));
            }
            else
            {                   
                Player[playerid][PasswordFails] += 1;
 
                if(Player[playerid][PasswordFails] >= 3) Kick(playerid);
                else
                {
                    new 
                        strings[50];
                    format(strings, sizeof(strings), RED"V�tajte sp� "WHITE"%s",PlayerName(playerid));
                    ShowPlayerDialog(playerid, D_Login, DIALOG_STYLE_PASSWORD, strings, 
                        WHITE"Pravidla:\n"\
                        RED"1. "WHITE"Nem��te pou��va� zv�hod�uj�ce modifik�cie do hry ako sobeit, cleo, parkur mod... .\n"\
                           "    "WHITE"V�nimkov s� m�dy na zmenu grafiky.\n"\
                        RED"2. "WHITE"Nesmiete sa vyd�va� za administr�tora serveru a ani za in� privil�gium na serveri.\n"\
                        RED"3. "WHITE"Vytv�ranie rekl�m na in� server respekt�ve konkurenciu bude pr�sne potrestan�.\n"\
                        RED"4. "WHITE"Server je ur�en� pre vekov� kateg�riu 18+. Za hranie na na�om serveri nezodpoved�me.\n"\
                        RED"5. "WHITE"Ur�anie in�ch hr��ov rasistick�m �i in�m podt�nom sa pr�sne trest�.\n"\
                        RED"6. "WHITE"Je pr�sne zak�zan� vyu��va� chyby serveru. V pr�pade n�jdenia chyby pros�me o nahl�senie cez pr�kaz /bug.\n"\
                        RED"7. "WHITE"Nem��te zneu��va� AFK respekt�ve ESC pred smr�ou.\n"\
                        RED"8. "WHITE"Je zak�zan� spamova� �i floodova� na serveri.\n\n",
                    "prihl�si�", "od�s�");
                    SendClientMessagef(playerid, X11_RED, "�| SERVER |� "WHITE"Zadali ste zl� heslo. Po�et pokusov "RED"%d/3",Player[playerid][PasswordFails]);
                }
            }
        }
        case D_Reg:
        {
            if(!response) return Kick(playerid);
 
            if(strlen(inputtext) <= 5 || strlen(inputtext) > 60)
            {   
                new 
                    string[50];
                format(string, sizeof(string), RED"V�tajte sp� "WHITE"%s",PlayerName(playerid));
                ShowPlayerDialog(playerid, D_Reg, DIALOG_STYLE_PASSWORD, string, 
                    WHITE"Pravidla:\n"\
                    RED"1. "WHITE"Nem��te pou��va� zv�hod�uj�ce modifik�cie do hry ako sobeit, cleo, parkur mod... .\n"\
                       "    "WHITE"V�nimkov s� m�dy na zmenu grafiky.\n"\
                    RED"2. "WHITE"Nesmiete sa vyd�va� za administr�tora serveru a ani za in� privil�gium na serveri.\n"\
                    RED"3. "WHITE"Vytv�ranie rekl�m na in� server respekt�ve konkurenciu bude pr�sne potrestan�.\n"\
                    RED"4. "WHITE"Server je ur�en� pre vekov� kateg�riu 18+. Za hranie na na�om serveri nezodpoved�me.\n"\
                    RED"5. "WHITE"Ur�anie in�ch hr��ov rasistick�m �i in�m podt�nom sa pr�sne trest�.\n"\
                    RED"6. "WHITE"Je pr�sne zak�zan� vyu��va� chyby serveru. V pr�pade n�jdenia chyby pros�me o nahl�senie cez pr�kaz /bug.\n"\
                    RED"7. "WHITE"Nem��te zneu��va� AFK respekt�ve ESC pred smr�ou.\n"\
                    RED"8. "WHITE"Je zak�zan� spamova� �i floodova� na serveri.\n\n"\
                    WHITE"Rozmedzie hesla mus� by� od "RED"5 - 60",
                "prihl�si�", "od�s�");
            }
            else
            {
                new 
                    Hash    [129],
                    DB_Query[500];

                SetPlayerTimer_(playerid, "advertising", 300_000, 225_000, -1);
                WP_Hash(Hash,sizeof(Hash),inputtext);

                mysql_format(Database, DB_Query, sizeof(DB_Query), 
                "INSERT INTO `PLAYERS` (`USERNAME`, `PASSWORD`, `REGISTRED`) VALUES ('%e', '%s', '%d')", PlayerName(playerid), Hash, gettime());
                mysql_tquery(Database, DB_Query, "OnPlayerRegister", "d", playerid);
            }
        }
		case D_Navrh:
		{
			if(!response) return false;
			else if(!strlen(inputtext))       return ShowPlayerDialog(playerid,D_Navrh,DIALOG_STYLE_INPUT,"N�vrh","Pros�m pop�te svoj n�vrh (nep�te iba n�zov dan�ho n�vrhu, pop�te aj jeho funkcionalitu)\n�akujem za pochopenie.","Posla�","Zavrie�");
			else if(strlen(inputtext) >= 128) return ShowPlayerDialog(playerid,D_Navrh,DIALOG_STYLE_INPUT,"N�vrh","Pros�m pop�te svoj n�vrh (nep�te iba n�zov dan�ho n�vrhu, pop�te aj jeho funkcionalitu)\n�akujem za pochopenie.\n\nPrep��te ale prekro�ili ste limit d�ky spr�vy. Maxim�lna d�ka je 128 znakov","Posla�","Zavrie�");
			else if(CheckSql(inputtext) != 0) return ShowPlayerDialog(playerid,D_Navrh,DIALOG_STYLE_INPUT,"N�vrh","Pros�m pop�te svoj n�vrh (nep�te iba n�zov dan�ho n�vrhu, pop�te aj jeho funkcionalitu)\n�akujem za pochopenie.\n\nPrep��te ale n�vrh nem�e obsahova� znak ('). �akujeme za pochopenie","Posla�","Zavrie�");
			
			new 
				query[235];
			mysql_format(Database, query, sizeof query, "INSERT INTO `BUS`(`TIME`, `TYPE`, `USERNAME`, `TEXT`) VALUES ('%d', '%s', '%s', '%s')",gettime(),"NAVRH",PlayerName(playerid),NotDiscreetly(inputtext));
			mysql_tquery(Database, query);
			SendClientMessage(playerid,X11_BLUE,"�| SERVER |� "WHITE"�akujeme za v� n�vrh.");

			Control[playerid][Navrh] = GetPlayerTimer(playerid) + MINUTES(1);
    	}
    	case D_Bug:
		{
			if(!response) return false;
			else if(!strlen(inputtext))       return ShowPlayerDialog(playerid,D_Bug,DIALOG_STYLE_INPUT,"Bug","Pros�m pop�te dan� chybu (nep�te iba n�zov danej chyby, pop�te aj �o ho sp�sobuje)\n�akujem za pochopenie.","Posla�","Zavrie�");
			else if(strlen(inputtext) >= 128) return ShowPlayerDialog(playerid,D_Bug,DIALOG_STYLE_INPUT,"Bug","Pros�m pop�te dan� chybu (nep�te iba n�zov danej chyby, pop�te aj �o ho sp�sobuje)\n�akujem za pochopenie.\n\nPrep��te ale prekro�ili ste limit d�ky spr�vy. Maxim�lna d�ka je 128 znakov","Posla�","Zavrie�");
			else if(CheckSql(inputtext) != 0) return ShowPlayerDialog(playerid,D_Bug,DIALOG_STYLE_INPUT,"Bug","Pros�m pop�te dan� chybu (nep�te iba n�zov danej chyby, pop�te aj �o ho sp�sobuje)\n�akujem za pochopenie.\n\nPrep��te ale n�vrh nem�e obsahova� znak ('). �akujeme za pochopenie","Posla�","Zavrie�");
			
			new 
				query[235];
			mysql_format(Database, query, sizeof query, "INSERT INTO `BUS`(`TIME`, `TYPE`, `USERNAME`, `TEXT`) VALUES ('%d', '%s', '%s', '%s')",gettime(),"BUG",PlayerName(playerid),NotDiscreetly(inputtext));
			mysql_tquery(Database, query);
			SendClientMessage(playerid,X11_BLUE,"�| SERVER |� "WHITE"�akujeme za va�u pomoc.");
			Control[playerid][Bug] = GetPlayerTimer(playerid) + MINUTES(1);
    	}
    	case D_Radio:
    	{
    		switch(listitem)
    		{
    			case 0:
    			{
    				if(!response) return false;
    				ShowPlayerDialog(playerid, D_RadioSelect, DIALOG_STYLE_LIST, "R�dio","Europa 2\nFun R�dio\nOne Retro\nOne Rock\nRockov� Republika\nAnt�na Rock\nR�dio Slovensko\nFun R�dio 80 - 90 r.\nR�dio Expres\nR�dio One","potvrdi�", "zavrie�"),Control[playerid][Radio]= 0;
    			}
    			case 1:
    			{ 
    				if(!response) return false;
    				ShowPlayerDialog(playerid, D_RadioSelect, DIALOG_STYLE_LIST, "R�dio","Europa 2\nFajn R�dio\nRock Zone\nDance\nBlan�k\nHip Hop Vibes\nR�dio Impulz\nCountry\nDepeche Mode\nClubbeat","potvrdi�", "zavrie�"), Control[playerid][Radio] = 1;
    			}
    			case 2: ShowPlayerDialog(playerid, D_Radio, DIALOG_STYLE_LIST, "R�dio - Hudba",BLUE"SK - "WHITE"R�dia\n"BLUE"CZ "WHITE"- R�dia\n"RED"Hudba - Pracuje sa\n"RED"Vypn�� hudbu", "potvrdi�", "zavrie�");
    			case 3: StopAudioStreamForPlayer(playerid);
    		}
    	}
    	case D_RadioSelect:
    	{
    		switch(Control[playerid][Radio])
    		{
    			case 0:
    			{
    				if(!response) ShowPlayerDialog(playerid, D_Radio, DIALOG_STYLE_LIST, "R�dio - Hudba",BLUE"SK - "WHITE"R�dia\n"BLUE"CZ "WHITE"- R�dia\n"RED"Hudba - Pracuje sa\n"RED"Vypn�� hudbu", "potvrdi�", "zavrie�");
    				else
    				{ 
    					switch(listitem)
    					{
    						case 0: PlayAudioStreamForPlayer(playerid, "http://pool.cdn.lagardere.cz/fm-europa2sk-128"); // EU 2 
    						case 1: PlayAudioStreamForPlayer(playerid, "http://stream.funradio.sk:8000/fun128.ogg.m3u"); // Fun Radio
    						case 2: PlayAudioStreamForPlayer(playerid, "http://217.75.92.14:8000/retro.m3u"); // One Retro
    						case 3: PlayAudioStreamForPlayer(playerid, "http://217.75.92.14:8000/rrock.m3u"); // One Rock
    						case 4: PlayAudioStreamForPlayer(playerid, "http://217.67.31.66:8000/republika128.mp3.m3u"); // Rockov� republika
    						case 5: PlayAudioStreamForPlayer(playerid, "http://stream.antenarock.sk/antena-hi.mp3.m3u"); // Ant�na rock
    						case 6: PlayAudioStreamForPlayer(playerid, "http://live.slovakradio.sk:8000/Slovensko_256.mp3.m3u"); // Slovensko
    						case 7: PlayAudioStreamForPlayer(playerid, "http://stream.funradio.sk:8000/80-90-128.mp3.m3u"); // Fun Radio 80. 90 roky
    						case 8: PlayAudioStreamForPlayer(playerid, "http://85.248.7.162:8000/96.mp3"); // Expres
    						case 9: PlayAudioStreamForPlayer(playerid, "http://217.75.92.14:8000/nr160kb.m3u"); // R�dio One
    					}
    				}
    			}
    			case 1:
    			{
    				if(!response) ShowPlayerDialog(playerid, D_Radio, DIALOG_STYLE_LIST, "R�dio - Hudba",BLUE"SK - "WHITE"R�dia\n"BLUE"CZ "WHITE"- R�dia\n"RED"Hudba - Pracuje sa\n"RED"Vypn�� hudbu", "potvrdi�", "zavrie�");
    				else
    				{
    					switch(listitem)
    					{
                			case 0  : PlayAudioStreamForPlayer(playerid,"http://icecast3.play.cz/evropa2-128.mp3.m3u");
                			case 1  : PlayAudioStreamForPlayer(playerid,"http://ice.abradio.cz:8000/fajn128.mp3");
                			case 2  : PlayAudioStreamForPlayer(playerid,"http://icecast5.play.cz/rockzone128.mp3");
                			case 3  : PlayAudioStreamForPlayer(playerid,"http://mp3stream4.abradio.cz:8000/dance128.mp3");
                			case 4  : PlayAudioStreamForPlayer(playerid,"http://ice.abradio.cz/blanikfm128.mp3");
                			case 5  : PlayAudioStreamForPlayer(playerid,"http://mp3stream4.abradio.cz:8000/hiphopvibes128.mp3");
                			case 6  : PlayAudioStreamForPlayer(playerid,"http://www.play.cz/radio/impuls128.mp3.m3u"); // Metalica Nejde
                			case 7  : PlayAudioStreamForPlayer(playerid,"http://mp3stream4.abradio.cz:8000/country128.mp3");
                			case 8  : PlayAudioStreamForPlayer(playerid,"http://mp3stream4.abradio.cz:8000/depeche128.mp3");
                			case 9  : PlayAudioStreamForPlayer(playerid,"http://mp3stream4.abradio.cz:8000/clubbeat128.mp3");
    					}
    				}
    			}
    		}
    	}
    	case D_Help:
    	{
    		switch(listitem)
    		{
    			case 0:
    			{
    				ShowPlayerDialog(playerid, D_HelpSelect, DIALOG_STYLE_TABLIST_HEADERS,BLUE"Tutori�l: "WHITE"Pr�kazy",
    				"Funkcia\tPr�kaz\n"\
    				BLUE"Ulo�ite si d�ta\t"WHITE"/ulozit\n"\
    				BLUE"Podate n�vrh na server\t"WHITE"/navrh\n"\
    				BLUE"N�hl�senie chyby\t"WHITE"/bug\n"\
    				BLUE"Pusti� si hudbu\t"WHITE"/radio\n"\
    				BLUE"Inform�cie a nastavenie ��tu\t"WHITE"/info\n"\
    				BLUE"Sp�chate samovra�du\t"WHITE"/kill\n", 
    				"potvrdi�","zavrie�");
    			}
    		}
    	}
    	case D_Info:
    	{
    		switch(listitem)
    		{
    			case 0:
    			{
    				new 
    				    string  [25], 
    				    string2 [500],
    				    Hodiny, Minuty, Sekundy = GetPlayerTimer(playerid);
				    
    				while(Sekundy >= 3600) Hodiny ++, Sekundy -= 3600;
    				while(Sekundy >= 60)   Minuty ++, Sekundy -=   60;
				    
    				format(string, sizeof(string), "%s",PlayerName(playerid));
    				format(string2,sizeof(string2),
    				    BLUE"��et\n"\
    				    BLUE"Vytvorenie ��tu: "WHITE"%s\n"\
    				    BLUE"Nahran� �as:"WHITE"%d "BLUE"Hod�n "WHITE"%d "BLUE"Min�t "WHITE"%d "BLUE"Sek�nd "WHITE"%d",
    				    StringFromUnix(Player[playerid][Registred] - HOURS(2)), Hodiny,Minuty,Sekundy);
    				ShowPlayerDialog(playerid, D_Default, DIALOG_STYLE_MSGBOX, string, string2, "potvrdi�", "");
    			}
    			case 1: ShowPlayerDialog(playerid, D_InfoSong, DIALOG_STYLE_LIST, BLUE"��et: "WHITE"PM Zvuk", "Wood\nAir Bubble\nBubble\nSpark\nBad Luck\nBird", "potvrdi�", "zavrie�");
    		}
    	}
    	case D_InfoSong:
    	{
    		if(response)
    		{
    			Player[playerid][PMSong] = listitem;
    			PlayAudioStreamForPlayer(playerid, SongSwitch[Player[playerid][PMSong]]);
    			ShowPlayerDialog(playerid, D_InfoSong, DIALOG_STYLE_LIST, BLUE"��et: "WHITE"PM Zvuk", "Wood\nAir Bubble\nBubble\nSpark\nBad Luck\nBird", "potvrdi�", "zavrie�"); 
    			
    		}
    		else
    		{
    			new 
    			    string [32];
    			format(string, sizeof string, BLUE"��et: "WHITE"%s",PlayerName(playerid));
    			ShowPlayerDialog(playerid, D_Info, DIALOG_STYLE_LIST, string, "Inform�cie o ��te\nNastavenie zvuku PM\n"BLUE"Zmena Hesla", "potvrdi�", "zavrie�");
    		}
    	}
	}
    return true;
}

forward advertising(playerid);
public advertising(playerid)
{
	switch(random(3))
	{
		case 0: SendClientMessageToAll(X11_ORANGE_RED, "�| TIP |�"WHITE" M� probl�m sa zorientova�? Po�iadaj o pomoc administr�tora alebo pou�i "ORANGE_RED"/help");
		case 1: SendClientMessageToAll(X11_ORANGE_RED, "�| TIP |�"WHITE" M� nejak� n�pad na zlep�enie? Nap� n�m ho cez pr�kaz "ORANGE_RED"/navrh");
		case 2: SendClientMessageToAll(X11_ORANGE_RED, "�| TIP |�"WHITE" Na�iel si chybu? Upozornite na� pomocou pr�kazu "ORANGE_RED"/bug");
	}
	return true;
}
/*================================================================================*/

/*
{ "San_Francisco_1", -3000, -2999.9998779296875, -1164, 1569, 0xFF0000FF },
{ "San_Francisco_2", -1164, -3000.0084838867188, 142, 504.46649169921875, 0xFF0000FF },
{ "Las_Vegas_1", -2994, 1568.9998779296875, 3000, 2997.9998779296875, 0xFF0000FF },
{ "Las_Vegas_2", -1164, 503, 3000.0001525878906, 1569, 0xFF0000FF },
{ "Los_Angeles", 142, -3000.0001220703125, 2999.9999084472656, 502.9998779296875, 0xFF0000FF },

| 0x00); // Invisible.
| 0x55); // Very Translucent.
| 0xAA); // Less Translucent.
| 0xFF); // Fully opaque.

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

08.07.2017 v0.36
- pr�kazy ( bug, n�vrh, r�dio )
- ozna�enie v chate ( @ )
- Register time save. 
- Debug UnixTime

09.07.2017 v0.40
- Debug Anti Money.
- Map (Pizza LS).
- Add Comands ( Help )

13.07.2017 v
- Debug Radio (Europa 2)
- Add Advertising 
- 

+++++ pm)
- Create Sectiom PM Song.
*/