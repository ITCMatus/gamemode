public OnGameModeInit()
{
	TimeTXD = TextDrawCreate(549.583618, 21.481433, "22:30");
	TextDrawLetterSize         (TimeTXD, 0.586667, 2.367404);
	TextDrawAlignment          (TimeTXD, 1);
	TextDrawColor              (TimeTXD, -1);
	TextDrawSetShadow          (TimeTXD, 0);
	TextDrawSetOutline         (TimeTXD, 1);
	TextDrawBackgroundColor    (TimeTXD, 255);
	TextDrawFont               (TimeTXD, 3);
	TextDrawSetProportional    (TimeTXD, 1);
	TextDrawSetShadow          (TimeTXD, 0);
	#if defined TextDraw_OnGameModeInit
        TextDraw_OnGameModeInit();
    #endif
    return true;
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit TextDraw_OnGameModeInit
#if defined TextDraw_OnGameModeInit
    forward TextDraw_OnGameModeInit();
#endif