COMMAND:info(playerid,params[])
{ 
    new 
        string [32];
    format(string, sizeof string, BLUE"��et: "WHITE"%s",PlayerName(playerid));
    ShowPlayerDialog(playerid, D_Info, DIALOG_STYLE_LIST, string, "Inform�cie o ��te\nNastavenie zvuku PM\n"BLUE"Zmena Hesla", "potvrdi�", "zavrie�");
    return true;
}

COMMAND:radio(playerid, params[])
{
    ShowPlayerDialog(playerid, D_Radio, DIALOG_STYLE_LIST, "R�dio - Hudba",BLUE"SK - "WHITE"R�dia\n"BLUE"CZ "WHITE"- R�dia\n"RED"Hudba - Pracuje sa\n"RED"Vypn�� hudbu", "potvrdi�", "zavrie�");
    return true;
}

COMMAND:kill(playerid, params[])
{
    SetPlayerHealth(playerid, 0.00);   
    return true;
}
COMMAND:ulozit(playerid, params[])
{
    SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Va�e d�ta sa ukladaj� ...");
    SavePlayerData(playerid);
    SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Va�e d�ta boli �spe�ne ulo�en�");
    return true;
}
COMMAND:navrh(playerid, params[])
{
    if(Control[playerid][Navrh] > GetPlayerTimer(playerid)) return SendClientMessage(playerid, X11_RED, "�| SERVER |� "WHITE"Prep��te ale n�vrh m��ete posla� a� o min�tu.");
    ShowPlayerDialog(playerid,D_Navrh,DIALOG_STYLE_INPUT,"N�vrh","Pros�m pop�te svoj n�vrh (nep�te iba n�zov dan�ho n�vrhu, pop�te aj jeho funkcionalitu)\n�akujem za pochopenie.","Posla�","Zavrie�");
    return true;
}
COMMAND:bug(playerid, params[])
{
    if(Control[playerid][Bug] > GetPlayerTimer(playerid)) return SendClientMessage(playerid, X11_RED, "�| SERVER |� "WHITE"Prep��te ale n�vrh m��ete posla� a� o min�tu.");
    ShowPlayerDialog(playerid,D_Bug,DIALOG_STYLE_INPUT,"Bug","Pros�m pop�te dan� chybu (nep�te iba n�zov danej chyby, pop�te aj �o ho sp�sobuje)\n�akujem za pochopenie.","Posla�","Zavrie�");
    return true;
}
COMMAND:help(playerid,params[])
{
    ShowPlayerDialog(playerid, D_Help, DIALOG_STYLE_LIST, BLUE"Tutori�l", "Pr�kazy", "potvrdi�", "zavrie�");
    return true;
}

COMMAND:pm(playerid,params[])
{
    new 
        id, text[128];
    if(sscanf(params, "ds[128]",id,text)) return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Pros�m pou�ite: "BLUE"/pm [ ID ] [ TEXT ].");
    else if(id == playerid)               return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Prep��te ale nem��te spr�vu s�m sebe!");
    else if(id == INVALID_PLAYER_ID)      return SendClientMessage(playerid, X11_BLUE, "�| SERVER |� "WHITE"Prep��te zadan� "BLUE"[ ID ]"WHITE" hr��a sa nenach�dza na serveri.");
    else
    {
        PlayAudioStreamForPlayer(id,SongSwitch[Player[playerid][PMSong]]);
        SendClientMessagef(id, X11_GOLD, "[PM] %s: %s",PlayerName(playerid),text);
    }
    return true;
}