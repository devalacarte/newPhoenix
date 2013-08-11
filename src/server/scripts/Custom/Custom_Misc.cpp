#include "ScriptMgr.h"

enum Spells_valkyr{
	SPELL_ONE                                   = 62443
};
// phoenix summon scripts
#define PHOENIX_CREATURE		600034
#define HONORIOU				600010
#define ARENAIOU				600011
#define NANITEBATTLEFIELD		26045
#define NANITEGLADIATOR			26044
// vipscripts
#define ITEM_VIP_TOKEN		    600005
// votescripts
#define ITEM_VOTE_TOKEN			600006




class celticscript_valkyr : public CreatureScript{
public:

	celticscript_valkyr() : CreatureScript("celticscript_valkyr") {}

	struct celticscript_valkyrAI : public ScriptedAI{
		celticscript_valkyrAI(Creature* creature) : ScriptedAI(creature) {}
		uint32 m_uiSpell1Timer;                                 // Timer for spell 1 when in combat

		// *** HANDLED FUNCTION ***
		//This is called after spawn and whenever the core decides we need to evade
		void Reset(){
			m_uiSpell1Timer = 5000;                             //  5 seconds
		}

		// Attack Start is called when victim change (including at start of combat)
		void AttackStart(Unit* who){
			ScriptedAI::AttackStart(who);
		}

		//Update AI is called Every single map update (roughly once every 50ms if a player is within the grid)
		void UpdateAI(uint32 uiDiff){			
			//Return since we have no target
			if (!UpdateVictim())
				return;


			//Spell 1 timer
			if (m_uiSpell1Timer <= uiDiff){
				//Cast spell one on our current target.
				DoCast(me->GetVictim(), SPELL_ONE);
				m_uiSpell1Timer = 5000;
			}else{
				m_uiSpell1Timer -= uiDiff;
			}

			DoMeleeAttackIfReady();
		}//end update ai
	};//end scripted ai
	CreatureAI* GetAI(Creature* creature) const{
		return new celticscript_valkyrAI(creature);
	}   
};//end creature script


//Summons a Phoenix from an item
class celticscript_item_custom_summon : public ItemScript{
public:
	celticscript_item_custom_summon() : ItemScript("celticscript_item_custom_summon") {}

	bool OnUse(Player* pPlayer, Item* /*pItem*/, SpellCastTargets const& /*targets*/){
		if (!pPlayer->IsInCombat() && !pPlayer->IsMounted() && !pPlayer->isDead() && !pPlayer->IsFlying()){
			Creature* findcreature = pPlayer->FindNearestCreature(PHOENIX_CREATURE, 150, true);
			if(findcreature){
				if(findcreature->GetCreatorGUID() != pPlayer->GetGUID()){
					Creature* pCreature = pPlayer->SummonCreature(PHOENIX_CREATURE, pPlayer->GetPositionX(), pPlayer->GetPositionY()+5, pPlayer->GetPositionZ()+1.2, 0, TEMPSUMMON_TIMED_DESPAWN, 35000);
					pCreature->CastSpell(pCreature, 63660);
					pCreature->SetCreatorGUID(pPlayer->GetGUID());
					return true;
				}else{
					pPlayer->GetSession()->SendNotification("You already spawned a creature within 150 yards");
					return false;
				}
			}else{
				Creature* pCreature = pPlayer->SummonCreature(PHOENIX_CREATURE, pPlayer->GetPositionX(), pPlayer->GetPositionY()+5, pPlayer->GetPositionZ()+1.2, 0, TEMPSUMMON_TIMED_DESPAWN, 35000);
				pCreature->CastSpell(pCreature, 63660);
				pCreature->SetCreatorGUID(pPlayer->GetGUID());
				return true;
			}
			
				
		}else{
			pPlayer->SendEquipError(EQUIP_ERR_CANT_DO_RIGHT_NOW, NULL);
			return false;
		}
	}
};


//Scripting the Phoenix
class celticscript_summoned_phoenix : public CreatureScript
{
public:
	celticscript_summoned_phoenix() : CreatureScript("celticscript_summoned_phoenix") {}

	bool DestroyItemsAddHonorOrArena(Player *pPlayer, uint32 DestroyItemId, uint32 DestroyItemCount, uint32 AddHonorPoints, uint32 AddArenaPoints, Creature *pCreature, uint32 ReturnToMenu){
		if (pPlayer->HasItemCount(DestroyItemId,DestroyItemCount,false)){
			pPlayer->DestroyItemCount(DestroyItemId,DestroyItemCount,true);
			pPlayer->SetHonorPoints(pPlayer->GetHonorPoints()+AddHonorPoints);
			pPlayer->SetArenaPoints(pPlayer->GetArenaPoints()+AddArenaPoints);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+ReturnToMenu);
			pPlayer->SEND_GOSSIP_MENU(pPlayer->GetGossipTextId(pCreature), pCreature->GetGUID());
			return true;
		}else{
			pCreature->MonsterSay("Not enough tokens!", LANG_UNIVERSAL, pPlayer->GetGUID());
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+ReturnToMenu);
			pPlayer->SEND_GOSSIP_MENU(pPlayer->GetGossipTextId(pCreature), pCreature->GetGUID());
			return false;
		}
	}
	

	bool OnGossipHello(Player* pPlayer, Creature* pCreature)
	{
		if(pCreature->GetCreatorGUID() == pPlayer->GetGUID())
		{
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Repair Gear] ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
			//pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Remove Ress Sickness] ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Vendor] ->", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_VENDOR);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "[Stables] ->", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_STABLEPET);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Honor/Arena Tokens -> Points] ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 20);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			return true;
		}else
		{
			pCreature->MonsterWhisper("I don't belong to you",pPlayer->GetGUID());
			return false;
		}
	}


	bool OnGossipSelect(Player* pPlayer, Creature* pCreature, uint32 /*uiSender*/, uint32 uiAction)
	{
		pPlayer->PlayerTalkClass->ClearMenus();

		switch (uiAction)
		{

		case GOSSIP_ACTION_INFO_DEF + 2000:
			
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Repair Gear] ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Vendor] ->", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_VENDOR);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "[Stables] ->", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_STABLEPET);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Honor/Arena Tokens -> Points] ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 20);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;

		case GOSSIP_ACTION_INFO_DEF + 2:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->DurabilityRepairAll(false, 0.0f, true);
			pCreature->MonsterWhisper("I repaired all your items, including items from bank.", pPlayer->GetGUID());
			break;

		case GOSSIP_OPTION_VENDOR:
			pPlayer->CLOSE_GOSSIP_MENU();
            pPlayer->GetSession()->SendListInventory(pCreature->GetGUID());
            break;

		case GOSSIP_OPTION_STABLEPET:
			pPlayer->CLOSE_GOSSIP_MENU();
			pPlayer->GetSession()->SendStablePet(pCreature->GetGUID());

		case GOSSIP_ACTION_INFO_DEF + 20:
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Honor IOU for 6500 Honor Points] ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 21);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Nanite Battlefield for 6500 Honor Points] ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 22);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Arena IOU for 75 Arena Points] ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 23);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Nanite Gladiator for 500 Arena Points] ->", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 24);
			pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "[Main Menu]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2000);
			pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
			break;

		case GOSSIP_ACTION_INFO_DEF + 21:
			DestroyItemsAddHonorOrArena(pPlayer,HONORIOU,1,6500,0,pCreature,20);
			break;

		case GOSSIP_ACTION_INFO_DEF + 22:
			DestroyItemsAddHonorOrArena(pPlayer,NANITEBATTLEFIELD,1,6500,0,pCreature,20);
			break;

		case GOSSIP_ACTION_INFO_DEF + 23:
			DestroyItemsAddHonorOrArena(pPlayer,ARENAIOU,1,0,75,pCreature,20);
			break;

		case GOSSIP_ACTION_INFO_DEF + 24:
			DestroyItemsAddHonorOrArena(pPlayer,NANITEGLADIATOR,1,0,500,pCreature,20);
			break;
		}
		return true;
	};
};










