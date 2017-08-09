public OnGameModeInit()
{
    new 
    	MySQLOpt:option_id = mysql_init_options();

    mysql_set_option(option_id, AUTO_RECONNECT, true); 
 
    Database = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATABASE, option_id); 
 
    if(Database == MYSQL_INVALID_HANDLE || mysql_errno(Database) != 0) 
    {
        print("| System | - M�d sa nem��e pripoji� na vzdialen� datab�zu. Pros�m kontaktujte v�ho spr�vcu."); 
        SendRconCommand("exit"); 
        return true;
    }
 	else print("| System | - �spe�ne pripojenie na vzdialen� datab�zu."); 
     
    #if defined Register_OnGameModeInit
        Register_OnGameModeInit();
    #endif
    return 1;
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Register_OnGameModeInit
#if defined Register_OnGameModeInit
    forward Register_OnGameModeInit();
#endif

/*================================================================================*/

public OnGameModeExit()
{
    for(new i = 0, j = GetPlayerPoolSize(); i < j; i++)
    {
        if(IsPlayerConnected(i))
        {
            OnPlayerDisconnect(i, 1);
        }    
    }
    mysql_close(Database); 
    #if defined Register_OnGameModeExit
        Register_OnGameModeExit();
    #endif
    return 1;
}
#if defined _ALS_OnGameModeExit
    #undef OnGameModeExit
#else
    #define _ALS_OnGameModeExit
#endif
#define OnGameModeExit Register_OnGameModeExit
#if defined Register_OnGameModeExit
    forward Register_OnGameModeExit();
#endif

/*================================================================================*/

