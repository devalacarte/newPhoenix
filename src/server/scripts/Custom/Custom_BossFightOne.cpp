#include "ScriptPCH.h"
#include <cstring>
//#include "precompiled.h"
// **** Quick Info* ***F
// Functions with Handled Function marked above them are functions that are called automatically by the core
// Functions that are marked Custom Function are functions I've created to simplify code

/*
void UpdateAI(uint32 diff)
	{
		if (!me->GetVictim())
        		{
		}

		if (!UpdateVictim())
			return;
			
		if (((me->GetHealth()*100 / me->GetMaxHealth()) < 75) && (Phase == 1))
		{
			Phase = 2;
		}

		if (((me->GetHealth()*100 / me->GetMaxHealth()) < 25) && (Phase == 2))
		{
			Phase = 3;
		}

		if (Phase == 1)
		{
		}
		
		if (Phase == 2)
		{
		}

		if (Phase == 3)
		{
		}
	}
*/

/*
std::list<Unit*> TargetList;
                Trinity::AnyUnfriendlyUnitInObjectRangeCheck checker(me, me, 100.0f);
                Trinity::UnitListSearcher<Trinity::AnyUnfriendlyUnitInObjectRangeCheck> searcher(me, TargetList, checker);
                me->VisitNearbyObject(100.0f, searcher);
                for (std::list<Unit*>::iterator itr = TargetList.begin(); itr != TargetList.end(); ++itr)
                {
                    Unit* target = *itr;
                 //Do stuff here
                    }
*/

/*
std::list<Player*> players;
                        Trinity::AnyPlayerInObjectRangeCheck checker(me, 40);
                        Trinity::PlayerListSearcher<Trinity::AnyPlayerInObjectRangeCheck> searcher(me, players, checker);
                        me->VisitNearbyWorldObject(40, searcher);
 
                        std::list<Player*>::const_iterator itr;
                        advance(itr, urand(0,players.size()-1));
 
                        if (Player* target = (*itr))
                            me->CastSpell(target, SPELL_CONFLAGRATION, true);
*/


			/*std::list<Unit*> TargetList2;
            Trinity::AnyFriendlyUnitInObjectRangeCheck checker(me, me, 1000.0f);
            Trinity::UnitListSearcher<Trinity::AnyFriendlyUnitInObjectRangeCheck> searcher(me, TargetList2, checker);
            me->VisitNearbyObject(1000.0f, searcher);
            for (std::list<Unit*>::iterator itr = TargetList2.begin(); itr != TargetList2.end(); ++itr){
				Unit* target = *itr;
				//Do stuff here
				me->AddAura(SPELL_BUFF, target);
				me->AddAura(SPELL_BERSERK, target);
				//me->MonsterSay("Buffed my add54654", LANG_UNIVERSAL, NULL);
			}*/
enum Spells_mini_boss_one{
    SPELL_MINI_BUFF                                  = 25661,
    SPELL_MINI_ONE                                   = 12555,
    SPELL_MINI_TWO                                   = 10017,
    SPELL_MINI_THREE                                 = 26027,
};

enum Spells_DPSAdd{
    SPELL_DPS_BUFF                                  = 25661,
    SPELL_DPS_ONE                                   = 12555,
    SPELL_DPS_TWO                                   = 10017,
    SPELL_DPS_THREE                                 = 26027,
};

enum Spells_HealingAdd{
	SPELL_HEALING_RENEW									= 66177,		//10k renew
	SPELL_HEALING_RENEWBOSS								= 49263,		//40% renew
	SPELL_HEALING_FLASHHEALBOSS							= 71783,		//400k flash heal
	SPELL_HEALING_FLASHHEAL								= 68023,		//100k flash heal
	SPELL_HEALING_CHAINHEAL								= 71120,		//70k chain heal
};


#define SAY_AGGRO		"Let the games begin."
#define SAY_RANDOM_0    "I see endless suffering. I see torment. I see rage. I see everything."
#define SAY_RANDOM_1    "Muahahahaha"
#define SAY_RANDOM_2    "These mortal infedels my lord, they have invaded your sanctum and seek to steal your secrets."
#define SAY_RANDOM_3    "You are already dead."
#define SAY_RANDOM_4    "Where to go? What to do? So many choices that all end in pain, end in death."
#define SAY_BERSERK     "$N, I sentance you to death!"
#define SAY_PHASE       "The suffering has just begun!"
#define SAY_DANCE       "I always thought I was a good dancer."
#define SAY_SALUTE      "Hmm a nice day for a walk alright"


enum Spells{
    SPELL_BUFF                                  = 25661,
    SPELL_ONE                                   = 12555,
    SPELL_ONE_ALT                               = 24099,
    SPELL_TWO                                   = 10017,
    SPELL_THREE                                 = 26027,
    SPELL_FRENZY                                = 23537,
    SPELL_BERSERK                               = 32965,
	SPELL_SHIELD								= 00000,
	SPELL_VISUALBUFF1							= 00000,
	SPELL_VISUALBUFF2							= 00000,
	SPELL_VISUALBUFF3							= 00000,
	SPELL_KNOCKBACK								= 40532,
	SPELL_IMMOBILIZE							= 8346,
	SPELL_FROZEN								= 2647,
	SPELL_PURGE									= 27626,
	SPELL_DISPELL								= 988,
};