/*
//////////////////////////////////////////
/////////////// VIPREWARDS ////////////////
//////////////////////////////////////////
*/



enum VIPReward
{
    ITEM,
    HONOR,
    ARENA_POINTS,
    MONEY
};

class npc_token_shop : public CreatureScript
{
public:
    npc_token_shop() : CreatureScript("npc_token_shop") {}

    bool AddVIPStuff(Player *pPlayer, Creature *pCreature, uint32 ItemId, uint32 TokensNeeded, uint32 Count, const char* MonsterSay, VIPReward type = ITEM)
    {
        bool bStuffAdded = false;
        if (pPlayer->HasItemCount(ITEM_VIP_TOKEN,TokensNeeded,true))
        {
            switch(type)
            {
                case ITEM:
                {
                    ItemPosCountVec dest;
                    uint8 msg = pPlayer->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, ItemId, Count, false);
                    if (msg == EQUIP_ERR_OK)
                    {
                        Item* pItem = pPlayer->StoreNewItem(dest,ItemId,Count,true);
                        if (pItem)
                        {
                            pPlayer->SendNewItem(pItem,Count,true,false,false);
                            bStuffAdded = true;
                        }
                    }
                    break;
                }
                case HONOR:
                    pPlayer->ModifyHonorPoints(Count);
                    bStuffAdded = true;
                    break;
                case ARENA_POINTS:
                    pPlayer->ModifyArenaPoints(Count);
                    bStuffAdded = true;
                    break;
                case MONEY:
                    pPlayer->ModifyMoney(Count);
                    bStuffAdded = true;
                    break;
            }
        }
        else
            pCreature->MonsterSay("You need more VIP tokens",LANG_UNIVERSAL,NULL);

        pPlayer->CLOSE_GOSSIP_MENU();

        if (bStuffAdded)
        {
            pCreature->MonsterSay(MonsterSay,LANG_UNIVERSAL,pPlayer->GetGUID());
            pPlayer->DestroyItemCount(ITEM_VIP_TOKEN,TokensNeeded,true);
            return true;
        }
        return false;
    }

    bool OnGossipSelect(Player* pPlayer, Creature* pCreature, uint32 uiSender, uint32 uiAction)
    {
        pPlayer->PlayerTalkClass->ClearMenus();
        switch(uiAction)
        {
            case GOSSIP_ACTION_INFO_DEF+1:
                AddVIPStuff(pPlayer,pCreature,NULL,1,10000,"One VIP token for 10000 honor.",HONOR);
                break;
            case GOSSIP_ACTION_INFO_DEF+2:
                AddVIPStuff(pPlayer,pCreature,47241,1,20,"One VIP token for 20 Emblems of Triumph.");
                break;
            case GOSSIP_ACTION_INFO_DEF+3:
                AddVIPStuff(pPlayer,pCreature,49426,1,10,"One VIP token for 10 Emblems of Frost.");
                break;
            case GOSSIP_ACTION_INFO_DEF+4:
                AddVIPStuff(pPlayer,pCreature,43228,1,20,"One VIP token for 20 Stone Keeper's Shards.");
                break;
            case GOSSIP_ACTION_INFO_DEF+5:
                AddVIPStuff(pPlayer,pCreature,NULL,4,20000000,"Four VIP token for 2000 Gold.",MONEY);
                break;
            case GOSSIP_ACTION_INFO_DEF+6:
                AddVIPStuff(pPlayer,pCreature,23162,6,1,"Six VIP tokens for 36 Slot Bag.");
                break;
            case GOSSIP_ACTION_INFO_DEF+7:
                AddVIPStuff(pPlayer,pCreature,33809,4,1,"Four VIP tokens for Amani War Bear.");
                break;
            case GOSSIP_ACTION_INFO_DEF+8:
                AddVIPStuff(pPlayer,pCreature,21176,4,1,"Four VIP tokens for Black Qiraji Resonating Crystal.");
                break;
            case GOSSIP_ACTION_INFO_DEF+9:
                AddVIPStuff(pPlayer,pCreature,32768,4,1,"Four VIP tokens for Reins of the Raven Lord.");
                break;
            case GOSSIP_ACTION_INFO_DEF+10:
                AddVIPStuff(pPlayer,pCreature,19872,4,1,"Four VIP tokens for Swift Razzashi Raptor.");
                break;
            case GOSSIP_ACTION_INFO_DEF+11:
                AddVIPStuff(pPlayer,pCreature,19902,4,1,"Four VIP tokens for Swift Zulian Tiger.");
                break;
            case GOSSIP_ACTION_INFO_DEF+12:
                AddVIPStuff(pPlayer,pCreature,32458,6,1,"Six VIP tokens for Ashes of Al'ar.");
                break;
            case GOSSIP_ACTION_INFO_DEF+13:
                AddVIPStuff(pPlayer,pCreature,45693,6,1,"Six VIP tokens for Mimiron's Head.");
                break;
            case GOSSIP_ACTION_INFO_DEF+14:
                AddVIPStuff(pPlayer,pCreature,49636,6,1,"Six VIP tokens for Reins of the Onyxian Drake.");
                break;
            case GOSSIP_ACTION_INFO_DEF+15:
                AddVIPStuff(pPlayer,pCreature,50818,8,1,"Eight VIP tokens for Invincible's Reins.");
                break;
            case GOSSIP_ACTION_INFO_DEF+16:
                AddVIPStuff(pPlayer,pCreature,54860,8,1,"Eight VIP tokens for X-53 Touring Rocket.");
                break;
        }
        return true;
    }

    bool OnGossipHello(Player* pPlayer, Creature* pCreature)
    {
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "1 VIP Token -> 10000 Honor", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1, "10000 Honor", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "1 VIP Token -> 20 Emblems of Triumph.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+2, "20 Emblems of Triumph.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "1 VIP Token -> 10 Emblems of Frost.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+3, "0 Emblems of Frost.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "1 VIP Token -> 20 Stone Keeper's Shards.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4, "20 Stone Keeper's Shards.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "4 VIP Tokens -> 2000 Gold.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+5, "2000 Gold.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "6 VIP Tokens -> 36 Slot Bag.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+6, "36 Slot Bag.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "4 VIP Tokens -> Amani War Bear.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+7, "Amani War Bear.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "4 VIP Tokens -> Black Qiraji Resonating Crystal.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+8, "Black Qiraji Resonating Crystal.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "4 VIP Tokens -> Reins of the Raven Lord.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+9, "Reins of the Raven Lord.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "4 VIP Tokens -> Swift Razzashi Raptor.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+10, "Swift Razzashi Raptor.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "4 VIP Tokens -> Swift Zulian Tiger.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+11, "Swift Zulian Tiger.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "6 VIP Tokens -> Ashes of Al'ar.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+12, "Ashes of Al'ar.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "6 VIP Tokens -> Mimiron's Head.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+13, "Mimiron's Head.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "6 VIP Tokens -> Onyxian Drake.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+14, "Onyxian Drake.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "8 VIP Tokens -> Invincible's Reins.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+15, "Invincible's Reins.", 0, false);
        pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_INTERACT_2, "8 VIP Tokens -> X-53 Touring Rocket.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+16, "X-53 Touring Rocket.", 0, false);
        pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
        return true;
    }
};










