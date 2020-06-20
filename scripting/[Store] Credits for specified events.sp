/* Thanks Kento for public release of Rankme Kento Edition. Took help from his plugins's code"*/

#pragma semicolon 1

#include <multicolors>
#include <sdkhooks>
#include <cstrike>
#include <store>

ConVar gc_bToggleChatMsg,
		gc_iAmountKill,
		gc_iAmountHeadshot, 
		gc_iAmountKnife,
		gc_iAmountBackstab,
		gc_iAmountTaser,
		gc_iAmountHeGrenade,
		gc_iAmountFlash,
		gc_iAmountSmoke,
		gc_iAmountMolotov,
		gc_iAmountDecoy,
		gc_iAmountMVP,
		gc_iAmountPlant,
		gc_iAmountDefuse,
		gc_iAmountAssists,
		gc_iAmountWinner;

char g_sTag[100];

bool g_bToggleChatMsg;
	
int g_iAmountKill,
	g_iAmountHeadshot,
	g_iAmountKnife,
	g_iAmountBackstab,
	g_iAmountTaser,
	g_iAmountHeGrenade,
	g_iAmountFlash,
	g_iAmountSmoke,
	g_iAmountMolotov,
	g_iAmountDecoy,
	g_iAmountMVP,
	g_iAmountPlant,
	g_iAmountDefuse,
	g_iAmountAssists,
	g_iAmountWinner;

public Plugin myinfo = 
{
	name			= 	"[Store][Kxnrl] Credits for specified events",
	author			= 	"Cruze",
	description		= 	"Credits for hs, knife, backstab knife, zeus, grenade, mvp, assists",
	version			= 	"1.1",
	url				= 	"http://steamcommunity.com/profiles/76561198132924835"
}


public void OnPluginStart()
{
	if(GetEngineVersion() != Engine_CSGO && GetEngineVersion() != Engine_CSS) 
		SetFailState("Plugin supports CSS and CS:GO only.");
	
	gc_bToggleChatMsg		=	CreateConVar("sm_cse_chatmsg", 			"1", 		"Print credits messages to chat? 0 to disable.");
	gc_iAmountKill			=	CreateConVar("sm_cse_killamount", 		"1", 		"Amount of credits to give to users killing enemy. 0 to disable.");
	gc_iAmountHeadshot		=	CreateConVar("sm_cse_hsamount", 		"3", 		"Amount of credits to give to users headshotting enemy. 0 to disable.");
	gc_iAmountKnife			=	CreateConVar("sm_cse_knifeamount", 		"10", 		"Amount of credits to give to users knifing enemy. 0 to disable.");
	gc_iAmountBackstab		=	CreateConVar("sm_cse_backstabamount", 	"3", 		"Amount of credits to give to users backstab knifing enemy. 0 to disable.");
	gc_iAmountTaser			=	CreateConVar("sm_cse_taseramount", 		"10", 		"Amount of credits to give to users tasing enemy. 0 to disable.");
	gc_iAmountHeGrenade		=	CreateConVar("sm_cse_hegrenadeamount", 	"3", 		"Amount of credits to give to users hegrenading enemy. 0 to disable.");
	gc_iAmountFlash			=	CreateConVar("sm_cse_flashamount", 		"50", 		"Amount of credits to give to users flash killing enemy. 0 to disable.");
	gc_iAmountSmoke			=	CreateConVar("sm_cse_smokeamount", 		"50", 		"Amount of credits to give to users smoke killing enemy. 0 to disable.");
	gc_iAmountMolotov		=	CreateConVar("sm_cse_molotovamount", 	"5", 		"Amount of credits to give to users molotov/incendiary killing enemy. 0 to disable.");
	gc_iAmountDecoy			=	CreateConVar("sm_cse_decoyamount", 		"50", 		"Amount of credits to give to users decoy killing enemy. 0 to disable.");
	gc_iAmountMVP			=	CreateConVar("sm_cse_mvpamount", 		"5", 		"Amount of credits to give to user who gets mvp. 0 to disable.");
	gc_iAmountPlant			=	CreateConVar("sm_cse_plantamount", 		"3", 		"Amount of credits to give to user who plant c4. 0 to disable.");
	gc_iAmountDefuse		=	CreateConVar("sm_cse_defuseamount", 	"3", 		"Amount of credits to give to user who defuse c4. 0 to disable.");
	gc_iAmountAssists		=	CreateConVar("sm_cse_assistsamount", 	"3", 		"Amount of credits to give to users who get assists on a kill. 0 to disable.");
	gc_iAmountWinner		=	CreateConVar("sm_cse_winneramount", 	"3", 		"Amount of credits to give to users who won round. 0 to disable.");
	
	AutoExecConfig(true, "cruze_creditsforspecifiedevents");
	LoadTranslations("cruze_creditsforspecifiedevents.phrases");

	HookConVarChange(gc_bToggleChatMsg, OnSettingChanged);
	HookConVarChange(gc_iAmountKill, OnSettingChanged);
	HookConVarChange(gc_iAmountHeadshot, OnSettingChanged);
	HookConVarChange(gc_iAmountKnife, OnSettingChanged);
	HookConVarChange(gc_iAmountBackstab, OnSettingChanged);
	HookConVarChange(gc_iAmountTaser, OnSettingChanged);
	HookConVarChange(gc_iAmountHeGrenade, OnSettingChanged);
	HookConVarChange(gc_iAmountFlash, OnSettingChanged);
	HookConVarChange(gc_iAmountSmoke, OnSettingChanged);
	HookConVarChange(gc_iAmountMolotov, OnSettingChanged);
	HookConVarChange(gc_iAmountDecoy, OnSettingChanged);
	HookConVarChange(gc_iAmountMVP, OnSettingChanged);
	HookConVarChange(gc_iAmountPlant, OnSettingChanged);
	HookConVarChange(gc_iAmountDefuse, OnSettingChanged);
	HookConVarChange(gc_iAmountAssists, OnSettingChanged);
	HookConVarChange(gc_iAmountWinner, OnSettingChanged);

	HookEvent("player_death", OnPlayerDeath);
	HookEvent("round_end", RoundEnd);
	HookEventEx("round_mvp", Event_RoundMVP);
	HookEventEx("bomb_planted", Event_BombPlanted);
	HookEventEx("bomb_defused", Event_BombDefused);
	
	for (int client = 1; client <= MaxClients; client++)
	{ 
		if (!IsClientInGame(client))
			continue;
		OnClientPutInServer(client); 
	}
}

