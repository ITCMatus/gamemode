enum 
{
    D_Default,
	D_Login,
	D_Reg,
    D_Navrh,
    D_Bug,
    D_Radio,
    D_RadioSelect,
    D_Help,
    D_HelpSelect,
    D_Info,
    D_InfoSong
};

enum
{
    CMD_ADMIN_0,
    CMD_ADMIN_1,
    CMD_ADMIN_2,
    CMD_ADMIN_3,
    CMD_ADMIN_4,
    CMD_ADMIN_5
};

enum PlayerData
{
    Cache:Player_Cache,

    Float:Healt,
    Float:Armor,
    Float:Pos_X,
    Float:Pos_Y,
    Float:Pos_Z,
    Float:Pos_A,
    Password[128],

    ID, 
    Job,
    Cash,
    Skin,
    Admin,
    GTime,  
    Kills,
    Colour,
    Deaths,
    PMSong,
    BanTime,
    LoggedIn,
    Registred,
    PasswordFails
};

enum ControlPlayerData
{
    Bug,
    Navrh,
    GTime,
    Radio,
    CMDSpam,
    Vehicle,
    Corrupt_Check
};

enum InteriorData
{
    Float:Exit_X,
    Float:Exit_Y,
    Float:Exit_Z,
    
    Exit_ID,
    Int_SID,
    Int_Pick,
    Exit_ZRot,
    Int_Lokalita
};
enum InteriorExitData
{
    Float:Int_X,
    Float:Int_Y,
    Float:Int_Z,
    
    Int_ID,
    MapIcon,
    Int_ZRot,
    Exit_Pick
};

/*================================================================================*/

/*CORE DEFINE*/
new IPVariable   [20];
new NameVariable [25];
new	FormatFolder [50];

/*MySQL*/
new MySQL: Database; 

/*TEXTDRAW*/
new Text:  TimeTXD;

new 
    DynServerHour,
    DynServerMins;

/*PLAYER DATA*/
new Player [MAX_PLAYERS][PlayerData];
new Control[MAX_PLAYERS][ControlPlayerData];

/*INTERIOR DATA*/
new InteriorInfo[MAX_INTERIORS][InteriorData]; 
new ExitInfo    [MAX_EXITS][InteriorExitData];

new 
    InteriorCount = -1,
    ExitCount     = -1;

/*MAPS*/
new Trava;                  //Stavenisko        SF
new SFGarage;               //Star· Gar·û       SF
new Desk;                   //Stvenisko         SF
new Chodnik;                //Stvenisko         SF
new Cesta;                  //Stvenisko         SF

/*OTHER VARIABLE*/
new CVehicle [MAX_PLAYERS];
new HospitalZone[5];

/*UNAMX*/
#emit load.pri Trava
#emit stor.pri Trava

#emit load.pri SFGarage
#emit stor.pri SFGarage

#emit load.pri Desk
#emit stor.pri Desk

#emit load.pri Cesta
#emit stor.pri Cesta

#emit load.pri Chodnik
#emit stor.pri Chodnik

new 
    Sign[MAX_SIGN][2][]={
        {"Ï","e"},{"ö","s"},{"Ë","c"},{"¯","r"},{"û","z"},{"Ô","d"},{"ù","t"},{"Ú","n"},
        {"˝","y"},{"·","a"},{"Ì","i"},{"È","e"},{"˙","u"},{"˘","u"},{"Û","o"},{"Ã","E"},
        {"ä","S"},{"»","C"},{"ÿ","R"},{"é","Z"},{"œ","D"},{"ç","T"},{"“","N"},{"›","Y"},
        {"¡","A"},{"Õ","I"},{"…","E"},{"⁄","U"},{"Ÿ","U"},{"”","O"},{"‘","O"},{"ƒ","A"},
        {"º","L"},{"æ","l"}
    };
new 
    SongSwitch[] ={ 
    "http://www.img.tpx.cz/uploads/Wood.mp3",
    "http://www.img.tpx.cz/uploads/AirBubble.mp3",
    "http://www.img.tpx.cz/uploads/Bubble.mp3",
    "http://www.img.tpx.cz/uploads/Spark.mp3",
    "http://www.img.tpx.cz/uploads/BadLuck.mp3",
    "http://www.img.tpx.cz/uploads/Bird.mp3"
};
new VehicleNames[][] = {
    "Landstalker","Bravura","Buffalo","Linerunner","Perenniel","Sentinel","Dumper","Firetruck",
    "Trashmaster","Stretch","Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulance",
    "Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr. Whoopee","BF Injection",
    "Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife",
    "Article Trailer","Previon","Coach","Cabbie","Stallion","Rumpo","RC Bandit","Romero","Packer","Monster",
    "Admiral","Squallo","Seasparrow","Pizzaboy","Tram","Article Trailer 2","Turismo","Speeder","Reefer",
    "Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway",
    "RC Baron","RC Raider","Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy",
    "Hermes","Sabre","Rustler","ZR-350","Walton","Regina","Comet","BMX","Burrito","Camper","Marquis","Baggage",
    "Dozer","Maverick","SAN News Maverick","Rancher","FBI Rancher","Virgo","Greenwood","Jetmax",
    "Hotring Racer","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin",
    "Hotring Racer 2","Hotring Racer 3","Bloodring Banger","Rancher 2","Super GT","Elegant","Journey",
    "Bike","Mountain Bike","Beagle","Cropduster","Stuntplane","Tanker","Roadtrain","Nebula","Majestic",
    "Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Towtruck","Fortune",
    "Cadrona","FBI Truck","Willard","Forklift","Tractor","Combine Harvester","Feltzer","Remington",
    "Slamvan","Blade","Freight","Brownstreak","Vortex","Vincent","Bullet","Clover","Sadler","Firetruck LA",
    "Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility Van","Nevada","Yosemite",
    "Windsor","Monster A","Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger",
    "Flash","Tahoma","Savanna","Bandito","Freight Flat Trailer","Streak Trailer","Kart","Mower","Dune",
    "Sweeper","Broadway","Tornado","AT400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Petrol Trailer",
    "Emperor","Wayfarer","Euros","Hotdog","Club","Freight Box Trailer","Article Trailer 3","Andromada","Dodo",
    "RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)","Police Car (LVPD)","Police Ranger","Picador",
    "S.W.A.T.","Alpha","Phoenix","Glendale Shit","Sadler Shit","Baggage Trailer A","Baggage Trailer B",
    "Tug Stairs Trailer","Boxville 2","Farm Trailer","Utility Trailer"
};