/*
//////////////////////////////////////////
/////////////// VOTEREWARDS ////////////////
//////////////////////////////////////////
*/



enum INFINITEBUFFS
{
	INFINITE_BUFF_1							= 500101, // [Toby Flask of the Frost Wyrm]
	INFINITE_BUFF_2							= 500102, // [Toby Flask of Endless Rage]  
	INFINITE_BUFF_3							= 500103, // [Toby Flask of Stoneblood] 
	INFINITE_BUFF_4							= 500104, // [Toby Runescroll of Fortitude]
	INFINITE_BUFF_5							= 500105, // [Toby Drums of Forgotten Kings]
	INFINITE_BUFF_6							= 500106,  // [Toby Drums of the Wild]
	INFINITE_BUFF_7							= 500107,  // [Toby Scroll Of Strength]
	INFINITE_BUFF_8							= 500108,  // [Toby Scroll Of Intellect]
	INFINITE_BUFF_9							= 500109,  // [Toby Scroll Of Stamina]
	INFINITE_BUFF_10						= 500110,  // [Toby Scroll Of Spirit]
	INFINITE_BUFF_11						= 500111,  // [Toby Scroll Of Agility]
	INFINITE_BUFF_12						= 500112,  // [Toby Scroll Of Protection]
	INFINITE_BUFF_13						= 500113,  // [Toby Water Walking Elixir]
	INFINITE_BUFF_14						= 500114,  // [Toby Swiftness Potion]
	INFINITE_BUFF_15						= 500115  // [Toby Swim Speed Potion]

};

enum GLOWS
{
	GLOWS_1									= 500130, // [Black Bubble Glow] 
	GLOWS_2									= 500131, // [Blue Feet Glow] 
	GLOWS_3									= 500132, // [Blue Glow] 
	GLOWS_4									= 500133, // [Blue Sparkies Glow] 
	GLOWS_5									= 500134, // [Blue Sparks Glow] 
	GLOWS_6									= 500135, // [Lightning Glow] 
	GLOWS_7									= 500136, // [Dark Cloud Glow] 
	GLOWS_8									= 500137, // [Fire Glow] 
	GLOWS_9									= 500138, // [Fire Shield Glow] 
	GLOWS_10								= 500139, // [Green Glow] 
	GLOWS_11								= 500140, // [Green Sparkies Glow] 
	GLOWS_12								= 500141, // [Blue Mist Glow] 
	GLOWS_13								= 500142, // [Red Mist Glow] 
	GLOWS_14								= 500143, // [Orange Mist Glow] 
	GLOWS_15								= 500144, // [Poison Glow] 
	GLOWS_16								= 500145, // [Purple Hand Glow]  
	GLOWS_17								= 500146, // [Purple Sparkies Glow] 
	GLOWS_18								= 500147, // [Red Cloud Glow] 
	GLOWS_19								= 500148, // [Red Sparkies Glow]
	GLOWS_20								= 500149, // [Swirling Light Glow] 
	GLOWS_21								= 500150  // [Yellow Sparkies Glow] 
};

enum REPUTATIONBADGES
{
	//all factions
	BADGE_N_1								= 43950, //[Kirin Tor Commendation Badge] 
	BADGE_N_2								= 44115, //[Wintergrasp Commendation] 
	BADGE_N_3								= 44710, //[Wyrmrest Commendation Badge] 
	BADGE_N_4								= 44711, //[Argent Crusade Commendation Badge]
	BADGE_N_5								= 44713, //[Ebon Blade Commendation Badge] 
	BADGE_N_6								= 49702, //[Sons of Hodir Commendation Badge] 

	//allliance
	BADGE_A_1								= 45714, //[Darnassus Commendation Badge] 
	BADGE_A_2								= 45715, //[Exodar Commendation Badge]
	BADGE_A_3								= 45716, //[Gnomeregan Commendation Badge] 
	BADGE_A_4								= 45717, //[Ironforge Commendation Badge] 
	BADGE_A_5								= 45718, //[Stormwind Commendation Badge]

	//horde
	BADGE_H_1								= 45719, //[Orgrimmar Commendation Badge]
	BADGE_H_2								= 45720, //[Sen'jin Commendation Badge]
	BADGE_H_3								= 45721, //[Silvermoon Commendation Badge]
	BADGE_H_4								= 45722, //[Thunder Bluff Commendation Badge]
	BADGE_H_5								= 45723 //[Undercity Commendation Badge]
};

enum CURRENCIES
{
	CURRENCY_1								= 29434, // [Badge of Justice] x20
	CURRENCY_2								= 32897, // [Mark of the Illidari] x20 
	CURRENCY_3								= 43228, // [Stone Keeper's Shard] x20
	CURRENCY_4								= 43229,  // [Emblem of Frost] x1
	CURRENCY_5								= 100, //ammount of Arena Points
	CURRENCY_6								= 10000 //ammount of Honor Points
};

enum LEGENDARY_PVE
{
	LEGENDARY_PVE_1							= 18582, // [The Twin Blades of Azzinoth] 
	LEGENDARY_PVE_2							= 13262, // [Ashbringer] 
	LEGENDARY_PVE_3							= 22691, // [Corrupted Ashbringer]
	LEGENDARY_PVE_4							= 17182, // [Sulfuras, Hand of Ragnaros] 
	LEGENDARY_PVE_5							= 34334, // [Thori'dal, the Stars' Fury] 
	LEGENDARY_PVE_6							= 19019, // [Thunderfury, Blessed Blade of the Windseeker] 
	LEGENDARY_PVE_7							= 46017 // [Val'anyr, Hammer of Ancient Kings] 
};

