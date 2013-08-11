#include "ScriptMgr.h"
#include "Chat.h"
#include "Player.h"

/*
//////////////////////////////////////////
////////////  HASTE BUG ABUSE ////////////
//////////////////////////////////////////
*/
class Custom_HasteBugAbuse : public PlayerScript
{
public:
    Custom_HasteBugAbuse() : PlayerScript("Custom_HasteBugAbuse") { }

	//leveling up with donors fucks up haste, instant casting every spell, kick the player so he can't abuse it
	//prefer to reset the spell, if someone figures it out, replace pPlayer->GetSession()->KickPlayer(); with a reset tging
	void OnLevelChanged(Player* pPlayer, uint8 oldlvl)
	{
		if (pPlayer->getLevel() == 70)
			pPlayer->GetSession()->KickPlayer();
	}
};




/*
//////////////////////////////////////////
////////////SPECIAL PVP TOKENS////////////
//////////////////////////////////////////
*/
//			    SW  Darn  IF  EXO  ORG   UD   SM   TB
int cities[]={1519,1657,1537,3557,1637,1497,3487,1638};
#define HYJALZONE				   616
#define HYJALPVPTOKEN			600000
#define CITYPVPTOKEN			600001
#define KILLINGSTREAKTOKEN 		600009

class Custom_PvPKillHyjalCities : public PlayerScript
{
public:
    Custom_PvPKillHyjalCities() : PlayerScript("Custom_PvPKillHyjalCities") { }

	

	//add custom token when player is in certain zone when they kill a player
	void OnPVPKill(Player* killer, Player* killed)
	{
		if (killer->GetZoneId() == HYJALZONE)
			killer->AddItem(HYJALPVPTOKEN,1);
		for each (int city in cities){
			if (killer->GetZoneId() == city)
				killer->AddItem(CITYPVPTOKEN,1);
		}
	}
};






/*
//////////////////////////////////////////
///////////////KILLSTREAKS////////////////
//////////////////////////////////////////
*/
struct KillStreak_Info
{
	uint32 killstreak;
	uint64 lastkill;
};

static std::map<uint64, KillStreak_Info> KillStreakData;

class Custom_Killingstreak : public PlayerScript
{
	public:
		Custom_Killingstreak() : PlayerScript("Custom_Killingstreak") {}

