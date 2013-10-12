#include "ObjectAccessor.h"
#include "ObjectMgr.h"
#include "ScriptMgr.h"
#include "Chat.h"
#include "AccountMgr.h"
//#include "Player.h"
#include "ReputationMgr.h"
#include "Group.h"

class CustomCommandScript : public CommandScript
{
public:
    CustomCommandScript() : CommandScript("CustomCommandScript") { }

	ChatCommand* GetCommands() const OVERRIDE
	{
		static ChatCommand headGMCommandTable[] =
		{
			{ "addgm",	        rbac::RBAC_PERM_COMMAND_HEADGM_ADDGM,					false, &HandleHeadAddGMCommand,				"", NULL },
			{ NULL,             0,											false, NULL,                                "", NULL }
		};

		static ChatCommand massCommandTable[] =
		{
			{ "revive",			rbac::RBAC_PERM_COMMAND_CUSTOM_MASS_REVIVE,		false, &HandleMassRessurectionCommand,		"", NULL },
			{ "unaura",			rbac::RBAC_PERM_COMMAND_CUSTOM_MASS_UNAURA,		false, &HandleMassUnauraCommand,			"", NULL },
			{ "morph",			rbac::RBAC_PERM_COMMAND_CUSTOM_MASS_MORPH,		false, &HandleGroupMorphCommand,			"", NULL },
			{ "demorph",		rbac::RBAC_PERM_COMMAND_CUSTOM_MASS_DEMORPH,		false, &HandleGroupDeMorphCommand,			"", NULL },
			{ NULL,             0,											false, NULL,                                "", NULL }
		};
        static ChatCommand eventGMCommandTable[] =
		{
			{ "addtoken",		rbac::RBAC_PERM_COMMAND_EVENTGM_ADDTOKEN,			false, &HandleAddEventTokenCommand,			"", NULL },
			{ "unaura",			rbac::RBAC_PERM_COMMAND_EVENTGM_UNAURA,			false, &HandleAddEventAuraCommand,			"", NULL },
			{ NULL,             0,											false, NULL,                                "", NULL }
        };
	    static ChatCommand devaSubCommandTable[] =
        {
            { "object",         rbac::RBAC_PERM_COMMAND_CUSTOM_OBJECT,			true,  &HandleDevaObjectCommand,			"", NULL },
			{ "patch",          rbac::RBAC_PERM_COMMAND_CUSTOM_PATCH,				true,  &HandleDevaObjectPatchCommand,		"", NULL },
			{ "hallo",          rbac::RBAC_PERM_COMMAND_CUSTOM_HALLO,				true,  &HandleHelloWorldCommand,			"", NULL },
			{ "mass",			rbac::RBAC_PERM_COMMAND_CUSTOM_MASS,				true, NULL,									"", massCommandTable },
            { NULL,             0,											false, NULL,								"", NULL }
        };

        static ChatCommand commandTable[] =
        {
            { "custom",         rbac::RBAC_PERM_COMMAND_CUSTOM,					true,	NULL,								"", devaSubCommandTable },
			{ "eventgm",		rbac::RBAC_PERM_COMMAND_EVENTGM,					true, NULL,									"", eventGMCommandTable},
			{ "headgm",			rbac::RBAC_PERM_COMMAND_HEADGM,					true, NULL,									"", headGMCommandTable },
            { NULL,				0,											false,	NULL,								"", NULL }
        };
        return commandTable;
    }
	//test command to see if custom commands work .custom hallo
	static bool HandleHelloWorldCommand(ChatHandler* handler, const char* /*args*/)
        {
            handler->PSendSysMessage("Hello World");
            return true;
        }