enum HARDCORE_PVE
{ 
	HARDCORE_PVE_1							= 18680, // [Toby Hardcore Bow] 
	HARDCORE_PVE_2							= 18756, // [Toby Hardcore Fortress] 
	HARDCORE_PVE_3							= 19968, // [Toby Hardcore Blade] 
	HARDCORE_PVE_4							= 22816, // [Toby Hardcore Tomahawk] 
	HARDCORE_PVE_5							= 22988, // [Toby Hardcore Mace] 
	HARDCORE_PVE_6							= 27490, // [Toby Hardcore Butcher's Axe] 
	HARDCORE_PVE_7							= 28386, // [Toby Hardcore Magic Stick] 
	HARDCORE_PVE_8							= 28540, // [Toby Hardcore War Axe] 
	HARDCORE_PVE_9							= 28782, // [Toby Hardcore Staff] 
	HARDCORE_PVE_10							= 29185, // [Toby Hardcore Blade] 
	HARDCORE_PVE_11						    = 30865, // [Toby Hardcore Dagger] 
	HARDCORE_PVE_12							= 31134, // [Toby Hardcore Excalibur]
	HARDCORE_PVE_13							= 34349, // [Toby Hardcore Throwing Star]
	HARDCORE_PVE_14							= 35514, // [Toby Hardcore Feral Staff] 
	HARDCORE_PVE_15							= 37216, // [Toby Hardcore Bubble] 
	HARDCORE_PVE_16							= 500170 // [Toby Hardcore Tome] 
};

enum TABARDS
{
	TABARD_1								= 38312, //Tabard of Brilliance
	TABARD_2								= 23705, //Tabard of Flame
	TABARD_3								= 23709, //Tabard of Frost
	TABARD_4								= 38313, //Tabard of Fury
	TABARD_5								= 38309, //Tabard of Nature
	TABARD_6								= 38310, //Tabard of Arcane
	TABARD_7								= 38314 //Tabard of the Defender

};

enum MOUNTS
{
	MOUNT_1									= 43599, //Big Blizzard Bear
	MOUNT_2									= 49282, //Big Battle Bear
	MOUNT_3									= 49290, //Magic Rooster Egg
	MOUNT_4									= 37719, //Swift Zhevra
	MOUNT_5									= 49284, //Swift Spectral Tiger
	MOUNT_6									= 54811 //Celestial Steed

};

enum ICCTRINKETS
{
	ICCTRINKET_1						= 50352, //[Corpse Tongue Coin]
	ICCTRINKET_2						= 50354, //[Bauble of True Blood] 
	ICCTRINKET_3						= 50362, //[Deathbringer's Will] 
	ICCTRINKET_4						= 50353, //[Dislodged Foreign Object] 
	ICCTRINKET_5						= 50351, //[Tiny Abomination in a Jar]
	ICCTRINKET_6						= 50360 //[Phylactery of the Nameless Lich]
};

enum TOKENCOUNTS
{
	TOKENCOUNT_LEGENDARY_PVE				=  84,
	TOKENCOUNT_HARDCORE_PVE					= 200,
	TOKENCOUNT_CURRENCY						= 9,
	TOKENCOUNT_GLOW							= 24,
	TOKENCOUNT_BUFFS						= 21,
	TOKENCOUNT_REP							= 18,
	TOKENCOUNT_TABARD						= 30,
	TOKENCOUNT_ICCTRINKETS					= 150,
	TOKENCOUNT_ARENA						= 20,
	TOKENCOUNT_HONOR						= 10
};



class npc_vote_rewards : public CreatureScript
{
public:
    npc_vote_rewards() : CreatureScript("npc_vote_rewards") {}

