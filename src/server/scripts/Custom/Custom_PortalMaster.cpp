#include "ScriptPCH.h"


enum eRidingSkills
{
	RIDING_APPRENTICE = 33388,
	RIDING_JOURNEYMAN = 33391,
	RIDING_EXPERT = 34090,
	RIDING_ARTISAN = 34091,
	COLD_WEATHER_FLYING = 54197
};

enum HonorKillPvPRank
    {
        HKRANKMAX = 15
    };	

class celtic_portalmaster : public CreatureScript
{
public:
	celtic_portalmaster()
		: CreatureScript("celtic_portalmaster"){}

	struct celtic_portalmasterAI : public ScriptedAI{

		celtic_portalmasterAI(Creature *c) : ScriptedAI(c){}
		
		void Reset(){
			me->RestoreFaction();
		}

		void EnterEvadeMode(){
			me->GetMotionMaster()->Clear();
			ScriptedAI::EnterEvadeMode();
		}


	};

	CreatureAI* GetAI(Creature* pCreature) const
	{
		return new celtic_portalmasterAI(pCreature);
	}

	void CreatureWhisperBasedOnBool(const char *text, Creature *pCreature, Player *pPlayer, bool value)
	{
		if (value)
			pCreature->MonsterWhisper(text, pPlayer->GetGUID());
	}

	uint32 PlayerMaxLevel() const
	{
		return sWorld->getIntConfig(CONFIG_MAX_PLAYER_LEVEL);
	}

	void RemoveEnchant(Player* player, Item* item)
	{
        if (!item)
        {
                player->GetSession()->SendNotification("You don't have the item equipped?");
                return;
        }
        item->ClearEnchantment(PERM_ENCHANTMENT_SLOT);
        player->GetSession()->SendNotification("Enchant has been removed!");
	}

	void MainMenu(Player *pPlayer, Creature *pCreature)
	{
		//pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Teleport Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Cities", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 12);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Arenas", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 28);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Dungeons", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 32);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Raids", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 79);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Blizzard Zones", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 106);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Custom Zones", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 200);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
		//pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Learn All Spells", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1000);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Player Tools", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2000);
		pPlayer->SEND_GOSSIP_MENU(907, pCreature->GetGUID());
	}

	bool PlayerHasItemOrSpell(const Player *plr, uint32 itemId, uint32 spellId) const
	{
		return plr->HasItemCount(itemId, 1, true) || plr->HasSpell(spellId);
	}

	bool OnGossipHello(Player* pPlayer, Creature* pCreature)
	{
		//pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Teleport Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Cities", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 12);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Arenas", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 28);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Dungeons", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 32);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Raids", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 79);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Blizzard Zones", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 106);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Custom Zones", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 200);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
		//pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Learn All Spells", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1000);
		pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Player Tools", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2000);
		pPlayer->PlayerTalkClass->SendGossipMenu(907, pCreature->GetGUID());


		return true;
	}




	void CreatureWhisperBasedOnRidingSkill(Creature *pCreature, const Player *pPlayer, eRidingSkills skill)
	{
		const uint64 &plrGuid = pPlayer->GetGUID();

		switch (skill)
		{
		case RIDING_APPRENTICE:
			pCreature->MonsterWhisper("I taught you Apprentice riding!", plrGuid);
			break;
		case RIDING_JOURNEYMAN:
			pCreature->MonsterWhisper("I taught you Journeyman riding!", plrGuid);
			break;
		case RIDING_EXPERT:
			pCreature->MonsterWhisper("I taught you Expert riding!", plrGuid);
			break;
		case RIDING_ARTISAN:
			pCreature->MonsterWhisper("I taught you Artisan riding!", plrGuid);
			break;
		case COLD_WEATHER_FLYING:
			pCreature->MonsterWhisper("I taught you Cold Weather Flying!",plrGuid);
		}
	}

	void GiveRidingSkill(Player *pPlayer, Creature *pCreature)
	{
		if (pPlayer->getLevel() <= 19)
			pCreature->MonsterWhisper("Your level is not high enough!", pPlayer->GetGUID());
		else if (pPlayer->getLevel() >= 20 && pPlayer->getLevel() <= 39)
		{
			if (pPlayer->HasSpell(RIDING_APPRENTICE))
				pCreature->MonsterWhisper("You already know Apprentice riding!", pPlayer->GetGUID());
			else
			{
				pPlayer->learnSpell(RIDING_APPRENTICE, false);
				CreatureWhisperBasedOnRidingSkill(pCreature, pPlayer, RIDING_APPRENTICE);
			}
		}
		else if (pPlayer->getLevel() >= 40 && pPlayer->getLevel() <= 59)
		{
			if (pPlayer->HasSpell(RIDING_JOURNEYMAN))
				pCreature->MonsterWhisper("You already know Journeyman riding!", pPlayer->GetGUID());
			else
			{
				pPlayer->learnSpell(RIDING_JOURNEYMAN, false);
				CreatureWhisperBasedOnRidingSkill(pCreature, pPlayer, RIDING_JOURNEYMAN);
			}
		}
		else if (pPlayer->getLevel() >= 60 && pPlayer->getLevel() <= 69)
		{
			if (pPlayer->HasSpell(RIDING_EXPERT))
				pCreature->MonsterWhisper("You already know Expert riding!", pPlayer->GetGUID());
			else
			{
				pPlayer->learnSpell(RIDING_EXPERT, false);
				CreatureWhisperBasedOnRidingSkill(pCreature, pPlayer, RIDING_EXPERT);
			}
		}
		else if (pPlayer->getLevel() >= 70 && pPlayer->getLevel() <=76)
		{
			if (pPlayer->HasSpell(RIDING_ARTISAN))
				pCreature->MonsterWhisper("You already know Artisan riding!", pPlayer->GetGUID());
			else
			{
				pPlayer->learnSpell(RIDING_ARTISAN, false);
				CreatureWhisperBasedOnRidingSkill(pCreature, pPlayer, RIDING_ARTISAN);
			}
		}
		else if (pPlayer->getLevel() >= 77)
		{
			if (pPlayer->HasSpell(COLD_WEATHER_FLYING))
				pCreature->MonsterWhisper("You already know Cold Weather Flying!", pPlayer->GetGUID());
			else
			{
				pPlayer->learnSpell(COLD_WEATHER_FLYING, false);
				CreatureWhisperBasedOnRidingSkill(pCreature, pPlayer, COLD_WEATHER_FLYING);
			}
		}

	}
	


	void WhisperKillsNeeded(Player *pPlayer, Creature *pCreature){
		uint32 pvp_ranks[HKRANKMAX];
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
			uint32 PlayerHonorableKills = pPlayer->GetUInt32Value(PLAYER_FIELD_LIFETIME_HONORABLE_KILLS);
			// Get PVP rank
			uint32 PVPRank = 0;
			for (int i = 1; i < HKRANKMAX; i++)
			{
                if (PlayerHonorableKills >= pvp_ranks[i]){
                        PVPRank = i;
				}
                else
                        break;
			}
			uint32 missingKills = pvp_ranks[PVPRank+1] - PlayerHonorableKills;
			std::stringstream str;
			str << "Missing kills till next pvp rank: ";
			str << missingKills;
			str << ".";
			pCreature->MonsterWhisper(str.str().c_str(), pPlayer->GetGUID());
	}