public OnPlayerConnect(playerid)
{
    new 
    	DB_Query[200],
        CleanPlayer[PlayerData],CleanControl[ControlPlayerData];

    Player [playerid] = CleanPlayer;
    Control[playerid] = CleanControl;

    Control[playerid][Corrupt_Check]++;  

    SetPlayerTimerEx_(playerid, "LoggedMap", 1700, 2000, 1, "i",playerid);
  
    mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT * FROM `PLAYERS` WHERE `USERNAME` = '%e' LIMIT 1", PlayerName(playerid));
    mysql_tquery(Database, DB_Query, "OnPlayerDataCheck", "ii", playerid, Control[playerid][Corrupt_Check]);
    
    #if defined Register_OnPlayerConnect
        Register_OnPlayerConnect(playerid);
    #endif
    return true;
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Register_OnPlayerConnect
#if defined Register_OnPlayerConnect
    forward Register_OnPlayerConnect(playerid);
#endif
 
/*================================================================================*/

public OnPlayerDisconnect(playerid, reason)
{
    Control[playerid][Corrupt_Check]++;
    
    if(Player[playerid][LoggedIn])
    { 
        new 
            DB_Query[600];
        if(reason == 1)
        {
            GetPlayerPos(playerid, Player[playerid][Pos_X], Player[playerid][Pos_Y], Player[playerid][Pos_Z]);
            GetPlayerHealth(playerid, Player[playerid][Healt]);
            GetPlayerArmour(playerid, Player[playerid][Armor]);
        }   
        mysql_format(Database, DB_Query, sizeof DB_Query, "UPDATE `PLAYERS` SET `ADMIN` = %d, `KILLS` = %d, `DEATHS` = %d, `GTIME` = %d, `PMSONG` = %d, `BANTIME` = %d,\
            `SKIN` = %d, `COLOUR` = %d, `CASH` = %d, `HEALTH` = %f, `ARMOUR` = %f, `POS_X` = %f, `POS_Y` = %f, `POS_Z` = %f, `POS_A` = %f WHERE `ID` = %d LIMIT 1",
        Player[playerid][Admin], Player[playerid][Kills], Player[playerid][Deaths], GetPlayerTimer(playerid), Player[playerid][PMSong], Player[playerid][BanTime], Player[playerid][Skin], GetPlayerColor(playerid), Player[playerid][Cash],
        Player[playerid][Healt], Player[playerid][Armor], Player[playerid][Pos_X],  Player[playerid][Pos_Y],  Player[playerid][Pos_Z], Player[playerid][Pos_A],
        Player[playerid][ID]);
    
        mysql_tquery(Database, DB_Query);
    } 
    else return false;

    if(cache_is_valid(Player[playerid][Player_Cache])) 
    {
        cache_delete(Player[playerid][Player_Cache]); 
        Player[playerid][Player_Cache] = MYSQL_INVALID_CACHE; 
    }

    if(Player[playerid][LoggedIn])
    { 
        switch(reason)
        {
            case 0: SendClientMessageToAllf(X11_GREY, "�| SERVER |� Hr�� %s odi�iel zo serveru [P�D HRY].",PlayerName(playerid));
            case 1: SendClientMessageToAllf(X11_GREY, "�| SERVER |� Hr�� %s odi�iel zo serveru.",PlayerName(playerid));
            case 2: SendClientMessageToAllf(X11_GREY, "�| SERVER |� Hr�� %s odi�iel zo serveru [KICK/BAN].",PlayerName(playerid));
        }
    }
    
    #if defined Register_OnPlayerDisconnect
    Register_OnPlayerDisconnect(playerid, reason);
    #endif
    return true;
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Register_OnPlayerDisconnect
#if defined Register_OnPlayerDisconnect
    forward Register_OnPlayerDisconnect(playerid, reason);
#endif

/*================================================================================*/

forward OnPlayerDataCheck(playerid, corrupt_check);
public OnPlayerDataCheck(playerid, corrupt_check)
{
    if(corrupt_check != Control[playerid][Corrupt_Check]) return Kick(playerid);
 
    new 
        string[46];
   
    if(cache_num_rows() > 0)
    {
        cache_get_value_int(0, "BANTIME",  Player[playerid][BanTime]);
        cache_get_value_int(0, "GTIME",    Player[playerid][GTime]);
        cache_get_value    (0, "PASSWORD", Player[playerid][Password], 129);

        Player[playerid][Player_Cache] = cache_save();
        if(Player[playerid][BanTime] < gettime())
        {
            PlayAudioStreamForPlayer(playerid,"http://www.img.tpx.cz/uploads/RetroMode.mp3");
            format(string, sizeof(string), RED"V�tajte sp� "WHITE"%s",PlayerName(playerid));
            ShowPlayerDialog(playerid, D_Login, DIALOG_STYLE_PASSWORD, string, 
                WHITE"Pravidla:\n"\
                RED"1. "WHITE"Nem��te pou��va� zv�hod�uj�ce modifik�cie do hry ako sobeit, cleo, parkur mod... .\n"\
                   "    "WHITE"V�nimkov s� m�dy na zmenu grafiky.\n"\
                RED"2. "WHITE"Nesmiete sa vyd�va� za administr�tora serveru a ani za in� privil�gium na serveri.\n"\
                RED"3. "WHITE"Vytv�ranie rekl�m na in� server respekt�ve konkurenciu bude pr�sne potrestan�.\n"\
                RED"4. "WHITE"Server je ur�en� pre vekov� kateg�riu 18+. Za hranie na na�om serveri nezodpoved�me.\n"\
                RED"5. "WHITE"Ur�anie in�ch hr��ov rasistick�m �i in�m podt�nom sa pr�sne trest�.\n"\
                RED"6. "WHITE"Je pr�sne zak�zan� vyu��va� chyby serveru. V pr�pade n�jdenia chyby pros�me o nahl�senie cez pr�kaz /bug.\n"\
                RED"7. "WHITE"Nem��te zneu��va� AFK respekt�ve ESC pred smr�ou.\n"\
                RED"8. "WHITE"Je zak�zan� spamova� �i floodova� na serveri.",
            "prihl�si�", "od�s�");
        }
        else
        {
            new 
                string1  [26], 
                string2 [500];
        
            format(string1, sizeof(string1), "%s",PlayerName(playerid));
            format(string2,sizeof(string2),WHITE"V�en� hr��.\n"\
            WHITE"Bol v�m udelen� ban, z d�vodu poru�ovania pravidiel.\n\n"\
            BLUE"\r\rNICK:     "WHITE"%s\n"\
            BLUE"IP:           "WHITE"%s\n"\
            BLUE"Unban:   "WHITE"%s\n\n\n"\
            WHITE"V pr�pade ak by sa jednalo o nedorozumenie, pros�m kontaktujte n�s, \ncez n� email "BLUE"panpodnikatel@centrum.sk",
            PlayerName(playerid),GetIp(playerid),StringFromUnix(Player[playerid][BanTime]));
            ShowPlayerDialog(playerid, D_Default, DIALOG_STYLE_MSGBOX, string1, string2, "potvrdi�", "");
            return PlayAudioStreamForPlayer(playerid,"http://www.img.tpx.cz/uploads/ban.mp3");
        }
    }
    else
    {
        PlayAudioStreamForPlayer(playerid,"http://www.img.tpx.cz/uploads/RetroMode.mp3");
        format(string, sizeof(string), RED"V�tajte "WHITE"%s",PlayerName(playerid));
        ShowPlayerDialog(playerid, D_Reg, DIALOG_STYLE_INPUT, string, 
            WHITE"Pravidla:\n"\
            RED"1. "WHITE"Nem��te pou��va� zv�hod�uj�ce modifik�cie do hry ako sobeit, cleo, parkur mod... .\n"\
               "    "WHITE"V�nimkov s� m�dy na zmenu grafiky.\n"\
            RED"2. "WHITE"Nesmiete sa vyd�va� za administr�tora serveru a ani za in� privil�gium na serveri.\n"\
            RED"3. "WHITE"Vytv�ranie rekl�m na in� server respekt�ve konkurenciu bude pr�sne potrestan�.\n"\
            RED"4. "WHITE"Server je ur�en� pre vekov� kateg�riu 18+. Za hranie na na�om serveri nezodpoved�me.\n"\
            RED"5. "WHITE"Ur�anie in�ch hr��ov rasistick�m �i in�m podt�nom sa pr�sne trest�.\n"\
            RED"6. "WHITE"Je pr�sne zak�zan� vyu��va� chyby serveru. V pr�pade n�jdenia chyby pros�me o nahl�senie cez pr�kaz /bug.\n"\
            RED"7. "WHITE"Nem��te zneu��va� AFK respekt�ve ESC pred smr�ou.\n"\
            RED"8. "WHITE"Je zak�zan� spamova� �i floodova� na serveri.",
        "registrova�", "od�s�");
    }
    return true;
}
 
/*================================================================================*/

forward SavePlayerData(playerid);
public SavePlayerData(playerid)
{
    new 
        DB_Query[600];
    GetPlayerPos(playerid, Player[playerid][Pos_X], Player[playerid][Pos_Y], Player[playerid][Pos_Z]);
    GetPlayerHealth(playerid, Player[playerid][Healt]);
    GetPlayerArmour(playerid, Player[playerid][Armor]);
    
    mysql_format(Database, DB_Query, sizeof DB_Query, "UPDATE `PLAYERS` SET `ADMIN` = %d, `KILLS` = %d, `DEATHS` = %d, `GTIME` = %d, `PMSONG` = %d, `BANTIME` = %d,\
            `SKIN` = %d, `COLOUR` = %d, `CASH` = %d, `HEALTH` = %f, `ARMOUR` = %f, `POS_X` = %f, `POS_Y` = %f, `POS_Z` = %f, `POS_A` = %f WHERE `ID` = %d LIMIT 1",
        Player[playerid][Admin], Player[playerid][Kills], Player[playerid][Deaths], GetPlayerTimer(playerid), Player[playerid][PMSong], Player[playerid][BanTime], Player[playerid][Skin], GetPlayerColor(playerid), Player[playerid][Cash],
        Player[playerid][Healt], Player[playerid][Armor], Player[playerid][Pos_X],  Player[playerid][Pos_Y],  Player[playerid][Pos_Z], Player[playerid][Pos_A],
        Player[playerid][ID]);
   
    mysql_tquery(Database, DB_Query);
    return true;
}
/*================================================================================*/
forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{   
    Player [playerid][ID]       = cache_insert_id();
    Control[playerid][GTime]    = gettime();
    Player [playerid][Registred]= gettime();
    Player [playerid][LoggedIn] = 1;
    Player [playerid][Colour]   = Y_DARKGREEN | 0x55;
    Player [playerid][Cash]     = 1000;
    Player [playerid][Skin]     = 206;
    Player [playerid][Pos_X]    = 2038.0022;
    Player [playerid][Pos_Y]    = -1411.3317;
    Player [playerid][Pos_Z]    = 17.1641;
    Player [playerid][Pos_A]    = 129.9821;


    ServerTime(playerid);
    SpawnPlayer(playerid);
    SetPlayerTimerEx_(playerid, "LoadMoney", 1700, 2000, 1, "i",playerid);
    StopAudioStreamForPlayer(playerid);
    TextDrawShowForPlayer(playerid, TimeTXD);
    SendClientMessageToAllf(X11_GREY, "�| SERVER |� Zaregistroval sa nov� hr�� %s.",PlayerName(playerid));
    return true;
}

/*================================================================================*/

forward LoggedMap(playerid);
public LoggedMap(playerid)
{
    SpawnPlayer            (playerid);
    SetPosition            (playerid,-691.1649,932.7473,13.6563,313.7462,playerid+1);
    SetPlayerSkin          (playerid, 299);
    SetPlayerCameraPos     (playerid, -687.291564, 939.784729, 15.334177);
    SetPlayerCameraLookAt  (playerid, -688.834594, 935.217834, 14.006546);
    return true;
}