	//.custom object - will list all the normal blizz objects like .gobject lookup but without the patch objects
	static bool HandleDevaObjectCommand(ChatHandler* handler, char const* args)
    {
        if (!*args)
            return false;

        std::string namePart = args;
        std::wstring wNamePart;

        // converting string that we try to find to lower case
        if (!Utf8toWStr(namePart, wNamePart))
            return false;

        wstrToLower(wNamePart);

        bool found = false;
        uint32 count = 0;
        uint32 maxResults = sWorld->getIntConfig(CONFIG_MAX_RESULTS_LOOKUP_COMMANDS);

        GameObjectTemplateContainer const* gotc = sObjectMgr->GetGameObjectTemplates();
        for (GameObjectTemplateContainer::const_iterator itr = gotc->begin(); itr != gotc->end(); ++itr)
        {
            uint8 localeIndex = handler->GetSessionDbLocaleIndex();
            if (GameObjectLocale const* objectLocalte = sObjectMgr->GetGameObjectLocale(itr->second.entry))
            {
                if (objectLocalte->Name.size() > localeIndex && !objectLocalte->Name[localeIndex].empty())
                {
                    std::string name = objectLocalte->Name[localeIndex];

                    if (Utf8FitTo(name, wNamePart))
                    {
                        if (maxResults && count++ == maxResults)
                        {
                            handler->PSendSysMessage(LANG_COMMAND_LOOKUP_MAX_RESULTS, maxResults);
                            return true;
                        }

                        if (handler->GetSession() && (name.find("PATCH") == std::string::npos))
                            handler->PSendSysMessage(LANG_GO_ENTRY_LIST_CHAT, itr->second.entry, itr->second.entry, name.c_str());

                        if (!found)
                            found = true;

                        continue;
                    }
                }
            }

            std::string name = itr->second.name;
            if (name.empty())
                continue;

            if (Utf8FitTo(name, wNamePart))
            {
                if (maxResults && count++ == maxResults)
                {
                    handler->PSendSysMessage(LANG_COMMAND_LOOKUP_MAX_RESULTS, maxResults);
                    return true;
                }

                if (handler->GetSession() && (name.find("PATCH") == std::string::npos))
                    handler->PSendSysMessage(LANG_GO_ENTRY_LIST_CHAT, itr->second.entry, itr->second.entry, name.c_str());

                if (!found)
                    found = true;
            }
        }

        if (!found)
            handler->SendSysMessage(LANG_COMMAND_NOGAMEOBJECTFOUND);

        return true;
    }

	//.custom patch - will list all the PATCHED gobjects like .gobject lookup but without the blizzard objects
	static bool HandleDevaObjectPatchCommand(ChatHandler* handler, char const* args)
    {
        if (!*args)
            return false;

        std::string namePart = args;
        std::wstring wNamePart;

        // converting string that we try to find to lower case
        if (!Utf8toWStr(namePart, wNamePart))
            return false;

        wstrToLower(wNamePart);

        bool found = false;
        uint32 count = 0;
        uint32 maxResults = sWorld->getIntConfig(CONFIG_MAX_RESULTS_LOOKUP_COMMANDS);

        GameObjectTemplateContainer const* gotc = sObjectMgr->GetGameObjectTemplates();
        for (GameObjectTemplateContainer::const_iterator itr = gotc->begin(); itr != gotc->end(); ++itr)
        {
            uint8 localeIndex = handler->GetSessionDbLocaleIndex();
            if (GameObjectLocale const* objectLocalte = sObjectMgr->GetGameObjectLocale(itr->second.entry))
            {
                if (objectLocalte->Name.size() > localeIndex && !objectLocalte->Name[localeIndex].empty())
                {
                    std::string name = objectLocalte->Name[localeIndex];

                    if (Utf8FitTo(name, wNamePart))
                    {
                        if (maxResults && count++ == maxResults)
                        {
                            handler->PSendSysMessage(LANG_COMMAND_LOOKUP_MAX_RESULTS, maxResults);
                            return true;
                        }

                        if (handler->GetSession() && (name.find("PATCH") != std::string::npos))
                            handler->PSendSysMessage(LANG_GO_ENTRY_LIST_CHAT, itr->second.entry, itr->second.entry, name.c_str());

                        if (!found)
                            found = true;

                        continue;
                    }
                }
            }

            std::string name = itr->second.name;
            if (name.empty())
                continue;

            if (Utf8FitTo(name, wNamePart))
            {
                if (maxResults && count++ == maxResults)
                {
                    handler->PSendSysMessage(LANG_COMMAND_LOOKUP_MAX_RESULTS, maxResults);
                    return true;
                }

                if (handler->GetSession() && (name.find("PATCH") != std::string::npos))
                    handler->PSendSysMessage(LANG_GO_ENTRY_LIST_CHAT, itr->second.entry, itr->second.entry, name.c_str());

                if (!found)
                    found = true;
            }
        }

        if (!found)
            handler->SendSysMessage(LANG_COMMAND_NOGAMEOBJECTFOUND);

        return true;
    }