	void OnPVPKill(Player * Killer, Player * Victim)
	{
		uint64 KillerGUID = Killer->GetGUID();
		uint64 VictimGUID = Victim->GetGUID();

		if( KillerGUID == VictimGUID || KillStreakData[KillerGUID].lastkill == VictimGUID )
			return;

		KillStreakData[KillerGUID].killstreak++;
		KillStreakData[KillerGUID].lastkill = VictimGUID;
		KillStreakData[VictimGUID].killstreak = 0;
		KillStreakData[VictimGUID].lastkill = 0;

		switch( KillStreakData[KillerGUID].killstreak )
		{
			char msg[250];
			/*case 1:
				snprintf(msg, 250, "[PvP System]: %s is on a killstreak of %u!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				break;*/

			/*case 10:
				snprintf(msg, 250, "[PvP System]: %s is on a killstreak of %u!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				break;*/

			case 25:
				snprintf(msg, 250, "[PvP System]: %s is on a killstreak of %u!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				Killer->AddItem(KILLINGSTREAKTOKEN,1);
				break;

			/*case 30:
				snprintf(msg, 250, "[PvP System]: %s is on a killstreak of %u!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				break;

			/*case 40:
				snprintf(msg, 250, "[PvP System]: %s is on a killstreak of %u!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				break;*/

			case 50:
				snprintf(msg, 250, "[PvP System]: %s is on a killstreak of %u!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				Killer->AddItem(KILLINGSTREAKTOKEN,2);
				break;

			case 60:
				snprintf(msg, 250, "[PvP System]: %s is on a killstreak of %u!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				break;

			case 70:
				snprintf(msg, 250, "[PvP System]: %s is on a killstreak of %u!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				break;
			
			case 75:
				Killer->AddItem(KILLINGSTREAKTOKEN,2);
			
			case 80:
				snprintf(msg, 250, "[PvP System]: %s is on a killstreak of %u!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				break;

			case 90:
				snprintf(msg, 250, "[PvP System]: %s is on a killstreak of %u!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				break;

			case 100:
				snprintf(msg, 250, "[PvP System]: %s WON THE KILL STREAK ROUND of %u kills and got 10 tokens as a reward!!!!", Killer->GetName(), KillStreakData[KillerGUID].killstreak);
				sWorld->SendServerMessage(SERVER_MSG_STRING, msg);
				Killer->AddItem(KILLINGSTREAKTOKEN,10);
				break;
		}
	} 
};








/*
//////////////////////////////////////////
/////////////// PVPTITLES ////////////////
//////////////////////////////////////////
*/
class PvPTitles : public PlayerScript
{
     public:
		 PvPTitles() : PlayerScript("PvPTitles") {}

	
		enum HonorKillPvPRank
			{
				HKRANKMAX = 15
			};

		void OnPVPKill(Player *pKiller, Player* /*pVictim*/)
		{
		    /* bool TitleSystemAllowed = sWorld->getBoolConfig(CONFIG_PVP_TITLE_SYSTEM_ENABLE);
			if (!TitleSystemAllowed)
			return;*/

			uint32 pvp_ranks[HKRANKMAX];
			bool Horde = pKiller->GetTeam() == HORDE;

        
			// Get values from config file
			std::string s_pvp_ranks = sWorld->GetPVPRanks();
			char *c_pvp_ranks = const_cast<char*>(s_pvp_ranks.c_str());
			for (int i = 0; i < HKRANKMAX; i++)
			{
				if (!i)
					pvp_ranks[0] = 0;
				else if (i == 1)
					pvp_ranks[i] = atoi(strtok (c_pvp_ranks, ","));
				else
					pvp_ranks[i] = atoi(strtok (NULL, ","));
			}

			// Get HK for players
			uint32 PlayerHonorableKills = pKiller->GetUInt32Value(PLAYER_FIELD_LIFETIME_HONORABLE_KILLS);

			// Get PVP rank
			uint32 PVPRank = 0;
			for (int i = 1; i < HKRANKMAX; i++)
			{
				if (PlayerHonorableKills >= pvp_ranks[i])
					PVPRank = i;
				else
					break;
			}

			// Check if player already have title for his rank, delete all PVP titles if no, add PVP title
			if (PVPRank)
			{
				if (CharTitlesEntry const* PVPTitle = sCharTitlesStore.LookupEntry(Horde ? (PVPRank + HKRANKMAX - 1) : (PVPRank)))
				{
					if (!pKiller->HasTitle(PVPTitle))
					{
						for (int i = 1; i < HKRANKMAX; i++)
						{
							if (CharTitlesEntry const* titleToRemove = sCharTitlesStore.LookupEntry(Horde ? (i + HKRANKMAX - 1) : i))
							{
								pKiller->SetTitle(titleToRemove, true);
								// If current title is selected, deselect
								if (pKiller->GetUInt32Value(PLAYER_CHOSEN_TITLE) == titleToRemove->bit_index)
									pKiller->SetUInt32Value(PLAYER_CHOSEN_TITLE, 0);
							}
						}
						pKiller->SetTitle(PVPTitle, false);
						// If no title is selected, select new title
						if (pKiller->GetUInt32Value(PLAYER_CHOSEN_TITLE) == 0)
							pKiller->SetUInt32Value(PLAYER_CHOSEN_TITLE, PVPTitle->bit_index);
					}
					for (uint32 i = 1; i <= PVPRank; i++)
						pKiller->UpdateAchievementCriteria(ACHIEVEMENT_CRITERIA_TYPE_OWN_RANK,i,i);
				}
			}
		}
};








class Custom_PVPSpellResetOnDuelEnd : public PlayerScript
{
    public:
        Custom_PVPSpellResetOnDuelEnd() : PlayerScript("Custom_PVPSpellResetOnDuelEnd") {}

    void OnDuelEnd(Player *winner, Player *looser, DuelCompleteType type)
    {
        //bool ResetAllowed = sWorld->getBoolConfig(CONFIG_RESET_SPELLS_AFTER_DUEL);

		// no forfeit or fleeing, no hyjal
		if (type != DUEL_INTERRUPTED && type != DUEL_FLED && winner->GetZoneId()!=616 && looser->GetZoneId()!=616){
		 if (winner && winner->IsInWorld() && winner->IsAlive()){
            winner->RemoveArenaSpellCooldowns();
            winner->SetHealth(winner->GetMaxHealth());
            winner->SetPower(POWER_MANA, winner->GetMaxPower(POWER_MANA));
			}
        if (looser && looser->IsInWorld() && looser->IsAlive()){
            looser->RemoveArenaSpellCooldowns();
            looser->SetHealth(looser->GetMaxHealth());
            looser->SetPower(POWER_MANA, looser->GetMaxPower(POWER_MANA));
			}
		}else{
			return;
		}
	}
};




void AddSC_Custom_PlayerScript()
{
	new Custom_HasteBugAbuse();
	new Custom_Killingstreak();
	new Custom_PvPKillHyjalCities();
	new PvPTitles(); //old script from ela
	new Custom_PVPSpellResetOnDuelEnd();
}



/*

    \.
     \'.      ;.
      \ '. ,--''-.~-~-'-,
       \,-' ,-.   '.~-~-~~,
     ,-'   (###)    \-~'~=-.
 _,-'       '-'      \=~-"~~',
/o                    \~-""~=-,
\__                    \=-,~"-~,
   """===-----.         \~=-"~-.
               \         \*=~-"
          CM    \         "=====----
                 \
                  \


CREDITS FOR CELTIC/HAIRY/LUNA/DEVA


*/














