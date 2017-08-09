
#define MAX_JOBS			20
#define MAX_JOB_LOCALS		43


#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

enum
{
	NEZAMESTNANY,
	DOKTOR,
	TERORISTA,
	YAKUZA,
	PILOT,
	MAFIA,
	SMETIAR,
	VOJAK   
};
enum
{
	LOSSANTOS,   
	SANFIERRO,   
	LASVENTURAS 
};

enum Data_Job
{
	JobLocal,
	IDJob
};
new 
	Povolanie[MAX_JOB_LOCALS][Data_Job];
new 
	CountSeatsJob = -1,
	PickupCount   = -1;
new 
	SelectJob[MAX_PLAYERS];
enum PICKUP_DATA
{
	Float:p_X,
	Float:p_Y,
	Float:p_Z,
	pID
};
new 
	PickupInfo[MAX_JOB_LOCALS][PICKUP_DATA];
new 
	JobName[MAX_JOBS][2][18] ={
		{"Nezamestnaný","Nezamestnany"},
		{"Doktor","Doktor"},
		{"Terorista","Terorista"},
		{"Yakuza","Yakuza"},
		{"Pilot","Pilot"},
		{"Mafia","Mafia"},
		{"Smetiar","Smetiar"},
		{"Vojak","Vojak"},
		{"Farmár","farmar"},
		{"VUS","VUS"},
		{"Právník","pravnik"},
		{"Strojvedúci","strojveduci"},
		{"Taxikár","taxikar"},
		{"Polícia","Policia"},
		{"Vodiè autobusu","Vodic autobusu"},
		{"Pohrebná služba","Pohrebna sluzba"},
		{"Mechanik","mechanik"},
		{"Predajca drog","Predajca drog"},
		{"Predajca zbraní","Predajca zbrani"},
		{"Vodiè elektrièky","Vodic elektricky"}
	};

public OnGameModeInit(){
	CreateJob(DOKTOR   , LOSSANTOS  ,  2035.3660, -1405.3491, 17.2362);
	CreateJob(DOKTOR   , SANFIERRO  , -2665.0027,   639.7718, 14.4531);
	CreateJob(DOKTOR   , LASVENTURAS,  1607.3276,  1815.8981, 10.8203);
	CreateJob(DOKTOR   ,           3, -2203.5830, -2309.9209, 31.3750);
	CreateJob(DOKTOR   ,           4, -1514.8192,  2519.7395, 56.0352);
	CreateJob(DOKTOR   ,           5, -320.2664 ,  1048.5605, 20.3403);
	CreateJob(TERORISTA, LASVENTURAS, -1303.4028,  2541.5469, 93.3047);
	CreateJob(YAKUZA   , SANFIERRO  , -2172.7390,   679.8108, 55.1621);
	CreateJob(YAKUZA   , LASVENTURAS,  1906.0701,   956.7598, 10.8203);
	CreateJob(PILOT    , LOSSANTOS  ,  1957.1975, -2183.5483, 13.5469);
	CreateJob(PILOT    , LASVENTURAS,  1715.2234,  1616.4121,  10.066);
	CreateJob(MAFIA    , LASVENTURAS,  2170.0618,  1711.8831, 11.0469);
	CreateJob(SMETIAR  , LASVENTURAS,  1442.2773,   969.8030, 10.8203);
	CreateJob(VOJAK    , LASVENTURAS,   349.5313,  2024.0840, 22.6406);
	#if defined Jobs_OnGameModeInit
    Jobs_OnGameModeInit();
    #endif
    return true;
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Jobs_OnGameModeInit
#if defined Jobs_OnGameModeInit
    forward Jobs_OnGameModeInit();
#endif

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_WALK))
	{
		for(new i;i<MAX_JOB_LOCALS;i++)
		{
			if(IsPlayerInRangeOfPoint(playerid,2,PickupInfo[i][p_X],PickupInfo[i][p_Y],PickupInfo[i][p_Z]))
			{
				new 
					job = Povolanie[i][IDJob];
				
				SelectJob[playerid] = i;
    	
				if(job != Player[playerid][Job])
				{
					//dialogs
				}
				return true;
			}
		}
	} 
	#if defined Jobs_OnPlayerKeyStateChange
	Jobs_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #endif
    return true;
}
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange Jobs_OnPlayerKeyStateChange
#if defined Jobs_OnPlayerKeyStateChange
    forward Jobs_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

stock CreatePickupf(pmodel,ptyp,Float:X,Float:Y,Float:Z)
{
	if(PickupCount+1 < MAX_JOB_LOCALS)
	{
	    PickupCount ++;
	    PickupInfo[PickupCount][p_X] = X;
		PickupInfo[PickupCount][p_Y] = Y;
  		PickupInfo[PickupCount][p_Z] = Z;
    	PickupInfo[PickupCount][pID] = CreatePickup(pmodel,ptyp,X,Y,Z,-1);
    }
    else print("SERVER:: Full MAX_PICKUP!");
	return true;
}

stock CreateJob(JobID,LocalJob,Float:X,Float:Y,Float:Z)
{
	if(CountSeatsJob+1 < MAX_JOB_LOCALS)
	{
    	CountSeatsJob ++;
		Povolanie[CountSeatsJob][JobLocal] = LocalJob;
		Povolanie[CountSeatsJob][IDJob]    = JobID;
		if(JobID == DOKTOR) CreatePickupf(1240,1,X,Y,Z);
		else CreatePickupf(1581,1,X,Y,Z);
		Create3DTextLabel(JobName[JobID][0],0xFFEAEAFF,X,Y,Z+0.5,30,0,1);
		CreateDynamicMapIcon(X,Y,Z, 11, X11_RED, 0,0,-1,STREAMER_MAP_ICON_SD, MAPICON_LOCAL,STREAMER_TAG_AREA -1);
	}
	return true;
}