	//.headgm addgm - will add gm in the character gm table where it checks if a GM is allowed to login
	static bool HandleHeadAddGMCommand(ChatHandler* handler, char const* args)
	{
		WorldSession *m_session = handler->GetSession();
		Player* target;
        uint64 targetGuid;
        std::string targetName;
		//std::string nametest;
		//nametest = handler->extractPlayerNameFromLink((char*)args);
		//std::string oldNameLink = handler->playerLink(targetName);
		std::stringstream message;
		
		if (!handler->extractPlayerTarget((char*)args, &target, &targetGuid, &targetName))
            return false;

		QueryResult result = CharacterDatabase.PQuery("SELECT * FROM character_gm_rights WHERE guid ='%u'", GUID_LOPART(targetGuid)); 
		if(result)
		{
			m_session->SendNotification("This player is already in the GM list");
			return false;
		}
		QueryResult accountid = CharacterDatabase.PQuery("SELECT account FROM characters WHERE guid = '%u'", GUID_LOPART(targetGuid));
		if(!accountid)
		{
			m_session->SendNotification("No matching accountid found for this name!");
			return false;
		}

		if (target)
        {
            // check online security
            if (handler->HasLowerSecurity(target, 0))
                return false;
			message << "INSERT INTO character_gm_rights VALUES('" << GUID_LOPART(targetGuid) << "','"<<target->GetSession()->GetAccountId() <<  "','" << targetName << " added by: " << m_session->GetPlayerName() << "');";
		}
		else
        {
            // check offline security
            if (handler->HasLowerSecurity(NULL, targetGuid))
                return false;
			Field * fields = accountid->Fetch();
			uint32 accId = fields[0].GetUInt32();
			message << "INSERT INTO character_gm_rights VALUES('" << GUID_LOPART(targetGuid) << "','"<< accId <<  "','" << targetName << " added by: " << m_session->GetPlayerName() << "');";
        }

		CharacterDatabase.Execute(message.str().c_str());
		m_session->SendNotification("New GM added");
		return true;
	}

	//.custom mass demorph - demorphs everyone in group
	static bool HandleGroupDeMorphCommand(ChatHandler* handler, char const* args)
	{
		std::string argstr = args;

		Player* target = handler->getSelectedPlayer();
		if (!target)
        {
            handler->SendSysMessage(LANG_SELECT_CHAR_OR_CREATURE);
            handler->SetSentErrorMessage(true);
            return false;
        }
        
		std::string nameLink = handler->GetNameLink(target);
        Group* grp = target->GetGroup();
        if (!grp)
        {
            handler->PSendSysMessage(LANG_NOT_IN_GROUP, nameLink.c_str());
            handler->SetSentErrorMessage(true);
            return false;
        }

		for (GroupReference* itr = grp->GetFirstMember(); itr != NULL; itr = itr->next())
        {
            Player* playergroup = itr->GetSource();

            if (!playergroup || !playergroup->GetSession())
                continue;

			playergroup->DeMorph();
		}
		return true;
	}

	//.custom mass morph - morphs everyone in group
	static bool HandleGroupMorphCommand(ChatHandler* handler, char const* args)
	{
		std::string argstr = args;

		Player* target = handler->getSelectedPlayer();
		if (!target)
        {
            handler->SendSysMessage(LANG_SELECT_CHAR_OR_CREATURE);
            handler->SetSentErrorMessage(true);
            return false;
        }

		uint16 display_id = (uint16)atoi((char*)args);
        
		std::string nameLink = handler->GetNameLink(target);
        Group* grp = target->GetGroup();
        if (!grp)
        {
            handler->PSendSysMessage(LANG_NOT_IN_GROUP, nameLink.c_str());
            handler->SetSentErrorMessage(true);
            return false;
        }

		for (GroupReference* itr = grp->GetFirstMember(); itr != NULL; itr = itr->next())
        {
            Player* playergroup = itr->GetSource();

            if (!playergroup || !playergroup->GetSession())
                continue;

			playergroup->SetDisplayId(display_id);
		}
		return true;
	}

	//.custom mass unaura removes auras from everyone in group
	static bool HandleMassUnauraCommand(ChatHandler* handler, char const* args)
    {
		std::string argstr = args;

		Player* target = handler->getSelectedPlayer();
		if (!target)
        {
            handler->SendSysMessage(LANG_SELECT_CHAR_OR_CREATURE);
            handler->SetSentErrorMessage(true);
            return false;
        }
        
		std::string nameLink = handler->GetNameLink(target);
        Group* grp = target->GetGroup();
        if (!grp)
        {
            handler->PSendSysMessage(LANG_NOT_IN_GROUP, nameLink.c_str());
            handler->SetSentErrorMessage(true);
            return false;
        }

		for (GroupReference* itr = grp->GetFirstMember(); itr != NULL; itr = itr->next())
        {
            Player* playergroup = itr->GetSource();

            if (!playergroup || !playergroup->GetSession())
                continue;

			if (argstr == "all")
			{
				playergroup->RemoveAllAuras();
				continue;
			}
				
			// number or [name] Shift-click form |color|Hspell:spell_id|h[name]|h|r or Htalent form
			uint32 spellId = handler->extractSpellIdFromLink((char*)args);
			if (!spellId)
				return false;

			playergroup->RemoveAurasDueToSpell(spellId); 
		}
		return true;
    }

