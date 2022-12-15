#include <sourcemod>
#include <sdktools>
 
public Plugin:myinfo =
{
	name = "Give pills",
	author = "Altair Sossai",
	description = "Gives pills to survivors at the start of each round.",
	version = "1.0.0",
	url = "http://forums.alliedmods.net/showthread.php?p=915033"
}

public void OnRoundIsLive()
{
	new flags = GetCommandFlags("give");	
	SetCommandFlags("give", flags & ~FCVAR_CHEAT);	

    int first_aid_kit = 1;

	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || GetClientTeam(i) != 2) 
            continue;

        if (first_aid_kit-- > 0)
            FakeClientCommand(i, "give first_aid_kit");
        else
            FakeClientCommand(i, "give pain_pills");
	}

	SetCommandFlags("give", flags|FCVAR_CHEAT);
}
