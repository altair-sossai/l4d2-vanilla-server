#include <sourcemod>
#include <sdktools>
#include <basecomm>
#include <clients>

public Plugin:myinfo =
{
	name = "[L4D2] Silence",
	author = "Altair Sossai",
	description = "Let your server have peace.",
	version = "1.0",
	url = "http://www.sourcemod.net/"
}

public OnClientPutInServer(client)
{
	if(!client)
		return;

	new String:SteamID[64];
	GetClientAuthId(client, AuthId_Steam2, SteamID, sizeof(SteamID));
    
    if (StrEqual(SteamID, "BOT"))
        return;

    new String:Name[128];
    GetClientName(client, Name, sizeof(Name));

    if(StrContains(SteamID, ":598701106", true) != -1 /* hard */)
	{
	    BaseComm_SetClientGag(client, true);
	    BaseComm_SetClientMute(client, true);
	}
}