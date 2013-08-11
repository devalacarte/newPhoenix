#include "ScriptPCH.h"
#include <cstring>
#include "AccountMgr.h"

extern WorldDatabaseWorkerPool WorldDatabase;
#define MSG_GOSSIP_TELE         "Teleport to GuildHouse"
#define MSG_GOSSIP_NEXTPAGE     "Next -->"
#define MSG_INCOMBAT            "You are in combat and cannot be teleported to your GuildHouse."
#define MSG_NOGUILDHOUSE        "Your guild currently does not own a GuildHouse."
#define MSG_NOTINGUILD          "You need to be in a guild before you can use a GuildHouse."
#define ACTION_TELE 1001
#define ICON_GOSSIP_BALOON 0





#define BOUNTY_1 "I would like to place a bounty of 5 Vote Tokens."
#define BOUNTY_2 "I would like to place a bounty. of 10 Guild House Tokens"
#define BOUNTY_3 "I would like to place a bounty. of 1 VIP Token"
#define PLACE_BOUNTY "I would like to place a bounty."
#define LIST_BOUNTY "List the current bounties."
#define NVM "Nevermind - Close"
#define WIPE_BOUNTY "Wipe bounties (for gms only)"


enum BountyPrice
{
	ITEM_GUILDHOUSETOKENS							= 600003,
	ITEM_VOTETOKENS									= 600006,
	ITEM_VIPTOKENS									= 600005,
	ITEM_BOUNTYTOKENS								= 600004,
};


/*
16345 - [Deathknell PvE Sword 1] 
23467 - [Deathknell PvE Sword 2] 
500000 - [Deathknell PvE Trinket 1] 
500001 - [Deathknell PvE Trinket 2] 
500002 - [Deathknell PvE Trinket 3] 
*/
int donors [] = {500000, 500001, 500002, 23467, 16345};







/*
////////////////////////////////////////
////////////GUILDHOUSE STUFF////////////
////////////////////////////////////////
*/


char str[200];

bool getGuildHouseCoords(uint32 guildId, float &x, float &y, float &z, uint32 &map)
{
	if (guildId == 0)
	{
		//if player has no guild
		return false;
	}

	QueryResult result;
	result = WorldDatabase.PQuery("SELECT `x`, `y`, `z`, `map` FROM `guildhouses` WHERE `guildId` = %u", guildId);
	if (result)
	{
		Field *fields = result->Fetch();
		x = fields[0].GetFloat();
		y = fields[1].GetFloat();
		z = fields[2].GetFloat();
		map = fields[3].GetUInt32();
		return true;
	}

	return false;
}

void teleportPlayerToGuildHouse(Player *player, Creature *_creature)
{
	if (player->GetGuildId() == 0)
	{
		//if player has no guild
		_creature->MonsterWhisper(MSG_NOTINGUILD, player->GetGUID());
		return;
	}

	if (!player->getAttackers().empty())
	{
		//if player in combat
		_creature->MonsterSay(MSG_INCOMBAT, LANG_UNIVERSAL, player->GetGUID());
		return;
	}

	float x, y, z;
	uint32 map;

	if (getGuildHouseCoords(player->GetGuildId(), x, y, z, map))
	{
		//teleport player to the specified location
		player->RemoveAura(27881,0);
		player->CastSpell(player,12438,false);
		player->TeleportTo(map, x, y, z, 0.0f);
	}
	else
		_creature->MonsterWhisper(MSG_NOGUILDHOUSE, player->GetGUID());
}

class celticscript_guildhouse : public CreatureScript
{
public:
	celticscript_guildhouse() : CreatureScript("celticscript_guildhouse") { }

	bool GossipSelectWithCode(Player *player, Creature *_creature, uint32 sender, uint32 action, const char* sCode){
		if (sender == GOSSIP_SENDER_MAIN){
		}
		return false;
	}