enum SpellsSupport{
    SPELL_SUPPORT_BERSERK								= 62555,  //500% dmg 150% speed at 10%hp left
    SPELL_SUPPORT_HEALINGDEBUFF                         = 67979, //aimed shot -50% healing when player level is under 15%
    SPELL_SUPPORT_BUFFABSORB                            = 63489, //50k dmg absorbed and 50% dmg done
    SPELL_SUPPORT_BUFFFIRESHIELD                        = 63778, //2-3k shield on attack after 15 seconds on every mob.
	SPELL_SUPPORT_SILENCE								= 56777, //4second silence
	SPELL_SUPPORT_MORPH									= 70410, // 12 seconds
};

enum Creatures{
	NPC_MAINBOSS								= 600050,
	NPC_HEALINGMOB								= 600051,
	NPC_DPSMOB									= 600052,
	NPC_SUPPORTMOB								= 600053,
	NPC_WAVEBOSSONE								= 600054,
};

enum Others{
	MORPHPSTARTFIGHT							= 10990, //panda
	MORPHPLAYER1								= 10990, //panda
	MORPHPLAYER2								= 18089, //bird
	MORPHPLAYER3								= 15918, //rabbit
	DONORITEM1									= 16345,
	DONORITEM2									= 23467,
	DONORITEM3									= 90075,
	DONORITEM4									= 90077,
	DONORITEM5									= 821020,
	MONEYNEEDED									= 10000, //in gold
};



void CheckIfPlayerHasPvEDonor(Creature *me){
			std::list<Player*> TargetList;
            Trinity::AnyPlayerInObjectRangeCheck check(me, 150.0f);
			Trinity::PlayerListSearcher<Trinity::AnyPlayerInObjectRangeCheck> searcher(me, TargetList, check);
			me->VisitNearbyObject(150.0f, searcher);
			for (std::list<Player*>::iterator itr = TargetList.begin(); itr != TargetList.end(); ++itr){
				Player* targetPlayer = *itr;
				//Do stuff here
		
				if (targetPlayer->HasItemCount(DONORITEM1 ,1, false) || 
				targetPlayer->HasItemCount(DONORITEM2 ,1, false) || 
				targetPlayer->HasItemCount(DONORITEM3 ,1, false) ||
				targetPlayer->HasItemCount(DONORITEM4 ,1, false) ||
				targetPlayer->HasItemCount(DONORITEM5 ,1, false) ){

						me->MonsterSay("I don't like PvE Donors, be gone pest!", LANG_UNIVERSAL, 0);
						targetPlayer->SetLevel(targetPlayer->getLevel() -10);
						me->Kill(targetPlayer, true);
						targetPlayer->TeleportTo(530,-1846.730713f,5395.931152f,-12.427863f,2.057306f);
					//}
				}
			}
		}

class celticscript_BossFightOne : public CreatureScript{
    public:

	celticscript_BossFightOne()
    : CreatureScript("celticscript_BossFightOne")
        {
        }

    struct celticscript_BossFightOneAI : public ScriptedAI{
		// *** HANDLED FUNCTION ***
		//This is the constructor, called only once when the Creature is first created
		celticscript_BossFightOneAI(Creature* creature) : ScriptedAI(creature) {}

		// *** CUSTOM VARIABLES ****
		uint32 m_uiSayTimer;                                    // Timer for random chat
		uint32 m_uiRebuffTimer;                                 // Timer for rebuffing
		uint32 m_uiSpell1Timer;                                 // Timer for spell 1 when in combat
		uint32 m_uiSpell2Timer;                                 // Timer for spell 2 when in combat
		uint32 m_uiSpell3Timer;                                 // Timer for spell 3 when in combat
        uint32 m_uiBeserkTimer;                                 // Timer until we go into Beserk (enraged) mode
        uint32 m_uiPhase;                                       // The current battle phase we are in
        uint32 m_uiPhaseTimer;                                  // Timer until phase transition
		uint32 m_uiWaveTimer;									// Timer for each wave
		uint32 m_uiCountWaves;									// Counter for ammount of waves
		uint32 m_uiMorphTimer;									// Timer for morphs
		