	static bool HandleAddEventAuraCommand(ChatHandler* handler, char const* args)
    {
        Unit* target = handler->getSelectedUnit();
        if (!target)
        {
            handler->SendSysMessage(LANG_SELECT_CHAR_OR_CREATURE);
            handler->SetSentErrorMessage(true);
            return false;
        }

        target->RemoveAurasDueToSpell(15265);
		target->RemoveAurasDueToSpell(67016);
		target->RemoveAurasDueToSpell(67017);
		target->RemoveAurasDueToSpell(67018);
		target->RemoveAurasDueToSpell(53760);
		target->RemoveAurasDueToSpell(54212);
		target->RemoveAurasDueToSpell(53755);
		target->RemoveAurasDueToSpell(53752);
		target->RemoveAurasDueToSpell(53758);
		target->RemoveAurasDueToSpell(58451);
		target->RemoveAurasDueToSpell(48100);
		target->RemoveAurasDueToSpell(48104);
		target->RemoveAurasDueToSpell(48102);
		target->RemoveAurasDueToSpell(58449);
		target->RemoveAurasDueToSpell(72590);
		target->RemoveAurasDueToSpell(23736);
		target->RemoveAurasDueToSpell(23767);
		target->RemoveAurasDueToSpell(23768);
		target->RemoveAurasDueToSpell(23766);
		target->RemoveAurasDueToSpell(23769);
		target->RemoveAurasDueToSpell(23738);
		target->RemoveAurasDueToSpell(23737);
		target->RemoveAurasDueToSpell(23735);
		target->RemoveAurasDueToSpell(15366);
		target->RemoveAurasDueToSpell(72586);
		target->RemoveAurasDueToSpell(72588);
		target->RemoveAurasDueToSpell(16591);
		target->RemoveAurasDueToSpell(16595);
		target->RemoveAurasDueToSpell(16593);

        return true;
    }

	//.custom mass revive - revives everyone in group
	static bool HandleMassRessurectionCommand(ChatHandler* handler, const char* args)
    {
        Player* target;
        uint64 targetGuid;
        if (!handler->extractPlayerTarget((char*)args, &target, &targetGuid))
            return false;

        if (target)
        {
			std::string nameLink = handler->GetNameLink(target);
			Group* grp = target->GetGroup();
			
			if (!grp)
			{
				handler->PSendSysMessage(LANG_NOT_IN_GROUP, nameLink.c_str());
				handler->SetSentErrorMessage(true);
				return false;
			}

			for (GroupReference* itr = grp->GetFirstMember(); itr != NULL; itr = itr->next())
			{
				Player* player = itr->GetSource();
				if (!player || !player->GetSession())
					continue;

		        if (handler->HasLowerSecurity(player, 0))
			        return false;

				player->ResurrectPlayer(!AccountMgr::IsPlayerAccount(target->GetSession()->GetSecurity()) ? 1.0f : 0.5f);
				player->SpawnCorpseBones();
				player->SaveToDB();
			} 
        }

        return true;
    }
	
	//.eventgm addtoken gives event token to players
	static bool HandleAddEventTokenCommand(ChatHandler* handler, const char* args)
{
		if (!*args)
            return false;
		
		int32 count = (uint32)atoi(args);
		uint32 itemId = 37829;

		Player* player = handler->GetSession()->GetPlayer();
		Player* playerTarget = handler->getSelectedPlayer();

		if (!playerTarget)
            playerTarget = player;

		sLog->outDebug(LOG_FILTER_GENERAL, handler->GetTrinityString(LANG_ADDITEM), itemId, count);

		ItemTemplate const* itemTemplate = sObjectMgr->GetItemTemplate(itemId);
        if (!itemTemplate)
        {
            handler->PSendSysMessage(LANG_COMMAND_ITEMIDINVALID, itemId);
            handler->SetSentErrorMessage(true);
            return false;
        }

        // Subtract
        if (count < 0)
        {
            playerTarget->DestroyItemCount(itemId, -count, true, false);
            handler->PSendSysMessage(LANG_REMOVEITEM, itemId, -count, handler->GetNameLink(playerTarget).c_str());
            return true;
        }

		// Adding items
        uint32 noSpaceForCount = 0;

        // check space and find places
        ItemPosCountVec dest;
        InventoryResult msg = playerTarget->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, itemId, count, &noSpaceForCount);
        if (msg != EQUIP_ERR_OK)                               // convert to possible store amount
            count -= noSpaceForCount;