	bool OnGossipSelect(Player *player, Creature *_creature, uint32 sender, uint32 action)
	{
		player->PlayerTalkClass->ClearMenus();
		if (sender != GOSSIP_SENDER_MAIN)
			return false;

		switch (action)
		{
		case ACTION_TELE:
			//teleport player to GH
			player->CLOSE_GOSSIP_MENU();
			teleportPlayerToGuildHouse(player, _creature);
			break;
		}

		return true;
	}


	bool OnGossipHello(Player *player, Creature *_creature)
	{
		player->ADD_GOSSIP_ITEM(ICON_GOSSIP_BALOON, MSG_GOSSIP_TELE,
			GOSSIP_SENDER_MAIN, ACTION_TELE);

		player->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, _creature->GetGUID());
		return true;
	}


};






/*
/////////////////////////////////////
////////////BOUNTY HUNTER////////////
/////////////////////////////////////
*/



class celticscript_bountyhunter : public CreatureScript
{
	public:
		celticscript_bountyhunter() : CreatureScript("celticscript_bountyhunter"){}
		
		bool OnGossipHello(Player * Player, Creature * Creature)
		{
			Player->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, PLACE_BOUNTY, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1);
			Player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TALK, LIST_BOUNTY, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+2);
			Player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TALK, NVM, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+3);
			if (Player->GetSession()->GetSecurity() >=SEC_GAMEMASTER)
				Player->ADD_GOSSIP_ITEM(GOSSIP_ICON_TALK, WIPE_BOUNTY, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+4);

			Player->PlayerTalkClass->SendGossipMenu(907, Creature->GetGUID());
			return true;
		}

		std::stringstream message;
		bool HasItem(Player * pPlayer, uint32 item, uint32 itemcount, Player * pBounty, uint8 ammountbountytokens, const char * code)
		{
			if(pPlayer->HasItemCount(item,itemcount,false))
			{
				pPlayer->DestroyItemCount(item, itemcount,true);
				CharacterDatabase.PExecute("INSERT INTO bounties VALUES('%u','%u', '%u', '%u')", pBounty->GetGUID(),ammountbountytokens,itemcount,pPlayer->GetSession()->GetAccountId());
				
				pBounty->SetPvP(true);
				pBounty->SetByteFlag(UNIT_FIELD_BYTES_2, 1, UNIT_BYTE2_FLAG_FFA_PVP);
				
				message << "[Bounty Hunter]: A bounty has been place on " << pBounty->GetName() << ". Kill immidiatly to collect the reward!";
				sWorld->SendServerMessage(SERVER_MSG_STRING, message.str().c_str(), 0);
				pPlayer->PlayerTalkClass->SendCloseGossip();
				return true;
			}else
			{
				WorldSession *m_session = pPlayer->GetSession();
				m_session->SendNotification("You don't have enough Tokens");
				pPlayer->PlayerTalkClass->SendCloseGossip();
				return false;
			}
		}

		bool passChecks(Player * pPlayer, const char * name)
		{ 
			Player * pBounty = sObjectAccessor->FindPlayerByName(name);
			WorldSession * m_session = pPlayer->GetSession();
			if(!pBounty)
			{
				m_session->SendNotification("The player is offline or doesn't exist!");
				return false;
			}
			
			QueryResult result = CharacterDatabase.PQuery("SELECT * FROM bounties WHERE guid ='%u'", pBounty->GetGUID());
			if(result)
			{
				m_session->SendNotification("This player already has a bounty on them!");
				return false;
			}

			if(pPlayer->GetGUID() == pBounty->GetGUID())
			{
				m_session->SendNotification("You cannot set a bounty on yourself!");
				return false;
			}
		return true;
		}

		bool OnGossipSelect(Player* pPlayer, Creature* pCreature, uint32 /*uiSender*/, uint32 uiAction)
		{
			pPlayer->PlayerTalkClass->ClearMenus();
			switch(uiAction)
			{
				case GOSSIP_ACTION_INFO_DEF+1:
				{
					pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_BATTLE, BOUNTY_2, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+6, "", 0, true);
					pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_BATTLE, BOUNTY_1, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+5, "", 0, true);
					pPlayer->ADD_GOSSIP_ITEM_EXTENDED(GOSSIP_ICON_BATTLE, BOUNTY_3, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+7, "", 0, true);
					pPlayer->PlayerTalkClass->SendGossipMenu(365, pCreature->GetGUID());
					break;
				}
				case GOSSIP_ACTION_INFO_DEF+2:
				{
					QueryResult Bounties = CharacterDatabase.PQuery("SELECT * FROM bounties");
					
					if(!Bounties)
					{
						pPlayer->PlayerTalkClass->SendCloseGossip();
						return false;
					}

					if(	Bounties->GetRowCount() != 0)
					{
						pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, "Bounties: ", GOSSIP_SENDER_MAIN, 1);
						do
						{
							Field * fields = Bounties->Fetch();
							std::string option;
							QueryResult name = CharacterDatabase.PQuery("SELECT name FROM characters WHERE guid='%u'", fields[0].GetUInt32());
							Field * names = name->Fetch();
							option = names[0].GetString();
							option +=" ";
							option += fields[1].GetString();
							option += " Bounty Token";
							pPlayer->ADD_GOSSIP_ITEM(GOSSIP_ICON_BATTLE, option, GOSSIP_SENDER_MAIN, 1);
						}while(Bounties->NextRow());
					}
					
					pPlayer->PlayerTalkClass->SendGossipMenu(878, pCreature->GetGUID());
					break;
				}

				case GOSSIP_ACTION_INFO_DEF+3:
				{
					pPlayer->PlayerTalkClass->SendCloseGossip();
					break;
				}
				case GOSSIP_ACTION_INFO_DEF+4:
				{
					if (pPlayer->IsGameMaster() ){
					CharacterDatabase.PExecute("TRUNCATE TABLE bounties");
					pPlayer->PlayerTalkClass->SendCloseGossip();
					}else{
						pPlayer->Kill(pPlayer, true);
					}
					break;
				}
			}
			return true;
		}

		bool OnGossipSelectCode(Player* pPlayer, Creature* pCreature, uint32 uiSender, uint32 uiAction, const char * code)
		{
			pPlayer->PlayerTalkClass->ClearMenus();
			if ( uiSender == GOSSIP_SENDER_MAIN )
			{
				if(islower(code[0]))
					toupper(code[0]);

				if(passChecks(pPlayer, code))
				{
					Player * pBounty = sObjectAccessor->FindPlayerByName(code);
					WorldSession *m_session = pPlayer->GetSession();
					switch (uiAction)
					{
						case GOSSIP_ACTION_INFO_DEF+5: //votetoken 5 2
						{
							HasItem(pPlayer,ITEM_VOTETOKENS,5,pBounty,2,code);
							break;
						}
							
						case GOSSIP_ACTION_INFO_DEF+6://ghtoken 10 1
						{	
							HasItem(pPlayer,ITEM_GUILDHOUSETOKENS,10,pBounty,1,code);
							break;
						}

						case GOSSIP_ACTION_INFO_DEF+7: //viptoken 1 3
						{
							HasItem(pPlayer,ITEM_VIPTOKENS,1,pBounty,3,code);
							break;
						}
					}
				}
				else
				{
					pPlayer->PlayerTalkClass->SendCloseGossip();
				}
			}
			return true;
		}
};