	bool OnGossipSelect(Player* pPlayer, Creature* pCreature, uint32 /*uiSender*/, uint32 uiAction)
	{
		if (pPlayer->IsInCombat()){
			pCreature->MonsterWhisper("You are in combat noob. Go die, or be a true paladin and bubble hs, while you still can.", pPlayer->GetGUID());
			pCreature->MonsterSay("Kill " && pPlayer->GetName().c_str(),LANG_UNIVERSAL, NULL);
			pCreature->CastSpell(pPlayer,6770,true);
			pCreature->CastSpell(pPlayer,53338, true);
			pPlayer->CLOSE_GOSSIP_MENU();
			return true;
		}

		pPlayer->PlayerTalkClass->ClearMenus();

		switch (uiAction)
		{

		case GOSSIP_ACTION_INFO_DEF + 3000:
			MainMenu(pPlayer, pCreature);
			break;

		case GOSSIP_ACTION_INFO_DEF + 2000:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Learn All Spells", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1000);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "I want to repair my items.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2001);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Advance my weapon skills to max.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2002);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove ressurection sickness.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2003);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Give me maximum riding skill.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2004);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Kills needed for Next PvP Title", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2005);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "I wanna get DRUNK!.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2006);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Ugh, Sober me up, I've had enough...", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2007);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant from select item", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2010);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;


		case GOSSIP_ACTION_INFO_DEF + 2001:
			pPlayer->DurabilityRepairAll(false, 0.0f, true);
			pCreature->MonsterWhisper("I repaired all your items, including items from bank.", pPlayer->GetGUID());
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2000);
			break;


		case GOSSIP_ACTION_INFO_DEF + 2002:
			pPlayer->UpdateSkillsToMaxSkillsForLevel();
			pCreature->MonsterWhisper("Your weapon skills have been advanced to the maximum level.", pPlayer->GetGUID());
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;

		case GOSSIP_ACTION_INFO_DEF + 2003:{
			if (pPlayer->HasAura(15007)){
				pPlayer->RemoveAura(15007);
				pCreature->MonsterWhisper("I have removed your ressurection sickness.", pPlayer->GetGUID());
			}
			else{
				pCreature->MonsterWhisper("You don't have ressurection sickness.", pPlayer->GetGUID());}
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;
										   }

		case GOSSIP_ACTION_INFO_DEF + 2004:
			GiveRidingSkill(pPlayer, pCreature);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;



		case GOSSIP_ACTION_INFO_DEF + 2005:
			pPlayer->CLOSE_GOSSIP_MENU();
			WhisperKillsNeeded(pPlayer, pCreature);
			break;


		case GOSSIP_ACTION_INFO_DEF + 2006:
			pPlayer->SetDrunkValue(255, 9);
			pCreature->MonsterSay("Sweet... You're drunk now!", LANG_UNIVERSAL, NULL);
			pPlayer->CLOSE_GOSSIP_MENU();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2007:
			pPlayer->SetDrunkValue(0, 9);
			pCreature->MonsterSay("It's never to late to get drunk again, homeboy!", LANG_UNIVERSAL, NULL);
			pPlayer->CLOSE_GOSSIP_MENU();
			break;

		case GOSSIP_ACTION_INFO_DEF + 2010:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Head", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2011);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Shoulders", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2012);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Cloak", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2013);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Chest", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2014);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Waist", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2015);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Wrists", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2016);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Feet", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2017);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Hands", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2018);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Legs", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2019);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Ring (Upper)", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2020);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Ring (Lower)", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2021);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Main Hand (1H-Weapon, 2H-Weapon)", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2022);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Offhand (1H-Weapon/Shield)", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2023);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Remove enchant: Ranged ((Cross)Bows/Guns)", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2024);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2000);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Main menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;


		case GOSSIP_ACTION_INFO_DEF + 2011:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_HEAD));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2012:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_SHOULDERS));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2013:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_BACK));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2014:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_CHEST));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2015:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_WAIST));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2016:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_WRISTS));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2017:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_FEET));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2018:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_HANDS));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2019:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_LEGS));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2020:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_FINGER1));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2021:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_FINGER2));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2022:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_MAINHAND));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2023:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_OFFHAND));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;
		case GOSSIP_ACTION_INFO_DEF + 2024:
			RemoveEnchant(pPlayer, pPlayer->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_RANGED));
            pPlayer->PlayerTalkClass->SendCloseGossip();
			break;





		case GOSSIP_ACTION_INFO_DEF + 2:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Cities", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 12);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Arenas", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 28);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Dungeons", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 32);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Raids", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 79);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Zones", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 106);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Custom", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 200);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Main menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break ;

			//CITIES
		case GOSSIP_ACTION_INFO_DEF + 12:
			switch (pPlayer->GetTeam())
			{
			case HORDE:
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Orgrimmar", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 13);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Thunderbluff", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 14);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Silvermoon", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 15);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Undercity", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 16);

				break;
			case ALLIANCE:
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Stormwind", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 17);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Ironforge", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 18);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Exodar", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 19);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Darnassus", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 20);
				break;
			}
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Booty Bay", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 24);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Gadgetzan", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 25);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Shattrath", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 23);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Dalaran", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 22);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 13:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 1629.36f, -4373.39f, 31.2564f, 3.54839f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 14:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -1277.37f, 124.804f, 131.287f, 5.22274f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 15:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 9487.69f, -7279.2f, 14.2866f, 6.16478f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 16:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, 1584.07f, 241.987f, -52.1534f, 0.049647f);
			break;
		case GOSSIP_ACTION_INFO_DEF + 17:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -8833.38f, 628.628f, 94.0066f, 1.06535f);
			break;
		case GOSSIP_ACTION_INFO_DEF + 18:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -4918.88f, -940.406f, 501.564f, 5.42347f);
			break;
		case GOSSIP_ACTION_INFO_DEF + 19:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -3965.7f, -11653.6f, -138.844f, 0.852154f);
			break;
		case GOSSIP_ACTION_INFO_DEF + 20:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 9949.56f, 2284.21f, 1341.4f, 1.59587f);
			break;
		case GOSSIP_ACTION_INFO_DEF + 22:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 5804.15f, 624.771f, 647.767f, 1.64f);
			break;
		case GOSSIP_ACTION_INFO_DEF + 23:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -1838.16f, 5301.79f, -12.428f, 5.9517f);
			break;
		case GOSSIP_ACTION_INFO_DEF + 24:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -14297.2f, 530.993f, 8.77916f, 3.98863f);
			break;
		case GOSSIP_ACTION_INFO_DEF + 25:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -7177.15f, -3785.34f, 8.36981f, 6.10237f);
			break;






			//ARENAS
		case GOSSIP_ACTION_INFO_DEF + 28:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Circle of Blood Arena", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 30);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "The Ring of Trials", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 31);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "The Maul", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 177);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 30:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 2839.44f, 5930.17f, 11.1002f, 3.16284f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 31:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -1999.94f, 6581.71f, 11.32f, 2.36528f);

			break;

		case GOSSIP_ACTION_INFO_DEF + 177:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -3748.476807f, 1067.564941f, 131.970474f, 1.618032f);

			break;





			//DUNGEONS
		case GOSSIP_ACTION_INFO_DEF + 32:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Classic Dungeons", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 33);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "TBC Dungeons", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 34);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "WOTLK Dungeons", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 35);

			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 33:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Ragefire Chasm", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 36);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "The Deadmines", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 37);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Wailing Caverns", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 38);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Shadowfang Keep", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 39);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Blackfathom Deeps", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 40);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Stormwind Stockade", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 41);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Gnomeregan", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 42);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Scarlet Monastery", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 43);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Razorfen Kraul", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 44);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Maraudon", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 46);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Uldaman", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 47);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Razorfen Dawns", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 48);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Zul Farrak", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 49);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Sunken Temple", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 50);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Dire Maul", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 51);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Blackrock Depths", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 52);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Blackrock Spire", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 53);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Scholomance", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 54);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Stratholme", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 55);

			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 32);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Main menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		
		case GOSSIP_ACTION_INFO_DEF + 36:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 1811.78f, -4410.5f, -18.4704f, 5.20165f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 37:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -11208.7f, 1673.52f, 24.6361f, 1.51067f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 38:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -805.049f, -2032.03f, 95.8796f, 6.18912f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 39:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -234.675f, 1561.63f, 76.8921f, 1.24031f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 40:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 4249.99f, 740.102f, -25.671f, 1.34062f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 41:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -8773.32f, 839.031f, 91.6376f, 0.648292f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 42:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -5163.54f, 925.423f, 257.181f, 1.57423f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 43:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -2872.6f, -764.3983f, 160.332f, 5.05735f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 44:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -4470.28f, -1677.77f, 81.3925f, 1.16302f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 46:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -1419.13f, 2908.14f, 137.464f, 1.57366f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 47:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -6071.37f, -2955.16f, 209.782f, 0.015708f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 48:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -4657.3f, -2519.35f, 81.0529f, 4.54808f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 49:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -6801.19f, -2893.02f, 9.00388f, 0.158639f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 50:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -10177.9f, -3994.9f, -111.239f, 6.01885f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 51:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -3521.29f, 1085.2f, 161.097f, 4.7281f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 52:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -7179.34f, -921.212f, 165.821f, 5.09599f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 53:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -7527.05f, -1226.77f, 285.732f, 5.29626f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 54:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, 1269.64f, -2556.21f, 93.6088f, 0.620623f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 55:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, 3352.92f, -3379.03f, 144.782f, 6.25978f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 34:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Hellfire Citadel", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 56);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Coilfang Reservoir", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 57);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Auchindoun", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 58);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Tempest Keep", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 59);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Caverns of Time", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 60);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Magisters' Terrace", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 61);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 56:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -390.863f, 3130.64f, 4.51327f, 0.218692f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 57:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 735.066f, 6883.45f, -66.2913f, 5.89172f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 58:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -3324.49f, 4943.45f, -101.239f, 4.63901f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 59:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 3099.36f, 1518.73f, 190.3f, 4.72592f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 60:
		case GOSSIP_ACTION_INFO_DEF + 73:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -8204.88f, -4495.25f, 9.0091f, 4.72574f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 61:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 12884.6f, -7317.69f, 65.5023f, 4.799f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 35:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Utgarde Keep", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 62);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "The Nexus", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 63);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Azjol-Nerub", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 64);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Ahn'Kahet: The Old Kingdom", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 65);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Drak'Tharon Keep", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 66);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "The Violet Hold", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 67);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Gundrak", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 68);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Halls of Stone", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 69);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Halls of Lightning", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 70);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "The Oculus", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 72);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Culling of Stratholme", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 73);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Utgarde Pinnacle", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 74);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Trial of Champion", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 75);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Pit of Saron", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 76);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Forge of Souls", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 77);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Halls of Reflection", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 78);

			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 32);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Main menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;

		case GOSSIP_ACTION_INFO_DEF + 62:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 1219.72f, -4865.28f, 41.2479f, 0.313228f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 63:
		case GOSSIP_ACTION_INFO_DEF + 72:
		case GOSSIP_ACTION_INFO_DEF + 101:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 3781.81f, 6953.65f, 104.82f, 0.467432f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 64:
		case GOSSIP_ACTION_INFO_DEF + 65:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 3707.86f, 2150.23f, 36.76f, 3.22f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 66:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 4774.6f, -2032.92f, 229.15f, 1.59f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 67:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 5696.73f, 507.4f, 652.97f, 4.03f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 68:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 6898.72f, -4584.94f, 451.12f, 2.34455f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 69:
		case GOSSIP_ACTION_INFO_DEF + 70:
		case GOSSIP_ACTION_INFO_DEF + 102:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 9049.37f, -1282.35f, 1060.19f, 5.8395f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 74:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 1259.33f, -4852.02f, 215.763f, 3.48293f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 75:
		case GOSSIP_ACTION_INFO_DEF + 104:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 8515.89f, 629.25f, 547.396f, 1.5747f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 76:
		case GOSSIP_ACTION_INFO_DEF + 77:
		case GOSSIP_ACTION_INFO_DEF + 78:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 5638.26f, 2053.01f, 798.046f, 4.59295f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 79:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Classic raids", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 80);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "TBC raids", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 81);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "WOTLK raids", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 82);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);

			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 80:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Zul'Gurub", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 83);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Molten Core", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 84);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Blackwing Lair", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 85);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Ahn'Qiraj Ruins", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 86);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Ahn'Qiraj Temple", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 87);

			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 79);

			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 83:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -11916.7f, -1215.72f, 92.289f, 4.72454f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 84:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(230, 1126.64f, -459.94f, -102.535f, 3.46095f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 85:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(229, 164.789f, -475.305f, 116.842f, 0.022714f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 86:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -8409.82f, 1499.06f, 27.7179f, 2.51868f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 87:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -8240.09f, 1991.32f, 129.072f, 0.941603f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 81:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Karazhan", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 88);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Gruul's Lair", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 89);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Magtheridon's Lair", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 90);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Zul'Aman", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 91);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Serpentshrine Cavern", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 92);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Tempest Keep: The Eye", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 93);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Hyjal", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 94);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Black Temple", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 95);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Sunwell Plateau", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 96);

			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 79);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 88:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -11118.9f, -2010.33f, 47.0819f, 0.649895f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 89:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 3530.06f, 5104.08f, 3.50861f, 5.51117f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 90:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -312.7f, 3087.26f, -116.52f, 5.19026f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 91:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 6851.78f, -7972.57f, 179.242f, 4.64691f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 92:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 820.025f, 6864.93f, -66.7556f, 6.28127f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 93:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 3088.49f, 1381.57f, 184.863f, 4.61973f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 94:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -8177.89f, -4181.23f, -167.552f, 0.913338f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 95:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -3649.92f, 317.469f, 35.2827f, 2.94285f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 96:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 12574.1f, -6774.81f, 15.0904f, 3.13788f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 82:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Naxxramas", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 97);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Obsidian Sanctum", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 98);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Ruby Sanctum", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 99);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Vault of Archavon", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 100);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Eye of Eternity", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 101);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Ulduar", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 102);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Icecrown Citadel", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 103);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Trial of the Crusader", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 104);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Onyxia's Lair", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 105);

			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 79);

			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 97:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 3668.72f, -1262.46f, 243.622f, 4.785f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 98:
		case GOSSIP_ACTION_INFO_DEF + 99:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 3479.66f, 264.625f, -120.144f, 0.097f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 100:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 5453.72f, 2840.79f, 421.28f, 0.0f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 103:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 5873.82f, 2110.98f, 636.011f, 3.5523f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 105:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -4708.27f, -3727.64f, 54.5589f, 3.72786f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 2301:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -1688.336182f, -4273.490723f, 1.998409f, 2.593258f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 2303:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, 2499.770020f, -41.674599f, 24.625900f, 2.940340f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 2304:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -7721.725586f, -3542.335693f, 37.024323f, 5.384436f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 2306:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -2543.280273f, 934.985901f, 87.440941f, 5.518139f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 106:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Eastern Kingdoms", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 107);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Kalimdor", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 108);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Outland", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 109);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Northrend", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 110);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 107:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Eversong Woods", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 111);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Tirisfal Glades", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 112);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Dun Morogh", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 113);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Elwynn Forest", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 114);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Ghostlands", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 115);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Silverpine Forest", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 116);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Westfall", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 117);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Loch Modan", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 118);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Redridge Mountains", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 119);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Duskwood", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 120);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Wetlands", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 122);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Hillsbrad Foothills", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 123);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Alterac Mountains", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 124);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Arathi Highlands", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 125);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Stranglethorn Vale", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 126);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Swamp of Sorrows", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 127);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Badlads", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 128);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "The Hinterlands", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 129);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Searing Gorge", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 130);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Blasted Lands", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 131);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Burning Steppes", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 132);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Western Plaguelands", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 134);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Eastern Plaguelands", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 135);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Deadwind Pass", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 136);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 106);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Main menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 111:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 9079.92f, -7193.23f, 55.6013f, 5.94597f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 112:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, 2036.02f, 161.331f, 33.8674f, 0.143896f);

			break;

		case GOSSIP_ACTION_INFO_DEF + 113:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -5451.55f, -656.992f, 392.675f, 0.66789f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 114:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -9617.06f, -288.949f, 57.3053f, 4.72687f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 115:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 7360.86f, -6803.3f, 44.2942f, 5.83679f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 116:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, 878.74f, 1359.33f, 50.355f, 5.89929f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 117:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -10235.2f, 1222.47f, 43.6252f, 6.2427f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 118:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -5202.94f, -2855.18f, 336.822f, 0.37651f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 119:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -9551.81f, -2204.73f, 93.473f, 5.47141f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 120:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -10898.3f, -364.784f, 39.2681f, 3.04614f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 122:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -3242.81f, -2469.04f, 15.9226f, 6.03924f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 123:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -436.657f, -581.254f, 53.5944f, 1.25917f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 124:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, 370.763f, -491.355f, 175.361f, 5.37858f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 125:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -1508.51f, -2732.06f, 32.4986f, 3.35708f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 126:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -12644.3f, -377.411f, 10.1021f, 6.09978f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 127:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -10345.4f, -2773.42f, 21.99f, 5.08426f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 128:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -6779.2f, -3423.64f, 241.667f, 0.647481f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 129:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, 119.387f, -3190.37f, 117.331f, 2.34064f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 130:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -7012.47f, -1065.13f, 241.786f, 5.63162f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 131:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -11182.5f, -3016.67f, 7.42235f, 4.0004f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 132:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -8118.54f, -1633.83f, 132.996f, 0.089067f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 134:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, 1728.65f, -1602.25f, 63.429f, 1.6558f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 135:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, 2300.97f, -4613.36f, 73.6231f, 0.367722f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 136:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -10438.8f, -1932.75f, 104.617f, 4.77402f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 108:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Teldrassil", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 137);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Azuremyst Isle", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 138);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Durotar", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 139);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Mulgore", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 140);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Bloodmyst Isle", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 141);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Darkshore", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 142);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "The Barrens", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 143);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Stonetalon Mountains", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 144);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Ashenvale", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 145);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Thousand Needles", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 146);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Desolace", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 148);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Dustwallow Marsh", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 149);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Tanaris", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 150);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Feralas", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 151);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Azshara", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 152);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Felwood", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 153);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Un'Goro Crater", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 154);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Silithus", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 155);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Winterspring", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 156);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Moonglade", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 157);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 106);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Main menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 137:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 10111.3f, 1557.73f, 1324.33f, 4.04239f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 138:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -4216.87f, -12336.9f, 4.34247f, 6.02008f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 139:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 1007.78f, -4446.22f, 11.2022f, 0.20797f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 140:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -2192.62f, -736.317f, -13.3274f, 0.487569f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 141:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -1993.62f, -11475.8f, 63.9657f, 5.29437f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 142:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 5756.25f, 298.505f, 20.6049f, 5.96504f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 143:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 884.54f, -3548.45f, 91.8532f, 2.95957f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 144:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 1570.92f, 1031.52f, 137.959f, 3.33006f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 145:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 1928.34f, -2165.95f, 93.7896f, 0.205731f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 146:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -4969.02f, -1726.89f, -62.1269f, 3.7933f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 148:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -606.395f, 2211.75f, 92.9818f, 0.809746f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 149:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -4043.65f, -2991.32f, 36.3984f, 3.37443f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 150:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -7931.2f, -3414.28f, 80.7365f, 0.66522f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 151:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -4841.19f, 1309.44f, 81.3937f, 1.48501f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 152:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 3341.36f, -4603.79f, 92.5027f, 5.28142f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 153:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 4102.25f, -1006.79f, 272.717f, 0.790048f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 154:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -7943.22f, -2119.09f, -218.343f, 6.0727f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 155:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -7426.87f, 1005.31f, 1.13359f, 2.96086f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 156:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 6759.18f, -4419.63f, 763.214f, 4.43476f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 157:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 7654.3f, -2232.87f, 462.107f, 5.96786f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 109:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Hellfire Peninsula", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 158);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Zangarmarsh", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 159);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Terokkar Forest", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 160);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Nagrand (64-67)", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 161);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Blade's Edge Mountains", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 162);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Shadowmoon Valley", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 163);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Netherstorm", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 164);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 106);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Main menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 158:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -211.237f, 4278.54f, 86.5678f, 4.59776f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 159:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -54.8621f, 5813.44f, 20.9764f, 0.081722f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 160:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -2000.47f, 4451.54f, 8.37917f, 4.40447f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 161:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -1145.95f, 8182.35f, 3.60249f, 6.13478f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 162:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 3037.67f, 5962.86f, 130.774f, 1.27253f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 163:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, -3179.6f, 2716.43f, 68.6444f, 4.16414f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 164:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 3830.23f, 3426.5f, 88.6145f, 5.16677f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 110:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Borean Tundra", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 165);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Howling Fjord", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 166);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Dragonblight", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 167);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Grizzly Hills", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 168);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Zul'Drak", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 169);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Sholazar Basin", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 170);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Crystalsong Forest", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 171);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "The Storm Peaks", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 172);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Icecrown", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 173);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Wintergrasp", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 174);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 106);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Main menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;
		case GOSSIP_ACTION_INFO_DEF + 165:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 3256.57f, 5278.23f, 40.8046f, 0.246367f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 166:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 1902.15f, -4883.91f, 171.363f, 3.11537f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 167:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 4103.36f, 264.478f, 50.5019f, 3.09349f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 168:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 4391.73f, -3587.92f, 238.531f, 3.57526f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 169:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 5560.23f, -3211.66f, 371.709f, 5.55055f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 170:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 5323, 4942, -133.5f, 2.17f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 171:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 5659.35f, 359.053f, 158.214f, 3.69933f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 172:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 7527.14f, -1260.89f, 919.049f, 2.0696f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 173:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 7253.64f, 1644.78f, 433.68f, 4.83412f);

			break;
		case GOSSIP_ACTION_INFO_DEF + 174:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 4760.7f, 2143.7f, 423, 1.13f);

			break;

				case GOSSIP_ACTION_INFO_DEF + 200:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Fun Zones", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 201);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "PvE Zones", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 202);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Leveling Zones", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 203);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "PvP Zones", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 204);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Main menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;

			//funzones
		case GOSSIP_ACTION_INFO_DEF + 201:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Normal Zone", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 206);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Funky Fun Zone [PATCH REQUIRED]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 205);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 200);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());

			break;

		case GOSSIP_ACTION_INFO_DEF + 202:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Bobland", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 209);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Dreamland", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 210);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Plains of Fire", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 211);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Infested BellyGrub (PvP Allowed)", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 212);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Bobgra (PvP Allowed)", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 213);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Dragonland", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 214);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 200);

			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;

		case GOSSIP_ACTION_INFO_DEF + 203:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Leveling Zone (1-80) ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 215);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Borean Tundra (68-80) ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 216);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 200);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;
		case GOSSIP_ACTION_INFO_DEF + 204:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Hyjal Start", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 217);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Hyjal 2", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 218);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Hyjal 3", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 219);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Hyjal 4", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 220);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Hyjal 5 (Zoo)", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 221);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- Back", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 200);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;

			//fun
		case GOSSIP_ACTION_INFO_DEF + 205:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1,-10450.771484f, 2246.849121f, 144.000397f, 0.930067f);
			break;

			//shiney
		case GOSSIP_ACTION_INFO_DEF + 206:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(530, 5953.713867f, -6733.520020f, 159.13641f, 6.061847f);
			break;

			//bobland
		case GOSSIP_ACTION_INFO_DEF + 209:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(560, 3527.830078f, 2288.739990f, 53.757900f, 6.270000f);
			break;

			//dreamland
		case GOSSIP_ACTION_INFO_DEF + 210:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(574, -109.360001f, -702.353027f, 186.253998f, 3.140500f);
			break;

			//plains of fire
		case GOSSIP_ACTION_INFO_DEF + 211:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(469, -7616.729980f, -747.153992f, 190.789993f, 1.870000f);
			break;

			//infested
		case GOSSIP_ACTION_INFO_DEF + 212:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(0, -8556.299805f, -1430.130005f, 261.833008f, 3.896690f);
			break;

			//bobgra
		case GOSSIP_ACTION_INFO_DEF + 213:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, -6726.339844f, -2902.979980f, 8.899900f, 6.168000f);
			break;

			//dragonland
		case GOSSIP_ACTION_INFO_DEF + 214:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(560, 1160.670044f, -205.681000f, 67.104897f, 3.060110f);
			break;

			//leveling zone
		case GOSSIP_ACTION_INFO_DEF + 215:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(543, -644.679993f, 1834.670044f, 59.520000f, 1.160000f);
			break;

			//borean tundre
		case GOSSIP_ACTION_INFO_DEF + 216:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(571, 2232.189941f, 5133.919922f, 5.340000f, 1.190000f);
			break;

			//hyjal start
		case GOSSIP_ACTION_INFO_DEF + 217:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 4615.850098f, -3853.070068f, 944.083008f, 1.034000f);
			break;

			//hyjal 2
		case GOSSIP_ACTION_INFO_DEF + 218:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 4456.060059f, -2559.679932f, 1128.760010f, 1.839000f);
			break;

			//hyjal 3
		case GOSSIP_ACTION_INFO_DEF + 219:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 4927.189941f, -1460.829956f, 1330.010010f, 5.258000f);
			break;

			//hyjal 4
		case GOSSIP_ACTION_INFO_DEF + 220:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 5024.310059f, -2034.500000f, 1367.385620f, 5.527000f);
			break;

			//hyjal 5 (ZOO)
		case GOSSIP_ACTION_INFO_DEF + 221:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->TeleportTo(1, 5455.660156f, -3794.500000f, 1610.939941f, 1.525000f);
			break;

		case GOSSIP_ACTION_INFO_DEF + 1001:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->learnSpell(2457, false);
			pPlayer->learnSpell(1715, false);
			pPlayer->learnSpell(2687, false);
			pPlayer->learnSpell(71, false);
			pPlayer->learnSpell(355, false);
			pPlayer->learnSpell(7384, false);
			pPlayer->learnSpell(72, false);
			pPlayer->learnSpell(694, false);
			pPlayer->learnSpell(2565, false);
			pPlayer->learnSpell(676, false);
			pPlayer->learnSpell(20230, false);
			pPlayer->learnSpell(12678, false);
			pPlayer->learnSpell(5246, false);
			pPlayer->learnSpell(1161, false);
			pPlayer->learnSpell(871, false);
			pPlayer->learnSpell(2458, false);
			pPlayer->learnSpell(20252, false);
			pPlayer->learnSpell(18449, false);
			pPlayer->learnSpell(1680, false);
			pPlayer->learnSpell(6552, false);
			pPlayer->learnSpell(11578, false);
			pPlayer->learnSpell(1719, false);
			pPlayer->learnSpell(34428, false);
			pPlayer->learnSpell(23920, false);
			pPlayer->learnSpell(3411, false);
			pPlayer->learnSpell(55694, false);
			pPlayer->learnSpell(47450, false);
			pPlayer->learnSpell(47465, false);
			pPlayer->learnSpell(47520, false);
			pPlayer->learnSpell(47467, false);
			pPlayer->learnSpell(47436, false);
			pPlayer->learnSpell(47502, false);
			pPlayer->learnSpell(47437, false);
			pPlayer->learnSpell(47475, false);
			pPlayer->learnSpell(47440, false);
			pPlayer->learnSpell(47471, false);
			pPlayer->learnSpell(57755, false);
			pPlayer->learnSpell(57823, false);
			pPlayer->learnSpell(47488, false);
			break;
		case GOSSIP_ACTION_INFO_DEF + 1002:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->learnSpell(48778, false);
			pPlayer->learnSpell(48266, false);
			pPlayer->learnSpell(50977, false);
			pPlayer->learnSpell(49576, false);
			pPlayer->learnSpell(49142, false);
			pPlayer->learnSpell(46584, false);
			pPlayer->learnSpell(48263, false);
			pPlayer->learnSpell(48528, false);
			pPlayer->learnSpell(45524, false);
			pPlayer->learnSpell(3714, false);
			pPlayer->learnSpell(48792, false);
			pPlayer->learnSpell(45529, false);
			pPlayer->learnSpell(56222, false);
			pPlayer->learnSpell(48743, false);
			pPlayer->learnSpell(56815, false);
			pPlayer->learnSpell(48707, false);
			pPlayer->learnSpell(48265, false);
			pPlayer->learnSpell(41999, false);
			pPlayer->learnSpell(47568, false);
			pPlayer->learnSpell(57623, false);
			pPlayer->learnSpell(49941, false);
			pPlayer->learnSpell(49909, false);
			pPlayer->learnSpell(51429, false);
			pPlayer->learnSpell(49916, false);
			pPlayer->learnSpell(42650, false);
			pPlayer->learnSpell(49930, false);
			pPlayer->learnSpell(49938, false);
			pPlayer->learnSpell(49895, false);
			pPlayer->learnSpell(49924, false);
			pPlayer->learnSpell(49921, false);
			break;
		case GOSSIP_ACTION_INFO_DEF + 1003:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->learnSpell(5487, false);
			pPlayer->learnSpell(6795, false);
			pPlayer->learnSpell(18960, false);
			pPlayer->learnSpell(5229, false);
			pPlayer->learnSpell(8946, false);
			pPlayer->learnSpell(1066, false);
			pPlayer->learnSpell(768, false);
			pPlayer->learnSpell(2782, false);
			pPlayer->learnSpell(2893, false);
			pPlayer->learnSpell(5209, false);
			pPlayer->learnSpell(783, false);
			pPlayer->learnSpell(5225, false);
			pPlayer->learnSpell(22842, false);
			pPlayer->learnSpell(9634, false);
			pPlayer->learnSpell(20719, false);
			pPlayer->learnSpell(29166, false);
			pPlayer->learnSpell(22812, false);
			pPlayer->learnSpell(8983, false);
			pPlayer->learnSpell(18658, false);
			pPlayer->learnSpell(9913, false);
			pPlayer->learnSpell(33357, false);
			pPlayer->learnSpell(33786, false);
			pPlayer->learnSpell(26995, false);
			pPlayer->learnSpell(40120, false);
			pPlayer->learnSpell(62078, false);
			pPlayer->learnSpell(49802, false);
			pPlayer->learnSpell(53307, false);
			pPlayer->learnSpell(52610, false);
			pPlayer->learnSpell(48575, false);
			pPlayer->learnSpell(48476, false);
			pPlayer->learnSpell(48560, false);
			pPlayer->learnSpell(49803, false);
			pPlayer->learnSpell(48443, false);
			pPlayer->learnSpell(48562, false);
			pPlayer->learnSpell(53308, false);
			pPlayer->learnSpell(48577, false);
			pPlayer->learnSpell(53312, false);
			pPlayer->learnSpell(48574, false);
			pPlayer->learnSpell(48465, false);
			pPlayer->learnSpell(48570, false);
			pPlayer->learnSpell(48378, false);
			pPlayer->learnSpell(48480, false);
			pPlayer->learnSpell(48579, false);
			pPlayer->learnSpell(48477, false);
			pPlayer->learnSpell(50213, false);
			pPlayer->learnSpell(48461, false);
			pPlayer->learnSpell(48470, false);
			pPlayer->learnSpell(48467, false);
			pPlayer->learnSpell(48568, false);
			pPlayer->learnSpell(48451, false);
			pPlayer->learnSpell(48469, false);
			pPlayer->learnSpell(48463, false);
			pPlayer->learnSpell(48441, false);
			pPlayer->learnSpell(50763, false);
			pPlayer->learnSpell(49800, false);
			pPlayer->learnSpell(48572, false);
			pPlayer->learnSpell(48447, false);
			break;
		case GOSSIP_ACTION_INFO_DEF + 1004:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->learnSpell(75, false);
			pPlayer->learnSpell(1494, false);
			pPlayer->learnSpell(13163, false);
			pPlayer->learnSpell(5116, false);
			pPlayer->learnSpell(883, false);
			pPlayer->learnSpell(2641, false);
			pPlayer->learnSpell(6991, false);
			pPlayer->learnSpell(982, false);
			pPlayer->learnSpell(1515, false);
			pPlayer->learnSpell(19883, false);
			pPlayer->learnSpell(20736, false);
			pPlayer->learnSpell(2974, false);
			pPlayer->learnSpell(6197, false);
			pPlayer->learnSpell(1002, false);
			pPlayer->learnSpell(19884, false);
			pPlayer->learnSpell(5118, false);
			pPlayer->learnSpell(34074, false);
			pPlayer->learnSpell(781, false);
			pPlayer->learnSpell(3043, false);
			pPlayer->learnSpell(1462, false);
			pPlayer->learnSpell(19885, false);
			pPlayer->learnSpell(3045, false);
			pPlayer->learnSpell(19880, false);
			pPlayer->learnSpell(13809, false);
			pPlayer->learnSpell(13161, false);
			pPlayer->learnSpell(5384, false);
			pPlayer->learnSpell(1543, false);
			pPlayer->learnSpell(19878, false);
			pPlayer->learnSpell(3034, false);
			pPlayer->learnSpell(13159, false);
			pPlayer->learnSpell(19882, false);
			pPlayer->learnSpell(14327, false);
			pPlayer->learnSpell(19879, false);
			pPlayer->learnSpell(19263, false);
			pPlayer->learnSpell(14311, false);
			pPlayer->learnSpell(19801, false);
			pPlayer->learnSpell(34026, false);
			pPlayer->learnSpell(27044, false);
			pPlayer->learnSpell(34600, false);
			pPlayer->learnSpell(34477, false);
			pPlayer->learnSpell(53271, false);
			pPlayer->learnSpell(49071, false);
			pPlayer->learnSpell(53338, false);
			pPlayer->learnSpell(49067, false);
			pPlayer->learnSpell(48996, false);
			pPlayer->learnSpell(49052, false);
			pPlayer->learnSpell(49056, false);
			pPlayer->learnSpell(49045, false);
			pPlayer->learnSpell(49001, false);
			pPlayer->learnSpell(61847, false);
			pPlayer->learnSpell(60192, false);
			pPlayer->learnSpell(61006, false);
			pPlayer->learnSpell(48990, false);
			pPlayer->learnSpell(53339, false);
			pPlayer->learnSpell(49048, false);
			pPlayer->learnSpell(58434, false);
			break;
		case GOSSIP_ACTION_INFO_DEF + 1005:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->learnSpell(130, false);
			pPlayer->learnSpell(475, false);
			pPlayer->learnSpell(1953, false);
			pPlayer->learnSpell(12051, false);
			pPlayer->learnSpell(7301, false);
			pPlayer->learnSpell(32271, false);
			pPlayer->learnSpell(3562, false);
			pPlayer->learnSpell(3567, false);
			pPlayer->learnSpell(32272, false);
			pPlayer->learnSpell(3561, false);
			pPlayer->learnSpell(3563, false);
			pPlayer->learnSpell(2139, false);
			pPlayer->learnSpell(45438, false);
			pPlayer->learnSpell(3565, false);
			pPlayer->learnSpell(3566, false);
			pPlayer->learnSpell(32266, false);
			pPlayer->learnSpell(11416, false);
			pPlayer->learnSpell(11417, false);
			pPlayer->learnSpell(32267, false);
			pPlayer->learnSpell(10059, false);
			pPlayer->learnSpell(11418, false);
			pPlayer->learnSpell(11419, false);
			pPlayer->learnSpell(11420, false);
			pPlayer->learnSpell(12826, false);
			pPlayer->learnSpell(66, false);
			pPlayer->learnSpell(30449, false);
			pPlayer->learnSpell(53140, false);
			pPlayer->learnSpell(42917, false);
			pPlayer->learnSpell(43015, false);
			pPlayer->learnSpell(43017, false);
			pPlayer->learnSpell(42985, false);
			pPlayer->learnSpell(43010, false);
			pPlayer->learnSpell(42833, false);
			pPlayer->learnSpell(42914, false);
			pPlayer->learnSpell(42859, false);
			pPlayer->learnSpell(42846, false);
			pPlayer->learnSpell(43012, false);
			pPlayer->learnSpell(42842, false);
			pPlayer->learnSpell(43008, false);
			pPlayer->learnSpell(43024, false);
			pPlayer->learnSpell(43020, false);
			pPlayer->learnSpell(43046, false);
			pPlayer->learnSpell(42897, false);
			pPlayer->learnSpell(43002, false);
			pPlayer->learnSpell(42921, false);
			pPlayer->learnSpell(42940, false);
			pPlayer->learnSpell(42956, false);
			pPlayer->learnSpell(61316, false);
			pPlayer->learnSpell(61024, false);
			pPlayer->learnSpell(42973, false);
			pPlayer->learnSpell(47610, false);
			pPlayer->learnSpell(58659, false);
			break;
		case GOSSIP_ACTION_INFO_DEF + 1006:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->learnSpell(21084, false);
			pPlayer->learnSpell(20271, false);
			pPlayer->learnSpell(498, false);
			pPlayer->learnSpell(1152, false);
			pPlayer->learnSpell(53408, false);
			pPlayer->learnSpell(31789, false);
			pPlayer->learnSpell(62124, false);
			pPlayer->learnSpell(25780, false);
			pPlayer->learnSpell(1044, false);
			pPlayer->learnSpell(5502, false);
			pPlayer->learnSpell(19746, false);
			pPlayer->learnSpell(20164, false);
			pPlayer->learnSpell(10326, false);
			pPlayer->learnSpell(1038, false);
			pPlayer->learnSpell(53407, false);
			pPlayer->learnSpell(19752, false);
			pPlayer->learnSpell(20165, false);
			pPlayer->learnSpell(642, false);
			pPlayer->learnSpell(10278, false);
			pPlayer->learnSpell(20166, false);
			pPlayer->learnSpell(4987, false);
			pPlayer->learnSpell(6940, false);
			pPlayer->learnSpell(10308, false);
			pPlayer->learnSpell(23214, false);
			pPlayer->learnSpell(25898, false);
			pPlayer->learnSpell(25899, false);
			pPlayer->learnSpell(34767, false);
			pPlayer->learnSpell(32223, false);
			pPlayer->learnSpell(31892, false);
			pPlayer->learnSpell(31801, false);
			pPlayer->learnSpell(53736, false);
			pPlayer->learnSpell(53720, false);
			pPlayer->learnSpell(33776, false);
			pPlayer->learnSpell(31884, false);
			pPlayer->learnSpell(54428, false);
			pPlayer->learnSpell(54043, false);
			pPlayer->learnSpell(48943, false);
			pPlayer->learnSpell(48936, false);
			pPlayer->learnSpell(48945, false);
			pPlayer->learnSpell(48938, false);
			pPlayer->learnSpell(48947, false);
			pPlayer->learnSpell(48817, false);
			pPlayer->learnSpell(48788, false);
			pPlayer->learnSpell(48932, false);
			pPlayer->learnSpell(48942, false);
			pPlayer->learnSpell(48801, false);
			pPlayer->learnSpell(48785, false);
			pPlayer->learnSpell(48934, false);
			pPlayer->learnSpell(48950, false);
			pPlayer->learnSpell(48819, false);
			pPlayer->learnSpell(48806, false);
			pPlayer->learnSpell(48782, false);
			pPlayer->learnSpell(53601, false);
			pPlayer->learnSpell(61411, false);
			break;
		case GOSSIP_ACTION_INFO_DEF + 1007:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->learnSpell(586, false);
			pPlayer->learnSpell(2053, false);
			pPlayer->learnSpell(528, false);
			pPlayer->learnSpell(6346, false);
			pPlayer->learnSpell(453, false);
			pPlayer->learnSpell(8129, false);
			pPlayer->learnSpell(605, false);
			pPlayer->learnSpell(552, false);
			pPlayer->learnSpell(6064, false);
			pPlayer->learnSpell(1706, false);
			pPlayer->learnSpell(988, false);
			pPlayer->learnSpell(10909, false);
			pPlayer->learnSpell(10890, false);
			pPlayer->learnSpell(60931, false);
			pPlayer->learnSpell(10955, false);
			pPlayer->learnSpell(34433, false);
			pPlayer->learnSpell(32375, false);
			pPlayer->learnSpell(48072, false);
			pPlayer->learnSpell(48169, false);
			pPlayer->learnSpell(48168, false);
			pPlayer->learnSpell(48170, false);
			pPlayer->learnSpell(48120, false);
			pPlayer->learnSpell(48063, false);
			pPlayer->learnSpell(48135, false);
			pPlayer->learnSpell(48171, false);
			pPlayer->learnSpell(48300, false);
			pPlayer->learnSpell(48071, false);
			pPlayer->learnSpell(48127, false);
			pPlayer->learnSpell(48113, false);
			pPlayer->learnSpell(48123, false);
			pPlayer->learnSpell(48173, false);
			pPlayer->learnSpell(47951, false);
			pPlayer->learnSpell(48073, false);
			pPlayer->learnSpell(48078, false);
			pPlayer->learnSpell(48087, false);
			pPlayer->learnSpell(53023, false);
			pPlayer->learnSpell(48161, false);
			pPlayer->learnSpell(48066, false);
			pPlayer->learnSpell(48162, false);
			pPlayer->learnSpell(48074, false);
			pPlayer->learnSpell(48068, false);
			pPlayer->learnSpell(48158, false);
			pPlayer->learnSpell(48125, false);
			break;
		case GOSSIP_ACTION_INFO_DEF + 1008:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->learnSpell(921, false);
			pPlayer->learnSpell(1776, false);
			pPlayer->learnSpell(1766, false);
			pPlayer->learnSpell(1804, false);
			pPlayer->learnSpell(51722, false);
			pPlayer->learnSpell(1725, false);
			pPlayer->learnSpell(2836, false);
			pPlayer->learnSpell(1833, false);
			pPlayer->learnSpell(1842, false);
			pPlayer->learnSpell(2094, false);
			pPlayer->learnSpell(1860, false);
			pPlayer->learnSpell(6774, false);
			pPlayer->learnSpell(26669, false);
			pPlayer->learnSpell(8643, false);
			pPlayer->learnSpell(11305, false);
			pPlayer->learnSpell(1787, false);
			pPlayer->learnSpell(26889, false);
			pPlayer->learnSpell(31224, false);
			pPlayer->learnSpell(5938, false);
			pPlayer->learnSpell(51724, false);
			pPlayer->learnSpell(57934, false);
			pPlayer->learnSpell(48674, false);
			pPlayer->learnSpell(48669, false);
			pPlayer->learnSpell(48659, false);
			pPlayer->learnSpell(48668, false);
			pPlayer->learnSpell(48672, false);
			pPlayer->learnSpell(48691, false);
			pPlayer->learnSpell(48657, false);
			pPlayer->learnSpell(57993, false);
			pPlayer->learnSpell(51723, false);
			pPlayer->learnSpell(48676, false);
			pPlayer->learnSpell(48638, false);
			break;
		case GOSSIP_ACTION_INFO_DEF + 1009:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->learnSpell(30671, false);
			pPlayer->learnSpell(2484, false);
			pPlayer->learnSpell(526, false);
			pPlayer->learnSpell(57994, false);
			pPlayer->learnSpell(8143, false);
			pPlayer->learnSpell(2645, false);
			pPlayer->learnSpell(2870, false);
			pPlayer->learnSpell(8166, false);
			pPlayer->learnSpell(131, false);
			pPlayer->learnSpell(10399, false);
			pPlayer->learnSpell(6196, false);
			pPlayer->learnSpell(546, false);
			pPlayer->learnSpell(556, false);
			pPlayer->learnSpell(8177, false);
			pPlayer->learnSpell(20608, false);
			pPlayer->learnSpell(36936, false);
			pPlayer->learnSpell(8012, false);
			pPlayer->learnSpell(8512, false);
			pPlayer->learnSpell(6495, false);
			pPlayer->learnSpell(8170, false);
			pPlayer->learnSpell(3738, false);
			pPlayer->learnSpell(2062, false);
			pPlayer->learnSpell(2894, false);
			pPlayer->learnSpell(2825, false);
			pPlayer->learnSpell(57960, false);
			pPlayer->learnSpell(49276, false);
			pPlayer->learnSpell(49236, false);
			pPlayer->learnSpell(58734, false);
			pPlayer->learnSpell(58582, false);
			pPlayer->learnSpell(58753, false);
			pPlayer->learnSpell(49231, false);
			pPlayer->learnSpell(49238, false);
			pPlayer->learnSpell(49277, false);
			pPlayer->learnSpell(55459, false);
			pPlayer->learnSpell(49271, false);
			pPlayer->learnSpell(49284, false);
			pPlayer->learnSpell(51994, false);
			pPlayer->learnSpell(61657, false);
			pPlayer->learnSpell(58739, false);
			pPlayer->learnSpell(49233, false);
			pPlayer->learnSpell(58656, false);
			pPlayer->learnSpell(58790, false);
			pPlayer->learnSpell(58745, false);
			pPlayer->learnSpell(58796, false);
			pPlayer->learnSpell(58757, false);
			pPlayer->learnSpell(49273, false);
			pPlayer->learnSpell(51514, false);
			pPlayer->learnSpell(60043, false);
			pPlayer->learnSpell(49281, false);
			pPlayer->learnSpell(58774, false);
			pPlayer->learnSpell(58749, false);
			pPlayer->learnSpell(58704, false);
			pPlayer->learnSpell(58643, false);
			pPlayer->learnSpell(58804, false);
			break;
		case GOSSIP_ACTION_INFO_DEF + 1010:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->learnSpell(59671, false);
			pPlayer->learnSpell(688, false);
			pPlayer->learnSpell(696, false);
			pPlayer->learnSpell(697, false);
			pPlayer->learnSpell(5697, false);
			pPlayer->learnSpell(698, false);
			pPlayer->learnSpell(712, false);
			pPlayer->learnSpell(126, false);
			pPlayer->learnSpell(5138, false);
			pPlayer->learnSpell(5500, false);
			pPlayer->learnSpell(132, false);
			pPlayer->learnSpell(691, false);
			pPlayer->learnSpell(18647, false);
			pPlayer->learnSpell(11719, false);
			pPlayer->learnSpell(1122, false);
			pPlayer->learnSpell(17928, false);
			pPlayer->learnSpell(6215, false);
			pPlayer->learnSpell(18540, false);
			pPlayer->learnSpell(23161, false);
			pPlayer->learnSpell(29858, false);
			pPlayer->learnSpell(50511, false);
			pPlayer->learnSpell(61191, false);
			pPlayer->learnSpell(47884, false);
			pPlayer->learnSpell(47856, false);
			pPlayer->learnSpell(47813, false);
			pPlayer->learnSpell(47855, false);
			pPlayer->learnSpell(47888, false);
			pPlayer->learnSpell(47865, false);
			pPlayer->learnSpell(47860, false);
			pPlayer->learnSpell(47857, false);
			pPlayer->learnSpell(47823, false);
			pPlayer->learnSpell(47891, false);
			pPlayer->learnSpell(47878, false);
			pPlayer->learnSpell(47864, false);
			pPlayer->learnSpell(57595, false);
			pPlayer->learnSpell(47893, false);
			pPlayer->learnSpell(47820, false);
			pPlayer->learnSpell(47815, false);
			pPlayer->learnSpell(47809, false);
			pPlayer->learnSpell(60220, false);
			pPlayer->learnSpell(47867, false);
			pPlayer->learnSpell(47889, false);
			pPlayer->learnSpell(48018, false);
			pPlayer->learnSpell(47811, false);
			pPlayer->learnSpell(47838, false);
			pPlayer->learnSpell(57946, false);
			pPlayer->learnSpell(58887, false);
			pPlayer->learnSpell(47836, false);
			pPlayer->learnSpell(61290, false);
			pPlayer->learnSpell(47825, false);
			break;


			/*case GOSSIP_ACTION_INFO_DEF + 1011:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->SendTalentWipeConfirm(pCreature->GetGUID());
			break;*/




		case GOSSIP_ACTION_INFO_DEF + 1000:
			if(pPlayer->getClass() == CLASS_WARRIOR && pPlayer->getLevel() == 80){
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Learn all.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1001);
			}
			if(pPlayer->getClass() == CLASS_DEATH_KNIGHT && pPlayer->getLevel() == 80){
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Learn all.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1002);
			}

			if(pPlayer->getClass() == CLASS_DRUID && pPlayer->getLevel() == 80){
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Learn all.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1003);
			}

			if(pPlayer->getClass() == CLASS_HUNTER && pPlayer->getLevel() == 80){
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Learn all.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1004);
			}

			if(pPlayer->getClass() == CLASS_MAGE && pPlayer->getLevel() == 80){
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Learn all.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1005);
			}

			if(pPlayer->getClass() == CLASS_PALADIN && pPlayer->getLevel() == 80){
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Learn all.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1006);
			}

			if(pPlayer->getClass() == CLASS_PRIEST && pPlayer->getLevel() == 80){
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Learn all.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1007);
			}

			if(pPlayer->getClass() == CLASS_ROGUE && pPlayer->getLevel() == 80){
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Learn all.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1008);
			}

			if(pPlayer->getClass() == CLASS_SHAMAN && pPlayer->getLevel() == 80){
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Learn all.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1009);
			}

			if(pPlayer->getClass() == CLASS_WARLOCK && pPlayer->getLevel() == 80){
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Learn all.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1010);
			}
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_DOT, "<- [Back]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3000);

			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;
		}

		return true;
	};
};

void AddSC_Custom_PortalMaster()
{
	new celtic_portalmaster();
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