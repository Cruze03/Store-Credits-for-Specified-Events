/* Thanks Kento for public release of Rankme Kento Edition. Took help from his plugins's code"*/

#pragma semicolon 1
//#pragma newdecls required

#include <colorvariables>
#include <sdkhooks>
#include <store>

ConVar gc_sToggleChatMsg,
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
		gc_iAmountAssists,
		gc_sTag;

char g_sTag[32], weapon[32];

bool g_sToggleChatMsg;
	
int g_iAmountHeadshot,
	g_iAmountKnife,
	g_iAmountBackstab,
	g_iAmountTaser,
	g_iAmountHeGrenade,
	g_iAmountFlash,
	g_iAmountSmoke,
	g_iAmountMolotov,
	g_iAmountDecoy,
	g_iAmountMVP,
	g_iAmountAssists;

public Plugin myinfo = 
{
	name				= 	"[Store] Credits for specified events",
	author			= 	"Cruze",
	description		= 	"Credits for hs, knife, backstab knife, zeus, grenade, mvp, assists",
	version			= 	"1.13.5",
	url				= 	"http://steamcommunity.com/profiles/76561198132924835"
}


public void OnPluginStart()
{
	if(GetEngineVersion() != Engine_CSGO && GetEngineVersion() != Engine_CSS) 
		SetFailState("Plugin supports CSS and CS:GO only.");
	
	gc_sToggleChatMsg		=	CreateConVar("sm_cse_chatmsg", 			"1", 		"Print credits messages to chat? 0 to disable.");
	gc_iAmountHeadshot		=	CreateConVar("sm_cse_hsamount", 			"3", 		"Amount of credits to give to users headshotting enemy. 0 to disable.");
	gc_iAmountKnife			=	CreateConVar("sm_cse_knifeamount", 		"10", 		"Amount of credits to give to users knifing enemy. 0 to disable.");
	gc_iAmountBackstab		=	CreateConVar("sm_cse_backstabamount", 	"3", 		"Amount of credits to give to users backstab knifing enemy. 0 to disable.");
	gc_iAmountTaser			=	CreateConVar("sm_cse_taseramount", 		"10", 		"Amount of credits to give to users tasing enemy. 0 to disable.");
	gc_iAmountHeGrenade	=	CreateConVar("sm_cse_hegrenadeamount", 	"3", 		"Amount of credits to give to users hegrenading enemy. 0 to disable.");
	gc_iAmountFlash			=	CreateConVar("sm_cse_flashamount", 		"50", 		"Amount of credits to give to users flash killing enemy. 0 to disable.");
	gc_iAmountSmoke			=	CreateConVar("sm_cse_smokeamount", 		"50", 		"Amount of credits to give to users smoke killing enemy. 0 to disable.");
	gc_iAmountMolotov		=	CreateConVar("sm_cse_molotovamount", 	"5", 		"Amount of credits to give to users molotov/incendiary killing enemy. 0 to disable.");
	gc_iAmountDecoy			=	CreateConVar("sm_cse_decoyamount", 		"50", 		"Amount of credits to give to users decoy killing enemy. 0 to disable.");
	gc_iAmountMVP			=	CreateConVar("sm_cse_mvpamount", 		"5", 		"Amount of credits to give to user who gets mvp. 0 to disable.");
	gc_iAmountAssists		=	CreateConVar("sm_cse_assistsamount", 	"3", 		"Amount of credits to give to users who get assists on a kill. 0 to disable.");
	
	AutoExecConfig(true, "cruze_creditsforspecifiedevents");
	LoadTranslations("cruze_creditsforspecifiedevents.phrases");
	
	HookConVarChange(gc_sToggleChatMsg, OnSettingChanged);
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
	HookConVarChange(gc_iAmountAssists, OnSettingChanged);

	HookEvent("player_death", OnPlayerDeath);
	HookEventEx("round_mvp", Event_RoundMVP);
	
	for (int client = 1; client <= MaxClients; client++)
	{ 
		if (!IsClientInGame(client))
			continue;

		OnClientPutInServer(client); 
         
	}
}