class BountyKills : public PlayerScript
{
	public:
		BountyKills() : PlayerScript("BountyKills"){}

		void OnPVPKill(Player * Killer, Player * Bounty)
		{
			if(Killer->GetGUID() == Bounty->GetGUID())
				return;

			QueryResult result = CharacterDatabase.PQuery("SELECT * FROM bounties WHERE guid='%u'", Bounty->GetGUID());
			if(!result)
				return;


			Field * fields = result->Fetch();
			WorldSession * m_session = Killer->GetSession();
			if (fields[3].GetUInt32() == m_session->GetAccountId())
			{
				m_session->SendNotification("We won't allow you to farm your own bounties");
				return;
			}

			Killer->AddItem(ITEM_BOUNTYTOKENS,fields[2].GetUInt8()); //ammount of tokens to reward = fields[2]
			CharacterDatabase.PExecute("DELETE FROM bounties WHERE guid='%u'", Bounty->GetGUID());
			std::stringstream message;
			message << "[Bounty Hunter]: The bounty on " << Bounty->GetName() << " has been collected by " << Killer->GetName() <<".";
			sWorld->SendServerMessage(SERVER_MSG_STRING, message.str().c_str(), 0);
		}
};






/*
//////////////////////////////////////////
////////////PVE REPORT SCRIPTS////////////
//////////////////////////////////////////
*/