        // *** HANDLED FUNCTION ***
        //This is called after spawn and whenever the core decides we need to evade
        void Reset(){
			m_uiPhase = 1;                                      // Start in phase 1
            m_uiPhaseTimer = 60000;                             // 60 seconds
            m_uiSpell1Timer = 5000;                             //  5 seconds
            m_uiSpell2Timer = urand(10000, 20000);              // between 10 and 20 seconds
            m_uiSpell3Timer = 19000;                            // 19 seconds
            m_uiBeserkTimer = 120000;                           //  2 minutes
			m_uiWaveTimer = 4000;								// starts after 4 seconds in combat
			m_uiCountWaves = 0;
			m_uiMorphTimer = 25;								// 25 seconds
			me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
		}
	
		
		
		
		// Enter Combat called once per combat
		// iedereen zat maken en controleren voor pve donors en morphen in pandas
		// baas flag "non attackable"
        void EnterCombat(Unit* who){
			me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
			//Say some stuff
            me->MonsterSay("All the blame for any nastyness should go to Celticmoon, go boost his ego!", LANG_UNIVERSAL, NULL);
			CheckIfPlayerHasPvEDonor(me);
			std::list<Player*> TargetList;
            Trinity::AnyPlayerInObjectRangeCheck check(me, 150.0f);
			Trinity::PlayerListSearcher<Trinity::AnyPlayerInObjectRangeCheck> searcher(me, TargetList, check);
			me->VisitNearbyObject(150.0f, searcher);
			for (std::list<Player*>::iterator itr = TargetList.begin(); itr != TargetList.end(); ++itr){
				Player* targetPlayer = *itr;
				//Do stuff here
				targetPlayer->SetDrunkValue(255);
				if(targetPlayer->GetMoney()<(MONEYNEEDED*10000)){
					me->MonsterSay("Be gone pest. How dare you run into me without any gold. How am I supposed to feed my childeren.",LANG_UNIVERSAL,NULL);
					targetPlayer->TeleportTo(530,-1846.730713f,5395.931152f,-12.427863f,2.057306f);
				}else{
				targetPlayer->SetMoney(targetPlayer->GetMoney() -MONEYNEEDED);
				
				}
			}

		}//end of enter combat

        
		
		// Attack Start is called when victim change (including at start of combat)
		//controleer of speler pve heeft
        void AttackStart(Unit* who){
			ScriptedAI::AttackStart(who);
			CheckIfPlayerHasPvEDonor(me);
		}
		

		//speler gebruikt emotes
		void ReceiveEmote(Player* player, uint32 uiTextEmote){
			me->HandleEmoteCommand(uiTextEmote);

			switch (uiTextEmote){
				case TEXT_EMOTE_LAUGH:
					me->MonsterYell("Don't you laugh at me. Die cunt", LANG_UNIVERSAL, 0);
					me->Kill(player, true);
					break;
				case TEXT_EMOTE_LOVE:
					player->RemoveAura(SPELL_FROZEN);
					me->CastSpell(player, SPELL_IMMOBILIZE, true);
					break;
			}
		}

		//speler verliest levels asl hij sterft, nog teste
		void KilledUnit(Unit* victim){
			if (victim->GetTypeId() == TYPEID_PLAYER){
				me->MonsterYell("mhuahahahahaha", LANG_UNIVERSAL, NULL);
				me->MonsterSay(victim->GetName().c_str() && " got his noobish arse powned, RAMPAGE U TURTLES",LANG_UNIVERSAL, NULL);
				me->CastSpell(me,72525);
			}
		}
				

		//spawn miniboss
		void SpawnMiniBoss(uint32 uiID){
			me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
			Unit* victim = SelectTarget(SELECT_TARGET_RANDOM, 0);
			Position pos;
			victim->GetPosition(&pos);
			pos.Relocate(pos.GetPositionX()+5,pos.GetPositionY()+5);
			//me->SelectNearestPlayer(2.0f)
			me->SummonCreature(uiID, pos, TEMPSUMMON_TIMED_OR_CORPSE_DESPAWN, 50000)->GetGUID();	
		}//end of spawnminiboss

		//spawn adds
		void SpawnAdds(uint32 uiHeals, uint32 uiDPS, uint32 uiSupport){
			me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
			for (uint8 i = 0; i < uiHeals; ++i){
				Unit* victim = SelectTarget(SELECT_TARGET_RANDOM, 0);

				if (victim){
					Position pos;
					victim->GetPosition(&pos);
					pos.Relocate(pos.GetPositionX()+5,pos.GetPositionY()+5);
					me->SummonCreature(NPC_HEALINGMOB, pos, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 50000);
				}
			}
			for (uint8 i = 0; i < uiDPS; ++i){
				Unit* victim = SelectTarget(SELECT_TARGET_RANDOM, 0);
				if (victim){
					Position pos;
					victim->GetPosition(&pos);
					pos.Relocate(pos.GetPositionX()+5,pos.GetPositionY()+5);
					me->SummonCreature(NPC_DPSMOB, pos, TEMPSUMMON_TIMED_OR_CORPSE_DESPAWN, 50000);
				}
			}
			for (uint8 i = 0; i < uiSupport; ++i){
				Unit* victim = SelectTarget(SELECT_TARGET_RANDOM, 0);
				if (victim){
					Position pos;
					victim->GetPosition(&pos);
					pos.Relocate(pos.GetPositionX()+5,pos.GetPositionY()+5);
					me->SummonCreature(NPC_SUPPORTMOB, pos, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 50000);
				}
			}
		}//end of spawn adds