public int OnSettingChanged(Handle convar, const char[] oldValue, const char[] newValue)
{
	if (convar == gc_sToggleChatMsg)
	{
		g_sToggleChatMsg = !!StringToInt(newValue);
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
	else if (convar == gc_iAmountAssists)
	{
		g_iAmountAssists = StringToInt(newValue);
	}
}

public void OnConfigsExecuted()
{
	gc_sTag = FindConVar("sm_store_chat_tag");
	gc_sTag.GetString(g_sTag, sizeof(g_sTag));
	
	g_sToggleChatMsg		= GetConVarBool(gc_sToggleChatMsg);
	g_iAmountHeadshot		= GetConVarInt(gc_iAmountHeadshot);
	g_iAmountKnife			= GetConVarInt(gc_iAmountKnife);
	g_iAmountBackstab		= GetConVarInt(gc_iAmountBackstab);
	g_iAmountTaser			= GetConVarInt(gc_iAmountTaser);
	g_iAmountHeGrenade		= GetConVarInt(gc_iAmountHeGrenade);
	g_iAmountFlash			= GetConVarInt(gc_iAmountFlash);
	g_iAmountSmoke			= GetConVarInt(gc_iAmountSmoke);
	g_iAmountMolotov		= GetConVarInt(gc_iAmountMolotov);
	g_iAmountDecoy			= GetConVarInt(gc_iAmountDecoy);
	g_iAmountMVP				= GetConVarInt(gc_iAmountMVP);
	g_iAmountAssists		= GetConVarInt(gc_iAmountAssists);
}

public void OnClientPutInServer(int client)
{
    SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}
public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if (victim < 1 || victim > MaxClients || attacker < 1 || attacker > MaxClients || GetClientTeam(attacker) == GetClientTeam(victim))
		return Plugin_Continue;

	GetClientWeapon(attacker, weapon, sizeof(weapon));
	if(StrContains(weapon, "knife") != -1 || StrContains(weapon, "knife_default_ct") != -1 || StrContains(weapon, "knife_default_t") != -1 || StrContains(weapon, "knife_t") != -1 || StrContains(weapon, "knifegg") != -1 || StrContains(weapon, "knife_flip") != -1 || StrContains(weapon, "knife_gut") != -1 || StrContains(weapon, "knife_karambit") != -1 || StrContains(weapon, "bayonet") != -1 || StrContains(weapon, "knife_m9_bayonet") != -1 || StrContains(weapon, "knife_butterfly") != -1 || StrContains(weapon, "knife_tactical") != -1 || StrContains(weapon, "knife_falchion") != -1 || StrContains(weapon, "knife_push") != -1 || StrContains(weapon, "knife_survival_bowie") != -1 || StrContains(weapon, "knife_ursus") != -1 || StrContains(weapon, "knife_gypsy_jackknife") != -1 || StrContains(weapon, "knife_stiletto") != -1 || StrContains(weapon, "knife_widowmaker") != -1)
	{
		if (damage > 99.0 && (damagetype & DMG_SLASH) == DMG_SLASH)
		{
			if(IsValidClient(attacker) && g_iAmountBackstab > 1)
			{
				if(g_sToggleChatMsg)
				{
					//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Backstab Knife{default} kill.", g_sTag, g_iAmountBackstab);
					CPrintToChat(attacker, "%t", "Backstab Knife Kill", g_sTag, g_iAmountBackstab);
				}
				Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountBackstab);
			}
		}
	}
	return Plugin_Continue;
	
}