public int OnSettingChanged(Handle convar, const char[] oldValue, const char[] newValue)
{
	if (StrEqual(oldValue, newValue, true))
        return;
	
	if (convar == gc_bToggleChatMsg)
	{
		g_bToggleChatMsg = !!StringToInt(newValue);
	}
	else if(convar == gc_iAmountKill)
	{
		g_iAmountKill = StringToInt(newValue);
	}
	else if (convar == gc_iAmountHeadshot)
	{
		g_iAmountHeadshot = StringToInt(newValue);
	}
	else if (convar == gc_iAmountKnife)
	{
		g_iAmountKnife == StringToInt(newValue);
	}
	else if (convar == gc_iAmountBackstab)
	{
		g_iAmountBackstab == StringToInt(newValue);
	}
	else if (convar == gc_iAmountTaser)
	{
		g_iAmountTaser == StringToInt(newValue);
	}
	else if (convar == gc_iAmountHeGrenade)
	{
		g_iAmountHeGrenade == StringToInt(newValue);
	}
	else if (convar == gc_iAmountFlash)
	{
		g_iAmountFlash == StringToInt(newValue);
	}
	else if (convar == gc_iAmountSmoke)
	{
		g_iAmountSmoke == StringToInt(newValue);
	}
	else if (convar == gc_iAmountMolotov)
	{
		g_iAmountMolotov == StringToInt(newValue);
	}
	else if (convar == gc_iAmountDecoy)
	{
		g_iAmountDecoy == StringToInt(newValue);
	}
	else if (convar == gc_iAmountMVP)
	{
		g_iAmountMVP = StringToInt(newValue);
	}
	else if (convar == gc_iAmountPlant)
	{
		g_iAmountPlant = StringToInt(newValue);
	}
	else if (convar == gc_iAmountDefuse)
	{
		g_iAmountDefuse = StringToInt(newValue);
	}
	else if (convar == gc_iAmountAssists)
	{
		g_iAmountAssists = StringToInt(newValue);
	}
	else if (convar == gc_iAmountWinner)
	{
		g_iAmountWinner	= StringToInt(newValue);
	}
}

public void OnConfigsExecuted()
{
	strcopy(g_sTag, sizeof(g_sTag), "[{green}Store{default}]");
	
	g_bToggleChatMsg		= GetConVarBool(gc_bToggleChatMsg);
	g_iAmountKill			= GetConVarInt(gc_iAmountKill);
	g_iAmountHeadshot		= GetConVarInt(gc_iAmountHeadshot);
	g_iAmountKnife			= GetConVarInt(gc_iAmountKnife);
	g_iAmountBackstab		= GetConVarInt(gc_iAmountBackstab);
	g_iAmountTaser			= GetConVarInt(gc_iAmountTaser);
	g_iAmountHeGrenade		= GetConVarInt(gc_iAmountHeGrenade);
	g_iAmountFlash			= GetConVarInt(gc_iAmountFlash);
	g_iAmountSmoke			= GetConVarInt(gc_iAmountSmoke);
	g_iAmountMolotov		= GetConVarInt(gc_iAmountMolotov);
	g_iAmountDecoy			= GetConVarInt(gc_iAmountDecoy);
	g_iAmountMVP			= GetConVarInt(gc_iAmountMVP);
	g_iAmountPlant			= GetConVarInt(gc_iAmountPlant);
	g_iAmountDefuse			= GetConVarInt(gc_iAmountDefuse);
	g_iAmountAssists		= GetConVarInt(gc_iAmountAssists);
	g_iAmountWinner			= GetConVarInt(gc_iAmountWinner);
}