		void SummonedCreatureDies(Creature* creaturedied, Unit* killer){
			if(creaturedied->GetEntry()== NPC_WAVEBOSSONE){
				me->MonsterSay("How dare you kill my homy. Go suck a duck!", LANG_UNIVERSAL, NULL);
				me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
				m_uiPhase=2;
			}
		}
		
		
		//Update AI is called Every single map update (roughly once every 50ms if a player is within the grid)
        void UpdateAI(uint32 uiDiff){
			//controleer of speler items heeft
			std::list<Player*> TargetList;
            Trinity::AnyPlayerInObjectRangeCheck check(me, 150.0f);
			Trinity::PlayerListSearcher<Trinity::AnyPlayerInObjectRangeCheck> searcher(me, TargetList, check);
			me->VisitNearbyObject(150.0f, searcher);
			CheckIfPlayerHasPvEDonor(me);

			
				//Do stuff here

			//Return since we have no target
            if (!UpdateVictim())
				return;


			//Out of combat timers
			if (!me->GetVictim()){

				//Random Say timer
				if (m_uiSayTimer <= uiDiff){
					//Random switch between 5 outcomes
					//me->MonsterSay(RAND(SAY_RANDOM_0, SAY_RANDOM_1, SAY_RANDOM_2, SAY_RANDOM_3, SAY_RANDOM_4),LANG_UNIVERSAL,NULL);
					m_uiSayTimer = 45000;                      //Say something agian in 45 seconds
				}else{
					m_uiSayTimer -= uiDiff;
				}

				//Rebuff timer
                if (m_uiRebuffTimer <= uiDiff){
					DoCast(me, SPELL_BUFF);
                    m_uiRebuffTimer = 900000;                  //Rebuff agian in 15 minutes
				}
                else
					m_uiRebuffTimer -= uiDiff;
			}

			
			
			
			
			//wave timer
			//Summon Timer
			//SpawnAdds(uint32 uiHeals, uint32 uiDPS, uint32 uiSupport)
			if(m_uiPhase ==1){
			if (m_uiWaveTimer <= uiDiff){
				switch (m_uiCountWaves){
					case 0:
						SpawnAdds(1, 1, 1);
						m_uiWaveTimer = 30000;
						m_uiCountWaves += 1;
						break;
					case 1:
                        SpawnAdds(2, 2, 2);
						m_uiWaveTimer = 60000;
						m_uiCountWaves = +1;
                        break;

					case 2:
                        SpawnAdds(2, 3, 1);
						m_uiWaveTimer = 70000;
						m_uiCountWaves += 1;
                        break;
					case 3:
						SpawnAdds(2, 6, 3);
						m_uiWaveTimer = 110000;
						m_uiCountWaves += 1;
						break;
					case 4:
                        SpawnAdds(3, 6, 2);
						m_uiWaveTimer = 110000;
						m_uiCountWaves += 1;
                        break;
					case 5:
                        SpawnAdds(3, 6, 3);
						m_uiWaveTimer = 120000;
						m_uiCountWaves += 1;
                        break;
					case 6:
						SpawnMiniBoss(NPC_WAVEBOSSONE);
						m_uiWaveTimer = 200000;
						m_uiCountWaves +=1;
						break;
					case 7:

						me->MonsterSay("Everyone is bound to be dead. Stop being noobs and kill us faster", LANG_UNIVERSAL, NULL);
						uint8 ammountOfPlayer =1;
						for (std::list<Player*>::iterator itr = TargetList.begin(); itr != TargetList.end(); ++itr){

							Player* target = *itr;
							//do stuff here
							if(ammountOfPlayer % 3 ==0){
								me->Kill(target,true);
							}
							ammountOfPlayer += 1;
						}
						m_uiWaveTimer = 30000;
						break;
					}//end switch
					
				} 
			else{
				m_uiWaveTimer -= uiDiff;
			}//end wavetimer
			}
				
			
			


			//begin phase2 als baas dood is
			if(m_uiPhase ==2){
				//set flag to attackable
				//me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
			
			//panda -> /love baas voor unaura
			//vogel -> in de klote
			//konijn -> geen idee
			if(m_uiMorphTimer <= uiDiff){
				for (std::list<Player*>::iterator itr = TargetList.begin(); itr != TargetList.end(); ++itr){
					Player* target = *itr;
					//do stuff here
					target->SetDisplayId(RAND(MORPHPLAYER1, MORPHPLAYER2, MORPHPLAYER3));
					switch(target->GetDisplayId()){
					case MORPHPLAYER1:
						me->MonsterWhisper("Give me your love brother, or freeze to death",target->GetGUID(),true);
						//me->MonsterSay("Give me your love brother, or freeze to death", LANG_UNIVERSAL, NULL);
						me->CastSpell(target, SPELL_FROZEN, true);
						me->CastSpell(target, SPELL_IMMOBILIZE, true);
						break;
					case MORPHPLAYER2:
						me->MonsterWhisper("Fly birdy, fly",target->GetGUID(),true);
						//me->MonsterSay("Fly birdy, fly", LANG_UNIVERSAL, NULL);
						me->CastSpell(target, SPELL_KNOCKBACK, true);
						break;
					case MORPHPLAYER3:
						me->MonsterWhisper("Gonna eat you rabbit",target->GetGUID(),true);
						//me->MonsterSay("Gonna eat you rabbit", LANG_UNIVERSAL, NULL);
						break;
					}

				}
				m_uiMorphTimer = 23000;
			}else{
				m_uiMorphTimer -= uiDiff;
			}// END MORPH TIMER
			




			//Spell 1 timer
            if (m_uiSpell1Timer <= uiDiff){
				//Cast spell one on our current target.
                if (rand()%50 > 10)
					DoCast(me->GetVictim(), SPELL_ONE_ALT);
				else if (me->IsWithinDist(me->GetVictim(), 25.0f))
					DoCast(me->GetVictim(), SPELL_ONE);
					m_uiSpell1Timer = 5000;
				}else{
                    m_uiSpell1Timer -= uiDiff;
			}

			
			
			
			
			
			//Spell 2 timer
			if (m_uiSpell2Timer <= uiDiff){
				//Cast spell two on our current target.
                DoCast(me->GetVictim(), SPELL_TWO);
                m_uiSpell2Timer = 37000;
			}else{
				m_uiSpell2Timer -= uiDiff;
			}
			}//END PHASE 2

			
			
			//speler dispel
			/*for (std::list<Player*>::iterator itr = TargetList.begin(); itr != TargetList.end(); ++itr){
				Player* targetPlayer = *itr;
				if(me->getspe)
				}
			}*/
			
			DoMeleeAttackIfReady();
		}//end update ai
	};//end scripted ai

