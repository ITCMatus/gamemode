COMMAND:admins(playerid,params[])
{
	new 
		string[600], OnlineAdmin;
	
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(Player[i][Admin] > 0 || IsPlayerAdmin(i))
		{
			format(string,sizeof(string),"%s"BLUE"%s\t"WHITE"\t%s",string,PlayerName(i),AdminNameLevel(i));
			if(IsPlayerAdmin(i)) strcat(string,"+ RCON");
	   		strcat(string,"\n");
			OnlineAdmin = true;
		}
	}
 	if(!OnlineAdmin) SendClientMessage(playerid, X11_BLUE,"�| SERVER |� "WHITE"Na serveri sa nenach�dza administr�tor!");
	ShowPlayerDialog(playerid,D_Default,DIALOG_STYLE_TABLIST,"Online administr�tori",string,"potvrdi�","");
 	return true;
}
COMMAND:spec(playerid, params[])
{ 
	/*
		Spectated player
	*/
	return true;
}
COMMAND:dann(playerid, params[])
{
	/*
		Tide on lower left text draw
	*/
	return true;
}
COMMAND:ann(playerid, params[])
{
	/*
		Tide on center text draw
	*/
	return true;
}
COMMAND:getinfo(playerid, params[])
{
	/*
		Get player information
	*/
	return true;
}
COMMAND:warps(playerid, params[])
{
	/*
		On/Off Warps
	*/
	return true;
}
COMMAND:pocasie(playerid, params[])
{
	new 
		weather = strval(params);
	if(Player[playerid][Admin] < 1)      return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(isnull(params))              return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Pros�m pou�ite: "RED"/pocasie [ 0 - 53, 2009 ]"WHITE".");
	else if(weather < 0 || weather > 53) return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Prep��te ale rozmedzie je od "RED"[ 0 - 53 ]"WHITE".");
	
	SetPlayerWeather(playerid, weather);
	SendClientMessageToAll(X11_RED, "�| AT |� "WHITE"Administrator zmenil po�asie!");
	return true;
}
COMMAND:cas(playerid, params[])
{
	new 
		hour,minute;
	if(Player[playerid][Admin] < 1)           return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(sscanf(params,"dd",hour,minute))  return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Pros�m pou�ite: "RED"/cas [ 0 - 24] [ 0 - 60 ]"WHITE".");
	else if(hour < 0 || hour > 24)	          return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Prep��te ale rozmedzie hod�n je od "RED"[ 0 - 24]"WHITE".");
	else if(minute < 0 || minute > 60)        return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Prep��te ale rozmedzie min�t je od "RED"[ 0 - 60]"WHITE".");
	else
	{
		SetPlayerTime(playerid, hour, minute);
		SendClientMessagef(playerid, X11_RED, "�| AT |� "WHITE"Administr�tor zmenil �as na "RED"%d"WHITE":"RED"%d",hour,minute);
	}
	return true;
}
COMMAND:spam(playerid, params[])
{
	if(Player[playerid][Admin] < 1) return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	for(new i = 0; i <= 50;i++) SendClientMessageToAll(X11_RED, " ");
	SendClientMessageToAll(X11_RED,"�| AT |� "WHITE"Administr�tor zmazal chat!");
	return true;
}
COMMAND:hp(playerid, params[])
{
	new 
		Float:health, id;
	if(Player[playerid][Admin] < 1)         return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(sscanf(params, "df",id,health)) return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Pros�m pou�ite: "RED"/hp [ 0.0 - 100.0 ]");
	else if(health < 0.0 || health > 100.0) return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te ale rozmedzie je od "RED"[ 0.0 - 100.0 ]");
	else if(id == INVALID_PLAYER_ID)        return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te zadan� "RED"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
	else
	{
		SetPlayerHealth(id, health);
		SendClientMessage(id, X11_RED, "�| AT |� "WHITE"Administr�tor v�m doplnil �ivot!");
	}
	return true;
}
COMMAND:jail(playerid, params[])
{
	/*
		Player kick to prison on static time
	*/
	return false;
}
COMMAND:mute(playerid, params[])
{
	/*
		Player don't tide on chat
	*/
	return false;
}
COMMAND:goto(playerid, params[])
{
	new 
		id = strval(params);

	if(Player[playerid][Admin] < 1)   return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");   
	else if(isnull(params))           return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Pros�m pou�ite: "RED"/goto [ ID ]");
	else if(!(IsPlayerConnected(id))) return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Prep��te zadan� "RED"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
	
	new 
		Float:X,Float:Y,Float:Z;
	
	GetPlayerPos(id, X,Y,Z);
	SetPlayerPos(playerid, X+2.0,Y,Z);
	return true;
}
COMMAND:freeze(playerid, params[])
{
	/*
		Freeze player
	*/
	return false;
}

