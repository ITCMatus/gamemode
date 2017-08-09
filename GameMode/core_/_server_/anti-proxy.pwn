/*
hash heslo 
*/

public OnPlayerConnect(playerid)
{
    new
        string[102];
    format(string, sizeof(string), "v2.api.iphub.info/ip/%s?key=MTE2OlVud1B5M3VOdHowUU1kVDViaDNLNkx6NGFxRm1rek9w&format=int",GetIp(playerid));
    HTTP  (playerid, HTTP_GET, string, "", "ProxyPublic");
    return true;
}
 
forward ProxyPublic(index,response_code,data[]);
public ProxyPublic(index,response_code,data[]){
    if(response_code == 200){       
        if(strval(data) == 1){
            SendClientMessagef(index, X11_RED, "«| SERVER |» "WHITE"Detekovali sme u vás "RED"Proxy IP"WHITE" prosím o zmenu IP. Prípadne nás kontaktujte.");
            SetPlayerTimerEx_(index, "ProxyTimer", 750, 1000, 1, "i",index);
        }
    }
    return true;
}
forward ProxyTimer(index);
public ProxyTimer(index) return Kick(index);