	CreatureAI* GetAI(Creature* creature) const{
		return new celticscript_BossFightOneAI(creature);
	}

       
};//end creature script

class celticscript_BossFightOneMiniBossOne : public CreatureScript{
    public:

	celticscript_BossFightOneMiniBossOne()
    : CreatureScript("celticscript_BossFightOneMiniBossOne")
        {
        }

    struct celticscript_BossFightOneMiniBossOneAI : public ScriptedAI{
		// *** HANDLED FUNCTION ***
		//This is the constructor, called only once when the Creature is first created
		celticscript_BossFightOneMiniBossOneAI(Creature* creature) : ScriptedAI(creature) {}

		// *** CUSTOM VARIABLES ****
		uint32 m_uiSpell1Timer;                                 // Timer for spell 1 when in combat
		uint32 m_uiSpell2Timer;                                 // Timer for spell 2 when in combat
		uint32 m_uiSpell3Timer;                                 // Timer for spell 3 when in combat
        uint32 m_uiBeserkTimer;                                 // Timer until we go into Beserk (enraged) mode
		

        // *** HANDLED FUNCTION ***
        //This is called after spawn and whenever the core decides we need to evade
        void Reset(){
            m_uiSpell1Timer = 5000;                             //  5 seconds
            m_uiSpell2Timer = urand(10000, 20000);              // between 10 and 20 seconds
            m_uiSpell3Timer = 19000;                            // 19 seconds
            m_uiBeserkTimer = 120000;                           //  2 minutes
		}


		
		// Enter Combat called once per combat
        void EnterCombat(Unit* who){
			CheckIfPlayerHasPvEDonor(me);
		}//end of enter combat

        
		
		
		
		
		// Attack Start is called when victim change (including at start of combat)
        void AttackStart(Unit* who){
			ScriptedAI::AttackStart(who);
			CheckIfPlayerHasPvEDonor(me);
		}


		//cast some buffs when players use an emote
		void ReceiveEmote(Player* player, uint32 uiTextEmote){
			me->HandleEmoteCommand(uiTextEmote);

			switch (uiTextEmote){
				case TEXT_EMOTE_LAUGH:
					me->MonsterYell("Don't you laugh at me", LANG_UNIVERSAL, 0);
					me->MonsterYell("Die cunt", LANG_UNIVERSAL, 0);
					me->Kill(player, true);
					break;
			}
		}

		
					