        if (count == 0 || dest.empty())                         // can't add any
        {
            handler->PSendSysMessage(LANG_ITEM_CANNOT_CREATE, itemId, noSpaceForCount);
            handler->SetSentErrorMessage(true);
            return false;
        }

        Item* item = playerTarget->StoreNewItem(dest, itemId, true, Item::GenerateItemRandomPropertyId(itemId));

		if (count > 0 && item)
        {
            player->SendNewItem(item, count, false, true);
            if (player != playerTarget)
                playerTarget->SendNewItem(item, count, true, false);
        }

        if (noSpaceForCount > 0)
            handler->PSendSysMessage(LANG_ITEM_CANNOT_CREATE, itemId, noSpaceForCount);

        return true;
    }
};


#define color_app			"|cffff8a00[App]: "	
#define color_dev			"|cffff8a00[DEV]: "	
#define color_gm			"|cffff8a00[GM]: "
#define color_senior		"|cffff8a00[SENIOR GM]: "	
#define color_head			"|cffff8a00[HEAD-GM]: "	
#define color_lord			"|cffff8a00[LORD]: "
#define color_overlord		"|cffff8a00[OVERLORD]: "	

class Custom_EditExcistingCommands : public CommandScript
{
        public:
                Custom_EditExcistingCommands() : CommandScript("Custom_EditExcistingCommands"){}
 
        ChatCommand * GetCommands() const
            {
        static ChatCommand commandTable[] =
        {
            { "nameannounce",   rbac::RBAC_PERM_COMMAND_NAMEANNOUNCE,      true,   &HandleNameAnnounceCommand,         "", NULL }, //moved from cs_message.cpp
            { "gmnameannounce", rbac::RBAC_PERM_COMMAND_GMNAMEANNOUNCE,      true,   &HandleGMNameAnnounceCommand,       "", NULL }, //moved from cs_message.cpp
            { NULL,             0,                  false,  NULL,                               "", NULL }
        };
        return commandTable;
    }
 
	static std::string getColor(Player * player)
	{
		std::string msg ="";
		
		switch(player->GetSession()->GetSecurity())
        {
			case SEC_MODERATOR:
				msg += color_app + player->GetName();
				break;
			case SEC_DEVELOPER:
				msg += color_dev + player->GetName();
				break;
			case SEC_GAMEMASTER:
				msg += color_gm + player->GetName();
				break;
			case SEC_SENIOR:
				msg += color_senior + player->GetName();
				break;
			case SEC_HEAD:
				msg += color_head + player->GetName();
				break;
			case SEC_LORD:
				msg += color_lord + player->GetName();
				break;
			case SEC_ADMINISTRATOR:
				msg += color_overlord + player->GetName();
				break;
		}
			return msg;
	}

     static bool HandleNameAnnounceCommand(ChatHandler* handler, char const* args)
    {
		if (!*args)
            return false;
		
		if (WorldSession* session = handler->GetSession())
		{
			std::string msg = "";
			Player * player = handler->GetSession()->GetPlayer();

			msg = "Announce by: " + getColor(player) + ": "+ args;
			sWorld->SendServerMessage(SERVER_MSG_STRING, msg.c_str(), 0); 
			return true;
		}else //console shit from original command
		{
			std::string name("Console");
			sWorld->SendWorldText(LANG_GM_ANNOUNCE_COLOR, name.c_str(), args);
			return true;
		}
    }

    static bool HandleGMNameAnnounceCommand(ChatHandler* handler, char const* args)
    {
		if (!*args)
            return false;
		
		if (WorldSession* session = handler->GetSession())
		{
			std::string msg = "";
            Player * player = handler->GetSession()->GetPlayer();
			
			msg = "STAFF ONLY: Announce by: " + getColor(player) + ": "+ args;
			sWorld->SendGMText(SERVER_MSG_STRING, msg.c_str(), 0); 
			return true;
		}else //console shit from original command
		{
			std::string name("Console");
			sWorld->SendGMText(LANG_GM_ANNOUNCE_COLOR, name.c_str(), args);
			return true;
		}
    }
};




void AddSC_Custom_CommandScript()
{
	new CustomCommandScript();
	new Custom_EditExcistingCommands();
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