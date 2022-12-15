#include <sourcemod>
#include <sdktools>

new Handle:g_hCvarTankCanSpawn;

public Plugin myinfo = {
	name = "Do not allow the tank to respawn on the finale map",
	author = "Altair Sossai",
	version = "1.0.0",
	description = "Do not allow the tank to respawn on the finale map",
	url = "https://github.com"
};

public void OnPluginStart() {
    g_hCvarTankCanSpawn = FindConVar("sm_tank_can_spawn");
    
    HookEvent("round_start", RoundStartEvent, EventHookMode_PostNoCopy);
}

public void RoundStartEvent(Event hEvent, const char[] name, bool dontBroadcast)
{
	CreateTimer(10.0, UpdateTankCanSpawnDelay);

	new String:map[64];
	GetCurrentMap(map, 64);

	if(StrContains(map, "c1m4_atrium", true) != -1
	|| StrContains(map, "c3m4_plantation", true) != -1
	|| StrContains(map, "c6m3_port", true) != -1
	|| StrContains(map, "c7m3_port", true) != -1
	|| StrContains(map, "c9m2_lots", true) != -1
	|| StrContains(map, "c13m4_cutthroatcreek", true) != -1
	|| StrContains(map, "c14m2_lighthouse", true) != -1
	|| StrContains(map, "m5_", true) != -1) {
		SetConVarBool(g_hCvarTankCanSpawn, false);
		return;
	}
	
	SetConVarBool(g_hCvarTankCanSpawn, true);
}

public Action:UpdateTankCanSpawnDelay(Handle:timer)
{
	SetConVarBool(g_hCvarTankCanSpawn, true);
}