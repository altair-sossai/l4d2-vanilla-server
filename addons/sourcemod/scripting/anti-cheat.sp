#include <ripext>
#include <sourcemod>

String:AreNotUsing[30][25];

public Plugin myinfo =
{
	name		= "L4D2 - Anti-cheat",
	author		= "Altair Sossai",
	description = "Custom anti-cheat designed to capture information directly in the user's client",
	version		= "1.0.0",
	url			= "https://github.com/altair-sossai/l4d2-server-manager-client"
};

ConVar cvar_anti_cheat_endpoint;
ConVar cvar_anti_cheat_access_token;

public void OnPluginStart()
{
	cvar_anti_cheat_endpoint = CreateConVar("anti_cheat_endpoint", "https://l4d2-server-manager-api.azurewebsites.net", "Anti-cheat endpoint", FCVAR_PROTECTED);
	cvar_anti_cheat_access_token = CreateConVar("anti_cheat_access_token", "", "Anti-cheat Access Token", FCVAR_PROTECTED);

	RegAdminCmd("sm_addsusp", AddSuspected, ADMFLAG_BAN);
	RegAdminCmd("sm_remsusp", RemoveSuspected, ADMFLAG_BAN);

	CreateTimer(30.0, RefreshSuspectsListTick, _, TIMER_REPEAT);
	CreateTimer(2.0, MoveToSpectatedPlayersWithoutAntiCheatTick, _, TIMER_REPEAT);
	
	RefreshSuspectsList();
}

public Action RefreshSuspectsListTick(Handle timer)
{
	RefreshSuspectsList();

	return Plugin_Continue;
}

public Action MoveToSpectatedPlayersWithoutAntiCheatTick(Handle timer)
{
	MoveToSpectatedPlayersWithoutAntiCheat();

	return Plugin_Continue;
}

public Action:AddSuspected(client, args)
{
	decl String:suspected[64];
	GetCmdArgString(suspected, sizeof(suspected));

	JSONObject command = new JSONObject();
	command.SetString("account", suspected);

	HTTPRequest request = BuildHTTPRequest("/api/suspected-players");
	request.Post(command, AddSuspectedResponse);
}

void AddSuspectedResponse(HTTPResponse httpResponse, any value)
{
	if (httpResponse.Status != HTTPStatus_OK)
	{
		PrintToChatAll("Falha ao adicionar jogador suspeito.");
		return;
	}

	JSONObject response = view_as<JSONObject>(httpResponse.Data);

	new String:name[255];
	response.GetString("name", name, sizeof(name));
	PrintToChatAll("\x04%s\x01 adicionado como suspeito.", name);

	RefreshSuspectsList();
}

public Action:RemoveSuspected(client, args)
{
	decl String:suspected[64];
	GetCmdArgString(suspected, sizeof(suspected));

	JSONObject command = new JSONObject();
	command.SetString("account", suspected);

	HTTPRequest request = BuildHTTPRequest("/api/suspected-players/delete");
	request.Post(command, RemoveSuspectedResponse);
}

void RemoveSuspectedResponse(HTTPResponse httpResponse, any value)
{
	if (httpResponse.Status != HTTPStatus_OK)
	{
		PrintToChatAll("Falha ao remover jogador suspeito.");
		return;
	}

	PrintToChatAll("Jogador removido da lista de suspeito.");

	RefreshSuspectsList();
}

public HTTPRequest BuildHTTPRequest(char[] path)
{
	new String:endpoint[255];
	GetConVarString(cvar_anti_cheat_endpoint, endpoint, sizeof(endpoint));
	StrCat(endpoint, sizeof(endpoint), path);

	new String:access_token[100];
	GetConVarString(cvar_anti_cheat_access_token, access_token, sizeof(access_token));

	HTTPRequest request = new HTTPRequest(endpoint);
	request.SetHeader("Authorization", access_token);

	return request;
}

public void RefreshSuspectsList()
{
	JSONObject command = new JSONObject();
	JSONArray suspecteds = new JSONArray();

	for (int client = 1; client <= MaxClients; client++)
	{
		if (!IsClientInGame(client) || IsFakeClient(client))
			continue;

		int clientTeam = GetClientTeam(client);
		if (clientTeam != 1 && clientTeam != 2 && clientTeam != 3)
			continue;

		new String:communityId[25];
		GetClientAuthId(client, AuthId_SteamID64, communityId, sizeof(communityId));

		suspecteds.PushString(communityId);
	}

	command.Set("suspecteds", suspecteds);

	HTTPRequest request = BuildHTTPRequest("/api/suspected-players-activity/check-anti-cheat-usage");
	request.Post(command, RefreshSuspectsListResponse);
}

void RefreshSuspectsListResponse(HTTPResponse httpResponse, any value)
{
	if (httpResponse.Status != HTTPStatus_OK)
		return;

	for (int i = 0; i < 30; i++)
		AreNotUsing[i] = "";

	JSONObject response = view_as<JSONObject>(httpResponse.Data);
	JSONArray areNotUsing = view_as<JSONArray>(response.Get("areNotUsing"));

	for (int i = 0; i < areNotUsing.Length; i++)
	{
		JSONObject suspectedPlayer = view_as<JSONObject>(areNotUsing.Get(i));

		new String:communityId[25];
		suspectedPlayer.GetString("communityId", communityId, sizeof(communityId));

		AreNotUsing[i] = communityId;
	}

	MoveToSpectatedPlayersWithoutAntiCheat();
}

public void MoveToSpectatedPlayersWithoutAntiCheat()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (!IsClientInGame(client) || IsFakeClient(client))
			continue;

		int clientTeam = GetClientTeam(client);
		if (clientTeam != 2 && clientTeam != 3)
			continue;

		new String:communityId[25];
		GetClientAuthId(client, AuthId_SteamID64, communityId, sizeof(communityId));

		for (int i = 0; i < 30; i++)
		{
			if(StrEqual(AreNotUsing[i], ""))
				break;

			if(!StrEqual(AreNotUsing[i], communityId))
				continue;

			ChangeClientTeam(client, 1);
			break;
		}
	}
}