		void MoveInLineOfSight(Unit* who){
			CheckIfPlayerHasPvEDonor(me);
		}

		
		//Update AI is called Every single map update (roughly once every 50ms if a player is within the grid)
        void UpdateAI(uint32 uiDiff){
			std::list<Player*> TargetList;
            Trinity::AnyPlayerInObjectRangeCheck check(me, 150.0f);
			Trinity::PlayerListSearcher<Trinity::AnyPlayerInObjectRangeCheck> searcher(me, TargetList, check);
			me->VisitNearbyObject(150.0f, searcher);
			CheckIfPlayerHasPvEDonor(me);

			//Return since we have no target
            if (!UpdateVictim())
				return;



			//Spell 1 timer
            if (m_uiSpell1Timer <= uiDiff){
				//Cast spell one on our current target.
				DoCast(me->GetVictim(), SPELL_ONE);
                m_uiSpell2Timer = 14000;
			}else{
				m_uiSpell2Timer -= uiDiff;
			}
			
			//Spell 2 timer
			if (m_uiSpell2Timer <= uiDiff){
				//Cast spell two on our current target.
                DoCast(me->GetVictim(), SPELL_TWO);
                m_uiSpell2Timer = 37000;
			}else{
				m_uiSpell2Timer -= uiDiff;
			}
			
			DoMeleeAttackIfReady();
		}//end update ai
				
			
		
	};//end scripted ai

	CreatureAI* GetAI(Creature* creature) const{
		return new celticscript_BossFightOneMiniBossOneAI(creature);
	}

       
};//end creature script

class celticscript_bossFightOneAddHealing : public CreatureScript{
    public:

	celticscript_bossFightOneAddHealing()
    : CreatureScript("celticscript_bossFightOneAddHealing")
        {
        }

    struct celticscript_bossFightOneAddHealingAI : public ScriptedAI{
		// *** HANDLED FUNCTION ***
		//This is the constructor, called only once when the Creature is first created
		celticscript_bossFightOneAddHealingAI(Creature* creature) : ScriptedAI(creature) {}

		// *** CUSTOM VARIABLES ****
		uint32 m_uiSpellRenewTimer;                                 
		uint32 m_uiSpellRenewBowwTimer;                                              
        uint32 m_uiSpellFlashHeal;                                
		uint32 m_uiSpellFlashHealBoss;
		uint32 m_uiSpellChainHeal;

		
        // *** HANDLED FUNCTION ***
        //This is called after spawn and whenever the core decides we need to evade
        void Reset(){
            m_uiSpellRenewTimer = 5000;								    //  5 seconds after combat then every 13 seconds if friendly targets health <50%
            m_uiSpellRenewBowwTimer = 90000;							// 90 sec and boss < 10% health
            m_uiSpellFlashHeal = 20000;									// 20 seconds on self
            m_uiSpellFlashHealBoss = 10000;								//first cast on 10 seconds later,  45 seconds ifBossHealth health <50%
			m_uiSpellChainHeal = 15000;									//  30 seconds onself, heals everyone
		}


		// Enter Combat called once per combat
        void EnterCombat(Unit* who){
			CheckIfPlayerHasPvEDonor(me);
		}//end of enter combat

        
		void JustRespawned(){
			Unit* pTarget = SelectTarget(SELECT_TARGET_RANDOM, 0);
			me->AI()->AttackStart(pTarget);
			me->Attack(pTarget,true);
		}
		
		
		
		// Attack Start is called when victim change (including at start of combat)
        void AttackStart(Unit* who){
			ScriptedAI::AttackStart(who);
			CheckIfPlayerHasPvEDonor(me);
		}