public void OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	int assister = GetClientOfUserId(GetEventInt(event, "assister"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	
	if (victim == attacker)
		return;

	if(assister == attacker)
		return;

	if(IsValidClient(attacker) && IsValidClient(victim))
	{
		if(GetClientTeam(victim) == GetClientTeam(attacker))
			return;
	}

	GetEventString(event, "weapon", weapon, sizeof(weapon));

	if(StrContains(weapon, "knife") != -1 || StrContains(weapon, "knife_default_ct") != -1 || StrContains(weapon, "knife_default_t") != -1 || StrContains(weapon, "knife_t") != -1 || StrContains(weapon, "knifegg") != -1 || StrContains(weapon, "knife_flip") != -1 || StrContains(weapon, "knife_gut") != -1 || StrContains(weapon, "knife_karambit") != -1 || StrContains(weapon, "bayonet") != -1 || StrContains(weapon, "knife_m9_bayonet") != -1 || StrContains(weapon, "knife_butterfly") != -1 || StrContains(weapon, "knife_tactical") != -1 || StrContains(weapon, "knife_falchion") != -1 || StrContains(weapon, "knife_push") != -1 || StrContains(weapon, "knife_survival_bowie") != -1 || StrContains(weapon, "knife_ursus") != -1 || StrContains(weapon, "knife_gypsy_jackknife") != -1 || StrContains(weapon, "knife_stiletto") != -1 || StrContains(weapon, "knife_widowmaker") != -1)
	{
		if(IsValidClient(attacker) && g_iAmountKnife > 1)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountKnife);
			
			if(g_sToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Knife{default} kill.", g_sTag, g_iAmountKnife);
				CPrintToChat(attacker, "%t","Knife Kill", g_sTag, g_iAmountKnife);
			}
		}
	}
	if(StrContains(weapon, "taser") != -1)
	{
		if(IsValidClient(attacker) && g_iAmountTaser > 1)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountTaser);
			
			if(g_sToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountTaser);
				CPrintToChat(attacker, "%t","Taser Kill", g_sTag, g_iAmountTaser);
			}
		}
	}
	if (StrContains(weapon, "hegrenade") != -1)
	{
		if(IsValidClient(attacker) &&  g_iAmountHeGrenade > 1)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountHeGrenade);
			
			if(g_sToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountHeGrenade);
				CPrintToChat(attacker, "%t","HeGrenade Kill", g_sTag, g_iAmountHeGrenade);
			}
		}
	}
	if (StrContains(weapon, "flashbang") != -1)
	{
		if(IsValidClient(attacker) &&  g_iAmountFlash > 1)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountFlash);
			
			if(g_sToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountFlash);
				CPrintToChat(attacker, "%t","Flash Grenade Kill", g_sTag, g_iAmountFlash);
			}
		}
	}
	if (StrContains(weapon, "smokegrenade") != -1)
	{
		if(IsValidClient(attacker) &&  g_iAmountSmoke > 1)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountSmoke);
			
			if(g_sToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountSmoke);
				CPrintToChat(attacker, "%t","Smoke Grenade Kill", g_sTag, g_iAmountSmoke);
			}
		}
	}
	if (StrContains(weapon, "molotov") != -1 || StrContains(weapon, "incgrenade") != -1 || StrContains(weapon, "inferno") != -1)
	{
		if(IsValidClient(attacker) &&  g_iAmountMolotov > 1)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountMolotov);
			
			if(g_sToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountMolotov);
				CPrintToChat(attacker, "%t","Molotov Grenade Kill", g_sTag, g_iAmountMolotov);
			}
		}
	}
	if (StrContains(weapon, "decoy") != -1)
	{
		if(IsValidClient(attacker) &&  g_iAmountDecoy > 1)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountDecoy);
			
			if(g_sToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_iAmountDecoy);
				CPrintToChat(attacker, "%t","Decoy Grenade Kill", g_sTag, g_iAmountDecoy);
			}
		}
	}
	if(GetEventBool(event, "headshot"))
	{
		if(IsValidClient(attacker) && g_iAmountHeadshot > 1)
		{
	
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_iAmountHeadshot);
			
			if(g_sToggleChatMsg)
			{
				//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Headshot{default}.", g_sTag, g_iAmountHeadshot);
				CPrintToChat(attacker, "%t","Headshot Kill", g_sTag, g_iAmountHeadshot);
			}
		}
	}
	if(IsValidClient(victim) && IsValidClient(assister) && g_iAmountAssists > 1)
	{
		if(GetClientTeam(assister) == GetClientTeam(victim))
			return;
		Store_SetClientCredits(assister, Store_GetClientCredits(assister) + g_iAmountAssists);
			
		if(g_sToggleChatMsg)
		{
			//CPrintToChat(assister, "%s You earned {green}%i{default} credits for {red}Assist{default} on a kill.", g_sTag, g_iAmountAssists);
			CPrintToChat(assister, "%t","Assist Kill", g_sTag, g_iAmountAssists);
		}
	}
}
public Action Event_RoundMVP(Handle event, const char[] name, bool dontBroadcast) 
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(IsValidClient(client) && g_iAmountMVP > 1)
	{
		Store_SetClientCredits(client, Store_GetClientCredits(client) + g_iAmountMVP);

		if(g_sToggleChatMsg)
		{
			char PlayerName[MAX_NAME_LENGTH];
			GetClientName(client, PlayerName, sizeof(PlayerName));
			//CPrintToChat(client, "%s You earned {green}%i{default} credits for being the {red}MVP{default}.", g_sTag, g_iAmountMVP);
			CPrintToChat(client, "%t","MVP Kill", g_sTag, g_iAmountMVP);
			//CPrintToChatAll("%s \x03%s\x01 earned {green}%i{default} credits for being {red}MVP{default}.", g_sTag, PlayerName, g_iAmountMVP);
			CPrintToChatAll("%t","MVP Kill All", g_sTag, PlayerName, g_iAmountMVP);
		}
	}
}
	
bool IsValidClient(client, bool bAllowBots = true, bool bAllowDead = true)
{
    if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client) && !bAllowBots) || IsClientSourceTV(client) || IsClientReplay(client) || (!bAllowDead && !IsPlayerAlive(client)))
    {
        return false;
    }
    return true;
}
