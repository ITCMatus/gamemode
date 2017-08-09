stock SetPosition(playerid,Float:x, Float:y, Float:z,Float:ang = 0.0, worldid = 0, interiorid = 0)
{
	SetPlayerPos(playerid, x, y, z);
	SetPlayerInterior(playerid, interiorid);
	SetPlayerFacingAngle(playerid, ang);
	SetPlayerVirtualWorld(playerid, worldid);
	return true;
}

stock GetPlayerTimer(playerid)
{
	if(Control[playerid][GTime] == 0) return Player[playerid][GTime];
	return Player[playerid][GTime]+(gettime()-Control[playerid][GTime]);
}

stock CheckSql(text[])
{
    if(strfind(text, "'", true) != -1) return 1;
	else return 0;
}

stock NotDiscreetly(txt[])
{
	new 
		string[128];
	format(string,sizeof(string),"%s",txt);
	for(new i;i<MAX_SIGN;i++)
	{
	    new znak2;
	    loop_diakritika:
		new PoradiZnaku = strfind(string,Sign[i][0],false,znak2);
		if(PoradiZnaku != -1)
		{
			znak2 = PoradiZnaku;
			strdel(string,PoradiZnaku,PoradiZnaku+1);
			strins(string,Sign[i][1],PoradiZnaku);
	    	goto loop_diakritika;
		}
	}
	return string;
}

stock StringFromUnix(unixtime,styl=2)
{
    new string[35], year, day, month, hour, mins,
		names_of_month[12][] = {"Leden/Január","Únor/Február","Bøezen/Marec","Duben/Apríl","Kvìten/Máj","Èerven/Jún","Èervenec/Júl","Srpen/August","Záøí/September","Øíjen/Október","Listopad/November","Prosinec/December"};
	UnixTimeToTime(unixtime,year,day,month,hour,mins);
    switch(styl)
	{
        case 1: format(string,sizeof(string),"%02d/%02d %02d:%02d",day+1,month+1,hour,mins);
        case 2: format(string,sizeof(string),"%d. %s %d, %02d:%02d",day+1,names_of_month[month],year,hour,mins);
        case 3: format(string,sizeof(string),"%02d/%02d/%d %02d:%02d",day+1,month+1,year,hour,mins);
        case 4: format(string,sizeof(string),"%02d.%02d.%d %02d:%02d",day+1,month+1,year,hour,mins);
        case 5: format(string,sizeof(string),"%02d:%02d",hour,mins);
        default: format(string,sizeof(string),"%d.%d.%d",day+1,month+1,year);
	}
    return string;
}

stock UnixTimeToTime(unixtime,&year,&day,&month,&hour,&mins)
{
	new PrestupnyRok, ZacatekLetnihoCasu, ZacatekZimnihoCasu,
		days_of_month[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
	year = 1970;
	unixtime += HOURS(1);   //èasové pásmo +1
    loop_prestupny_rok:
    if(((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) PrestupnyRok = 0;
    else PrestupnyRok = DAYS(1);
    while(unixtime>=31622400-PrestupnyRok)
	{
        unixtime -= (31622400-PrestupnyRok), year++;
        goto loop_prestupny_rok;
    }
    if(PrestupnyRok == 0) days_of_month[1] = 29;
    else days_of_month[1] = 28;
	for(new utl;utl<3;utl++) ZacatekLetnihoCasu += days_of_month[utl];
	for(new utz;utz<10;utz++) ZacatekZimnihoCasu += days_of_month[utz];
	PrestupnyRok = DayWithWeek(year,ZacatekLetnihoCasu)+1;
	if(PrestupnyRok != 7) ZacatekLetnihoCasu -= PrestupnyRok;
	PrestupnyRok = DayWithWeek(year,ZacatekZimnihoCasu)+1;
	if(PrestupnyRok != 7) ZacatekZimnihoCasu -= PrestupnyRok;
	ZacatekLetnihoCasu = (ZacatekLetnihoCasu-1)*DAYS(1)+HOURS(2);
	ZacatekZimnihoCasu = (ZacatekZimnihoCasu-1)*DAYS(1)+HOURS(2);
	if(unixtime >= ZacatekLetnihoCasu && unixtime < ZacatekZimnihoCasu) unixtime += HOURS(1);   //letní èas
	while(unixtime>=DAYS(1))
	{
        unixtime -= DAYS(1), day++;
        if(day == days_of_month[month]) day=0, month++;
    }
    while(unixtime>=MINUTES(1))
	{
        unixtime -= MINUTES(1), mins++;
        if(mins == 60) mins=0, hour++;
    }
}

stock DayWithWeek(year,day)
{
	day -= 331;
	for(new y=2012;y<year;y++)
	{
		if(((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0)) day += 366;
		else day += 365;
	}
	return day % 7;
}

stock GivePlayerMoneys(playerid,money)
{
	Player[playerid][Cash] += money;
	return GivePlayerMoney(playerid, money);
}

stock GetPlayerMoneys(playerid)
{
	if(GetPlayerMoney(playerid) > Player[playerid][Cash])
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney (playerid, Player[playerid][Cash]);
	}
	return Player[playerid][Cash];
}

stock SetPlayerMoneys(playerid,money) return GivePlayerMoney(playerid, Player[playerid][Cash] = money);

stock AdminNameLevel(playerid)
{
	new 
		string[10];
	
	switch(Player[playerid][Admin])
	{
		case 1: string = "Admin";
		case 2: string = "Moderátor";
		case 3: string = "Správca";
		case 4: string = "Hl. Admin";
		case 5: string = "Majite¾";
	}
	return string;
}

stock SpawnVehicle(playerid,id)
{
	new 
		Float:x,Float:y,Float:z,Float:rotation;
	switch(Control[playerid][Vehicle])
	{
		case 0:
		{
			if(IsPlayerInAnyVehicle(playerid)) DestroyVehicle(GetPlayerVehicleID(playerid));
			
			GetPlayerPos         (playerid, x,y,z);
			GetPlayerFacingAngle (playerid, rotation);
			GetPlayerVirtualWorld(playerid);
	
			Control[playerid][Vehicle] = 1;
			CVehicle  [playerid] = CreateVehicle(id,x,y,z+1.0,rotation, X11_WHITE, X11_DARK_GREEN,-1,0);
			PutPlayerInVehicle(playerid, CVehicle[playerid], 0);
		}
		case 1:
		{
			if(IsPlayerInAnyVehicle(playerid)) DestroyVehicle(GetPlayerVehicleID(playerid));
			
			GetPlayerPos         (playerid, x,y,z);
			DestroyVehicle       (CVehicle[playerid]);
			GetPlayerFacingAngle (playerid, rotation);
			GetPlayerVirtualWorld(playerid);
	
			CVehicle[playerid] = CreateVehicle(id,x,y,z+1.0,rotation, X11_WHITE, X11_DARK_GREEN,-1,0);
			PutPlayerInVehicle(playerid, CVehicle[playerid], 0);
		}
	}
	return true;
}
stock Randoms(max, min = 0)
{
	new 
		calculation = random(max) - random(max) * 2 - 10;
	if(calculation > max) calculation * 2 - 5;
	return calculation;
}