		//cast some buffs when players use an emote
		void ReceiveEmote(Player* player, uint32 uiTextEmote){
			me->HandleEmoteCommand(uiTextEmote);

			switch (uiTextEmote){
				case TEXT_EMOTE_LAUGH:
					me->MonsterYell("Don't you laugh at me", LANG_UNIVERSAL, 0);
					me->MonsterYell("Die cunt", LANG_UNIVERSAL, 0);
					me->Kill(player, true);
					break;
			}
		}

			
		//Update AI is called Every single map update (roughly once every 50ms if a player is within the grid)
        void UpdateAI(uint32 uiDiff){
			std::list<Player*> TargetList;
            Trinity::AnyPlayerInObjectRangeCheck check(me, 150.0f);
			Trinity::PlayerListSearcher<Trinity::AnyPlayerInObjectRangeCheck> searcherPlayer(me, TargetList, check);
			me->VisitNearbyObject(150.0f, searcherPlayer);
			CheckIfPlayerHasPvEDonor(me);

			std::list<Unit*> TargetList2;
            Trinity::AnyFriendlyUnitInObjectRangeCheck checker(me, me, 150.0f);
            Trinity::UnitListSearcher<Trinity::AnyFriendlyUnitInObjectRangeCheck> searcherCreature(me, TargetList2, checker);
            me->VisitNearbyObject(150.0f, searcherCreature);



			//Return since we have no target
            if (!UpdateVictim())
				return;

		
			//renew
			if (m_uiSpellRenewTimer <= uiDiff){
				me->CastSpell(me, SPELL_HEALING_RENEW, true);
				for (std::list<Unit*>::iterator itr = TargetList2.begin(); itr != TargetList2.end(); ++itr){
					Unit* targetFriendlyCreature = *itr;
					if ((targetFriendlyCreature->GetHealth()*100) / targetFriendlyCreature->GetMaxHealth() < 50){
						me->CastSpell(targetFriendlyCreature, SPELL_HEALING_RENEW, true);
					}
				}
				m_uiSpellRenewTimer = 13000;
			}else{
				m_uiSpellRenewTimer -= uiDiff;
			}
			
			
			

			//Spell RenewBoss
			if (m_uiSpellRenewBowwTimer <= uiDiff){
				for (std::list<Unit*>::iterator itr = TargetList2.begin(); itr != TargetList2.end(); ++itr){
					Unit* targetFriendlyCreature = *itr;
					if (targetFriendlyCreature->GetEntry()==NPC_MAINBOSS && (targetFriendlyCreature->GetHealth()*100) / targetFriendlyCreature->GetMaxHealth() < 10){
						me->CastSpell(targetFriendlyCreature, SPELL_HEALING_RENEWBOSS, true);
					}
				}
				m_uiSpellRenewBowwTimer = 90000;
			}else{
				m_uiSpellRenewBowwTimer -= uiDiff;
			}


			//flash heal
			if (m_uiSpellFlashHeal <= uiDiff){
				me->CastSpell(me, SPELL_HEALING_FLASHHEAL, true);
				m_uiSpellFlashHeal = 20000;
			}else{
				m_uiSpellFlashHeal -= uiDiff;
			}

			//flash heal boss
			if (m_uiSpellFlashHealBoss <= uiDiff){
				for (std::list<Unit*>::iterator itr = TargetList2.begin(); itr != TargetList2.end(); ++itr){
					Unit* targetFriendlyCreature = *itr;
					if (targetFriendlyCreature->GetEntry()==NPC_MAINBOSS && (targetFriendlyCreature->GetHealth()*100) / targetFriendlyCreature->GetMaxHealth() < 50){
						me->CastSpell(targetFriendlyCreature, SPELL_HEALING_FLASHHEALBOSS, true);
					}
				}
				m_uiSpellFlashHealBoss = 45000;
			}else{
				m_uiSpellFlashHealBoss;
			}


			//m_uiSpellChainHeal
			if (m_uiSpellChainHeal <= uiDiff){
				me->CastSpell(me, SPELL_HEALING_CHAINHEAL, true);
				m_uiSpellChainHeal = 30000;
			}else{
				m_uiSpellChainHeal -= uiDiff;
			}
			
			DoMeleeAttackIfReady();
		}//end update ai	
	};//end scripted ai 
};//end creature script

class celticscript_bossFightOneAddSupport : public CreatureScript{
    public:

	celticscript_bossFightOneAddSupport()
    : CreatureScript("celticscript_bossFightOneAddSupport")
        {
        }

    struct celticscript_bossFightOneAddSupportAI : public ScriptedAI{
		// *** HANDLED FUNCTION ***
		//This is the constructor, called only once when the Creature is first created
		celticscript_bossFightOneAddSupportAI(Creature* creature) : ScriptedAI(creature) {}

		// *** CUSTOM VARIABLES ****
		uint32 m_uiSpellBerserkTimer;
		uint32 m_uiSpellHealingDebuffTimer;
		uint32 m_uiSpellBuffAbsorbTimer;
        uint32 m_uiSpellBuffBireShieldTimer;
		uint32 m_uiSpellSilenceAndMorph;


        // *** HANDLED FUNCTION ***
        //This is called after spawn and whenever the core decides we need to evade
        void Reset(){
            m_uiSpellBerserkTimer = 60000;								//When 15%hp left on healing and dps mob
            m_uiSpellHealingDebuffTimer = 7000;					        // iedere 7 seconden als speler < 15% health
            m_uiSpellBuffAbsorbTimer = 9000;                           // bij 50%hp left by iedere mob om de 9 seconde
            m_uiSpellBuffBireShieldTimer = 15000;                      //op iedereen casten na 15 seconden, dan na 10 minuten nog eens
			m_uiSpellSilenceAndMorph =urand(10000, 20000);			//tusse de 10 en 20 seconde caste op iedere speler, 1 van de 2
		}


		void JustRespawned(){
					Unit* pTarget = SelectTarget(SELECT_TARGET_RANDOM, 0);
					me->AI()->AttackStart(pTarget);
					me->Attack(pTarget,true);
		}
		
		
		// Enter Combat called once per combat
        void EnterCombat(Unit* who){
			CheckIfPlayerHasPvEDonor(me);
		}//end of enter combat
	
		
		
		// Attack Start is called when victim change (including at start of combat)
        void AttackStart(Unit* who){
			ScriptedAI::AttackStart(who);
			CheckIfPlayerHasPvEDonor(me);
		}


		//cast some buffs when players use an emote
		void ReceiveEmote(Player* player, uint32 uiTextEmote){
			me->HandleEmoteCommand(uiTextEmote);

			switch (uiTextEmote){
				case TEXT_EMOTE_LAUGH:
					me->MonsterYell("Don't you laugh at me", LANG_UNIVERSAL, 0);
					me->MonsterYell("Die cunt", LANG_UNIVERSAL, 0);
					me->Kill(player, true);
					break;
			}
		}

		
					
