/* Thanks Kento for public release of Rankme Kento Edition. Took help from his plugins's code"*/

#pragma semicolon 1
//#pragma newdecls required

#include <colorvariables>
#include <store>

ConVar CSE_AmountHeadshot, 
		CSE_AmountKnife,
		CSE_AmountTaser,
		CSE_AmountMVP,
		CSE_AmountAssists,
		gc_sTag;

char g_sTag[32], weapon[32];
	
int g_AmountHeadshot,
	g_AmountKnife,
	g_AmountTaser,
	g_AmountMVP,
	g_AmountAssists;

public Plugin myinfo = 
{
	name				= 	"[Store] Credits for specified events",
	author			= 	"Cruze",
	description		= 	"Credits for hs, knife, zeus, mvp, assists",
	version			= 	"1.0",
	url				= 	""
}


public void OnPluginStart()
{
	if(GetEngineVersion() != Engine_CSGO && GetEngineVersion() != Engine_CSS) 
		SetFailState("Plugin supports CSS and CS:GO only.");
	
	CSE_AmountHeadshot		=	CreateConVar("cse_hsamount", 		"3", 		"Amount of credits to give to users headshotting enemy. 0 to disable.");
	CSE_AmountKnife			=	CreateConVar("cse_knifeamount", 		"10", 		"Amount of credits to give to users knifing enemy. 0 to disable.");
	CSE_AmountTaser			=	CreateConVar("cse_taseramount", 		"10", 		"Amount of credits to give to users tasing enemy. 0 to disable.");
	CSE_AmountMVP			=	CreateConVar("cse_mvpamount", 		"5", 		"Amount of credits to give to user who gets mvp. 0 to disable.");
	CSE_AmountAssists		=	CreateConVar("cse_assistsamount", 	"3", 		"Amount of credits to give to users who get assists on a kill. 0 to disable.");
	
	AutoExecConfig(true, "cruze_creditsforspecifiedevents");
	LoadTranslations("cruze_creditsforspecifiedevents.phrases");
	
	g_AmountHeadshot	= GetConVarInt(CSE_AmountHeadshot);
	g_AmountKnife		= GetConVarInt(CSE_AmountKnife);
	g_AmountTaser		= GetConVarInt(CSE_AmountTaser);
	g_AmountMVP			= GetConVarInt(CSE_AmountMVP);
	g_AmountAssists		= GetConVarInt(CSE_AmountAssists);
	
	HookEvent("player_death", OnPlayerDeath);
	HookEventEx("round_mvp", Event_RoundMVP);
}

public OnConfigsExecuted()
{
	gc_sTag = FindConVar("sm_store_chat_tag");
	gc_sTag.GetString(g_sTag, sizeof(g_sTag));
	
	HookConVarChange(CSE_AmountHeadshot, OnSettingChanged);
	HookConVarChange(CSE_AmountKnife, OnSettingChanged);
	HookConVarChange(CSE_AmountTaser, OnSettingChanged);
	HookConVarChange(CSE_AmountMVP, OnSettingChanged);
	HookConVarChange(CSE_AmountAssists, OnSettingChanged);
}

public int OnSettingChanged(Handle convar, const char[] oldValue, const char[] newValue)
{
	if (convar == CSE_AmountHeadshot)
	{
		g_AmountHeadshot = StringToInt(newValue);
	}
	else if (convar == CSE_AmountKnife)
	{
		g_AmountKnife == StringToInt(newValue);
	}
	else if (convar == CSE_AmountTaser)
	{
		g_AmountTaser == StringToInt(newValue);
	}
	else if (convar == CSE_AmountMVP)
	{
		g_AmountMVP = StringToInt(newValue);
	}
	else if (convar == CSE_AmountAssists)
	{
		g_AmountAssists = StringToInt(newValue);
	}
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
	

	GetEventString(event, "weapon", weapon, sizeof(weapon));

	if(StrContains(weapon, "knife") != -1 || StrContains(weapon, "knife_default_ct") != -1 || StrContains(weapon, "knife_default_t") != -1 || StrContains(weapon, "knife_t") != -1 || StrContains(weapon, "knifegg") != -1 || StrContains(weapon, "knife_flip") != -1 || StrContains(weapon, "knife_gut") != -1 || StrContains(weapon, "knife_karambit") != -1 || StrContains(weapon, "bayonet") != -1 || StrContains(weapon, "knife_m9_bayonet") != -1 || StrContains(weapon, "knife_butterfly") != -1 || StrContains(weapon, "knife_tactical") != -1 || StrContains(weapon, "knife_falchion") != -1 || StrContains(weapon, "knife_push") != -1 || StrContains(weapon, "knife_survival_bowie") != -1 || StrContains(weapon, "knife_ursus") != -1 || StrContains(weapon, "knife_gypsy_jackknife") != -1 || StrContains(weapon, "knife_stiletto") != -1 || StrContains(weapon, "knife_widowmaker") != -1)
	{
		if(IsValidClient(attacker) && g_AmountKnife > 1)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_AmountKnife);
			
			//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Knife{default} kill.", g_sTag, g_AmountKnife);
			CPrintToChat(attacker, "%t","Knife Kill", g_sTag, g_AmountKnife);
		}
	}
	if(StrContains(weapon, "taser") != -1)
	{
		if(IsValidClient(attacker) && g_AmountTaser > 1)
		{
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_AmountTaser);
			
			//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Zeus{default} kill.", g_sTag, g_AmountTaser);
			CPrintToChat(attacker, "%t","Taser Kill", g_sTag, g_AmountTaser);
		}
	}
	if(GetEventBool(event, "headshot"))
	{
		if(IsValidClient(attacker) && g_AmountHeadshot > 1)
		{
	
			Store_SetClientCredits(attacker, Store_GetClientCredits(attacker) + g_AmountHeadshot);
			
			//CPrintToChat(attacker, "%s You earned {green}%i{default} credits for {red}Headshot{default}.", g_sTag, g_AmountHeadshot);
			CPrintToChat(attacker, "%t","Headshot Kill", g_sTag, g_AmountHeadshot);
		}
	}
	if(IsValidClient(assister) && g_AmountAssists > 1)
	{
		Store_SetClientCredits(assister, Store_GetClientCredits(assister) + g_AmountAssists);
			
		//CPrintToChat(assister, "%s You earned {green}%i{default} credits for {red}Assist{default} on a kill.", g_sTag, g_AmountAssists);
		CPrintToChat(assister, "%t","Assist Kill", g_sTag, g_AmountAssists);
	}
}
public Action Event_RoundMVP(Handle event, const char[] name, bool dontBroadcast) 
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(IsValidClient(client) && g_AmountMVP > 1)
	{
		Store_SetClientCredits(client, Store_GetClientCredits(client) + g_AmountMVP);

		char PlayerName[MAX_NAME_LENGTH];
		GetClientName(client, PlayerName, sizeof(PlayerName));
		//CPrintToChat(client, "%s You earned {green}%i{default} credits for being the {red}MVP{default}.", g_sTag, g_AmountMVP);
		CPrintToChat(client, "%t","MVP Kill", g_sTag, g_AmountMVP);
		//CPrintToChatAll("%s \x03%s\x01 earned {green}%i{default} credits for being {red}MVP{default}.", g_sTag, PlayerName, g_AmountMVP);
		CPrintToChatAll("%t","MVP Kill All", g_sTag, PlayerName, g_AmountMVP);
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