    bool AddRewardItem(Player *pPlayer, uint32 ItemId, uint32 count, Creature *pCreature)
    {
        ItemPosCountVec dest;
        uint8 msg = pPlayer->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, ItemId, count, false);
        if (msg == EQUIP_ERR_OK)
        {
            Item *item = pPlayer->StoreNewItem(dest, ItemId, count, true);
            pPlayer->SendNewItem(item, count, true, false, false);
            return true;
        }
        else
            pCreature->MonsterSay("Your bags are full!", LANG_UNIVERSAL, pPlayer->GetGUID());
        return false;
    }

    bool AddRewardItemAndDestroyTokens(Player *pPlayer, uint32 ItemId, uint32 TokenCount, Creature *pCreature, uint32 ReturnTo, uint32 ItemCount = 1)
    {
        if (pPlayer->HasItemCount(ITEM_VOTE_TOKEN,TokenCount,false))
        {
            if (AddRewardItem(pPlayer,ItemId,ItemCount, pCreature))
            {
                pPlayer->DestroyItemCount(ITEM_VOTE_TOKEN,TokenCount,true);
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+ReturnTo);
                pPlayer->SEND_GOSSIP_MENU(pPlayer->GetGossipTextId(pCreature), pCreature->GetGUID());
                return true;
            }
        }
        else
            pCreature->MonsterSay("Not enough tokens!", LANG_UNIVERSAL, pPlayer->GetGUID());
        pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+ReturnTo);
        pPlayer->SEND_GOSSIP_MENU(pPlayer->GetGossipTextId(pCreature), pCreature->GetGUID());
        return false;
    }

    bool AddReputationAndDestroyTokens(Player *pPlayer, uint32 ReputationSpell, uint32 TokenCount, Creature *pCreature)
    {
        if (pPlayer->HasItemCount(ITEM_VOTE_TOKEN,TokenCount,false))
        {
            pPlayer->CastSpell(pPlayer,ReputationSpell,true);
            pPlayer->DestroyItemCount(ITEM_VOTE_TOKEN,TokenCount,true);
            pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+28);
            pPlayer->SEND_GOSSIP_MENU(pPlayer->GetGossipTextId(pCreature), pCreature->GetGUID());
            return true;
        }
        pCreature->MonsterSay("Not enough tokens!", LANG_UNIVERSAL, pPlayer->GetGUID());
        pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+28);
        pPlayer->SEND_GOSSIP_MENU(pPlayer->GetGossipTextId(pCreature), pCreature->GetGUID());
        return false;
    }

    bool OnGossipHello(Player* pPlayer, Creature* pCreature)
    {
                       pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "PvE Legendary Weapons [84 Vote Tokens]",             GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+50);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Upgraded Hardcore PvE Weapons [150 Vote Tokens]",             GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+100);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Currencies [9 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+250);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Glows [24 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+300);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Infinite Buffs [21 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+350);
				//pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Tabards [30 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+400);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Mounts",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+500);
				//pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Pets",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+700);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Reputation Badges [18 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+900);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Misc",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1000);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "ICC Trinkets [150 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1100);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Recipes",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1200);
        pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* pPlayer, Creature* pCreature, uint32 uiSender, uint32 uiAction)
    {
        pPlayer->PlayerTalkClass->ClearMenus();
        switch(uiAction)
        {

			case GOSSIP_ACTION_INFO_DEF+4: // Main Menu
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "PvE Legendary Weapons [84 Vote Tokens]",             GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+50);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Upgraded Hardcore PvE Weapons [150 Vote Tokens]",             GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+100);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Currencies [9 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+250);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Glows [24 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+300);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Infinite Buffs [21 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+350);
				//pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Tabards [30 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+400);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Mounts",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+500);
				//pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Pets",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+700);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Reputation Badges [18 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+900);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Misc",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1000);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "ICC Trinkets [150 Vote Tokens]",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1100);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "Recipes",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1200);
                pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;
           

            case GOSSIP_ACTION_INFO_DEF+50: //PvE Legendary Weapons
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[The Twin Blades of Azzinoth]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+51);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Ashbringer] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+52);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Corrupted Ashbringer]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+53);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Sulfuras, Hand of Ragnaros] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+54);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Thori'dal, the Stars' Fury] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+55);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Thunderfury, Blessed Blade of the Windseeker] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+56);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Val'anyr, Hammer of Ancient Kings] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+57);
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
                pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;

			
			
			case GOSSIP_ACTION_INFO_DEF+51:
                AddRewardItemAndDestroyTokens(pPlayer,LEGENDARY_PVE_1,TOKENCOUNT_LEGENDARY_PVE,pCreature,50);
                break;
			case GOSSIP_ACTION_INFO_DEF+52:
                AddRewardItemAndDestroyTokens(pPlayer,LEGENDARY_PVE_2,TOKENCOUNT_LEGENDARY_PVE,pCreature,50);
                break;
			case GOSSIP_ACTION_INFO_DEF+53:
                AddRewardItemAndDestroyTokens(pPlayer,LEGENDARY_PVE_3,TOKENCOUNT_LEGENDARY_PVE,pCreature,50);
                break;
			case GOSSIP_ACTION_INFO_DEF+54:
                AddRewardItemAndDestroyTokens(pPlayer,LEGENDARY_PVE_4,TOKENCOUNT_LEGENDARY_PVE,pCreature,50);
                break;
			case GOSSIP_ACTION_INFO_DEF+55:
                AddRewardItemAndDestroyTokens(pPlayer,LEGENDARY_PVE_5,TOKENCOUNT_LEGENDARY_PVE,pCreature,50);
                break;
			case GOSSIP_ACTION_INFO_DEF+56:
                AddRewardItemAndDestroyTokens(pPlayer,LEGENDARY_PVE_6,TOKENCOUNT_LEGENDARY_PVE,pCreature,50);
                break;
			case GOSSIP_ACTION_INFO_DEF+57:
                AddRewardItemAndDestroyTokens(pPlayer,LEGENDARY_PVE_7,TOKENCOUNT_LEGENDARY_PVE,pCreature,50);
                break;


				
			
			
			case GOSSIP_ACTION_INFO_DEF+100: //Upgraded Hardcore PvE Weapons
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Bow] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+101);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Fortress] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+102);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Blade] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+103);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Tomahawk]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+104);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Mace] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+105);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Butcher's Axe] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+106);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Magic Stick] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+107);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore War Axe] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+108);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Staff] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+109);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Blade] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+110);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Dagger] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+111);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Excalibur]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+112);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Throwing Star]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+113);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Feral Staff] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+114);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Bubble]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+115);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "[Toby Hardcore Tome] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+116);
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
                pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
				break;
			case GOSSIP_ACTION_INFO_DEF+101:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_1,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
                break;
			case GOSSIP_ACTION_INFO_DEF+102:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_2,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
                break;
			case GOSSIP_ACTION_INFO_DEF+103:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_3,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
                break;
			case GOSSIP_ACTION_INFO_DEF+104:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_4,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
                break;
			case GOSSIP_ACTION_INFO_DEF+105:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_5,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
                break;
			case GOSSIP_ACTION_INFO_DEF+106:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_6,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
                break;
			case GOSSIP_ACTION_INFO_DEF+107:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_7,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
				break;
			case GOSSIP_ACTION_INFO_DEF+108:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_8,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
				break;
			case GOSSIP_ACTION_INFO_DEF+109:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_9,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
				break;
			case GOSSIP_ACTION_INFO_DEF+110:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_10,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
				break;
			case GOSSIP_ACTION_INFO_DEF+111:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_11,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
				break;
			case GOSSIP_ACTION_INFO_DEF+112:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_12,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
				break;
			case GOSSIP_ACTION_INFO_DEF+113:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_13,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
				break;
			case GOSSIP_ACTION_INFO_DEF+114:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_14,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
				break;
			case GOSSIP_ACTION_INFO_DEF+115:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_15,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
				break;
			case GOSSIP_ACTION_INFO_DEF+116:
                AddRewardItemAndDestroyTokens(pPlayer,HARDCORE_PVE_16,TOKENCOUNT_HARDCORE_PVE,pCreature,4);
				break;

            

				case GOSSIP_ACTION_INFO_DEF+250: //CURRENCIES
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Badge of Justice x20]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+251);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Mark of the Illidari x20] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+252);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Stone Keeper's Shard x20]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+253);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Emblem of Frost x2] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+254);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Arena Points x100] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+255);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Honor Points x10000] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+256);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;

				case GOSSIP_ACTION_INFO_DEF+251:
					AddRewardItemAndDestroyTokens(pPlayer,CURRENCY_1,TOKENCOUNT_CURRENCY,pCreature,250,20);
					break;
				case GOSSIP_ACTION_INFO_DEF+252:
					 AddRewardItemAndDestroyTokens(pPlayer,CURRENCY_2,TOKENCOUNT_CURRENCY,pCreature,250,20);
					break;
				case GOSSIP_ACTION_INFO_DEF+253:
					AddRewardItemAndDestroyTokens(pPlayer,CURRENCY_3,TOKENCOUNT_CURRENCY,pCreature,250,20);
					break;
				case GOSSIP_ACTION_INFO_DEF+254:
					AddRewardItemAndDestroyTokens(pPlayer,CURRENCY_4,TOKENCOUNT_CURRENCY,pCreature,250,2);
					break;
				case GOSSIP_ACTION_INFO_DEF+255:
					pPlayer->SetArenaPoints(pPlayer->GetArenaPoints()+CURRENCY_5);
					break;
				case GOSSIP_ACTION_INFO_DEF+256:
					pPlayer->SetHonorPoints(pPlayer->GetHonorPoints()+CURRENCY_6);
					break;








				case GOSSIP_ACTION_INFO_DEF+300: //PvE Legendary Weapons
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Black Bubble Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+301);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Blue Feet Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+302);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Blue Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+303);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Blue Sparkies Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+304);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Blue Sparks Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+305);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Lightning Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+306);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Dark Cloud Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+307);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Fire Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+308);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Fire Shield Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+309);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Green Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+310);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Green Sparkies Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+311);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Blue Mist Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+312);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Red Mist Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+313);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Orange Mist Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+314);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Poison Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+315);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Purple Hand Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+316);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Purple Sparkies Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+317);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Red Cloud Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+318);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Red Sparkies Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+319);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Swirling Light Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+320);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Yellow Sparkies Glow] 50 Charges", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+321);
					
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
					break;

				case GOSSIP_ACTION_INFO_DEF+301:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_1,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+302:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_2,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+303:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_3,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+304:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_4,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+305:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_5,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+306:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_6,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+307:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_7,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+308:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_8,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+309:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_9,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+310:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_10,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+311:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_11,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+312:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_12,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+313:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_13,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+314:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_14,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+315:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_15,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+316:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_16,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+317:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_17,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+318:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_18,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+319:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_19,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+320:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_20,TOKENCOUNT_GLOW,pCreature,300);
					break;
				case GOSSIP_ACTION_INFO_DEF+321:
					AddRewardItemAndDestroyTokens(pPlayer,GLOWS_21,TOKENCOUNT_GLOW,pCreature,300);
					break;











				case GOSSIP_ACTION_INFO_DEF+350: //PvE Legendary Weapons
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Flask of the Frost Wyrm]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+351);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Flask of Endless Rage] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+352);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Flask of Stoneblood] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+353);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Runescroll of Fortitude]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+354);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Drums of Forgotten Kings]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+355);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Drums of the Wild]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+356);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Scroll Of Strength]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+357);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Scroll Of Intellect]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+358);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Scroll Of Stamina]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+359);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Scroll Of Spirit]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+360);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Scroll Of Agility]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+361);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Scroll Of Protection]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+362);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Water Walking Elixir]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+363);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Swiftness Potion]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+364);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Toby Swim Speed Potion]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+365);

					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
					break;

				
				case GOSSIP_ACTION_INFO_DEF+351:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_1,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+352:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_2,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+353:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_3,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+354:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_4,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+355:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_5,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+356:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_6,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+357:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_7,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+358:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_8,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+359:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_9,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+360:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_10,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+361:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_11,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+362:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_12,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+363:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_13,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+364:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_14,TOKENCOUNT_BUFFS,pCreature,350);
					break;
				case GOSSIP_ACTION_INFO_DEF+365:
					AddRewardItemAndDestroyTokens(pPlayer,INFINITE_BUFF_15,TOKENCOUNT_BUFFS,pCreature,350);
					break;




													          
			
			case GOSSIP_ACTION_INFO_DEF+500: // Mounts
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "200 Tokens for Big Blizzard Bear",            GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+501, "200 Tokens for Big Blizzard Bear",            0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "200 Tokens for Big Battle Bear",              GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+502, "200 Tokens for Big Battle Bear",              0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "200 Tokens for Magic Rooster Egg",            GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+503, "200 Tokens for Magic Rooster Egg",            0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "200 Tokens for Swift Zhevra",                 GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+504, "200 Tokens for Swift Zhevra",                 0, false);
				pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "600 Tokens for Swift Spectral Tiger",                 GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+505, "600 Tokens For Swift Spectral Tiger",                 0, false);
				pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "600 Tokens for Celestial Steed",                 GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+506, "600 Tokens for Celestial Steed",                 0, false);
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
                pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;

 
			case GOSSIP_ACTION_INFO_DEF+501: // Mounts - Big Blizzard Bear
                AddRewardItemAndDestroyTokens(pPlayer,MOUNT_1,200,pCreature,500);
                break;
            case GOSSIP_ACTION_INFO_DEF+502: // Mounts - Big Battle Bear
                AddRewardItemAndDestroyTokens(pPlayer,MOUNT_2,200,pCreature,500);
                break;
            case GOSSIP_ACTION_INFO_DEF+503: // Mounts - Magic Rooster Egg
                AddRewardItemAndDestroyTokens(pPlayer,MOUNT_3,200,pCreature,500);
                break;
            case GOSSIP_ACTION_INFO_DEF+504: // Mounts - Swift Zhevra
                AddRewardItemAndDestroyTokens(pPlayer,MOUNT_4,200,pCreature,500);
                break;
			case GOSSIP_ACTION_INFO_DEF+505: 
                AddRewardItemAndDestroyTokens(pPlayer,MOUNT_5,600,pCreature,500);
                break;
            case GOSSIP_ACTION_INFO_DEF+506:
                AddRewardItemAndDestroyTokens(pPlayer,MOUNT_6,600,pCreature,500);
                break;


			









			case GOSSIP_ACTION_INFO_DEF+900: //reputations
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Kirin Tor Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+901);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Wyrmrest Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+903);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Argent Crusade Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+904);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Ebon Blade Commendation Badge] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+905);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Sons of Hodir Commendation Badge] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+906);

					switch (pPlayer->GetTeam())
				{
				case ALLIANCE:
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Darnassus Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+907);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Exodar Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+908);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Gnomeregan Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+909);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Ironforge Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+910);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Stormwind Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+911);
					break;
				case HORDE:
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Orgrimmar Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+912);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Sen'jin Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+913);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Silvermoon Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+914);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Thunder Bluff Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+915);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Undercity Commendation Badge]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+916);
					break;
				}
					

					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
					break;


				case GOSSIP_ACTION_INFO_DEF+901: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_N_1,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+903: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_N_3,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+904: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_N_4,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+905: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_N_5,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+906: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_N_6,TOKENCOUNT_REP,pCreature,900);
					break;


				case GOSSIP_ACTION_INFO_DEF+907: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_A_1,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+908: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_A_2,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+909: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_A_3,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+910: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_A_4,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+911: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_A_5,TOKENCOUNT_REP,pCreature,900);
					break;


				case GOSSIP_ACTION_INFO_DEF+912: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_H_1,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+913: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_H_2,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+914: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_H_3,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+915: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_H_4,TOKENCOUNT_REP,pCreature,900);
					break;
				case GOSSIP_ACTION_INFO_DEF+916: //
					AddRewardItemAndDestroyTokens(pPlayer,BADGE_H_5,TOKENCOUNT_REP,pCreature,900);
					break;


           
			
			
			
			

			
			
			
			case GOSSIP_ACTION_INFO_DEF+1000: //MISC
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Levening Trinket] 42 Vote Tokens", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1001);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Leveling Necklace] 42 Vote Tokens", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1002);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_VENDOR, "[Tabards] 30 Vote Tokens",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+400);


					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;

				case GOSSIP_ACTION_INFO_DEF+1001:
					AddRewardItemAndDestroyTokens(pPlayer,80197,42,pCreature,1000);
					break;
				case GOSSIP_ACTION_INFO_DEF+1002:
					 AddRewardItemAndDestroyTokens(pPlayer,80317,42,pCreature,1000);
					break;
			
				case GOSSIP_ACTION_INFO_DEF+400: // Tabards
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_TABARD, "[Tabard of Brilliance]",     GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+401, "[Tabard of Brilliance]",     0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_TABARD, "[Tabard of Flame]",          GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+402, "[Tabard of Flame]",          0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_TABARD, "[Tabard of Frost]",          GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+403, "[Tabard of Frost]",          0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_TABARD, "[Tabard of Fury]",           GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+404, "[Tabard of Fury]",           0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_TABARD, "[Tabard of Nature]",         GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+405, "[Tabard of Nature]",         0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_TABARD, "[Tabard of the Arcane]",     GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+406, "[Tabard of the Arcane]",     0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_TABARD, "[Tabard of the Defender]",   GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+407, "[Tabard of the Defender]",   0, false);
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
                pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;
			

			case GOSSIP_ACTION_INFO_DEF+401: // Tabard - Tabard of Brilliance
                AddRewardItemAndDestroyTokens(pPlayer,TABARD_1,TOKENCOUNT_TABARD,pCreature,400);
                break;
            case GOSSIP_ACTION_INFO_DEF+402: // Tabard - Tabard of Flame
                AddRewardItemAndDestroyTokens(pPlayer,TABARD_2,TOKENCOUNT_TABARD,pCreature,400);
                break;
            case GOSSIP_ACTION_INFO_DEF+403: // Tabard - Tabard of Frost
                AddRewardItemAndDestroyTokens(pPlayer,TABARD_3,TOKENCOUNT_TABARD,pCreature,400);
                break;
            case GOSSIP_ACTION_INFO_DEF+404: // Tabard - Tabard of Fury
                AddRewardItemAndDestroyTokens(pPlayer,TABARD_4,TOKENCOUNT_TABARD,pCreature,400);
                break;
            case GOSSIP_ACTION_INFO_DEF+405: // Tabard - Tabard of Nature
                AddRewardItemAndDestroyTokens(pPlayer,TABARD_5,TOKENCOUNT_TABARD,pCreature,400);
                break;
            case GOSSIP_ACTION_INFO_DEF+406: // Tabard - Tabard of the Arcane
                AddRewardItemAndDestroyTokens(pPlayer,TABARD_6,TOKENCOUNT_TABARD,pCreature,400);
                break;
            case GOSSIP_ACTION_INFO_DEF+407: // Tabard - Tabard of the Defender
                AddRewardItemAndDestroyTokens(pPlayer,TABARD_7,TOKENCOUNT_TABARD,pCreature,400);
                break;
			



			
				case GOSSIP_ACTION_INFO_DEF+1100: //ICC TRINKETS
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Corpse Tongue Coin]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1101);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Bauble of True Blood]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1102);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Deathbringer's Will] ", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1103);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Dislodged Foreign Object]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1104);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Tiny Abomination in a Jar]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1105);
					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_MONEY_BAG, "[Phylactery of the Nameless Lich]", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1106);

					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;

				case GOSSIP_ACTION_INFO_DEF+1101:
					AddRewardItemAndDestroyTokens(pPlayer,ICCTRINKET_1,TOKENCOUNT_ICCTRINKETS,pCreature,1100);
					break;
				case GOSSIP_ACTION_INFO_DEF+1102:
					 AddRewardItemAndDestroyTokens(pPlayer,ICCTRINKET_2,TOKENCOUNT_ICCTRINKETS,pCreature,1100);
					break;
				case GOSSIP_ACTION_INFO_DEF+1103:
					 AddRewardItemAndDestroyTokens(pPlayer,ICCTRINKET_3,TOKENCOUNT_ICCTRINKETS,pCreature,1100);
					break;
				case GOSSIP_ACTION_INFO_DEF+1104:
					 AddRewardItemAndDestroyTokens(pPlayer,ICCTRINKET_4,TOKENCOUNT_ICCTRINKETS,pCreature,1100);
					break;
				case GOSSIP_ACTION_INFO_DEF+1105:
					 AddRewardItemAndDestroyTokens(pPlayer,ICCTRINKET_5,TOKENCOUNT_ICCTRINKETS,pCreature,1100);
					break;
				case GOSSIP_ACTION_INFO_DEF+1106:
					 AddRewardItemAndDestroyTokens(pPlayer,ICCTRINKET_6,TOKENCOUNT_ICCTRINKETS,pCreature,1100);
					break;
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			

            
			
			case GOSSIP_ACTION_INFO_DEF+1200:
                if (pPlayer->HasSkill(SKILL_BLACKSMITHING))
                    pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Blacksmithing", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1300);
                if (pPlayer->HasSkill(SKILL_ENCHANTING))
                    pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Enchanting", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1400);
                if (pPlayer->HasSkill(SKILL_LEATHERWORKING))
                    pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Leatherworking", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1500);
                if (pPlayer->HasSkill(SKILL_TAILORING))
                    pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Tailoring", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1600);
				if (pPlayer->HasSkill(SKILL_COOKING))
                    pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Cooking", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1700);
				if (pPlayer->HasSkill(SKILL_JEWELCRAFTING))
                    pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Jewelcrafting", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1800);
				if (pPlayer->HasSkill(SKILL_ENGINEERING))
                    pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_TRAINER, "Engineering", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1900);

					pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return to Main Menu", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;

            case GOSSIP_ACTION_INFO_DEF+1300: //bs
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Plans: Indestructible Plate Girdle - 30 Tokens",     GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1301, "Plans: Indestructible Plate Girdle - 30 Tokens"     ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Plans: Plate Girdle of Righteousness - 30 Tokens",   GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1302, "Plans: Plate Girdle of Righteousness - 30 Tokens"   ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Plans: Treads of Destiny - 30 Tokens",               GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1303, "Plans: Treads of Destiny - 30 Tokens"               ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Plans: Battlelord's Plate Boots - 30 Tokens",        GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1304, "Plans: Battlelord's Plate Boots - 30 Tokens"        ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Plans: Belt of the Titans - 30 Tokens",              GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1305, "Plans: Belt of the Titans - 30 Tokens"              ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Plans: Spiked Deathdealers - 30 Tokens",             GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1306, "Plans: Spiked Deathdealers - 30 Tokens"             ,0, false);
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1200);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;
            case GOSSIP_ACTION_INFO_DEF+1400: //ench
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Formula: Enchant Weapon - Blade Ward - 150 Tokens",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1401, "Formula: Enchant Weapon - Blade Ward - 150 Tokens"       ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Formula: Enchant Weapon - Blood Draining - 150 Tokens",   GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1402, "Formula: Enchant Weapon - Blood Draining - 150 Tokens"   ,0, false);
				pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Formula: Enchant Weapon - Deathfrost - 150 Tokens",   GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1402, "Formula: Enchant Weapon - Deathfrost - 150 Tokens"   ,0, false);
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1200);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;
            case GOSSIP_ACTION_INFO_DEF+1500: //lw
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Lightning Grounded Boots - 30 Tokens",  GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1501, "Pattern: Lightning Grounded Boots - 30 Tokens"  ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Death-warmed Belt - 30 Tokens",         GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1502, "Pattern: Death-warmed Belt - 30 Tokens"         ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Footpads of Silence - 30 Tokens",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1503, "Pattern: Footpads of Silence - 30 Tokens"       ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Belt of Arctic Life - 30 Tokens",       GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1504, "Pattern: Belt of Arctic Life - 30 Tokens"       ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Boots of Living Scale - 30 Tokens",     GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1505, "Pattern: Boots of Living Scale - 30 Tokens"     ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Belt of Dragons - 30 Tokens",           GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1506, "Pattern: Belt of Dragons - 30 Tokens"           ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Boots of Wintry Endurance - 30 Tokens", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1507, "Pattern: Boots of Wintry Endurance - 30 Tokens" ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Blue Belt of Chaos - 30 Tokens",        GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1508, "Pattern: Blue Belt of Chaos - 30 Tokens"        ,0, false);
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1200);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;
            case GOSSIP_ACTION_INFO_DEF+1600: //tailor
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Sash of Ancient Power - 30 Tokens",     GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1601, "Pattern: Sash of Ancient Power - 30 Tokens"     ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Savior's Slippers - 30 Tokens",         GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1602, "Pattern: Savior's Slippers - 30 Tokens"         ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Cord of the White Dawn - 30 Tokens",    GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1603, "Pattern: Cord of the White Dawn - 30 Tokens"    ,0, false);
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Pattern: Spellslinger's Slippers - 30 Tokens",   GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1604, "Pattern: Spellslinger's Slippers - 30 Tokens"   ,0, false);
                pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1200);
					pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
                break;
            case GOSSIP_ACTION_INFO_DEF+1700: //cooking
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Recipe: Fish Feast - 30 Tokens",     GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1701, "Recipe: Fish Feast - 30 Tokens"     ,0, false);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1200);
				pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
				break;
			case GOSSIP_ACTION_INFO_DEF+1800: //jewelcrafting
				pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Design: Thundering Skyflare Diamond - 150 Tokens",     GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1801, "Design: Thundering Skyflare Diamond - 150 Tokens"     ,0, false);
				pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Design: Powerful Earthstorm Diamond - 150 Tokens",     GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1802, "Design: Powerful Earthstorm Diamond - 150 Tokens"     ,0, false);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1200);
				pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
				break;
			case GOSSIP_ACTION_INFO_DEF+1900: //engineering
                pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_VENDOR, "Schematic: Jeeves - 150 Tokens",     GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1901, "Schematic: Jeeves - 150 Tokens"     ,0, false);
				pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_INTERACT_2, "Return", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1200);
				pPlayer->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, pCreature->GetGUID());
				break;
			
			
				//BS
			case GOSSIP_ACTION_INFO_DEF+1301:
                AddRewardItemAndDestroyTokens(pPlayer,45092,30,pCreature,1300);
                break;
			case GOSSIP_ACTION_INFO_DEF+1302:
                AddRewardItemAndDestroyTokens(pPlayer,45090,30,pCreature,1300);
                break;
			case GOSSIP_ACTION_INFO_DEF+1303:
                AddRewardItemAndDestroyTokens(pPlayer,45091,30,pCreature,1300);
                break;
			case GOSSIP_ACTION_INFO_DEF+1304:
                AddRewardItemAndDestroyTokens(pPlayer,45089,30,pCreature,1300);
                break;
			case GOSSIP_ACTION_INFO_DEF+1305:
                AddRewardItemAndDestroyTokens(pPlayer,45088,30,pCreature,1300);
                break;
			case GOSSIP_ACTION_INFO_DEF+1306:
                AddRewardItemAndDestroyTokens(pPlayer,45093,30,pCreature,1300);
                break;


				//ENCH
            case GOSSIP_ACTION_INFO_DEF+1401:
                AddRewardItemAndDestroyTokens(pPlayer,46027,150,pCreature,1400);
                break;
			case GOSSIP_ACTION_INFO_DEF+1402:
                AddRewardItemAndDestroyTokens(pPlayer,46348,150,pCreature,1400);
                break;
			case GOSSIP_ACTION_INFO_DEF+1403:
                AddRewardItemAndDestroyTokens(pPlayer,35498,150,pCreature,1400);
                break;
            

					//LW
			case GOSSIP_ACTION_INFO_DEF+1501:
                AddRewardItemAndDestroyTokens(pPlayer,45097,30,pCreature,1500);
                break;
			case GOSSIP_ACTION_INFO_DEF+1502:
                AddRewardItemAndDestroyTokens(pPlayer,45098,30,pCreature,1500);
                break;
			case GOSSIP_ACTION_INFO_DEF+1503:
                AddRewardItemAndDestroyTokens(pPlayer,45099,30,pCreature,1500);
                break;
			case GOSSIP_ACTION_INFO_DEF+1504:
                AddRewardItemAndDestroyTokens(pPlayer,45100,30,pCreature,1500);
                break;
			case GOSSIP_ACTION_INFO_DEF+1505:
                AddRewardItemAndDestroyTokens(pPlayer,45095,30,pCreature,1500);
                break;
			case GOSSIP_ACTION_INFO_DEF+1506:
                AddRewardItemAndDestroyTokens(pPlayer,45094,30,pCreature,1500);
                break;
			case GOSSIP_ACTION_INFO_DEF+1507:
                AddRewardItemAndDestroyTokens(pPlayer,45101,30,pCreature,1500);
                break;
			case GOSSIP_ACTION_INFO_DEF+1508:
                AddRewardItemAndDestroyTokens(pPlayer,45096,30,pCreature,1500);
                break;


				//Tailor
			case GOSSIP_ACTION_INFO_DEF+1601:
                AddRewardItemAndDestroyTokens(pPlayer,45102,30,pCreature,1600);
                break;
			case GOSSIP_ACTION_INFO_DEF+1602:
                AddRewardItemAndDestroyTokens(pPlayer,45105,30,pCreature,1600);
                break;
			case GOSSIP_ACTION_INFO_DEF+1603:
                AddRewardItemAndDestroyTokens(pPlayer,45104,30,pCreature,1600);
                break;
			case GOSSIP_ACTION_INFO_DEF+1604:
                AddRewardItemAndDestroyTokens(pPlayer,45103,30,pCreature,1600);
                break;


				//Cooking
			case GOSSIP_ACTION_INFO_DEF+1701:
                AddRewardItemAndDestroyTokens(pPlayer,43017,30,pCreature,1700);
                break;


				//JC
			case GOSSIP_ACTION_INFO_DEF+1801:
                AddRewardItemAndDestroyTokens(pPlayer,41787,150,pCreature,1800);
                break;
			case GOSSIP_ACTION_INFO_DEF+1802:
                AddRewardItemAndDestroyTokens(pPlayer,25902,150,pCreature,1800);
                break;


				//JC
			case GOSSIP_ACTION_INFO_DEF+1901:
                AddRewardItemAndDestroyTokens(pPlayer,49050,150,pCreature,1900);
                break;


				default:
                break;

        }
        return true;
    }
};



 
void AddSC_Custom_Misc(){
	new celticscript_item_custom_summon();
	new celticscript_summoned_phoenix();
	new celticscript_valkyr();
	new npc_token_shop(); // old script (updated)
	new npc_vote_rewards(); //old script (updated)
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