COMMAND:info(playerid,params[])
{ 
    new 
        string [32];
    format(string, sizeof string, BLUE"Úèet: "WHITE"%s",PlayerName(playerid));
    ShowPlayerDialog(playerid, D_Info, DIALOG_STYLE_LIST, string, "Informácie o úète\nNastavenie zvuku PM\n"BLUE"Zmena Hesla", "potvrdi", "zavrie");
    return true;
}

COMMAND:radio(playerid, params[])
{
    ShowPlayerDialog(playerid, D_Radio, DIALOG_STYLE_LIST, "Rádio - Hudba",BLUE"SK - "WHITE"Rádia\n"BLUE"CZ "WHITE"- Rádia\n"RED"Hudba - Pracuje sa\n"RED"Vypnú hudbu", "potvrdi", "zavrie");
    return true;
}

COMMAND:kill(playerid, params[])
{
    SetPlayerHealth(playerid, 0.00);   
    return true;
}
COMMAND:ulozit(playerid, params[])
{
    SendClientMessage(playerid, X11_BLUE, "«| SERVER |» "WHITE"Vaše dáta sa ukladajú ...");
    SavePlayerData(playerid);
    SendClientMessage(playerid, X11_BLUE, "«| SERVER |» "WHITE"Vaše dáta boli úspešne uloené");
    return true;
}
COMMAND:navrh(playerid, params[])
{
    if(Control[playerid][Navrh] > GetPlayerTimer(playerid)) return SendClientMessage(playerid, X11_RED, "«| SERVER |» "WHITE"Prepáète ale návrh môete posla a o minútu.");
    ShowPlayerDialog(playerid,D_Navrh,DIALOG_STYLE_INPUT,"Návrh","Prosím popíšte svoj návrh (nepíšte iba názov daného návrhu, popíšte aj jeho funkcionalitu)\nÏakujem za pochopenie.","Posla","Zavrie");
    return true;
}
COMMAND:bug(playerid, params[])
{
    if(Control[playerid][Bug] > GetPlayerTimer(playerid)) return SendClientMessage(playerid, X11_RED, "«| SERVER |» "WHITE"Prepáète ale návrh môete posla a o minútu.");
    ShowPlayerDialog(playerid,D_Bug,DIALOG_STYLE_INPUT,"Bug","Prosím popíšte danú chybu (nepíšte iba názov danej chyby, popíšte aj èo ho spôsobuje)\nÏakujem za pochopenie.","Posla","Zavrie");
    return true;
}
COMMAND:help(playerid,params[])
{
    ShowPlayerDialog(playerid, D_Help, DIALOG_STYLE_LIST, BLUE"Tutoriál", "Príkazy", "potvrdi", "zavrie");
    return true;
}

COMMAND:pm(playerid,params[])
{
    new 
        id, text[128];
    if(sscanf(params, "ds[128]",id,text)) return SendClientMessage(playerid, X11_BLUE, "«| SERVER |» "WHITE"Prosím pouite: "BLUE"/pm [ ID ] [ TEXT ].");
    else if(id == playerid)               return SendClientMessage(playerid, X11_BLUE, "«| SERVER |» "WHITE"Prepáète ale nemôte správu sám sebe!");
    else if(id == INVALID_PLAYER_ID)      return SendClientMessage(playerid, X11_BLUE, "«| SERVER |» "WHITE"Prepáète zadané "BLUE"[ ID ]"WHITE" hráèa sa nenachádza na serveri.");
    else
    {
        PlayAudioStreamForPlayer(id,SongSwitch[Player[playerid][PMSong]]);
        SendClientMessagef(id, X11_GOLD, "[PM] %s: %s",PlayerName(playerid),text);
    }
    return true;
}