class PvEReportScript : public PlayerScript
{
	public:
		PvEReportScript() : PlayerScript("PvEReportScript"){}


		void OnPVPKill(Player * Killer, Player * Victim)
		{
			if(Killer->GetGUID() == Victim->GetGUID())
				return;

			for(uint8 donoritem=0;donoritem<5;donoritem++){
				for(uint8 slot=EQUIPMENT_SLOT_START; slot<EQUIPMENT_SLOT_END; slot++){ //checks in each slot if one of these items are equiped
					Item* item = Killer->GetItemByPos(INVENTORY_SLOT_BAG_0, slot);
					if(item){
						if(item->GetTemplate()->ItemId == donors[donoritem]){
							Killer->GetSession()->SendNotification(" [PvE Report]: Do NOT PVP with your PvE Donor!!");
							std::stringstream message;
							message << "[PvE Report]: " << Killer->GetSession()->GetPlayerName() << " has killed " << Victim->GetSession()->GetPlayerName() << " with "<< item->GetTemplate()->Name1 <<".";
							sWorld->SendServerMessage(SERVER_MSG_STRING, message.str().c_str(), 0);
							//CharacterDatabase.PExecute("INSERT INTO `pve_reports` (`KillerName`, `KillerGuid`, `KillerAccount`, `ItemEntry`, `ItemGuid`, `KilledName`, `KilledGuid`) VALUES ('%a','u%','b%','d%','e%','f%','g%');",Killer->GetSession()->GetPlayerName(),"0",Killer->GetSession()->GetAccountId(),item->GetTemplate()->ItemId,item->GetGUID(),Victim->GetSession()->GetPlayerName(),Victim->GetGUID());
							
							//reports to database
							std::stringstream str;
							str << "INSERT INTO `pve_reports` (`KillerName`, `KillerGuid`, `KillerAccount`, `ItemEntry`, `ItemGuid`, `KilledName`, `KilledGuid`,`PlayersKilled`) VALUES ('";
							str << Killer->GetSession()->GetPlayerName() << "','" << Killer->GetGUIDLow() << "','" << Killer->GetSession()->GetAccountId() << "','";
							str << item->GetTemplate()->ItemId << "','" << item->GetGUIDLow() << "','" << Victim->GetSession()->GetPlayerName()<< "','"<< Victim->GetGUIDLow() << "');";
							CharacterDatabase.Execute(str.str().c_str());
						}

					}
				}
			}
		}
};






///////////////////////////////////////////
////////////BAN GM IF NOT IN DB////////////
///////////////////////////////////////////

class BanGMNotInDb : public PlayerScript
{
	public:
		BanGMNotInDb() : PlayerScript("BanGMNotInDb") {}
		void OnLogin(Player * pPlayer)
		{
			if(pPlayer->GetSession()->GetSecurity()>=SEC_MODERATOR)
			{
				QueryResult result = CharacterDatabase.PQuery("SELECT * FROM character_gm_rights WHERE guid='%u' and accountId ='%u'", pPlayer->GetGUID(),pPlayer->GetSession()->GetAccountId());
				if(!result)
				{
					std::string accountName;
					AccountMgr::GetName(pPlayer->GetSession()->GetAccountId(), accountName);
					sWorld->BanAccount(BAN_ACCOUNT,accountName,"-200","GM not in character_GM tables","Server");
				}
			}
		}

};



void AddSC_Custom_DBScripts()
{
	new celticscript_guildhouse();
	new celticscript_bountyhunter();
	new BountyKills();
	new PvEReportScript();
	new BanGMNotInDb();
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