COMMAND:disarm(playerid, params[])
{
	new 
		id = strval(params);
	if(Player[playerid][Admin] < 1) return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(isnull(params))         return SendClientMessage(playerid, X11_RED,"�| AT |� "WHITE"Pros�m zadajte "RED"/disarm [ ID ]");
	else if(!IsPlayerConnected(id)) return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te zadan� "RED"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
	ResetPlayerWeapons(id);
	return true;
}
COMMAND:playsound(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Pros�m zadajte "RED"/playaudio [ LINK ]"WHITE".");
	PlayAudioStreamForPlayer(playerid, params);
	return true;
}
COMMAND:kick(playerid, params[])
{
	new 
		id, text[24];
	if(Player[playerid][Admin] < 1)             return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(sscanf(params, "rS()[24]",id,text)) return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Pros�m zadajte "RED"/kick [ ID ] [ DOVOD ]"WHITE".");
	else if(id == INVALID_PLAYER_ID)            return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te zadan� "RED"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
	else if(Player[id][Admin] >= playerid)      return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te ale nem��te vyhodi� administr�tora! ");
	else
	{
		if(!strlen(text)) SendClientMessageToAllf(X11_RED,"�| AT |� "WHITE"Administr�tor "RED"[ %s ]"WHITE" vyhodil hr��a "RED"[ %s ]",PlayerName(playerid),PlayerName(id));
		else
		{
			if(strlen(text) < 3 || strlen(text) > 23) return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te ale rozmedzie slov je "RED"[ 3 - 23 ]");
			SendClientMessageToAllf(X11_RED,"�| AT |� "WHITE"Administr�tor "RED"[ %s ]"WHITE" vyhodil hr��a "RED"[ %s ]"WHITE" d�vod "RED"[ %s ]",PlayerName(playerid),PlayerName(id),text);
		}
		Kick(id);
	}
	return true;
}
COMMAND:get(playerid, params[])
{
	new 
		id = strval(params);
	if(Player[playerid][Admin] < 1)   return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(isnull(params))           return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Pros�m pou�ite: "RED"/get [ ID ]"WHITE".");
	else if(!(IsPlayerConnected(id))) return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Prep��te zadan� "RED"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
	
	new 
		Float:X,Float:Y,Float:Z;
		
	GetPlayerPos(playerid, X,Y,Z);
	SetPlayerPos(id, X+2.0,Y,Z+1.0);
	return true;
}
COMMAND:allunlock(playerid, params[])
{
	if(Player[playerid][Admin] < 2) return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	for(new j=0; j<MAX_VEHICLES; j++) for(new i = 0; i < MAX_PLAYERS; i++) SetVehicleParamsForPlayer(i, j, 0, 0);
	SendClientMessageToAll(X11_RED, "�| AT |� "WHITE"Administr�tor odomkol v�etky vozidl�!");
	return true;
}
COMMAND:gw(playerid, params[])
{
	new 
		id,zbran,naboje;

	if(Player[playerid][Admin] < 1)                               return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(sscanf(params, "rdd", id, zbran, naboje))             return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Pros�m pou�ite: "RED"/GW [ ID ] [ ZBRA� ] [ MUN�CIA ]");
	else if(id == INVALID_PLAYER_ID)                              return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Prep��te zadan� "RED"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
	else if(zbran < 1 || zbran > 18 && zbran < 22 || zbran > 46 ) return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Prep��te ale v�ber zbran� je v rozmedz�: [ 0-18 ] alebo [ 22-46 ]");
	else if(naboje < 1 || naboje > 9999)                          return SendClientMessage(playerid, X11_RED , "�| AT |� "WHITE"Prep��te ale v�ber mun�cie je v rozmedz�: [ 1 - 9999 ]");
	else
	{
		new 
			string[32];
		GetWeaponName(zbran, string, sizeof(string));
		GivePlayerWeapon(id, zbran, naboje);
		SendClientMessagef(id, X11_RED, "�| AT |� "WHITE"Administrator v�m dal zbra� "RED"[ %s ] "WHITE"mun�cia "RED"[ %d ]", string, naboje);
	}
	return true;
}