public void OnClientPutInServer(int client)
{
    SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}
public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if (victim < 1 || victim > MaxClients || attacker < 1 || attacker > MaxClients || GetClientTeam(attacker) == GetClientTeam(victim))
		return Plugin_Continue;

	char weapon[64];
	GetClientWeapon(attacker, weapon, sizeof(weapon));
	if(StrContains(weapon, "knife", false) != -1 || StrContains(weapon, "bayonet", false) != -1 || StrContains(weapon, "fists", false) != -1 || StrContains(weapon, "axe", false) != -1 || StrContains(weapon, "hammer", false) != -1 || StrContains(weapon, "spanner", false) != -1 || StrContains(weapon, "melee", false) != -1)
	{
		if (damage > 99.0 && (damagetype & DMG_SLASH) == DMG_SLASH)
		{
			if(g_iAmountBackstab > 0)
			{
				Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountBackstab, "Backstab Knife Kill");
				if(g_bToggleChatMsg)
				{
					//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Backstab Knife{default} kill.", g_sTag, g_iAmountBackstab);
					CPrintToChat(attacker, "%t", "Backstab Knife Kill", g_sTag, g_iAmountBackstab);
				}
			}
		}
	}
	return Plugin_Continue;
	
}

public Action OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	int assister = GetClientOfUserId(GetEventInt(event, "assister"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	
	if (victim == attacker || assister == attacker)
	{
		return Plugin_Continue;
	}

	if(!IsValidClient(attacker) || !IsValidClient(victim))
	{
		return Plugin_Continue;
	}
	
	if(GetClientTeam(victim) == GetClientTeam(attacker))
	{
		return Plugin_Continue;
	}
	
	if(g_iAmountKill > 0)
	{
		Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountKill, "Kill");
		if(g_bToggleChatMsg)
		{
			//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for killing the enemy.", g_sTag, g_iAmountKill);
			CPrintToChat(attacker, "%t","Kill", g_sTag, g_iAmountKill);
		}
	}

	char weapon[64];
	GetEventString(event, "weapon", weapon, sizeof(weapon));

	if(StrContains(weapon, "knife", false) != -1 || StrContains(weapon, "bayonet", false) != -1 || StrContains(weapon, "fists", false) != -1 || StrContains(weapon, "axe", false) != -1 || StrContains(weapon, "hammer", false) != -1 || StrContains(weapon, "spanner", false) != -1 || StrContains(weapon, "melee", false) != -1)
	{
		if(g_iAmountKnife > 0)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountKnife, "Knife Kill");
			if(g_bToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Knife{default} kill.", g_sTag, g_iAmountKnife);
				CPrintToChat(attacker, "%t","Knife Kill", g_sTag, g_iAmountKnife);
			}
		}
	}
	if(StrContains(weapon, "taser") != -1)
	{
		if(g_iAmountTaser > 0)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountTaser, "Taser Kill");
			if(g_bToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountTaser);
				CPrintToChat(attacker, "%t","Taser Kill", g_sTag, g_iAmountTaser);
			}
		}
	}
	if (StrContains(weapon, "hegrenade") != -1)
	{
		if(g_iAmountHeGrenade > 0)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountHeGrenade, "HeGrenade Kill");
			if(g_bToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountHeGrenade);
				CPrintToChat(attacker, "%t","HeGrenade Kill", g_sTag, g_iAmountHeGrenade);
			}
		}
	}
	if (StrContains(weapon, "flashbang") != -1)
	{
		if(g_iAmountFlash > 0)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountFlash, "Flash Grenade Kill");
			if(g_bToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountFlash);
				CPrintToChat(attacker, "%t","Flash Grenade Kill", g_sTag, g_iAmountFlash);
			}
		}
	}
	if (StrContains(weapon, "smokegrenade") != -1)
	{
		if(g_iAmountSmoke > 0)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountSmoke, "Smoke Grenade Kill");
			if(g_bToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountSmoke);
				CPrintToChat(attacker, "%t","Smoke Grenade Kill", g_sTag, g_iAmountSmoke);
			}
		}
	}
	if (StrContains(weapon, "molotov") != -1 || StrContains(weapon, "incgrenade") != -1 || StrContains(weapon, "inferno") != -1)
	{
		if(g_iAmountMolotov > 0)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountMolotov, "Molotov Grenade Kill");
			if(g_bToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountMolotov);
				CPrintToChat(attacker, "%t","Molotov Grenade Kill", g_sTag, g_iAmountMolotov);
			}
		}
	}
	if (StrContains(weapon, "decoy") != -1)
	{
		if(g_iAmountDecoy > 0)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountDecoy, "Decoy Grenade Kill");
			if(g_bToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountDecoy);
				CPrintToChat(attacker, "%t","Decoy Grenade Kill", g_sTag, g_iAmountDecoy);
			}
		}
	}
	if(GetEventBool(event, "headshot"))
	{
		if(g_iAmountHeadshot > 0)
		{
	
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountHeadshot, "Headshot Kill");
			if(g_bToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Headshot{default}.", g_sTag, g_iAmountHeadshot);
				CPrintToChat(attacker, "%t","Headshot Kill", g_sTag, g_iAmountHeadshot);
			}
		}
	}
	if(IsValidClient(assister) && g_iAmountAssists > 0)
	{
		if(GetClientTeam(assister) == GetClientTeam(victim))
			return Plugin_Continue;

		Store_SetClientCredits(assister, Store_GetClientCredits(assister) + g_iAmountAssists, "Assist Kill");
		if(g_bToggleChatMsg)
		{
			//CPrintToChat(assister, "%s You earned {green}%i{default} credits for {red}Assist{default} on a kill.", g_sTag, g_iAmountAssists);
			CPrintToChat(assister, "%t","Assist Kill", g_sTag, g_iAmountAssists);
		}
	}
	return Plugin_Continue;
}