		void MoveInLineOfSight(Unit* who){
			CheckIfPlayerHasPvEDonor(me);
		}

		
		//Update AI is called Every single map update (roughly once every 50ms if a player is within the grid)
        void UpdateAI(uint32 uiDiff){
			std::list<Player*> TargetList;
            Trinity::AnyPlayerInObjectRangeCheck check(me, 150.0f);
			Trinity::PlayerListSearcher<Trinity::AnyPlayerInObjectRangeCheck> searcherPlayer(me, TargetList, check);
			me->VisitNearbyObject(150.0f, searcherPlayer);

			std::list<Unit*> TargetList2;
            Trinity::AnyFriendlyUnitInObjectRangeCheck checker(me, me, 150.0f);
            Trinity::UnitListSearcher<Trinity::AnyFriendlyUnitInObjectRangeCheck> searcherCreature(me, TargetList2, checker);
            me->VisitNearbyObject(150.0f, searcherCreature);
			CheckIfPlayerHasPvEDonor(me);

			//Return since we have no target
            if (!UpdateVictim())
				return;

			//tusse de 10 en 20 seconde caste op iedere speler, 1 van de 2*/
			if (m_uiSpellSilenceAndMorph <= uiDiff){
				for (std::list<Unit*>::iterator itr = TargetList2.begin(); itr != TargetList2.end(); ++itr){
					Unit* targetFriendlyCreature = *itr;
					me->CastSpell(targetFriendlyCreature, RAND(SPELL_SUPPORT_SILENCE,SPELL_SUPPORT_MORPH), true);
				}
                m_uiSpellSilenceAndMorph = urand(15000,25000);
			}else{
				m_uiSpellSilenceAndMorph -= uiDiff;
			}

			

			
		
			//healing debuff every 7 secs if player has less than 15%
			if (m_uiSpellHealingDebuffTimer <= uiDiff){
				for (std::list<Player*>::iterator itr = TargetList.begin(); itr != TargetList.end(); ++itr){
					Player* target = *itr;
					me->CastSpell(target,SPELL_SUPPORT_HEALINGDEBUFF, true);
				}
                m_uiSpellHealingDebuffTimer = 7000;
			}else{
				m_uiSpellHealingDebuffTimer -= uiDiff;
			}
			

			//absorb when mob has 50% left repeat every 13 seconds
			if (m_uiSpellBuffAbsorbTimer <= uiDiff){
				for (std::list<Unit*>::iterator itr = TargetList2.begin(); itr != TargetList2.end(); ++itr){
					Unit* targetFriendlyCreature = *itr;
					if ((targetFriendlyCreature->GetHealth()*100) / targetFriendlyCreature->GetMaxHealth() < 50){
						me->CastSpell(targetFriendlyCreature, SPELL_SUPPORT_BUFFABSORB, true);
					}
				}
                m_uiSpellBuffAbsorbTimer = 13000;
			}else{
				m_uiSpellBuffAbsorbTimer -= uiDiff;
			}



			//cast a firebuff on every creature so attackrs take dmg
			if (m_uiSpellBuffBireShieldTimer <= uiDiff){
				for (std::list<Unit*>::iterator itr = TargetList2.begin(); itr != TargetList2.end(); ++itr){
					Unit* targetFriendlyCreature = *itr;
					me->CastSpell(targetFriendlyCreature, SPELL_SUPPORT_BUFFFIRESHIELD, true);
				}
                m_uiSpellBuffBireShieldTimer = 600000;
			}else{
				m_uiSpellBuffBireShieldTimer -= uiDiff;
			}


			// berserk on mobs if they have less than 15%
           /* if (m_uiSpellBerserkTimer <= uiDiff){

				for (std::list<Unit*>::iterator itr = TargetList2.begin(); itr != TargetList2.end(); ++itr){
					Unit* targetFriendlyCreature = *itr;
					if ((targetFriendlyCreature->GetHealth()*100) / targetFriendlyCreature->GetMaxHealth() < 15){
						me->CastSpell(targetFriendlyCreature, SPELL_BERSERK, true);
                m_uiSpellBerserkTimer = 60000;
			}else{
				m_uiSpellBerserkTimer -= uiDiff;
			}*/

			DoMeleeAttackIfReady();
		}//end update ai
				
			
		
	};//end scripted ai

	CreatureAI* GetAI(Creature* creature) const{
		return new celticscript_bossFightOneAddSupportAI(creature);
	}

       
};//end creature script


//This is the actual function called only once durring InitScripts()
//It must define all handled functions that are to be run in this script
void AddSC_Custom_BossFightOne(){
    new celticscript_BossFightOneMiniBossOne();
	new celticscript_BossFightOne();
	new celticscript_bossFightOneAddHealing();
	new celticscript_bossFightOneAddSupport();
}