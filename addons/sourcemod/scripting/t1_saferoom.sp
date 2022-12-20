#include <sourcemod>
#include <sdktools>
 
public Plugin:myinfo =
{
	name = "[L4D] T1 in the saferrom",
	author = "Altair Sossai",
	description = "Gives t1 to survivors at the start of each round.",
	version = "1.1.2",
	url = "http://forums.alliedmods.net"
}

public void OnRoundIsLive()
{
	new flags = GetCommandFlags("give");	
	SetCommandFlags("give", flags & ~FCVAR_CHEAT);	
	
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || GetClientTeam(i) != 2) 
			continue;

		FakeClientCommand(i, "give shotgun_chrome");
		FakeClientCommand(i, "give pumpshotgun");
		FakeClientCommand(i, "give smg");
		FakeClientCommand(i, "give smg_silenced");

		break;
	}

	SetCommandFlags("give", flags|FCVAR_CHEAT);
}
