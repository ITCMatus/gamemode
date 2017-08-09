#pragma warning disable 203

native WP_Hash(buffer[], len, const str[]);

#define MYSQL_HOST        "127.0.0.1" 
#define MYSQL_USER        "CMatus" 
#define MYSQL_PASS        "atena" 
#define MYSQL_DATABASE    "Matus"

#define MAX_INTERIORS  87
#define VW_INTERIOR	   5000 
#define MAX_EXITS      25
#define MAX_SIGN       34

#define DAYS(%1) %1*86400 
#define HOURS(%1) %1*3600
#define MINUTES(%1) %1*60

#define GetIp(%0) (GetPlayerIp((%0), IPVariable, sizeof(IPVariable)), IPVariable)
#define PlayerName(%0) (GetPlayerName((%0), NameVariable, sizeof(NameVariable)), NameVariable)
#define PlayerFolders(%0) (format(FormatFolder, sizeof(FormatFolder),"Database/Players/%s.txt",PlayerName(%0)),FormatFolder)

#define strcpy(%0,%1) (strcat((%0[0] = '\0', %0), %1))

#define X11_ORANGE_RED 0xFF4500FF
#define X11_DARK_GREEN 0x006400FF
#define X11_DEEP_PING  0xFF1493FF
#define X11_CHARTEUSE  0x76EE00FF
#define X11_CHOCOLATE  0xD2691EFF
#define X11_MAGENTA    0xFF00FFFF
#define X11_ORANGE     0xFF3300FF
#define X11_WHITE      0xFFFFFFFF
#define X11_AZURE      0xF0FFFFFF
#define X11_GREEN      0x008000FF
#define X11_BROWM      0xA52A2AFF
#define X11_BLUE       0x3399FFFF
#define X11_GREY       0x808080FF
#define X11_GOLD       0xFFD700FF
#define X11_AQA        0x00FFFFFF
#define X11_RED        0xFF0000FF

#define Y_SNOW         0xFFFAFA00
#define Y_DARKGREEN    0x00640000
#define Y_GOLD         0xFFD70000
#define Y_GREEN        0x00FF0000
#define Y_ORANGE       0xFFA50000
#define Y_BLUE         0x3399FF00

#define ORANGE_RED     "{FF4500}"
#define DARK_GREEN     "{006400}"
#define DEEP_PING      "{FF1493}"
#define CHARTEUSE      "{76EE00}" 
#define CHOCOLATE      "{D2691E}"
#define MAGENTA        "{FF00FF}"
#define ORANGE         "{FF3300}"
#define WHITE          "{FFFFFF}"
#define AZURE          "{F0FFFF}"
#define GREEN          "{008000}"
#define BROWM          "{A52A2A}"
#define BLUE           "{3399FF}"
#define GREY           "{808080}"
#define GOLD           "{FFD700}"
#define AQA            "{00FFFF}"
#define RED            "{FF0000}"