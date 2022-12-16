#include <sourcemod>
#include <sdktools>

public
Plugin myinfo =
    {
        name = "Remove items",
        author = "Altair Sossai",
        description = "Remove items",
        version = "0.1.1",
        url = "https://github.com"};

public
void OnPluginStart()
{
    HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
}

public
void Event_RoundStart(Event hEvent, const char[] name, bool dontBroadcast)
{
    RemoveMedkits();
}

void RemoveMedkits()
{
    int iEntityCount = GetEntityCount();
    char EdictClassName[128];

    int weapon_molotov = 2;
    int weapon_pipe_bomb = 2;
    int weapon_pain_pills = 2;
    int weapon_adrenaline = 2;

    for (int i = iEntityCount; i >= 0; i--)
    {
        if (!IsValidEntity(i))
            continue;

        GetEdictClassname(i, EdictClassName, sizeof(EdictClassName));

        if (StrContains(EdictClassName, "weapon_first_aid_kit", false) != -1
         || StrContains(EdictClassName, "weapon_defibrillator", false) != -1
         || StrContains(EdictClassName, "weapon_grenade_launcher", false) != -1
         || StrContains(EdictClassName, "weapon_rifle_m60", false) != -1
         || StrContains(EdictClassName, "upgrade_laser_sight", false) != -1
         || StrContains(EdictClassName, "upgrade_ammo_incendiary", false) != -1
         || StrContains(EdictClassName, "upgrade_ammo_explosive", false) != -1
         || StrContains(EdictClassName, "weapon_upgradepack_incendiary", false) != -1
         || StrContains(EdictClassName, "weapon_upgradepack_explosive", false) != -1)
            AcceptEntityInput(i, "Kill");

        if (StrContains(EdictClassName, "weapon_molotov", false) != -1 && weapon_molotov-- <= 0)
            AcceptEntityInput(i, "Kill");

        if (StrContains(EdictClassName, "weapon_pipe_bomb", false) != -1 && weapon_pipe_bomb-- <= 0)
            AcceptEntityInput(i, "Kill");

        if (StrContains(EdictClassName, "weapon_pain_pills", false) != -1 && weapon_pain_pills-- <= 0)
            AcceptEntityInput(i, "Kill");

        if (StrContains(EdictClassName, "weapon_adrenaline", false) != -1 && weapon_adrenaline-- <= 0)
            AcceptEntityInput(i, "Kill");
    }
}