COMMAND:gm(playerid, params[])
{
	new 
		id,money;
	if(Player[playerid][Admin] < 4)        return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(sscanf(params, "rd",id,money)) return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Pros�m zadajte "RED"/gm [ ID ] [ �IASTKA ]"WHITE".");
	else if(money < 1 || money > 1000000)  return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te ale rozmedzie je "RED"[ 1 - 1 000 000 ]");
	//else if(id == playerid)                return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te ale nem��te posla� peniaze s�m sebe!");
	else if(id == INVALID_PLAYER_ID)       return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te zadan� "RED"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
	else
	{
		GivePlayerMoney(id, money);
		SendClientMessagef(id,       X11_RED,"�| AT |� "WHITE"Administr�tor "RED"[ %s ] "WHITE"v�m dal "RED"[ %d ]",PlayerName(playerid),money);
		SendClientMessagef(playerid, X11_RED,"�| AT |� "WHITE"Administr�tor "RED"[ %s ] "WHITE"v�m dal "RED"[ %d ]",PlayerName(id),money);
	}
	return true;
}

COMMAND:car(playerid, params[])
{
	new 
		string[20],number; 
	if(isnull(params))  SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Pros�m pou�ite "BLUE"[ 400 -600 | MENO ]"); 
	else if(!sscanf(params, "i",number))
	{ 
		if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Prep��te ale nem��te si spawn�� vozidlo v dome!");
	
		SpawnVehicle(playerid,number);
	}
	else if(!sscanf(params, "s[20]",string))
	{
		if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Prep��te ale nem��te si spawn�� vozidlo v dome!");
		
		SpawnVehicle(playerid,VehName(params));
	}
	return true;
}
COMMAND:ban(playerid, params[])
{
	new 
		id, cas, text[6];
	if(Player[playerid][Admin] < 3)               return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(sscanf(params, "rdS[6]",id,cas,text)) return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Pros�m zadajte "RED"/ban [ ID ] [ CAS ] [ DNI | HODIN | MINUT ]"WHITE".");
	else if(id == INVALID_PLAYER_ID)              return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te zadan� "RED"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
	else if(Player[id][Admin] >= playerid)        return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te ale nem��te zabanova� administr�tora! ");
	else
	{	
		if(strlen(text) > 0)
		{
			if(!strcmp(text,"dni",false))       {Player[playerid][BanTime] = DAYS   (cas)+gettime(); Kick(id);}   
			else if(!strcmp(text,"hodin",false)){Player[playerid][BanTime] = HOURS  (cas)+gettime(); Kick(id);}  
			else if(!strcmp(text,"minut",false)){Player[playerid][BanTime] = MINUTES(cas)+gettime(); Kick(id);}
			else return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Pros�m zadajte "RED"/ban [ ID ] [ CAS ] [ HODIN | MINUT | DNI ]"WHITE".");
		}
		else BanEx(id, "Perma Ban");
		SendClientMessageToAllf(X11_RED,"�| AT |� "WHITE"Administr�tor "RED"[ %s ]"WHITE" zabanoval hr��a "RED"[ %s ]",PlayerName(playerid),PlayerName(id));
	}
	return true;
}

COMMAND:setlvl(playerid,params[])
{
	new 
		id,lvl;

	if(strcmp("CMatus", PlayerName(playerid))|| Player[playerid][Admin] < 4) return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(sscanf(params,"rd",id,lvl)) return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Pros�m zadajte "RED"/setlvl [ ID ] [ LVL ]"WHITE".");
	else if(lvl < 0 || lvl > 5)         return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te ale rozmedzie je "RED"[ 0 - 5 ]");
	else if(id == INVALID_PLAYER_ID)    return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te zadan� "RED"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
	else
	{
		Player[id][Admin] = lvl;
		SendClientMessagef(id      , X11_RED, "�| AT |� "WHITE"Administr�tor "RED"[ %s ]"WHITE" v�m dal admin level "RED"[ %s ]",PlayerName(playerid),AdminNameLevel(id));
		SendClientMessagef(playerid, X11_RED, "�| AT |� "WHITE"Dali ste "RED"[ %s ]"WHITE" admin level "RED"[ %s ]",PlayerName(id),AdminNameLevel(id));
	}
	return true;
}

COMMAND:crash(playerid,params[])
{
	new 
		id = strval(params);
	if(Player[playerid][Admin] < 5)                                               return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help"WHITE" !");
	else if(strcmp("CMatus", PlayerName(playerid))|| Player[playerid][Admin] < 4) return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Nezn�my pr�kaz. Pros�m pou�ite "BLUE"/help");    
	else if(isnull(params))                                                       return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Pros�m zadajte "RED"/crash [ ID ]"WHITE".");
   	else if (id == INVALID_PLAYER_ID)                                             return SendClientMessage(playerid, X11_RED, "�| AT |� "WHITE"Prep��te zadan� "RED"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
	
   	GameTextForPlayer(playerid, "~k~~INVALID_KEY~", 100, 4);
	return true;
}

stock VehName(VehName[])
{
    for(new i = 0; i < 211; i++) if(strfind(VehicleNames[i], VehName, true) != -1) return i + 400;
    return -1;
}