public Action RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	if(g_iAmountWinner > 0)
	{
		int winner = GetEventInt(event, "winner");
		for(int i = 1; i <= MaxClients; i++) if(IsValidClient(i))
		{
			if(GetClientTeam(i) == winner)
			{
				Store_SetClientCredits(i, Store_GetClientCredits(i) + g_iAmountWinner, "Winner Team");
				if(g_bToggleChatMsg)
				{
					//CPrintToChat(i, "%s You earned {green}%i{default} credits for winning this round.", g_sTag, g_iAmountWinner);
					CPrintToChat(i, "%t","Winner Team", g_sTag, g_iAmountWinner);
				}
			}
		}
	}
	return Plugin_Continue;
}
public Action Event_RoundMVP(Handle event, const char[] name, bool dontBroadcast) 
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}
	if(g_iAmountMVP > 0)
	{
		Store_SetClientCredits(client, Store_GetClientCredits(client) + g_iAmountMVP, "MVP");
		if(g_bToggleChatMsg)
		{
			//CPrintToChat(client, "%s You earned {green}%i{default} credits for being the {red}MVP{default}.", g_sTag, g_iAmountMVP);
			CPrintToChat(client, "%t","MVP Kill", g_sTag, g_iAmountMVP);
			//CPrintToChatAll("%s \x03%N\x01 earned {green}%i{default} credits for being {red}MVP{default}.", g_sTag, client, g_iAmountMVP);
			CPrintToChatAll("%t","MVP Kill All", g_sTag, client, g_iAmountMVP);
		}
	}
	return Plugin_Continue;
}
public Action Event_BombPlanted(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}
	if(g_iAmountPlant > 0)
	{
		for (int i = 1; i <= MaxClients; i++) if(IsClientInGame(i))
		{
			Store_SetClientCredits(i, Store_GetClientCredits(i) + g_iAmountPlant, "Bomb Plant");
			if(g_bToggleChatMsg)
			{
				//CPrintToChat(i, "%s You earned {green}%i{default} credits for planting the C4.", g_sTag, g_iAmountPlant);
				CPrintToChat(i, "%t", "Plant Creds", g_sTag, g_iAmountPlant);
			}
		}	
	}
	return Plugin_Continue;
}
public Action Event_BombDefused(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}
	if(g_iAmountDefuse > 0)
	{
		for (int i = 1; i <= MaxClients; i++) if(IsClientInGame(i))
		{
			Store_SetClientCredits(i, Store_GetClientCredits(i) + g_iAmountDefuse, "Bomb Defuse");
			if(g_bToggleChatMsg)
			{
				//CPrintToChat(i, "%s You earned {green}%i{default} credits for defusing the C4.", g_sTag, g_iAmountDefuse);
				CPrintToChat(i, "%t", "Defuse Creds", g_sTag, g_iAmountDefuse);
			}
		}	
	}
	return Plugin_Continue;
}
	
bool IsValidClient(int client)
{
    if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client)) || IsClientSourceTV(client) || IsClientReplay(client))
    {
        return false;
    }
    return true;
}
