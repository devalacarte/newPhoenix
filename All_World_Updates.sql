/* 
* sql\updates\world\2013_08_29_00_world_sai.sql 
*/ 
-- Escape from Silverbrook
SET @ENTRY          := 27499; -- Caged Prisoner
SET @PRISONER       := 27411; -- Freed Alliance Scout
SET @HORSE          := 27409; -- The Qorse (Reference to Machiavelli)
SET @SUMM_HORSE     := 48651; -- Summon Ducal's Horse
SET @SUMM_WORG      := 48681; -- Summon Worgen
SET @WORG           := 27417; -- Silverbrook Worgen

DELETE FROM `spell_script_names` WHERE `spell_id` IN (48682,48681);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(48682, 'spell_q12308_escape_from_silverbrook'),
(48681, 'spell_q12308_escape_from_silverbrook_summon_worgen'); 

UPDATE `creature_template` SET AIName='SmartAI' WHERE `entry` IN (@ENTRY,@PRISONER,@HORSE,@WORG);
DELETE FROM `smart_scripts` WHERE `entryorguid`IN (@ENTRY,@PRISONER,@PRISONER*100,@HORSE,@HORSE*100,@WORG) AND `source_type`IN (0,9);
DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (@ENTRY,@PRISONER,@HORSE,@WORG);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`)VALUES
(@ENTRY,0,0,1,19,0,100,0,12308,0,0,0,11,48710,0,0,0,0,0,19,24042,10,0,0,0,0,0,'Caged Prisoner - on quest accepted - Summon Freed Alliance Scout'),
(@ENTRY,0,1,2,61,0,100,0,0,0,0,0,9,0,0,0,0,0,0,15,188706,10,0,0,0,0,0,'Caged Prisoner - On Link - Activate Cage'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,41,500,0,0,0,0,0,1,0,0,0,0,0,0,0,'Caged Prisoner - On quest accepted - Summon Freed Alliance Scout'),
-- 
(@PRISONER,0,0,0,54,0,100,0,0,0,0,0,80,@PRISONER*100,2,0,0,0,0,1,0,0,0,0,0,0,0,'Freed Alliance Scout - On Respawn - Start Timed Action Script'),
(@PRISONER,0,1,2,40,0,100,1,6,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'Freed Alliance Scout - On WP Reached - Say 3'),
(@PRISONER,0,2,3,61,0,100,0,0,0,0,0,11,@SUMM_HORSE,0,0,0,0,0,1,0,0,0,0,0,0,0,'Freed Alliance Scout - On Link - Summon Horse'),
(@PRISONER,0,3,0,61,0,100,0,0,0,0,0,11,46598,0,0,0,0,0,19,@HORSE,10,0,0,0,0,0,'Freed Alliance Scout - On Link - Mount Horse'),
(@PRISONER,0,4,0,38,0,100,0,1,1,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,'Freed Alliance Scout - On Link - Say'),
--
(@PRISONER*100,9,0,0,0,0,100,0,3000,3000,3000,3000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Freed Alliance Scout - On Script - Say 0'),
(@PRISONER*100,9,1,0,0,0,100,0,5000,5000,5000,5000,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Freed Alliance Scout - On Script - Say 1'),
(@PRISONER*100,9,2,0,0,0,100,0,4000,4000,4000,4000,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Freed Alliance Scout - On Script - Say 2'),
(@PRISONER*100,9,3,0,0,0,100,0,9000,9000,9000,9000,53,1,@PRISONER,0,0,0,0,1,0,0,0,0,0,0,0,'Freed Alliance Scout - On Script - Start WP movement'),
--
(@HORSE,0,0,1,27,0,100,0,0,0,0,0,80,@HORSE*100,0,0,0,0,0,1,0,0,0,0,0,0,0,'Ducal''s Horse - On Passanger Boarded - Start Timed Action Script'),
(@HORSE,0,1,0,61,0,100,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Ducal''s Horse - On Link - Allow Combat Movement'),
(@HORSE,0,2,5,40,0,100,0,102,0,0,0,11,48678,0,0,0,0,0,21,10,0,0,0,0,0,0,'Ducal''s Horse - On WP Reached - Dismount Player'),
(@HORSE,0,3,0,40,0,100,0,36,0,0,0,97,25,10,0,0,0,0,1,0,0,0,4063.238525,-2261.991211,215.988922,0,'Ducal''s Horse - On WP Reached - Jump to PoS'),
(@HORSE,0,4,0,40,0,100,0,74,0,0,0,97,25,10,0,0,0,0,1,0,0,0,3900.396484,-2743.329346, 219.152481,0,'Ducal''s Horse - On WP Reached - Jump to PoS'),
(@HORSE,0,5,6,61,0,100,0,0,0,0,0,33,28019,0,0,0,0,0,21,10,0,0,0,0,0,0,'Ducal''s Horse - On WP Reached - Give Credit'),
(@HORSE,0,6,0,61,0,100,0,0,0,0,0,41,5000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Ducal''s Horse - On WP Reached - Despawn'),
-- 48678
(@HORSE*100,9,0,0,0,0,100,0,5000,5000,5000,5000,53,1,@HORSE,0,12308,0,0,1,0,0,0,0,0,0,0,'Ducal''s Horse - Script - Start WP Movement'),
(@HORSE*100,9,1,0,0,0,100,0,1000,1000,1000,1000,45,1,1,0,0,0,0,19,@PRISONER,10,0,0,0,0,0,'Ducal''s Horse - Script - Start WP Movement'),
(@HORSE*100,9,2,0,0,0,100,0,0,0,0,0,11,48683,2,0,0,0,0,1,0,0,0,0,0,0,0,'Ducal''s Horse - Script - Cast On self'),
--
(@WORG,0,0,0,54,0,100,0,9,0,0,0,49,0,0,0,0,0,0,19,@HORSE,60,0,0,0,0,0,'Silverbrook Worgen - On Spawn - Attack Horse'),
(@WORG,0,1,0,4,0,100,0,9,0,0,0,11,36589,0,0,0,0,0,1,0,0,0,0,0,0,0,'Silverbrook Worgen - On Aggro - Cast Dash');

DELETE FROM `creature_text` WHERE entry = 27411;
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES
(27411, 0, 0, 'Were you bitten?', 12, 0, 100, 6, 0, 0, 'Freed Alliance Scout Say1'),
(27411, 1, 1, 'Answer me! Were you bloody bitten?', 14, 0, 100, 22, 0, 0, 'Freed Alliance Scout Yell'),
(27411, 2, 2, 'You don''t even know, do you? The trappers? They''re not human... we have to get out of here! Come, quick!', 12, 0, 100, 0, 0, 0, 'Freed Alliance Scout Say2'),
(27411, 3, 3, 'Take Ducal''s horse, he''s one of them now!', 12, 0, 100, 0, 0, 0, 'Freed Alliance Scout Say3'),
(27411, 4, 4, 'There''s lamp oil in the back - make use of it. The fiends hate fire!', 12, 0, 100, 0, 0, 0, 'Freed Alliance Scout Say4');

DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`= 27409;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES 
(27409, 48678, 1, 0); -- Mount Ducal's Horse (for player)

UPDATE `creature_template` SET `speed_walk`=1.142857, `speed_run`=1, `rangeattacktime`=2000, `dynamicflags`=0 WHERE `entry`=27499; -- Caged Prisoner
UPDATE `creature_template` SET `VehicleId` = 51, `IconName`= 'vehichleCursor', `npcflag` =16777216, `unit_flags`=0, `spell1` = 48677, `spell2` = 48768, `spell3` = 48783 WHERE `entry` = 27409;
UPDATE `creature_template` SET `faction_A`=1891,`faction_H`=1891,`baseattacktime`=1500,`unit_flags`=768 WHERE `entry`=27411;
UPDATE `creature_template` SET `faction_A` = 16, `faction_H` = 16 WHERE entry = 27417;

-- Ducal's Horse waypoints
DELETE FROM `waypoints` WHERE entry = 27409;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `point_comment`) VALUES 
(27409, 0, 4431.638672, -2481.546143, 245.497971, ''),
(27409, 1, 4449.238281, -2471.332031, 242.360382, ''),
(27409, 2, 4461.925293, -2462.848145, 239.519882, ''),
(27409, 3, 4462.994141, -2448.238037, 237.881256, ''),
(27409, 4, 4479.575684, -2434.093506, 235.040390, ''),
(27409, 5, 4488.495605, -2420.688477, 233.043091, ''),
(27409, 6, 4494.654785, -2414.143066, 230.241013, ''),
(27409, 7, 4499.730469, -2414.861572, 230.952850, ''),
(27409, 8, 4510.846191, -2401.806641, 226.618698, ''),
(27409, 9, 4517.005371, -2388.016357, 220.151077, ''),
(27409, 10, 4520.017578, -2373.915283, 213.041779, ''),
(27409, 11, 4524.577637, -2355.400391, 202.208481, ''),
(27409, 12, 4520.500977, -2332.202148, 190.853638, ''),
(27409, 13, 4509.677734, -2314.525635, 182.408096, ''),
(27409, 14, 4488.281250, -2309.130127, 184.351913, ''),
(27409, 15, 4480.724609, -2311.419434, 185.420715, ''),
(27409, 16, 4470.293457, -2314.579346, 183.929382, ''),
(27409, 17, 4453.349121, -2318.290771, 189.487000, ''),
(27409, 18, 4442.953613, -2311.859375, 192.656219, ''),
(27409, 19, 4414.564941, -2297.739258, 191.105362, ''),
(27409, 20, 4396.023438, -2286.889648, 192.638016, ''),
(27409, 21, 4383.112305, -2278.546631, 188.321487, ''),
(27409, 22, 4369.118652, -2256.089844, 187.592911, ''),
(27409, 23, 4339.653320, -2250.217529, 188.636993, ''),
(27409, 24, 4299.784180, -2260.091309, 205.303589, ''),
(27409, 25, 4292.068848, -2261.806885, 209.099808, ''),
(27409, 26, 4258.068359, -2270.728027, 212.053543, ''),
(27409, 27, 4224.148926, -2276.497559, 214.878052, ''),
(27409, 28, 4210.618652, -2280.829346, 214.910553, ''),
(27409, 29, 4193.759766, -2285.936035, 219.885529, ''),
(27409, 30, 4168.561523, -2272.436279, 221.375009, ''),
(27409, 31, 4151.019531, -2269.352783, 223.433472, ''),
(27409, 32, 4131.847168, -2271.157715, 221.920700, ''),
(27409, 33, 4112.480469, -2276.041748, 219.916550, ''),
(27409, 34, 4103.597656, -2274.198730, 219.276031, ''),
(27409, 35, 4093.837158, -2276.393066, 219.042526, ''),
(27409, 36, 4084.734375, -2272.286133, 217.870331, ''), -- Jump PoS
(27409, 37, 4063.238525, -2261.991211, 215.988922, ''), -- Jump continuation
(27409, 38, 4059.935547, -2260.473145, 216.993256, ''),
(27409, 39, 4028.185791, -2252.874512, 218.258530, ''),
(27409, 40, 4020.977539, -2249.354004, 217.129837, ''),
(27409, 41, 4005.426025, -2256.105957, 218.451675, ''),
(27409, 42, 3988.108398, -2262.058350, 217.109756, ''),
(27409, 43, 3968.364014, -2267.235840, 215.268341, ''),
(27409, 44, 3953.139893, -2268.633057, 212.391113, ''),
(27409, 45, 3935.732422, -2276.518066, 209.669937, ''),
(27409, 46, 3922.170898, -2282.024414, 211.200699, ''),
(27409, 47, 3913.766846, -2300.279541, 209.620239, ''),
(27409, 48, 3914.160156, -2317.614990, 208.949615, ''),
(27409, 49, 3911.533936, -2330.580078, 207.751999, ''),
(27409, 50, 3907.095947, -2346.107422, 204.630707, ''),
(27409, 51, 3901.425537, -2362.481201, 206.197708, ''),
(27409, 52, 3885.374756, -2368.482178, 202.270737, ''),
(27409, 53, 3871.682617, -2371.436035, 196.694305, ''),
(27409, 54, 3858.806396, -2374.236816, 194.038589, ''),
(27409, 55, 3833.323975, -2390.121582, 187.584473, ''),
(27409, 56, 3818.713379, -2403.767090, 183.718597, ''),
(27409, 57, 3812.403564, -2425.267334, 185.086273, ''),
(27409, 58, 3812.611328, -2432.785400, 186.023727, ''),
(27409, 59, 3812.221680, -2453.928711, 188.508041, ''),
(27409, 60, 3815.669189, -2479.355957, 192.388458, ''),
(27409, 61, 3819.468262, -2503.677002, 195.024658, ''),
(27409, 62, 3822.264648, -2517.937256, 194.068130, ''),
(27409, 63, 3825.485107, -2534.361572, 196.379684, ''),
(27409, 64, 3829.201660, -2554.680664, 196.714203, ''),
(27409, 65, 3836.672119, -2578.528076, 196.706253, ''),
(27409, 66, 3847.536133, -2609.345459, 200.060410, ''),
(27409, 67, 3861.525879, -2624.756592, 202.314850, ''),
(27409, 68, 3882.063232, -2655.939209, 203.425415, ''),
(27409, 69, 3886.698975, -2663.550293, 208.091705, ''),
(27409, 70, 3900.575928, -2672.409912, 212.662750, ''),
(27409, 71, 3909.817383, -2687.583008, 217.098572, ''),
(27409, 72, 3911.782959, -2695.853027, 220.364487, ''),
(27409, 73, 3916.008301, -2703.185791, 221.175446, ''),
(27409, 74, 3912.544678, -2712.180420, 221.059509, ''), -- Jump location
(27409, 75, 3900.396484, -2743.329346, 219.152481, ''), -- Jump continue
(27409, 76, 3889.821777, -2751.587646, 221.798737, ''),
(27409, 77, 3883.421875, -2756.963379, 223.885544, ''),
(27409, 78, 3851.103027, -2769.906494, 227.460480, ''),
(27409, 79, 3837.903076, -2769.537842, 226.115402, ''),
(27409, 80, 3813.292725, -2770.593018, 220.927460, ''),
(27409, 81, 3801.162109, -2771.017578, 219.535080, ''),
(27409, 82, 3780.501709, -2772.391602, 213.905884, ''),
(27409, 83, 3767.551025, -2775.388672, 211.281708, ''),
(27409, 84, 3759.778320, -2782.290771, 209.165924, ''),
(27409, 85, 3752.759277, -2787.596436, 206.495926, ''),
(27409, 86, 3729.982422, -2803.813721, 210.023056, ''),
(27409, 87, 3723.949951, -2808.085693, 211.655594, ''),
(27409, 88, 3705.986328, -2819.675537, 215.066315, ''),
(27409, 89, 3685.556152, -2832.987549, 217.602127, ''),
(27409, 90, 3674.411377, -2843.797852, 217.875214, ''),
(27409, 91, 3662.455811, -2853.292480, 216.581512, ''),
(27409, 92, 3647.392822, -2857.280518, 213.150558, ''),
(27409, 93, 3630.625977, -2860.268555, 214.962250, ''),
(27409, 94, 3610.744141, -2858.618164, 208.903931, ''),
(27409, 95, 3587.919189, -2854.562500, 203.447754, ''),
(27409, 96, 3562.793213, -2842.607666, 197.044495, ''),
(27409, 97, 3534.265625, -2828.214600, 197.154617, ''),
(27409, 98, 3515.692871, -2829.376709, 201.276230, ''),
(27409, 99, 3487.658691, -2829.192871, 202.143524, ''),
(27409, 100, 3472.460693, -2821.599365, 201.429428, ''),
(27409, 101, 3460.582031, -2817.212402, 201.804962, ''),
(27409, 102, 3443.644531, -2811.332520, 202.097687, '');

-- Freed Alliance Scout waypoints
DELETE FROM `waypoints` WHERE entry = 27411;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `point_comment`) VALUES 
(27411, 0, 4394.648438, -2502.304688, 252.802429, ''),
(27411, 1, 4389.777832, -2502.323242, 252.251602, ''),
(27411, 2, 4382.442383, -2501.507080, 246.809448, ''),
(27411, 3, 4381.006836, -2497.183838, 247.235260, ''),
(27411, 4, 4393.843750, -2484.841553, 248.717392, ''),
(27411, 5, 4416.043457, -2481.504150, 247.175400, ''),
(27411, 6, 4425.312500, -2486.656006, 246.555176, '');
 
 
/* 
* sql\updates\world\2013_08_29_01_world_update.sql 
*/ 
UPDATE `conditions` SET `NegativeCondition`=0 WHERE `SourceTypeOrReferenceId`=1 AND `SourceGroup` IN (36597,39166,39167,39168) AND `SourceEntry`=51315 AND `ConditionTypeOrReference`=3;
 
 
/* 
* sql\updates\world\2013_08_29_02_world_sai.sql 
*/ 
--  Suppression (7583)
SET @NPC_DEMON  := 12396;

DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@NPC_DEMON;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@NPC_DEMON;

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_DEMON);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_DEMON,0,0,0,0,0,100,0,5000,8000,18000,24000,11,16005,0,0,0,0,0,2,0,0,0,0,0,0,0,'Doomguard Commander - Cast Rain of Fire'),
(@NPC_DEMON,0,1,0,0,0,100,0,12000,15000,20000,25000,11,16727,0,0,0,0,0,2,0,0,0,0,0,0,0,'Doomguard Commander - Cast War Stomp'),
(@NPC_DEMON,0,2,0,0,0,100,0,2000,4000,25000,32000,11,20812,0,0,0,0,0,2,0,0,0,0,0,0,0,'Doomguard Commander - Cast Cripple'),
(@NPC_DEMON,0,3,0,0,0,100,0,7000,14000,17000,22000,11,15090,0,0,0,0,0,2,0,0,0,0,0,0,0,'Doomguard Commander - Cast Dispel Magic'),
--
(@NPC_DEMON,0,4,5,8,0,100,0,23019,0,0,0,56,18605,1,0,0,0,0,18,20,0,0,0,0,0,0,'Doomguard Commander - On spellhit - Add item Imprisoned Doomguard'),
(@NPC_DEMON,0,5,6,61,0,100,0,0,0,0,0,11,23020,0,0,0,0,0,1,0,0,0,0,0,0,0,'Doomguard Commander - On spellhit - Cast Crystal Imprisonment'),
(@NPC_DEMON,0,6,0,61,0,100,0,0,0,0,0,41,2000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Doomguard Commander - On spellhit - Despawn');

-- Conditions for Glowing Crystal Prison 
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=17 AND `SourceEntry`=23015;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(17,0,23015,0,0,31,1,3,12396,0,0,173,0,'','Glowing Crystal Prison target limit to Doomguard Commander');
 
 
/* 
* sql\updates\world\2013_08_29_03_world_quest_template.sql 
*/ 
ALTER TABLE `quest_template` DROP `RequiredSpellCast1`;
ALTER TABLE `quest_template` DROP `RequiredSpellCast2`;
ALTER TABLE `quest_template` DROP `RequiredSpellCast3`;
ALTER TABLE `quest_template` DROP `RequiredSpellCast4`;
 
 
/* 
* sql\updates\world\2013_08_29_04_world_db_errors.sql 
*/ 
-- Update sai to correlate with the pointid changes, otherwise we get a cluster of bad movement
UPDATE `smart_scripts` SET `event_param1`=7 WHERE  `entryorguid`=27411 AND `source_type`=0 AND `id`=1 AND `link`=2;
UPDATE `smart_scripts` SET `event_param1`=37 WHERE  `entryorguid`=27409 AND `source_type`=0 AND `id`=3 AND `link`=0;
UPDATE `smart_scripts` SET `event_param1`=75 WHERE  `entryorguid`=27409 AND `source_type`=0 AND `id`=4 AND `link`=0;
UPDATE `smart_scripts` SET `event_param1`=103 WHERE  `entryorguid`=27409 AND `source_type`=0 AND `id`=2 AND `link`=5;

DELETE FROM `waypoints` WHERE entry = 27409;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `point_comment`) VALUES
(27409, 1, 4431.638672, -2481.546143, 245.497971, ''),
(27409, 2, 4449.238281, -2471.332031, 242.360382, ''),
(27409, 3, 4461.925293, -2462.848145, 239.519882, ''),
(27409, 4, 4462.994141, -2448.238037, 237.881256, ''),
(27409, 5, 4479.575684, -2434.093506, 235.040390, ''),
(27409, 6, 4488.495605, -2420.688477, 233.043091, ''),
(27409, 7, 4494.654785, -2414.143066, 230.241013, ''),
(27409, 8, 4499.730469, -2414.861572, 230.952850, ''),
(27409, 9, 4510.846191, -2401.806641, 226.618698, ''),
(27409, 10, 4517.005371, -2388.016357, 220.151077, ''),
(27409, 11, 4520.017578, -2373.915283, 213.041779, ''),
(27409, 12, 4524.577637, -2355.400391, 202.208481, ''),
(27409, 13, 4520.500977, -2332.202148, 190.853638, ''),
(27409, 14, 4509.677734, -2314.525635, 182.408096, ''),
(27409, 15, 4488.281250, -2309.130127, 184.351913, ''),
(27409, 16, 4480.724609, -2311.419434, 185.420715, ''),
(27409, 17, 4470.293457, -2314.579346, 183.929382, ''),
(27409, 18, 4453.349121, -2318.290771, 189.487000, ''),
(27409, 19, 4442.953613, -2311.859375, 192.656219, ''),
(27409, 20, 4414.564941, -2297.739258, 191.105362, ''),
(27409, 21, 4396.023438, -2286.889648, 192.638016, ''),
(27409, 22, 4383.112305, -2278.546631, 188.321487, ''),
(27409, 23, 4369.118652, -2256.089844, 187.592911, ''),
(27409, 24, 4339.653320, -2250.217529, 188.636993, ''),
(27409, 25, 4299.784180, -2260.091309, 205.303589, ''),
(27409, 26, 4292.068848, -2261.806885, 209.099808, ''),
(27409, 27, 4258.068359, -2270.728027, 212.053543, ''),
(27409, 28, 4224.148926, -2276.497559, 214.878052, ''),
(27409, 29, 4210.618652, -2280.829346, 214.910553, ''),
(27409, 30, 4193.759766, -2285.936035, 219.885529, ''),
(27409, 31, 4168.561523, -2272.436279, 221.375009, ''),
(27409, 32, 4151.019531, -2269.352783, 223.433472, ''),
(27409, 33, 4131.847168, -2271.157715, 221.920700, ''),
(27409, 34, 4112.480469, -2276.041748, 219.916550, ''),
(27409, 35, 4103.597656, -2274.198730, 219.276031, ''),
(27409, 36, 4093.837158, -2276.393066, 219.042526, ''),
(27409, 37, 4084.734375, -2272.286133, 217.870331, ''), -- Jump PoS
(27409, 38, 4063.238525, -2261.991211, 215.988922, ''), -- Jump continuation
(27409, 39, 4059.935547, -2260.473145, 216.993256, ''),
(27409, 40, 4028.185791, -2252.874512, 218.258530, ''),
(27409, 41, 4020.977539, -2249.354004, 217.129837, ''),
(27409, 42, 4005.426025, -2256.105957, 218.451675, ''),
(27409, 43, 3988.108398, -2262.058350, 217.109756, ''),
(27409, 44, 3968.364014, -2267.235840, 215.268341, ''),
(27409, 45, 3953.139893, -2268.633057, 212.391113, ''),
(27409, 46, 3935.732422, -2276.518066, 209.669937, ''),
(27409, 47, 3922.170898, -2282.024414, 211.200699, ''),
(27409, 48, 3913.766846, -2300.279541, 209.620239, ''),
(27409, 49, 3914.160156, -2317.614990, 208.949615, ''),
(27409, 50, 3911.533936, -2330.580078, 207.751999, ''),
(27409, 51, 3907.095947, -2346.107422, 204.630707, ''),
(27409, 52, 3901.425537, -2362.481201, 206.197708, ''),
(27409, 53, 3885.374756, -2368.482178, 202.270737, ''),
(27409, 54, 3871.682617, -2371.436035, 196.694305, ''),
(27409, 55, 3858.806396, -2374.236816, 194.038589, ''),
(27409, 56, 3833.323975, -2390.121582, 187.584473, ''),
(27409, 57, 3818.713379, -2403.767090, 183.718597, ''),
(27409, 58, 3812.403564, -2425.267334, 185.086273, ''),
(27409, 59, 3812.611328, -2432.785400, 186.023727, ''),
(27409, 60, 3812.221680, -2453.928711, 188.508041, ''),
(27409, 61, 3815.669189, -2479.355957, 192.388458, ''),
(27409, 62, 3819.468262, -2503.677002, 195.024658, ''),
(27409, 63, 3822.264648, -2517.937256, 194.068130, ''),
(27409, 64, 3825.485107, -2534.361572, 196.379684, ''),
(27409, 65, 3829.201660, -2554.680664, 196.714203, ''),
(27409, 66, 3836.672119, -2578.528076, 196.706253, ''),
(27409, 67, 3847.536133, -2609.345459, 200.060410, ''),
(27409, 68, 3861.525879, -2624.756592, 202.314850, ''),
(27409, 69, 3882.063232, -2655.939209, 203.425415, ''),
(27409, 70, 3886.698975, -2663.550293, 208.091705, ''),
(27409, 71, 3900.575928, -2672.409912, 212.662750, ''),
(27409, 72, 3909.817383, -2687.583008, 217.098572, ''),
(27409, 73, 3911.782959, -2695.853027, 220.364487, ''),
(27409, 74, 3916.008301, -2703.185791, 221.175446, ''),
(27409, 75, 3912.544678, -2712.180420, 221.059509, ''), -- Jump location
(27409, 76, 3900.396484, -2743.329346, 219.152481, ''), -- Jump continue
(27409, 77, 3889.821777, -2751.587646, 221.798737, ''),
(27409, 78, 3883.421875, -2756.963379, 223.885544, ''),
(27409, 79, 3851.103027, -2769.906494, 227.460480, ''),
(27409, 80, 3837.903076, -2769.537842, 226.115402, ''),
(27409, 81, 3813.292725, -2770.593018, 220.927460, ''),
(27409, 82, 3801.162109, -2771.017578, 219.535080, ''),
(27409, 83, 3780.501709, -2772.391602, 213.905884, ''),
(27409, 84, 3767.551025, -2775.388672, 211.281708, ''),
(27409, 85, 3759.778320, -2782.290771, 209.165924, ''),
(27409, 86, 3752.759277, -2787.596436, 206.495926, ''),
(27409, 87, 3729.982422, -2803.813721, 210.023056, ''),
(27409, 88, 3723.949951, -2808.085693, 211.655594, ''),
(27409, 89, 3705.986328, -2819.675537, 215.066315, ''),
(27409, 90, 3685.556152, -2832.987549, 217.602127, ''),
(27409, 91, 3674.411377, -2843.797852, 217.875214, ''),
(27409, 92, 3662.455811, -2853.292480, 216.581512, ''),
(27409, 93, 3647.392822, -2857.280518, 213.150558, ''),
(27409, 94, 3630.625977, -2860.268555, 214.962250, ''),
(27409, 95, 3610.744141, -2858.618164, 208.903931, ''),
(27409, 96, 3587.919189, -2854.562500, 203.447754, ''),
(27409, 97, 3562.793213, -2842.607666, 197.044495, ''),
(27409, 98, 3534.265625, -2828.214600, 197.154617, ''),
(27409, 99, 3515.692871, -2829.376709, 201.276230, ''),
(27409, 100, 3487.658691, -2829.192871, 202.143524, ''),
(27409, 101, 3472.460693, -2821.599365, 201.429428, ''),
(27409, 102, 3460.582031, -2817.212402, 201.804962, ''),
(27409, 103, 3443.644531, -2811.332520, 202.097687, '');

-- Freed Alliance Scout waypoints
DELETE FROM `waypoints` WHERE entry = 27411;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `point_comment`) VALUES
(27411, 1, 4394.648438, -2502.304688, 252.802429, ''),
(27411, 2, 4389.777832, -2502.323242, 252.251602, ''),
(27411, 3, 4382.442383, -2501.507080, 246.809448, ''),
(27411, 4, 4381.006836, -2497.183838, 247.235260, ''),
(27411, 5, 4393.843750, -2484.841553, 248.717392, ''),
(27411, 6, 4416.043457, -2481.504150, 247.175400, ''),
(27411, 7, 4425.312500, -2486.656006, 246.555176, '');
 
 
/* 
* sql\updates\world\2013_08_30_00_world_gameobject_loot_template.sql 
*/ 
UPDATE `gameobject_loot_template` SET `item`=37700 /* 33700 */ WHERE  `entry`=24157 AND `item`=37703;
 
 
/* 
* sql\updates\world\2013_08_30_01_world_command.sql 
*/ 
ALTER TABLE `command` CHANGE `security` `permission` SMALLINT(5) UNSIGNED DEFAULT 0 NOT NULL;

-- Player commands
UPDATE `command` SET `permission` = 7 WHERE `permission` = 0;
-- Moderator commands
UPDATE `command` SET `permission` = 8 WHERE `permission` = 1;
-- GM commands
UPDATE `command` SET `permission` = 9 WHERE `permission` = 2;
-- administrator commands
UPDATE `command` SET `permission` = 10 WHERE `permission` = 3;
-- console commands
UPDATE `command` SET `permission` = 12 WHERE `permission` = 4;
 
 
/* 
* sql\updates\world\2013_08_30_02_world_command.sql 
*/ 
-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = 201 WHERE `name` = 'rbac account';
UPDATE `command` SET `permission` = 202 WHERE `name` = 'rbac account group';
UPDATE `command` SET `permission` = 203 WHERE `name` = 'rbac account group add';
UPDATE `command` SET `permission` = 204 WHERE `name` = 'rbac account group remove';
UPDATE `command` SET `permission` = 205 WHERE `name` = 'rbac account role';
UPDATE `command` SET `permission` = 206 WHERE `name` = 'rbac account role grant';
UPDATE `command` SET `permission` = 207 WHERE `name` = 'rbac account role deny';
UPDATE `command` SET `permission` = 208 WHERE `name` = 'rbac account role revoke';
UPDATE `command` SET `permission` = 209 WHERE `name` = 'rbac account permission';
UPDATE `command` SET `permission` = 210 WHERE `name` = 'rbac account permission grant';
UPDATE `command` SET `permission` = 211 WHERE `name` = 'rbac account permission deny';
UPDATE `command` SET `permission` = 212 WHERE `name` = 'rbac account permission revoke';
UPDATE `command` SET `permission` = 214 WHERE `name` = 'rbac account list groups';
UPDATE `command` SET `permission` = 215 WHERE `name` = 'rbac account list roles';
UPDATE `command` SET `permission` = 216 WHERE `name` = 'rbac account list permissions';
 
 
/* 
* sql\updates\world\2013_08_30_03_world_command.sql 
*/ 
UPDATE `command` SET `name` = 'rbac account' WHERE `name` = '.rbac account';
UPDATE `command` SET `name` = 'rbac account group' WHERE `name` = '.rbac account group';
UPDATE `command` SET `name` = 'rbac account group add' WHERE `name` = '.rbac account group add';
UPDATE `command` SET `name` = 'rbac account group remove' WHERE `name` = '.rbac account group remove';
UPDATE `command` SET `name` = 'rbac account role' WHERE `name` = '.rbac account role';
UPDATE `command` SET `name` = 'rbac account role grant' WHERE `name` = '.rbac account role grant';
UPDATE `command` SET `name` = 'rbac account role deny' WHERE `name` = '.rbac account role deny';
UPDATE `command` SET `name` = 'rbac account role revoke' WHERE `name` = '.rbac account role revoke';
UPDATE `command` SET `name` = 'rbac account permission' WHERE `name` = '.rbac account permission';
UPDATE `command` SET `name` = 'rbac account permission grant' WHERE `name` = '.rbac account permission grant';
UPDATE `command` SET `name` = 'rbac account permission deny' WHERE `name` = '.rbac account permission deny';
UPDATE `command` SET `name` = 'rbac account permission revoke' WHERE `name` = '.rbac account permission revoke';
UPDATE `command` SET `name` = 'rbac account list groups' WHERE `name` = '.rbac account list groups';
UPDATE `command` SET `name` = 'rbac account list roles' WHERE `name` = '.rbac account list roles';
UPDATE `command` SET `name` = 'rbac account list permissions' WHERE `name` = '.rbac account list permissions';
 
 
/* 
* sql\updates\world\2013_08_30_04_world_command.sql 
*/ 
-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = 217 WHERE `name` = 'account';
UPDATE `command` SET `permission` = 218 WHERE `name` = 'account addon';
UPDATE `command` SET `permission` = 219 WHERE `name` = 'account create';
UPDATE `command` SET `permission` = 220 WHERE `name` = 'account delete';
UPDATE `command` SET `permission` = 221 WHERE `name` = 'account lock';
UPDATE `command` SET `permission` = 222 WHERE `name` = 'account lock country';
UPDATE `command` SET `permission` = 223 WHERE `name` = 'account lock ip';
UPDATE `command` SET `permission` = 224 WHERE `name` = 'account onlinelist';
UPDATE `command` SET `permission` = 225 WHERE `name` = 'account password';
UPDATE `command` SET `permission` = 226 WHERE `name` = 'account set';
UPDATE `command` SET `permission` = 227 WHERE `name` = 'account set addon';
UPDATE `command` SET `permission` = 228 WHERE `name` = 'account set gmlevel';
UPDATE `command` SET `permission` = 229 WHERE `name` = 'account set password';
 
 
/* 
* sql\updates\world\2013_08_30_05_world_command.sql 
*/ 
-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = 230 WHERE `name` = 'achievement';
UPDATE `command` SET `permission` = 231 WHERE `name` = 'achievement add';
UPDATE `command` SET `permission` = 232 WHERE `name` = 'arena';
UPDATE `command` SET `permission` = 233 WHERE `name` = 'arena captain';
UPDATE `command` SET `permission` = 234 WHERE `name` = 'arena create';
UPDATE `command` SET `permission` = 235 WHERE `name` = 'arena disband';
UPDATE `command` SET `permission` = 236 WHERE `name` = 'arena info';
UPDATE `command` SET `permission` = 237 WHERE `name` = 'arena lookup';
UPDATE `command` SET `permission` = 238 WHERE `name` = 'arena rename';
 
 
/* 
* sql\updates\world\2013_08_30_06_world_command.sql 
*/ 
-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = 239 WHERE `name` = 'ban';
UPDATE `command` SET `permission` = 240 WHERE `name` = 'ban account';
UPDATE `command` SET `permission` = 241 WHERE `name` = 'ban character';
UPDATE `command` SET `permission` = 242 WHERE `name` = 'ban ip';
UPDATE `command` SET `permission` = 243 WHERE `name` = 'ban playeraccount';
UPDATE `command` SET `permission` = 244 WHERE `name` = 'baninfo';
UPDATE `command` SET `permission` = 245 WHERE `name` = 'baninfo account';
UPDATE `command` SET `permission` = 246 WHERE `name` = 'baninfo character';
UPDATE `command` SET `permission` = 247 WHERE `name` = 'baninfo ip';
UPDATE `command` SET `permission` = 248 WHERE `name` = 'banlist';
UPDATE `command` SET `permission` = 249 WHERE `name` = 'banlist account';
UPDATE `command` SET `permission` = 250 WHERE `name` = 'banlist character';
UPDATE `command` SET `permission` = 251 WHERE `name` = 'banlist ip';
UPDATE `command` SET `permission` = 252 WHERE `name` = 'unban';
UPDATE `command` SET `permission` = 253 WHERE `name` = 'unban account';
UPDATE `command` SET `permission` = 254 WHERE `name` = 'unban character';
UPDATE `command` SET `permission` = 255 WHERE `name` = 'unban ip';
UPDATE `command` SET `permission` = 256 WHERE `name` = 'unban playeraccount';
 
 
/* 
* sql\updates\world\2013_08_30_07_world_eai_sai.sql 
*/ 
DELETE FROM `creature_ai_scripts` WHERE `action1_type`=27;

-- INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES
--   ('343001', '3430', '0', '0', '100', '0', '0', '0', '0', '0', '27', '5043', '17013', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Mangletooth - Cast Agamaggan''s Agility on Quest Complete'),
--   ('343002', '3430', '0', '0', '100', '0', '0', '0', '0', '0', '27', '5042', '16612', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Mangletooth - Cast Agamaggan''s Strength on Quest Complete'),
--   ('343003', '3430', '0', '0', '100', '0', '0', '0', '0', '0', '27', '5046', '16610', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Mangletooth - Cast Razorhide on Quest Complete'),
--   ('343004', '3430', '0', '0', '100', '0', '0', '0', '0', '0', '27', '5045', '10767', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Mangletooth - Cast Rising Spirit on Quest Complete'),
--   ('343005', '3430', '0', '0', '100', '0', '0', '0', '0', '0', '27', '889', '16618', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Mangletooth - Cast Spirit of the Wind on Quest Complete'),
--   ('343006', '3430', '0', '0', '100', '0', '0', '0', '0', '0', '27', '5044', '7764', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'Mangletooth - Cast Wisdom of Agamaggan on Quest Complete');

UPDATE `smart_scripts` SET `action_type`=33, `action_param2`=0 WHERE `source_type`=0 AND `action_type`=27; -- by VM

-- all quests that used RequiredSpellCastX fields
UPDATE `quest_template` SET `SpecialFlags`=`SpecialFlags`|32 WHERE `Id` IN
(28,29,532,553,849,877,905,974,2118,2932,2994,3825,5096,5163,5165,5441,
6124,6129,6381,6395,6661,8346,8889,9066,9169,9193,9275,9294,9391,9440,
9444,9447,9489,9526,9600,9629,9667,9685,9720,9805,9824,9874,9910,10011,
10078,10087,10129,10144,10146,10182,10208,10233,10240,10305,10306,10307,
10313,10335,10345,10392,10426,10446,10447,10488,10545,10564,10598,10637,
10688,10714,10771,10792,10802,10808,10813,10833,10859,10866,10895,10913,
10923,10935,11055,11150,11205,11232,11245,11247,11258,11259,11285,11330,
11332,11421,11496,11515,11523,11542,11543,11547,11568,11576,11582,11610,
11617,11637,11656,11677,11684,11694,11713,11880,12092,12094,12096,12154,
12172,12173,12180,12213,12232,12267,12417,12449,12502,12588,12591,12598,
12641,12669,12728,12859,13110,13119,13211);
 
 
/* 
* sql\updates\world\2013_08_30_08_world_sai.sql 
*/ 
-- Deeprun Rat Roundup (6661)

SET @QUEST                 := 6661;  -- Random Comment
SET @NPC_RAT               := 13016; -- Deeprun Rat
SET @NPC_ENTHRALLED_RAT    := 13017; -- Enthralled Deeprun Rat
SET @NPC_MONTY             := 12997; -- Monty <Rat Extermination Specialist>
SET @SPELL_FLUTE           := 21050; -- Melodious Rapture
SET @SPELL_FLUTE_VISUAL    := 21051; -- Melodious Rapture Visual (DND)
SET @SPELL_BASH            := 21052; -- Monty Bashes Rats (DND)

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@NPC_RAT;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@NPC_ENTHRALLED_RAT;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@NPC_MONTY;

UPDATE `creature_model_info` SET `bounding_radius`=1,`combat_reach`=1,`gender`=2 WHERE `modelid`=1141; -- Deeprun Rat
-- Addon data for creature 13016 (Deeprun Rat)
DELETE FROM `creature_template_addon` WHERE `entry`=@NPC_RAT;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(@NPC_RAT,0,0,1,0, ''); -- Deeprun Rat

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_RAT,@NPC_ENTHRALLED_RAT,@NPC_MONTY);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_RAT,0,0,1,8,0,100,1,@SPELL_FLUTE,0,0,0,12,@NPC_ENTHRALLED_RAT,2,120000,0,0,0,1,0,0,0,0,0,0,0,'Deeprun Rat - On Spellhit - Summon Enthralled Rat'),
(@NPC_RAT,0,1,0,61,0,100,0,0,0,0,0,41,100,1,0,0,0,0,1,0,0,0,0,0,0,0,'Deeprun Rat - On link - Despawn'),
--
(@NPC_ENTHRALLED_RAT,0,0,1,54,0,100,0,0,0,0,0,2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,'Deeprun Rat - Just summoned - Update Faction'),
(@NPC_ENTHRALLED_RAT,0,1,2,61,0,100,0,0,0,0,0,33,@NPC_ENTHRALLED_RAT,0,0,0,0,0,21,5,0,0,0,0,0,0,'Deeprun Rat - On Link - Give Q credit'),
(@NPC_ENTHRALLED_RAT,0,2,3,61,0,100,0,0,0,0,0,11,@SPELL_FLUTE_VISUAL,0,0,0,0,0,1,0,0,0,0,0,0,0,'Deeprun Rat - On Link - Set Flute Visual'),
(@NPC_ENTHRALLED_RAT,0,3,4,61,0,100,0,0,0,0,0,29,0,0,0,0,0,0,21,5,0,0,0,0,0,0,'Deeprun Rat - On Link - Follow Player'),
(@NPC_ENTHRALLED_RAT,0,4,0,61,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Deeprun Rat - On LInk- Set Phase 1'),
(@NPC_ENTHRALLED_RAT,0,5,0,8,1,100,0,@SPELL_BASH,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Deeprun Rat - On Spellhit - Despawn'),
--
(@NPC_MONTY,0,0,1,20,0,100,0,@QUEST,0,0,0,11,@SPELL_BASH,0,0,0,0,0,1,0,0,0,0,0,0,0,'Monty - On Reward Quest - Cast Bash'),
(@NPC_MONTY,0,1,0,61,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Monty - On Reward Quest - Talk');

DELETE FROM `creature_text` WHERE `entry`=@NPC_MONTY;
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES
(@NPC_MONTY,0,0,'Into the box me pretties! Thats it. One by one ye go.',12,0,0,0,0,0,'Monty');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=@SPELL_BASH;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,@SPELL_BASH,0,0,31,0,3,@NPC_ENTHRALLED_RAT,0,0,0,'','Spell Bash target rats');
 
 
/* 
* sql\updates\world\2013_08_30_09_world_spell_script_names.sql 
*/ 
DELETE FROM `spell_script_names` WHERE `ScriptName`='spell_rotface_vile_gas_trigger';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(72285, 'spell_rotface_vile_gas_trigger'),
(72288, 'spell_rotface_vile_gas_trigger');
 
 
/* 
* sql\updates\world\2013_08_31_00_world_reputation_reward_rate.sql 
*/ 
ALTER TABLE `reputation_reward_rate` CHANGE `quest_repeatable_rate` `quest_repeatable_rate` FLOAT NOT NULL DEFAULT '1' AFTER `quest_monthly_rate`;
 
 
/* 
* sql\updates\world\2013_08_31_01_world_gameobject_loot_template.sql 
*/ 
UPDATE `gameobject_loot_template` SET `item`=37700 WHERE  `entry`=24157 AND `item`=33700;
 
 
/* 
* sql\updates\world\2013_08_31_02_world_sai.sql 
*/ 
-- The Lost Mistwhisper Treasure (12575)
SET @TARTEK                     := 28105;
SET @ZEPTEK                     := 28399;
SET @HC_RIDE                    := 46598;
SET @TRIGGER                    := 5030;
SET @SPEARBORNBUNNY             := 28457;
-- REF 6710.741, 5154.322, -19.3981
-- REF 6712.461, 5136.462, -19.3981

-- Propper phasing 
DELETE FROM `spell_area` WHERE `spell` = 52217;
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`, `quest_start_status`, `quest_end_status`) VALUES 
(52217, 4306, 12574, 0, 0, 0, 2, 1, 74, 64),
(52217, 4308, 12574, 0, 0, 0, 2, 1, 74, 64);

-- Needs one waypoint for passenger removal
DELETE FROM `waypoints` WHERE `entry`=@ZEPTEK;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@ZEPTEK, 1, 6712.461, 5136.462, -19.3981, 'Zeptek the Destroyer');

-- Criteria linked with involved relation
DELETE FROM `areatrigger_involvedrelation` WHERE `id` = @TRIGGER;
INSERT INTO `areatrigger_involvedrelation` (`id`,`quest`) VALUES
(@TRIGGER,12575);

DELETE FROM `areatrigger_scripts` WHERE `entry` = @TRIGGER;
INSERT INTO `areatrigger_scripts` (`entry`, `ScriptName`) VALUES
(@TRIGGER,'SmartTrigger');

DELETE FROM `smart_scripts` WHERE `entryorguid` =@TRIGGER AND `source_type`=2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@TRIGGER,2,0,0,46,0,100,0,@TRIGGER,0,0,0,45,1,1,0,0,0,0,10,99764,@SPEARBORNBUNNY,0,0,0,0,0,"On Trigger - Set Data");

DELETE FROM `smart_scripts` WHERE `entryorguid` =@SPEARBORNBUNNY AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@SPEARBORNBUNNY,0,0,0,10,0,100,0,1,200,10000,10000,11,51642,2,0,0,0,0,7,0,0,0,0,0,0,0,'Spearborn Encampment Bunny - On update OOC - Spellcast Spearborn Encampment Aura'),
(@SPEARBORNBUNNY,0,1,2,38,0,100,0,1,1,300000,300000,45,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Spearborn Encampment Bunny - On Data Set - Set Data'),
(@SPEARBORNBUNNY,0,2,0,61,0,100,0,0,0,0,0,12,@TARTEK,1,300000,0,0,0,8,0,0,0,6709.02, 5169.21, -20.8878, 4.91029, 'Spearborn Encampment Bunny - Linked with Previous Event - Spawn Warlord Tartek');

DELETE FROM `creature` WHERE `id`=@TARTEK;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@TARTEK;
DELETE FROM `creature_ai_scripts` WHERE `creature_id` =@TARTEK; 
DELETE FROM `smart_scripts` WHERE `entryorguid` =@TARTEK;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@TARTEK,0,0,1,11,0,100,0,0,0,0,0,2,2061,0,0,0,0,0,1,0,0,0,0,0,0,0,'Warlord Tartek - On Spawn - Set Faction'),
(@TARTEK,0,1,2,61,0,100,0,0,0,0,0,18,756,0,0,0,0,0,1,0,0,0,0,0,0,0,'Warlord Tartek - On Link - Set Unattackable Flags'),
(@TARTEK,0,2,3,61,0,100,0,0,0,0,0,12,@ZEPTEK,1,100000,0,0,0,1,0,0,0,0,0,0,0,'Warlord Tartek - On Link - Summon Zeptek'),
(@TARTEK,0,3,4,61,0,100,0,0,0,0,0,11,@HC_RIDE,2,0,0,0,0,11,@ZEPTEK,10,0,0,0,0,0,'Warlord Tartek - On Link - Ride Zeptek'),
(@TARTEK,0,4,5,61,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Warlord Tartek - On Link - Say 0'),
(@TARTEK,0,5,0,4,0,100,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Warlord Tartek - On Aggro - Say 1'),
(@TARTEK,0,6,0,8,0,100,0,@HC_RIDE,0,0,0,19,756,0,0,0,0,0,1,0,0,0,0,0,0,0,'Warlord Tartek - On Data set - Remove Unattackable Flags'),
-- Combat
(@TARTEK,0,7,0,9,0,100,0,5000,8000,5000,8000,11,29426,2,0,0,0,0,1,0,0,0,0,0,0,0,'Warlord Tartek - IC - Cast Heroic Strike'),
(@TARTEK,0,8,0,0,0,100,0,5000,15000,5000,15000,11,35429,2,0,0,0,0,1,0,0,0,0,0,0,0,'Warlord Tartek - IC - Cast Sweeping Strikes'),
(@TARTEK,0,9,0,0,0,100,0,6000,15000,6000,15000,11,15572,2,0,0,0,0,2,0,0,0,0,0,0,0,'Warlord Tartek - IC - Cast Sunder Armor'),
-- Credit
(@TARTEK,0,10,11,6,0,100,0,0,0,0,0,45,1,1,0,0,0,0,9,28121,0,50,0,0,0,0, 'Warlord Tartek - On Death - Set Data Jaloot'), -- If spawned by player, will say text.
(@TARTEK,0,11,0,61,0,100,0,0,0,0,0,15,12575,0,0,0,0,0,7,0,0,0,0,0,0,0,'Warlord Tartek - On Link - Call area explored or event happens');

UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ZEPTEK;
DELETE FROM `creature_ai_scripts` WHERE `creature_id` =@ZEPTEK; 
DELETE FROM `smart_scripts` WHERE `entryorguid` =@ZEPTEK;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@ZEPTEK,0,0,1,11,0,100,0,0,0,0,0,2,2061,0,0,0,0,0,1,0,0,0,0,0,0,0,'Zeptik The Destroyer - On Spawn - Set Faction'),
(@ZEPTEK,0,1,0,61,0,100,0,0,0,0,0,53,1,@ZEPTEK,0,0,0,0,1,0,0,0,0,0,0,0,'Zeptik The Destroyer  - On Link - Start WP'),
(@ZEPTEK,0,2,3,40,0,100,0,1,0,0,0,11,@HC_RIDE,0,0,0,0,0,11,@TARTEK,20,0,0,0,0,0,'Zeptik The Destroyer - ON WP reached - Dismount Tartek'),
(@ZEPTEK,0,3,4,61,0,100,0,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Zeptik The Destroyer - OnLink - Summon New Zeptek'),
(@ZEPTEK,0,4,0,61,0,100,0,0,0,0,0,28,@HC_RIDE,0,0,0,0,0,1,0,0,0,0,0,0,0,'Zeptik The Destroyer - On LInk - Attack Closest Player');

DELETE FROM `creature_equip_template` WHERE `entry` =@TARTEK;
INSERT INTO `creature_equip_template` (`entry`, `id`, `itemEntry1`, `itemEntry2`, `itemEntry3`) VALUES
(@TARTEK, 1, 5305, 0, 0);

DELETE FROM `creature_text` WHERE `entry` =@TARTEK;
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES
(@TARTEK, 0, 0, 'My treasure! You no steal from Tartek, dumb big-tongue traitor thing.', 14, 0, 100, 0, 0, 0, 'Warlord Tartek'),
(@TARTEK, 1, 0, 'Tartek and nasty dragon going to kill you! You so dumb.', 14, 0, 100, 0, 0, 0, 'Warlord Tartek');
-- Needs special flags 2 for external event
UPDATE `quest_template` SET `SpecialFlags`=2 WHERE  `Id`=12575;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=@TRIGGER AND `SourceId`=2;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,1,@TRIGGER,2,0,9,0,12575,0,0,0,0,'','Trigger only activates if player is on the Lost Mistwhisper Treasure');
 
 
/* 
* sql\updates\world\2013_08_31_03_world_creature_text.sql 
*/ 
DELETE FROM `creature_text` WHERE `entry`=24480;
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES 
(24480, 0, 0, 'I thought you''d never ask!', 15, 0, 100, 0, 0, 0, 'Mojo'), 
(24480, 0, 1, 'I promise not to give you warts...', 15, 0, 100, 0, 0, 0, 'Mojo'), 
(24480, 0, 2, 'This won''t take long, did it?', 15, 0, 100, 0, 0, 0, 'Mojo'), 
(24480, 0, 3, 'Now that''s what I call froggy-style!', 15, 0, 100, 0, 0, 0, 'Mojo'), 
(24480, 0, 4, 'Listen, $n, I know of a little swamp not too far from here....', 15, 0, 100, 0, 0, 0, 'Mojo'), 
(24480, 0, 5, 'Your lily pad or mine?', 15, 0, 100, 0, 0, 0, 'Mojo'), 
(24480, 0, 6, 'Feelin'' a little froggy, are ya?', 15, 0, 100, 0, 0, 0, 'Mojo'),
(24480, 0, 7, 'There''s just never enough Mojo to go around...', 15, 0, 100, 0, 0, 0, 'Mojo');
 
 
/* 
* sql\updates\world\2013_08_31_04_world_spell_script_names.sql 
*/ 
DELETE FROM `spell_script_names` WHERE `spell_id`=51858;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(51858, 'spell_q12641_death_comes_from_on_high');
 
 
/* 
* sql\updates\world\2013_08_31_05_world_creature_template.sql 
*/ 
UPDATE `creature_template` SET `ScriptName`='npc_pet_gen_mojo' WHERE `ScriptName`='npc_mojo';
 
 
/* 
* sql\updates\world\2013_08_31_06_world_smart_scripts.sql 
*/ 
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (18110,18142,18143,18144) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(18110, 0, 0, 1, 8, 0, 100, 1, 31927, 0, 0, 0, 80, 1811000, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Windyreed Quest Credit - On Spellhit - Run Script'),
(18110, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 33, 18110, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Windyreed Quest Credit - On Spellhit (Link) - Quest Credit'),
(18142, 0, 0, 1, 8, 0, 100, 1, 31927, 0, 0, 0, 80, 1814200, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Windyreed Quest Credit - On Spellhit - Run Script'),
(18142, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 33, 18142, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Windyreed Quest Credit - On Spellhit (Link) - Quest Credit'),
(18143, 0, 0, 1, 8, 0, 100, 1, 31927, 0, 0, 0, 80, 1814300, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Windyreed Quest Credit - On Spellhit - Run Script'),
(18143, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 33, 18143, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Windyreed Quest Credit - On Spellhit (Link) - Quest Credit'),
(18144, 0, 0, 1, 8, 0, 100, 1, 31927, 0, 0, 0, 80, 1814400, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Windyreed Quest Credit - On Spellhit - Run Script'),
(18144, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 33, 18144, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Windyreed Quest Credit - On Spellhit (Link) - Quest Credit');
 
 
/* 
* sql\updates\world\2013_08_31_07_world_creature.sql 
*/ 
UPDATE `creature` SET 
  `position_x`=1814.592,
  `position_y`=-5988.646,
  `position_z`=125.4968,
  `orientation`=3.228859
WHERE `id`=28525;

UPDATE `creature` SET
  `position_x`=1590.806,
  `position_y`=-5731.661,
  `position_z`=143.8694,
  `orientation`=0.9075712
WHERE `id`=28543;

UPDATE `creature` SET
  `position_x`= 1651.211,
  `position_y`=-5994.667,
  `position_z`=133.5836
WHERE `id`=28542;

UPDATE `creature` SET  `position_x`= 1385.928,
  `position_x`=1385.928,
  `position_y`= -5702.061,
  `position_z`= 146.3048,
  `orientation`=4.153883
WHERE `id`=28544;
 
 
/* 
* sql\updates\world\2013_08_31_08_world_command.sql 
*/ 
/* cs_bf.cpp */

SET @id = 257;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'bf';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'bf start';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'bf stop';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'bf switch';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'bf timer';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'bf enabled';

 
 
/* 
* sql\updates\world\2013_09_01_00_world_spell_script_names.sql 
*/ 
DELETE FROM `spell_script_names` WHERE `spell_id` IN (63276,63278);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(63276,'spell_general_vezax_mark_of_the_faceless'),
(63278,'spell_general_vezax_mark_of_the_faceless_leech');
 
 
/* 
* sql\updates\world\2013_09_01_01_world_trinity_string.sql 
*/ 
DELETE FROM `trinity_string` WHERE `entry` IN (453, 548, 549, 550, 714, 716, 749, 752, 843, 844, 845, 846, 847, 848, 849, 850, 851, 852, 853, 854, 871); 
INSERT INTO `trinity_string` (`entry`, `content_default`) VALUES
(453,'│Player %s %s (guid: %u)'),
(548,'│ GM Mode active, Phase: -1'),
(549,'├─ Banned: (Type: %s, Reason: %s, Time: %s, By: %s)'),
(550,'├─ Muted: (Reason: %s, Time: %s, By: %s)'),
(714,'│ Account: %s (ID: %u), GMLevel: %u'),
(716,'│ Last Login: %s (Failed Logins: %u)'),
(749,'│ OS: %s - Latency: %u ms - Mail: %s'),
(752,'│ Last IP: %s (Locked: %s)'),
(843,'│ Level: %u (%u/%u XP (%u XP left))'),
(844,'│ Race: %s %s, %s'),
(845,'│ Alive ?: %s'),
(846,'│ Phase: %u'),
(847,'│ Money: %ug%us%uc'),
(848,'│ Map: %s, Area: %s, Zone: %s'),
(849,'│ Guild: %s (ID: %u)'),
(850,'├─ Rank: %s'),
(851,'├─ Note: %s'),
(852,'├─ O. Note: %s'),
(853,'│ Played time: %s'),
(854,'└ Mails: %d Read/%u Total'),
(871,'│ Level: %u');
 
 
/* 
* sql\updates\world\2013_09_01_02_world_smart_scripts.sql 
*/ 
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (25510,25511,25512,25513);

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (25510,25511,25512,25513) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(25510, 0, 0, 0, 8, 0, 100, 1, 45692, 0, 0, 0, 33, 25510, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, '1st Kvaldir Vessel (The Serpent''s Maw) - On Spellhit "Use Tuskarr Torch" - Give Quest Credit'),
(25511, 0, 0, 0, 8, 0, 100, 1, 45692, 0, 0, 0, 33, 25511, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, '2nd Kvaldir Vessel (The Kur Drakkar) - On Spellhit "Use Tuskarr Torch" - Give Quest Credit'),
(25512, 0, 0, 0, 8, 0, 100, 1, 45692, 0, 0, 0, 33, 25512, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, '3rd Kvaldir Vessel (Bor''s Hammer) - On Spellhit "Use Tuskarr Torch" - Give Quest Credit'),
(25513, 0, 0, 0, 8, 0, 100, 1, 45692, 0, 0, 0, 33, 25513, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, '4th Kvaldir Vessel (Bor''s Anvil) - On Spellhit "Use Tuskarr Torch" - Give Quest Credit');
 
 
/* 
* sql\updates\world\2013_09_01_03_world_smart_scripts.sql 
*/ 
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (19866,19867,19868);

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (19866,19867,19868) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(19866, 0, 0, 0, 8, 0, 100, 1, 34646, 0, 0, 0, 33, 19866, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Invis East KV Rune - On Spellhit "Activate Kirin''Var Rune" - Give Quest Credit'),
(19867, 0, 0, 0, 8, 0, 100, 1, 34646, 0, 0, 0, 33, 19867, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Invis NE KV Rune - On Spellhit "Activate Kirin''Var Rune" - Give Quest Credit'),
(19868, 0, 0, 0, 8, 0, 100, 1, 34646, 0, 0, 0, 33, 19868, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Invis West KV Rune - On Spellhit "Activate Kirin''Var Rune" - Give Quest Credit');
 
 
/* 
* sql\updates\world\2013_09_01_04_world_smart_scripts.sql 
*/ 
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (19723,19724) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(19723, 0, 0, 1, 8, 0, 100, 1, 34526, 0, 0, 0, 80, 1972300, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Invis BE Ballista - On Spellhit - Run Script'),
(19723, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 33, 19723, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Invis BE Ballista - On Spellhit (Link) - Quest Credit'),
(19724, 0, 0, 1, 8, 0, 100, 1, 34526, 0, 0, 0, 80, 1972400, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Invis BE Tent - On Spellhit - Run Script'),
(19724, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 33, 19724, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Invis BE Tent - On Spellhit (Link) - Quest Credit');
 
 
/* 
* sql\updates\world\2013_09_01_05_world_skinning_loot_template.sql 
*/ 
-- --------------------------------------------------------------------------------------
-- -- Skinning Loot Revamp by ZxBiohazardZx
-- --------------------------------------------------------------------------------------
SET @var := 100000; -- Set this to the reference value, gap is 10 minimum, more ofc later (10<00X>)?
-- Delete old junk that isnt needed & assign new template to those creatures:
UPDATE `creature_template` SET `skinloot`=0 WHERE `entry`=534;
DELETE FROM `skinning_loot_template` WHERE `entry`=534;
UPDATE `creature_template` SET `skinloot`=@var WHERE `skinloot` IN (721,883,890,2098,2442,2620,4166,5951,17467,10780,12296,12297,12298);
DELETE FROM `skinning_loot_template` WHERE `entry` IN(721,883,890,2098,2442,2620,4166,5951,17467,10780,12296,12297,12298);
-- Var+1
UPDATE `creature_template` SET `skinloot`=@var+1 WHERE `skinloot`=100007;
DELETE FROM `skinning_loot_template` WHERE `entry`=100007;
-- Var+2
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+2 WHERE `skinloot` IN (
 113, 118, 119, 330, 390, 524, 525, 822, 834,1125,1126,1127,1128,1131,1132,1133,1134,1135,
1137,1138,1190,1196,1199,1201,1547,1548,1549,1553,1554,1689,1765,1922,2033,2034,2042,2043,
2070,2175,2956,2957,2958,2959,2960,2972,2973,3035,3068,3099,3100,3110,3121,3122,3123,3125,
3126,3127,3130,3131,3225,3226,3227,3566,5807,6789,10105,10356,14430,15650,15651,15652,
16347,16353,17199,17200,17202,17203,17345,17372,17373);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (
 113, 118, 119, 330, 390, 524, 525, 822, 834,1125,1126,1127,1128,1131,1132,1133,1134,1135,
1137,1138,1190,1196,1199,1201,1547,1548,1549,1553,1554,1689,1765,1922,2033,2034,2042,2043,
2070,2175,2956,2957,2958,2959,2960,2972,2973,3035,3068,3099,3100,3110,3121,3122,3123,3125,
3126,3127,3130,3131,3225,3226,3227,3566,5807,6789,10105,10356,14430,15650,15651,15652,
16347,16353,17199,17200,17202,17203,17345,17372,17373);
-- Var+3
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+3 WHERE `skinloot` IN (
 157, 454, 833,1130,1186,1188,1191,1271,1388,1693,1766,1769,1770,1778,1779,1782,1797,1892,
1893,1896,1924,1961,1972,2069,2163,2164,2185,2321,2322,2974,3056,3058,3231,3234,3241,3242,
3243,3244,3246,3248,3254,3255,3415,3425,3461,3531,4127,4316,5829,5865,12431,12432,16348,
16354,17347,17525,17556);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (
 157, 454, 833,1130,1186,1188,1191,1271,1388,1693,1766,1769,1770,1778,1779,1782,1797,1892,
1893,1896,1924,1961,1972,2069,2163,2164,2185,2321,2322,2974,3056,3058,3231,3234,3241,3242,
3243,3244,3246,3248,3254,3255,3415,3425,3461,3531,4127,4316,5829,5865,12431,12432,16348,
16354,17347,17525,17556);
-- Var+4 
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+4 WHERE `skinloot` IN (
 213, 547, 565,1189,1192,1224,2071,2165,2172,2187,2237,2323,3236,3240,3245,3247,3256,3257,
3398,3416,3424,3426,3463,3466,3475,3721,3816,3823,4008,4009,4011,4129,5053,6788,10644,16349,
16355,17348,17527,17588,17589);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (
 213, 547, 565,1189,1192,1224,2071,2165,2172,2187,2237,2323,3236,3240,3245,3247,3256,3257,
3398,3416,3424,3426,3463,3466,3475,3721,3816,3823,4008,4009,4011,4129,5053,6788,10644,16349,
16355,17348,17527,17588,17589);
-- Var+5 
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+5 WHERE `skinloot` IN (
 335, 345, 521, 628, 819, 923,1015,1016,1017,1020,1021,1022,1258,1400,1417,1923,2089,2275,
2351,2354,2356,2384,2476,2529,3235,3237,3238,3239,3249,3250,3252,3472,3473,3474,3774,3809,
3810,3817,3824,4012,4013,4014,4015,4016,4018,4019,4031,4032,4042,4044,4067,4117,4126,4126,
4128,4250,5835,12678,12723,12940);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (
 335, 345, 521, 628, 819, 923,1015,1016,1017,1020,1021,1022,1258,1400,1417,1923,2089,2275,
2351,2354,2356,2384,2476,2529,3235,3237,3238,3239,3249,3250,3252,3472,3473,3474,3774,3809,
3810,3817,3824,4012,4013,4014,4015,4016,4018,4019,4031,4032,4042,4044,4067,4117,4126,4126,
4128,4250,5835,12678,12723,12940);
-- Var+6 
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+6 WHERE `skinloot` IN (1225,3653,3851,3853,3854,3855,3861,3862,3864,3865,3914,5058);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (1225,3653,3851,3853,3854,3855,3861,3862,3864,3865,3914,5058);
-- Var+7 
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+7 WHERE `skinloot` IN (3857,3859,3866,3868,3886,4279,4511,4514,4824,4827,4887,14357);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (3857,3859,3866,3868,3886,4279,4511,4514,4824,4827,4887,14357);
-- Var+8
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+8 WHERE `skinloot` IN (1042,1043,1069);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (1042,1043,1069);
-- Var+9
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+9 WHERE `skinloot` IN (3630,3631,3632,3633,3634,3636,3637,3641,5048,5056,5755,5756,5762,8886,20797);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (3630,3631,3632,3633,3634,3636,3637,3641,5048,5056,5755,5756,5762,8886,20797);
-- Var+10
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+10 WHERE `skinloot` IN (
 205, 206, 533, 681, 683, 855, 898, 920,1018,1019,1023,1150,1353,2248,2385,2408,2559,3476,
3789,3791,3811,3815,3818,3825,4017,4041,4107,4109,4110,4118,4119,4124,4142,4147,4248,4249,4548,
4688,5827,6071,6167,10116,10882,12677);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (
 205, 206, 533, 681, 683, 855, 898, 920,1018,1019,1023,1150,1353,2248,2385,2408,2559,3476,
3789,3791,3811,3815,3818,3825,4017,4041,4107,4109,4110,4118,4119,4124,4142,4147,4248,4249,4548,
4688,5827,6071,6167,10116,10882,12677);
-- Var+11
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+11 WHERE `skinloot` IN (
 507, 682, 685, 686, 688, 689, 736, 856,1084,1085,1108,1151,1152,2249,2250,2251,2406,
2407,2560,2727,4139,4140,4143,4144,4150,4151,4304,4341,4351,4689,4696,4697,4700,4726,
4728,10131,10992,12676);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (
 507, 682, 685, 686, 688, 689, 736, 856,1084,1085,1108,1151,1152,2249,2250,2251,2406,
2407,2560,2727,4139,4140,4143,4144,4150,4151,4304,4341,4351,4689,4696,4697,4700,4726,
4728,10131,10992,12676);
-- Var+12
-- --------------------------------------------------------------------------------------
UPDATE `creature_template` SET `skinloot`=@var+12 WHERE `skinloot` IN (
3927,4274,4515,4538,4825,4829);
DELETE FROM `skinning_loot_template` WHERE `entry` IN (
3927,4274,4515,4538,4825,4829);
-- Var+13
UPDATE `creature_template` SET `skinloot`=@var+13 WHERE `skinloot` IN 
(687, 690, 728, 767, 772, 854, 874,1082,1114,1557,2473,2561,2728,2729,2731,2732,4342,4343,
4344,4345,4347,4348,4352,4355,4356,4357,4388,4662,4678,4681,4685,4690,4699,4701,4702,4727,
4729,10136,11785,13602,14227,14232,14233);
DELETE FROM `skinning_loot_template` WHERE `entry` IN
(687, 690, 728, 767, 772, 854, 874,1082,1114,1557,2473,2561,2728,2729,2731,2732,4342,4343,
4344,4345,4347,4348,4352,4355,4356,4357,4388,4662,4678,4681,4685,4690,4699,4701,4702,4727,
4729,10136,11785,13602,14227,14232,14233);

-- Var+14
UPDATE `creature_template` SET `skinloot`=@var+14 WHERE `skinloot` IN 
( 730,1087,1511,1514,1516,1550,1551,1558,2657,2658,2734,4389,4841,5224,5260,5268,5272,5300,
5304,5305,5307,5308,5419,5420,5425,5426,7268,11786,12741);
DELETE FROM `skinning_loot_template` WHERE `entry` IN
( 730,1087,1511,1514,1516,1550,1551,1558,2657,2658,2734,4389,4841,5224,5260,5268,5272,5300,
5304,5305,5307,5308,5419,5420,5425,5426,7268,11786,12741);

-- --------------------------------------------------------------------------------------
-- -- Add the new profiles
-- --------------------------------------------------------------------------------------
DELETE FROM `skinning_loot_template` WHERE `entry` BETWEEN @var AND @var+15;
INSERT INTO `skinning_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
-- Var (Light Leather)
(@var,2318,90,1,1,1,1), -- Ruined Leather Scraps
(@var,2934,10,1,1,1,1), -- Light Leather
-- Var+1 (Light Leather) -- 
(@var+1,2934,80,1,1,1,1), -- Light Leather
(@var+1, 783,20,1,1,1,1), -- Light Hide
-- Var+2 (Light Leather
(@var+2,2934,60,1,1,1,1), -- Ruined Leather Scraps
(@var+2,2318,40,1,1,1,1), -- Light Leather
-- Var+3 (Light Leather)
(@var+3,2318,60,1,1,1,1), -- Light Leather
(@var+3,2934,35,1,1,1,1), --  Ruined Leather Scraps
(@var+3, 783, 5,1,1,1,1), --  Light Hide
-- Var+4 (Light/Medium Leather
(@var+4,2318,72,1,1,1,2), -- Light Leather
(@var+4,2319,20,1,1,1,1), -- Medium Leather
(@var+4, 783, 5,1,1,1,1), -- Light Hide
(@var+4,4232, 3,1,1,1,1), -- Medium Hide
-- Var+5 (Light/Medium Leather
(@var+5,2319,50,1,1,1,1), -- Medium Leather
(@var+5,2318,42,1,1,1,2), -- Light Leather
(@var+5, 783, 5,1,1,1,1), -- Light Hide
(@var+5,4232, 3,1,1,1,1), -- Medium Hide
-- Var+6 (Light/Medium Leather2)
(@var+6,2318,65,1,1,1,2), -- Light Leather
(@var+6,2319,25,1,1,1,2), -- Medium Leather
(@var+6, 783, 7,1,1,1,1), -- Light Hide
(@var+6,4232, 3,1,1,1,1), -- Medium Hide
-- Var+7 (Light/Medium Leather2)
(@var+7,2318,55,1,1,1,2), -- Light Leather
(@var+7,2319,35,1,1,1,2), -- Medium Leather
(@var+7, 783, 7,1,1,1,1), -- Light Hide
(@var+7,4232, 3,1,1,1,1), -- Medium Hide
-- Var+8 (Red Whelp Scale Dragons)
(@var+8,2318,37,1,1,1,2), -- Light Leather
(@var+8,2319,45,1,1,1,1), -- Medium Leather
(@var+8, 783, 3,1,1,1,1), -- Light Hide
(@var+8,4232, 5,1,1,1,1), -- Medium Hide
(@var+8,7287,10,1,1,1,1), -- Red Whelp Scale
-- Var+9 (Deviate Scales)
(@var+9,2318,50,1,1,1,2), -- Light Leather
(@var+9,2319,25,1,1,1,2), -- Medium Leather
(@var+9,6470,10,1,1,1,1), -- Deviate Scale
(@var+9, 783, 7,1,1,1,1), -- Light Hide
(@var+9,6471, 5,1,1,1,1), -- Perfect Deviate Scale
(@var+9,4232, 3,1,1,1,1), -- Medium Hide
-- Var+10 (Medium Leather)
(@var+10,2319,73,1,1,1,1), -- Medium Leather
(@var+10,4234,20,1,1,1,1), -- Heavy Leather
(@var+10,4232, 5,1,1,1,1), -- Medium Hide
(@var+10,4235, 2,1,1,1,1), -- Heavy Hide
-- Var+11 (Medium Leather)
(@var+11,4234,51,1,1,1,1), -- Heavy Leather
(@var+11,2319,42,1,1,1,1), -- Medium Leather
(@var+11,4232, 4,1,1,1,1), -- Medium Hide
(@var+11,4235, 3,1,1,1,1), -- Heavy Hide
-- Var+12 (Medium Leather)
(@var+12,2319,64,1,1,1,2), -- Medium Leather
(@var+12,4234,27,1,1,1,2), -- Heavy Leather
(@var+12,4232, 6,1,1,1,1), -- Medium Hide
(@var+12,4235, 3,1,1,1,1), -- Heavy Hide
-- Var+13 (Heavy Leather)
(@var+13,4234,77,1,1,1,1), -- Heavy Leather
(@var+13,4304,20,1,1,1,1), -- Thick Leather
(@var+13,4235, 3,1,1,1,1), -- Heavy Hide
-- Var+14 (Heavy Leather)
(@var+14,4304,50,1,1,1,1), -- Thick Leather
(@var+14,4234,45,1,1,1,1), -- Heavy Leather
(@var+14,8169, 3,1,1,1,1), -- Thick Hide
(@var+14,4235, 2,1,1,1,1), -- Heavy Hide
-- Var+15 (Green Whelp Scale)
(@var+15,4234,40,1,1,1,1), -- Heavy Leather
(@var+15,2319,33,1,1,1,1), -- Medium Leather
(@var+15,7392,20,1,1,1,1), -- Green Whelp Scale
(@var+15,4232, 4,1,1,1,1), -- Medium Hide
(@var+15,4235, 3,1,1,1,1); -- Heavy Hide
 
 
/* 
* sql\updates\world\2013_09_01_06_world_misc.sql 
*/ 
DELETE FROM `creature_addon` WHERE `auras` LIKE '%46598%'; -- no need to specify GUID, these are unique
DELETE FROM `creature_addon` WHERE `auras` LIKE '%43671%'; -- no need to specify GUID, these are unique
DELETE FROM `creature_addon` WHERE `guid`=85236;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES 
(85236,0,22471,0,1,0,'63500 64718');
DELETE FROM `creature_addon` WHERE `guid` IN (132681,128620);
 
 
/* 
* sql\updates\world\2013_09_01_07_world_trinity_strings.sql 
*/ 
DELETE FROM `trinity_string` WHERE `entry` IN (749, 872, 873, 874, 875, 876, 877, 878, 879, 880, 881);
INSERT INTO `trinity_string` (`entry`, `content_default`) VALUES
(749,'│ OS: %s - Latency: %u ms'),
(872, 'Entered email is not equal to registration email, check input'),
(873, 'The new emails do not match'),
(874, 'The email was changed'),
(875, 'Your email can''t be longer than 64 characters, email not changed!'),
(876, 'Email not changed (unknown error)!'),
(877, 'Email change unnecessary, new email is equal to old email'),
(878, 'Your email is: %s'),
(879, '│ Registration Email: %s - Email: %s'),
(880, 'Security Level: %s'),
(881, 'You require an email to change your password.');

UPDATE `command` SET `help` = 'Syntax: .account password $old_password $new_password $new_password [$email]\r\n\r\nChange your account password. You may need to check the actual security mode to see if email input is necessary.' WHERE name = 'account password';
UPDATE `command` SET `help` = 'Syntax: .account\r\n\r\nDisplay the access level of your account and the email adress if you possess the necessary permissions.' WHERE name = 'account';

DELETE FROM `command` WHERE `name` = 'account email';
DELETE FROM `command` WHERE `name` = 'account set sec email';
DELETE FROM `command` WHERE `name` = 'account set sec regmail';

INSERT INTO `command` (`name`, `permission`, `help`) VALUES
('account email', 263, 'Syntax: .account email $oldemail $currentpassword $newemail $newemailconfirmation\r\n\r\n Change your account email. You may need to check the actual security mode to see if email input is necessary for password change'),
('account set sec email', 265, 'Syntax: .account set sec email $accountname $email $emailconfirmation\r\n\r\nSet the email for entered player account.'),
('account set sec regmail', 266, 'Syntax: .account set sec regmail $account $regmail $regmailconfirmation\r\n\r\nSets the regmail for entered player account.');
 
 
/* 
* sql\updates\world\2013_09_02_00_world_smart_scripts.sql 
*/ 
UPDATE `smart_scripts` SET `target_type`=7 WHERE `entryorguid` IN (18818,21237,19009,21236) AND `source_type`=0 AND `id`=1;
 
 
/* 
* sql\updates\world\2013_09_02_01_world_command.sql 
*/ 
/* cs_cheat.cpp */

SET @id = 291;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'cheat';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'cheat casttime';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'cheat cooldown';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'cheat explore';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'cheat god';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'cheat power';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'cheat status';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'cheat taxi';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'cheat waterwalk';
 
 
/* 
* sql\updates\world\2013_09_02_02_world_command.sql 
*/ 
/* cs_debug.cpp */

SET @id = 300;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'debug';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'debug anim';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'debug areatriggers';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'debug arena';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'debug bg';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'debug entervehicle';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'debug getitemstate';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'debug getitemvalue';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'debug getvalue';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'debug hostil';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'debug itemexpire';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'debug lootrecipient';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'debug los';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'debug mod32value';
UPDATE `command` SET `permission` = @id+14 WHERE `name` = 'debug moveflags';
UPDATE `command` SET `permission` = @id+15 WHERE `name` = 'debug play';
UPDATE `command` SET `permission` = @id+16 WHERE `name` = 'debug play cinematics';
UPDATE `command` SET `permission` = @id+17 WHERE `name` = 'debug play movie';
UPDATE `command` SET `permission` = @id+18 WHERE `name` = 'debug play sound';
UPDATE `command` SET `permission` = @id+19 WHERE `name` = 'debug send';
UPDATE `command` SET `permission` = @id+20 WHERE `name` = 'debug send buyerror';
UPDATE `command` SET `permission` = @id+21 WHERE `name` = 'debug send channelnotify';
UPDATE `command` SET `permission` = @id+22 WHERE `name` = 'debug send chatmessage';
UPDATE `command` SET `permission` = @id+23 WHERE `name` = 'debug send equiperror';
UPDATE `command` SET `permission` = @id+24 WHERE `name` = 'debug send largepacket';
UPDATE `command` SET `permission` = @id+25 WHERE `name` = 'debug send opcode';
UPDATE `command` SET `permission` = @id+26 WHERE `name` = 'debug send qinvalidmsg';
UPDATE `command` SET `permission` = @id+27 WHERE `name` = 'debug send qpartymsg';
UPDATE `command` SET `permission` = @id+28 WHERE `name` = 'debug send sellerror';
UPDATE `command` SET `permission` = @id+29 WHERE `name` = 'debug send setphaseshift';
UPDATE `command` SET `permission` = @id+30 WHERE `name` = 'debug send spellfail';
UPDATE `command` SET `permission` = @id+31 WHERE `name` = 'debug setaurastate';
UPDATE `command` SET `permission` = @id+32 WHERE `name` = 'debug setbit';
UPDATE `command` SET `permission` = @id+33 WHERE `name` = 'debug setitemvalue';
UPDATE `command` SET `permission` = @id+34 WHERE `name` = 'debug setvalue';
UPDATE `command` SET `permission` = @id+35 WHERE `name` = 'debug setvid';
UPDATE `command` SET `permission` = @id+36 WHERE `name` = 'debug spawnvehicle';
UPDATE `command` SET `permission` = @id+37 WHERE `name` = 'debug threat';
UPDATE `command` SET `permission` = @id+38 WHERE `name` = 'debug update';
UPDATE `command` SET `permission` = @id+39 WHERE `name` = 'debug uws';
UPDATE `command` SET `permission` = @id+40 WHERE `name` = 'wpgps';
 
 
/* 
* sql\updates\world\2013_09_02_03_world_command.sql 
*/ 
/* cs_deserter.cpp */

SET @id = 341;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'deserter';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'deserter bg';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'deserter bg add';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'deserter bg remove';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'deserter instance';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'deserter instance add';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'deserter instance remove';
 
 
/* 
* sql\updates\world\2013_09_02_04_world_command.sql 
*/ 
/* cs_disable.cpp */

SET @id = 348;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'disable';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'disable add';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'disable add achievement_criteria';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'disable add battleground';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'disable add map';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'disable add mmap';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'disable add outdoorpvp';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'disable add quest';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'disable add spell';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'disable add vmap';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'disable remove';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'disable remove achievement_criteria';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'disable remove battleground';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'disable remove map';
UPDATE `command` SET `permission` = @id+14 WHERE `name` = 'disable remove mmap';
UPDATE `command` SET `permission` = @id+15 WHERE `name` = 'disable remove outdoorpvp';
UPDATE `command` SET `permission` = @id+16 WHERE `name` = 'disable remove quest';
UPDATE `command` SET `permission` = @id+17 WHERE `name` = 'disable remove spell';
UPDATE `command` SET `permission` = @id+18 WHERE `name` = 'disable remove vmap';
 
 
/* 
* sql\updates\world\2013_09_02_05_world_command.sql 
*/ 
/* cs_event.cpp */

SET @id = 367;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'event';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'event activelist';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'event start';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'event stop';
 
 
/* 
* sql\updates\world\2013_09_02_06_world_command.sql 
*/ 
/* cs_gm.cpp */

SET @id = 371;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'gm';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'gm chat';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'gm fly';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'gm ingame';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'gm list';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'gm visible';
 
 
/* 
* sql\updates\world\2013_09_02_07_world_command.sql 
*/ 
/* cs_go.cpp */

SET @id = 371;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'go';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'go creature';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'go graveyard';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'go grid';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'go object';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'go taxinode';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'go ticket';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'go trigger';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'go xyz';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'go zonexy';
 
 
/* 
* sql\updates\world\2013_09_02_08_world_command.sql 
*/ 
/* cs_gobject.cpp */

SET @id = 371;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'gobject';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'gobject activate';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'gobject add';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'gobject add temp';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'gobject delete';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'gobject info';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'gobject move';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'gobject near';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'gobject set';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'gobject set phase';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'gobject set state';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'gobject target';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'gobject turn';
 
 
/* 
* sql\updates\world\2013_09_02_09_world_command.sql 
*/ 
/* cs_guild.cpp */

SET @id = 401;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'guild';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'guild create';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'guild delete';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'guild invite';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'guild uninvite';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'guild rank';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'guild rename';
 
 
/* 
* sql\updates\world\2013_09_02_10_world_command.sql 
*/ 
/* cs_honor.cpp */

SET @id = 408;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'honor';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'honor add';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'honor add kill';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'honor update';
 
 
/* 
* sql\updates\world\2013_09_02_11_world_command.sql 
*/ 
/* cs_instance.cpp */

SET @id = 408;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'instance';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'instance listbinds';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'instance unbind';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'instance stats';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'instance savedata';
 
 
/* 
* sql\updates\world\2013_09_02_12_world_command.sql 
*/ 
/* cs_learn.cpp */

SET @id = 417;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'learn';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'learn all';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'learn all my';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'learn all my class';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'learn all my pettalents';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'learn all my spells';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'learn all my talents';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'learn all gm';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'learn all crafts';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'learn all default';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'learn all lang';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'learn all recipes';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'unlearn';
 
 
/* 
* sql\updates\world\2013_09_02_13_world_command.sql 
*/ 
/* cs_lfg.cpp */

SET @id = 430;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'lfg';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'lfg player';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'lfg group';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'lfg queue';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'lfg clean';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'lfg options';
 
 
/* 
* sql\updates\world\2013_09_02_14_world_command.sql 
*/ 
/* cs_list.cpp */

SET @id = 436;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'list';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'list creature';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'list item';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'list object';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'list auras';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'list mail';
 
 
/* 
* sql\updates\world\2013_09_02_15_world_command.sql 
*/ 
/* cs_lookup.cpp */

SET @id = 442;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'lookup';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'lookup area';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'lookup creature';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'lookup event';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'lookup faction';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'lookup item';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'lookup itemset';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'lookup object';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'lookup quest';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'lookup player';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'lookup player ip';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'lookup player account';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'lookup player email';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'lookup skill';
UPDATE `command` SET `permission` = @id+14 WHERE `name` = 'lookup spell';
UPDATE `command` SET `permission` = @id+15 WHERE `name` = 'lookup spell id';
UPDATE `command` SET `permission` = @id+16 WHERE `name` = 'lookup taxinode';
UPDATE `command` SET `permission` = @id+17 WHERE `name` = 'lookup tele';
UPDATE `command` SET `permission` = @id+18 WHERE `name` = 'lookup title';
UPDATE `command` SET `permission` = @id+19 WHERE `name` = 'lookup map';
 
 
/* 
* sql\updates\world\2013_09_02_16_world_command.sql 
*/ 
/* cs_message.cpp */

SET @id = 462;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'announce';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'channel';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'channel set';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'channel set ownership';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'gmannounce';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'gmnameannounce';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'gmnotify';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'nameannounce';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'notify';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'whispers';
 
 
/* 
* sql\updates\world\2013_09_02_17_world_command.sql 
*/ 
/* cs_cast.cpp */

SET @id = 263;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'cast';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'cast back';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'cast dist';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'cast self';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'cast target';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'cast dest';
 
 
/* 
* sql\updates\world\2013_09_02_18_world_command.sql 
*/ 
/* cs_character.cpp */

SET @id = 273;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0  WHERE `name` = 'character';
UPDATE `command` SET `permission` = @id+1  WHERE `name` = 'character customize';
UPDATE `command` SET `permission` = @id+2  WHERE `name` = 'character changefaction';
UPDATE `command` SET `permission` = @id+3  WHERE `name` = 'character changerace';
UPDATE `command` SET `permission` = @id+4  WHERE `name` = 'character deleted';
UPDATE `command` SET `permission` = @id+5  WHERE `name` = 'character deleted delete';
UPDATE `command` SET `permission` = @id+6  WHERE `name` = 'character deleted list';
UPDATE `command` SET `permission` = @id+7  WHERE `name` = 'character deleted restore';
UPDATE `command` SET `permission` = @id+8  WHERE `name` = 'character deleted old';
UPDATE `command` SET `permission` = @id+9  WHERE `name` = 'character erase';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'character level';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'character rename';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'character reputation';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'character titles';
UPDATE `command` SET `permission` = @id+14 WHERE `name` = 'levelup';
UPDATE `command` SET `permission` = @id+15 WHERE `name` = 'pdump';
UPDATE `command` SET `permission` = @id+16 WHERE `name` = 'pdump load';
UPDATE `command` SET `permission` = @id+17 WHERE `name` = 'pdump write';
 
 
/* 
* sql\updates\world\2013_09_02_19_world_spelldifficulty_dbc.sql 
*/ 
DELETE FROM `spelldifficulty_dbc` WHERE `id` IN (51849, 50840, 50834, 50830, 50831);
INSERT INTO `spelldifficulty_dbc`(`id`,`spellid0`,`spellid1`) VALUES
(51849, 51849, 59861),
(50840, 50840, 59848),
(50834, 50834, 59846),
(50830, 50830, 59844),
(50831, 50831, 59845);
 
 
/* 
* sql\updates\world\2013_09_02_20_world_sai.sql 
*/ 
-- Random comment
SET @QUEST              := 12470; -- Mystery of the Infinite (12470)
SET @NPC_HoE            := 27840; -- Hourglass of Eternity
SET @NPC_FU             := 27899; -- Future You
SET @NPC_ICM            := 27898; -- Infinite Chrono-Magus
SET @NPC_IA             := 27896; -- Infinite Assailant
SET @NPC_ID             := 27897; -- Infonite Destroyer
SET @NPC_IT             := 27900; -- Infinite Timerender
SET @SPELL_SUMMON_FU    := 49942; -- Mystery of the Infinite: Force Cast to Player of Summon Future You
SET @SPELL_CAST         := 49686; -- Mystery of the Infinite: Script Effect Player Cast Mirror Image
SET @SPELL_MIRROR       := 49889; -- Mystery of the Infinite: Future You's Mirror Image Aura
SET @SPELL_NEARBY       := 50867; -- Hourglass of Eternity Nearby
SET @AURA_VISUAL        := 50057; -- Mystery of the Infinite: Hourglass of Eternity Visual/Sound Aura
SET @AURA_CLASS         := 49925; -- Mystery of the Infinite: Future You's Mirror Class Aura
SET @FU_SAY_RAND        := 50037; -- Mystery of the Infinite: Future You's Whisper to Controller - Random
SET @FU_SAY_BYE         := 50023; -- Mystery of the Infinite: Future You's Whisper to Controller - Farewell
SET @FU_SAY_NOZD        := 50014; -- Mystery of the Infinite: Future You's Whisper to Controller - Nozdormu
SET @VIEW_INVISIBILITY  := 50020; -- Mystery of the Infinite: Hourglass cast See Invis on Master
SET @VIEW_INVISIBILITY1 := 50012; -- See Nozdormu Invisibility
SET @FU_DESPAWN_TIME    := 50022; -- Mystery of the Infinite: Future You's Despawn Timer
SET @SPELL_ASSAILANT    := 49900; -- Summon Infinite Assailant
SET @SPELL_DESTROYER    := 49901; -- Summon Infinite Destroyer
SET @SPELL_MAGUS        := 49902; -- Summon Infinite Chrono-Magus
SET @SPELL_TIMERENDER   := 49905; -- Summon Infinite Timerender

-- Hourglass of Eternity
UPDATE `creature` SET `orientation`=2.085232 WHERE `guid`=152260;
UPDATE `creature_template` SET `InhabitType`=4 WHERE `entry`=27925;
UPDATE `creature_template` SET `AIName`='SmartAI',`RegenHealth`=0 WHERE `entry`=@NPC_HoE;
DELETE FROM `smart_scripts` WHERE (`entryorguid`=@NPC_HoE AND `source_type`=0) OR (`entryorguid`IN (@NPC_HoE*100,@NPC_HoE*100+1) AND `source_type`=9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_HoE,0,0,1,54,0,100,1,0,0,0,0,85,@SPELL_SUMMON_FU,0,0,0,0,0,7,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On spawn - Invoker Cast'),
(@NPC_HoE,0,1,2,61,0,100,0,0,0,0,0,11,@SPELL_NEARBY,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On link - Cast Spell'),
(@NPC_HoE,0,2,3,61,0,100,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - Set passive - Self'),
(@NPC_HoE,0,3,6,61,0,100,0,0,0,0,0,80,@NPC_HoE*100,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On link - Start timed script'),
(@NPC_HoE,0,4,0,6,0,100,0,0,0,0,0,6,@QUEST,0,0,0,0,0,16,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On Death - Fail Quest'),
(@NPC_HoE,0,5,0,38,0,100,0,2,1,0,0,80,@NPC_HoE*100+1,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On Data Set  - Start timed script two'),
(@NPC_HoE,0,6,0,61,0,100,0,0,0,0,0,11,@AURA_VISUAL,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On link - Cast Spell'),

-- Wave 1 + Random speech
(@NPC_HoE*100,9,0,0,0,0,100,1,5000,5000,0,0,45,1,1,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,1,0,0,0,100,1,5000,5000,0,0,45,1,2,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,2,0,0,0,100,1,5000,5000,0,0,11,@SPELL_MAGUS,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Cast Spell on self'),
(@NPC_HoE*100,9,3,0,0,0,100,1,0,0,0,0,11,@SPELL_ASSAILANT,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Cast Spell on self'),
-- Wave 2 + Random speech
(@NPC_HoE*100,9,4,0,0,0,100,1,5000,5000,0,0,45,1,3,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,5,0,0,0,100,1,6000,6000,0,0,45,1,4,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,6,0,0,0,100,1,19000,19000,0,0,11,@SPELL_MAGUS,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Cast Spell on self'),
(@NPC_HoE*100,9,7,0,0,0,100,1,0,0,0,0,11,@SPELL_MAGUS,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Cast Spell on self'),
-- Wave 3 + Random speech
(@NPC_HoE*100,9,8,0,0,0,100,1,5000,5000,0,0,45,1,5,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,9,0,0,0,100,1,6000,6000,0,0,45,1,6,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,10,0,0,0,100,1,5000,5000,0,0,45,1,7,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,11,0,0,0,100,1,14000,14000,0,0,11,@SPELL_MAGUS,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Cast Spell on self'),
(@NPC_HoE*100,9,12,0,0,0,100,1,0,0,0,0,11,@SPELL_ASSAILANT,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Cast Spell on self'),
(@NPC_HoE*100,9,13,0,0,0,100,1,0,0,0,0,11,@SPELL_DESTROYER,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Cast Spell on self'),
-- Wave 4 + Random speech 
(@NPC_HoE*100,9,14,0,0,0,100,1,5000,5000,0,0,45,1,8,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,15,0,0,0,100,1,9000,9000,0,0,45,1,9,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,16,0,0,0,100,1,7000,7000,0,0,45,1,10,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,17,0,0,0,100,1,9000,9000,0,0,11,@SPELL_MAGUS,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100,9,18,0,0,0,100,1,0,0,0,0,11,@SPELL_ASSAILANT,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'OHourglass of Eternity - On update - Cast Spell on self'),
(@NPC_HoE*100,9,19,0,0,0,100,1,0,0,0,0,11,@SPELL_DESTROYER,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Cast Spell on self'),
-- Wave 5 final + Random speech
(@NPC_HoE*100,9,20,0,0,0,100,1,23000,23000,0,0,11,@SPELL_TIMERENDER,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Cast Spell on self'),
-- End Text Script
(@NPC_HoE*100+1,9,0,0,0,0,100,1,4000,4000,0,0,45,2,1,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100+1,9,1,0,0,0,100,1,0,0,0,0,15,@QUEST,0,0,0,0,0,21,10,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Give Quest Credit'),
(@NPC_HoE*100+1,9,2,0,0,0,100,1,8000,8000,0,0,45,2,2,0,0,0,0,19,@NPC_FU,20,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update - Set Data on Future You'),
(@NPC_HoE*100+1,9,3,0,0,0,100,1,0,0,0,0,41,4000,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Hourglass of Eternity - On update -Despawn after timer');

-- Future You
DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_FU AND `source_type`=0;
UPDATE `creature_template` SET `faction_A`=2141,`faction_H`=2141,`AIName`='SmartAI',`unit_flags`=0,`RegenHealth`=0 WHERE `entry`=@NPC_FU;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_FU,0,0,1,54,0,100,1,0,0,0,0,85,@SPELL_MIRROR,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spawn - Invoker Cast Spell - Self'),
(@NPC_FU,0,1,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,11,@NPC_HoE,10,0,0.0,0.0,0.0,0.0,'Future You - On link - Set Orientation'),
(@NPC_FU,0,2,3,38,0,100,0,1,1,0,0,11,@FU_SAY_RAND,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,3,0,61,0,100,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 1'),
(@NPC_FU,0,4,5,38,0,100,0,1,2,0,0,11,@FU_SAY_RAND,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,5,0,61,0,100,0,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 2'),
(@NPC_FU,0,6,7,38,0,100,0,1,3,0,0,11,@FU_SAY_RAND,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,7,0,61,0,100,0,0,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 3'),
(@NPC_FU,0,8,9,38,0,100,0,1,4,0,0,11,@FU_SAY_RAND,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,9,0,61,0,100,0,0,0,0,0,1,4,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 4'),
(@NPC_FU,0,10,11,38,0,100,0,1,5,0,0,11,@FU_SAY_RAND,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,11,0,61,0,100,0,0,0,0,0,1,5,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 5'),
(@NPC_FU,0,12,13,38,0,100,0,1,6,0,0,11,@FU_SAY_RAND,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,13,0,61,0,100,0,0,0,0,0,1,6,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 6'),
(@NPC_FU,0,14,15,38,0,100,0,1,7,0,0,11,@FU_SAY_RAND,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,15,0,61,0,100,0,0,0,0,0,1,7,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 7'),
(@NPC_FU,0,16,17,38,0,100,0,1,8,0,0,11,@FU_SAY_RAND,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,17,0,61,0,100,0,0,0,0,0,1,8,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 8'),
(@NPC_FU,0,18,19,38,0,100,0,1,9,0,0,11,@FU_SAY_RAND,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,19,0,61,0,100,0,0,0,0,0,1,9,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 9'),
(@NPC_FU,0,20,21,38,0,100,0,1,10,0,0,11,@FU_SAY_RAND,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,21,0,61,0,100,0,0,0,0,0,1,10,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 10'),
(@NPC_FU,0,22,23,38,0,100,0,2,1,0,0,11,@FU_SAY_NOZD,2,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Cast spell'),
(@NPC_FU,0,23,0,61,0,100,0,0,0,0,0,1,11,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On spellhit - Whisper 11'),
(@NPC_FU,0,24,25,38,0,100,0,2,2,0,0,1,12,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Data Set - Whisper 12'),
(@NPC_FU,0,25,0,61,0,100,0,0,0,0,0,41,3000,0,0,0,0,0,11,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Link - Despawn after timer'),
(@NPC_FU,0,26,27,7,0,100,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Evade - Despawn after timer'),
(@NPC_FU,0,27,0,61,0,100,0,0,0,0,0,85,@SPELL_SUMMON_FU,0,0,0,0,0,7,0,0,0,0.0,0.0,0.0,0.0,'Future You - On Link - Cast Summon Clone');

-- Clone invoker weapons
DELETE FROM `spell_linked_spell` WHERE `spell_trigger`=@SPELL_MIRROR;
INSERT INTO `spell_linked_spell` (`spell_trigger`,`spell_effect`,`type`,`comment`) VALUES
(@SPELL_MIRROR,41055,1,'Copy main weapon'),
(@SPELL_MIRROR,45206,1,'Copy off weapon');

-- Spell Area to see Nozdormu invis
DELETE FROM `spell_area` WHERE spell = @VIEW_INVISIBILITY1;
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`, `quest_start_status`, `quest_end_status`) VALUES
(@VIEW_INVISIBILITY1, 4175, 12470, 0, 0, 0, 2, 1, 2, 11);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=@SPELL_MIRROR;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,7,@SPELL_MIRROR,0,0,31,0,3,@NPC_FU,0,0,0,'','Spell target Future You');

DELETE FROM `creature_template_addon` WHERE `entry` IN (@NPC_HoE,@NPC_FU);
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`auras`) VALUES
(@NPC_HoE,0,0x0,0x1,''),
(@NPC_FU,0,0x0,0x1,'');

-- Future You's text
DELETE FROM `creature_text` WHERE `entry`=@NPC_FU;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@NPC_FU,1,0,'Hey there, $N, don''t be alarmed. It''s me... you... from the future. I''m here to help.',15,0,100,396,0,0,'Future You'),
(@NPC_FU,2,0,'Head''s up... here they come. I''ll help as much as I can. Let''s just keep them off the hourglass!',15,0,100,396,0,0,'Future You'),
(@NPC_FU,3,0,'No matter what, you can''t die, because that would mean that I would cease to exist, right? I was here before when i was you. I''m so confused!',15,0,100,0,0,0,'Future You'),
(@NPC_FU,4,0,'I can''t believe that I used to wear that.',15,0,100,0,0,0,'Future You'),
(@NPC_FU,5,0,'Sorry, but Chromie said that I couldn''t reveal anything about your future to you. She said that if I did, I would cease to exist.',15,0,100,0,0,0,'Future You'),
(@NPC_FU,6,0,'Wow, I''d forgotten how inexperienced I used to be.',15,0,100,0,0,0,'Future You'),
(@NPC_FU,7,0,'Look at you fight; no wonder I turned to drinking.',15,0,100,0,0,0,'Future You'),
(@NPC_FU,8,0,'What? Am I here alone. We both have a stake at this, you know!',15,0,100,0,0,0,'Future You'),
(@NPC_FU,9,0,'Listen. I''m not supposed to tell you this, but there''s going to be this party that you''re invited to. Whatever you do, DO NOT DRINK THE PUNCH!',15,0,100,0,0,0,'Future You'),
(@NPC_FU,10,0,'Wish I could remember how many of the Infinite Dragonflight were going to try to stop you. This fight was so long ago.',15,0,100,0,0,0,'Future You'),
(@NPC_FU,11,0,'Look, $N, the hourglass has revealed Nozdormu!',15,0,100,25,0,0,'Future You'),
(@NPC_FU,12,0,'Farewell, $N, Keep us alive and get some better equipment!',15,0,100,0,0,0,'Future You');

DELETE FROM `creature_ai_scripts` WHERE creature_id IN (27898,27900);
UPDATE `creature_template` SET `AIName`='SmartAI',`faction_A`=2111,`faction_H`=2111,`unit_flags`=559104 WHERE `entry` IN (@NPC_ICM,@NPC_IA,@NPC_ID,@NPC_IT);
-- Infinite Chrono-Magus
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@NPC_ICM;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_ICM,0,0,0,4,0,100,1,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Infinite Chrono-Magus - Set Phase 1 - On Aggro'),
(@NPC_ICM,0,1,0,4,1,100,1,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Infinite Chrono-Magus - Stop Moving - On Aggro'),
(@NPC_ICM,0,2,0,4,1,100,1,0,0,0,0,11,9613,0,0,0,0,0,2,0,0,0,0,0,0,0,'Infinite Chrono-Magus - Cast bolt on Aggro'),
(@NPC_ICM,0,3,0,9,1,100,0,0,40,3400,4700,11,9613,0,0,0,0,0,2,0,0,0,0,0,0,0,'Infinite Chrono-Magus -  Cast Bolt'),
(@NPC_ICM,0,4,0,9,1,100,0,40,100,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Infinite Chrono-Magus - Start Moving - When not in bolt Range'),
(@NPC_ICM,0,5,0,9,1,100,0,10,15,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Infinite Chrono-Magus - Stop Moving - 15 Yards'),
(@NPC_ICM,0,6,0,9,1,100,0,0,40,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Infinite Chrono-Magus - Stop Moving - When in bolt Range'),
(@NPC_ICM,0,7,0,3,1,100,0,0,15,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Infinite Chrono-Magus - Set Phase 2 - 15% Mana'),
(@NPC_ICM,0,8,0,3,2,100,0,0,15,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Infinite Chrono-Magus - Start Moving - 15% Mana'),
(@NPC_ICM,0,9,0,3,2,100,0,30,100,100,100,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Infinite Chrono-Magus - Set Phase 1 - When Mana is above 30%'),
(@NPC_ICM,0,10,0,0,1,100,0,8000,8000,12000,14000,11,38085,0,0,0,0,0,2,0,0,0,0,0,0,0,'Infinite Chrono-Magus - IC -Cast Shadow Blast');

-- Infinite Timerender
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@NPC_IT;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_IT,0,0,0,0,0,100,0,5000,6000,12000,17000,11,51020,0,0,0,0,0,2,0,0,0,0,0,0,0,'Infinite Timerender - IC - Cast Time Lapse'),
(@NPC_IT,0,1,0,6,0,100,0,0,0,0,0,45,2,1,0,0,0,0,19,@NPC_HoE,20,0,0,0,0,0,'Infinite Timerender - On Death - Set Data on HoE');
 
 
/* 
* sql\updates\world\2013_09_03_00_world_smart_scripts.sql 
*/ 
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=25310;

DELETE FROM `smart_scripts` WHERE `entryorguid`=25310 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(25310, 0, 0, 0, 8, 0, 100, 1, 45414, 0, 0, 0, 33, 25310, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Borean - Westrift Cleftcliff Anomaly - On Spellhit "Calculate Seismic Readings" - Give Quest Credit');
 
 
/* 
* sql\updates\world\2013_09_03_01_world_creature.sql 
*/ 
-- Delete 2 incorrectly spawned mobs
DELETE FROM `creature` WHERE `guid` IN (66177,84663) AND `map` = 530;
 
 
/* 
* sql\updates\world\2013_09_03_02_world_update.sql 
*/ 
UPDATE `creature_template` SET `spell1`=52497, `spell2`=52510 WHERE  `entry`=28843;
 
 
/* 
* sql\updates\world\2013_09_03_03_world_sai.sql 
*/ 
-- Disclosure (12710)
SET @MALMORTIS      := 28948;  -- Malmortis
SET @TRIGG_BUNNY    := 28617;  -- Drakuramas Teleport Bunny 01
SET @LOW_TRIG_B     := 114831; -- Lower Trigger Bunny Guid
SET @TRIGGER1       := 5080;   -- Lower Teleport Trigger
SET @UP_TRIG_B      := 114829; -- Upper Trigger Bunny guid
SET @TRIGGER2       := 5061;   -- Upper Teleport Trigger
SET @SCEPT_AURA     := 52678;  -- Teleporter Scepter Aura
SET @ESCORT_A       := 52839;  -- Summon Escort Aura
SET @T_SCRIPT       := 52676;  -- Drakuramas Teleport Script 03
SET @TELEPORT3      := 52677;  -- Drakuramas Teleport 03
SET @SUM_MAL        := 52775;  -- Summon Malmortis
SET @HEARTBEAT      := 61707;  -- Malmortis Heartbeat
SET @KILLCREDIT     := 53101;  -- Kill Credit
SET @T_SCRIPT2      := 52089;  -- Drakuramas Teleport Script 01
SET @TELEPORT1      := 52091;  -- Drakuramas Teleport 01

-- Drakuramas Teleport 03 position
DELETE FROM `spell_target_position` WHERE `id`=@TELEPORT3;
INSERT INTO `spell_target_position` (`id`,`target_map`,`target_position_x`,`target_position_y`,`target_position_z`,`target_orientation`) VALUES
(@TELEPORT3,571,6252.58, -1965.86, 484.782, 3.7);

-- Drakuramas Teleport Script 01 position
DELETE FROM `spell_target_position` WHERE `id`=@TELEPORT1;
INSERT INTO `spell_target_position` (`id`,`target_map`,`target_position_x`,`target_position_y`,`target_position_z`,`target_orientation`) VALUES
(@TELEPORT1,571,6165.262, -2001.812, 408.167, 2.2);

DELETE FROM `areatrigger_scripts` WHERE `entry` = @TRIGGER1;
INSERT INTO `areatrigger_scripts` (`entry`, `ScriptName`) VALUES
(@TRIGGER1,'SmartTrigger');

DELETE FROM `smart_scripts` WHERE `entryorguid` =@TRIGGER1 AND `source_type`=2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@TRIGGER1,2,0,0,46,0,100,0,@TRIGGER1,0,0,0,45,1,1,0,0,0,0,10,@LOW_TRIG_B,@TRIGG_BUNNY,0,0,0,0,0,'');

DELETE FROM `areatrigger_scripts` WHERE `entry` = @TRIGGER2;
INSERT INTO `areatrigger_scripts` (`entry`, `ScriptName`) VALUES
(@TRIGGER2,'SmartTrigger');

DELETE FROM `smart_scripts` WHERE `entryorguid` =@TRIGGER2 AND `source_type`=2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@TRIGGER2,2,0,0,46,0,100,0,@TRIGGER2,0,0,0,45,1,1,0,0,0,0,10,@UP_TRIG_B,@TRIGG_BUNNY,0,0,0,0,0,'');

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-@LOW_TRIG_B,-@UP_TRIG_B) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`)VALUES
(-@LOW_TRIG_B,0,0,0,38,0,100,0,1,1,0,0,11,@T_SCRIPT2,0,0,0,0,0,21,5,0,0,0,0,0,0,'Drakuramas Teleport Bunny 01 - On Data Set - Tele Player'),
--
(-@UP_TRIG_B,0,0,0,38,0,100,0,1,1,0,0,11,@T_SCRIPT,0,0,0,0,0,21,5,0,0,0,0,0,0,'Drakuramas Teleport Bunny 01 - On Data Set - Tele Player');

DELETE FROM `spell_linked_spell` WHERE `spell_trigger` IN (@T_SCRIPT,@T_SCRIPT2,@ESCORT_A);
INSERT INTO `spell_linked_spell` (`spell_trigger`,`spell_effect`,`type`,`comment`) VALUES
(@ESCORT_A,@SUM_MAL,1,'Summon Malmortis'),
(@T_SCRIPT,@TELEPORT3,1,'Teleport'),
(@T_SCRIPT2,@TELEPORT1,1,'Teleport');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry` IN (@TRIGGER1,@TRIGGER2);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22,1,@TRIGGER1,2,0,1,0,@SCEPT_AURA,0,0,0,0,'','SAI areatrigger triggers only if player has aura Teleporter Scepter Aura'),
(22,1,@TRIGGER2,2,0,1,0,@SCEPT_AURA,0,0,0,0,'','SAI areatrigger triggers only if player has aura Teleporter Scepter Aura');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (@T_SCRIPT,@T_SCRIPT2);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(13, 1, @T_SCRIPT, 0, 0, 31, 0, 4, 0, 0, 0, 0, 0, '', 'Spell only hits player'),
(13, 1, @T_SCRIPT2, 0, 0, 31, 0, 4, 0, 0, 0, 0, 0, '', 'Spell only hits player');

UPDATE `gameobject_template` SET `size`=2 WHERE `entry` IN (190948,190949); -- Musty Coffin
DELETE FROM `gameobject` WHERE `id` IN (190949,190948);
INSERT INTO `gameobject` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`) VALUES
(9253, 190949, 571, 1, 1, 6260.489, -1960.045, 484.7818, 3.787367, 0, 0, 0, 1, 120, 255, 1), -- Musty Coffin (Area: Reliquary of Pain)
(9254, 190948, 571, 1, 1, 6260.482, -1960.039, 484.7818, 3.787367, 0, 0, 0, 1, 120, 255, 1); -- Musty Coffin (Area: Reliquary of Pain)

-- Template updates for creature 28948 (Malmortis)
UPDATE `creature_template` SET `minlevel`=85,`maxlevel`=85,`unit_flags`=`unit_flags`|264,`speed_walk`=2.4,`speed_run`=0 WHERE `entry`=@MALMORTIS; -- Malmortis
-- Model data 8055 (creature 28948 (Malmortis))
UPDATE `creature_model_info` SET `bounding_radius`=2,`combat_reach`=3,`gender`=0 WHERE `modelid`=8055; -- Malmortis
-- Addon data for creature 28948 (Malmortis)
DELETE FROM `creature_template_addon` WHERE `entry`=@MALMORTIS;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(@MALMORTIS,0,0,1,0,''); -- Malmortis

UPDATE `creature_template` SET AIName='SmartAI' WHERE `entry` IN (@MALMORTIS,@TRIGGER1,@TRIGGER2,@TRIGG_BUNNY);
DELETE FROM `smart_scripts` WHERE `entryorguid`IN (@MALMORTIS,@MALMORTIS*100) AND `source_type`IN (0,9);
DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (@MALMORTIS);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`)VALUES
(@MALMORTIS,0,0,1,54,0,100,0,0,0,0,0,80,@MALMORTIS*100,2,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Respawn - Start Timed Action Script'),
(@MALMORTIS,0,1,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Malmortis - On Respawn - Set Orientation To Invoker'),
-- 47
(@MALMORTIS,0,2,0,40,0,100,1,8,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On WP Reached - Say 3'),
(@MALMORTIS,0,3,0,40,0,100,1,18,0,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On WP Reached- Say 4'),
(@MALMORTIS,0,4,5,40,0,100,1,47,0,0,0,1,5,7000,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On WP Reached - Say'),
(@MALMORTIS,0,5,0,61,0,100,0,0,0,0,0,54,10000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Link - Pause WP'),
(@MALMORTIS,0,6,0,52,0,100,1,5,@MALMORTIS,0,0,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Text Over 5 - Say 6'),
-- 121
(@MALMORTIS,0,6,7,40,0,100,1,80,0,0,0,1,7,0,0,0,0,0,1,0,10,0,0,0,0,0,'Malmortis - On WP Reached - Say 7'),
(@MALMORTIS,0,7,0,61,0,100,0,0,0,0,0,54,6000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Link - Pause WP'),
(@MALMORTIS,0,8,9,40,0,100,1,81,0,0,0,1,8,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On WP Reached - Say 8'),
(@MALMORTIS,0,9,0,61,0,100,0,0,0,0,0,54,6000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Link - Pause WP'),
-- 128
(@MALMORTIS,0,10,11,40,0,100,1,86,0,0,0,1,9,3000,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On WP Reached - Say 9'),
(@MALMORTIS,0,11,0,61,0,100,0,0,0,0,0,54,23000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Link - Pause WP'),
(@MALMORTIS,0,12,0,52,0,100,1,9,@MALMORTIS,0,0,1,10,7000,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Text Over 9 - Say 10'),
(@MALMORTIS,0,13,0,52,0,100,1,10,@MALMORTIS,0,0,1,11,7000,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Text Over 10 - Say 11'),
(@MALMORTIS,0,14,0,52,0,100,1,11,@MALMORTIS,0,0,1,12,7000,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Text Over 11 - Say 12'),
-- 137 
(@MALMORTIS,0,15,0,40,0,100,1,93,0,0,0,1,13,5000,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On WP Reached - Say 13'),
(@MALMORTIS,0,16,17,52,0,100,1,13,@MALMORTIS,0,0,1,14,7000,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Text Over 13 - Say 14'),
(@MALMORTIS,0,17,18,61,0,100,0,0,0,0,0,11,@T_SCRIPT,2,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Link - Cast on self'),
(@MALMORTIS,0,18,0,61,0,100,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Link - Despawn'),
-- 
(@MALMORTIS*100,9,0,0,0,0,100,0,3000,3000,3000,3000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Script - Say 0'),
(@MALMORTIS*100,9,1,0,0,0,100,0,5000,5000,5000,5000,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Script - Say 1'),
(@MALMORTIS*100,9,2,0,0,0,100,0,5000,5000,5000,5000,53,0,@MALMORTIS,0,0,0,0,1,0,0,0,0,0,0,0,'Malmortis - On Script - Start WP movement'),
-- It's weird that credit is given here, but hey, we're Blizzard, we can do it wherever we want.
(@MALMORTIS*100,9,3,0,0,0,100,0,1000,1000,1000,1000,11,@KILLCREDIT,2,0,0,0,0,7,0,0,0,0,0,0,0,'Malmortis - On Script - Cast Q Credit to Invoker');


DELETE FROM `creature_text` WHERE `entry`=28948;
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES 
(28948, 0, 0, 'Ahh... there you are. The master told us you''d be arriving soon.', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 1, 0, 'Please, follow me, $N. There is much for you to see...', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 2, 0, 'Ever since his arrival from Drak''Tharon, the master has spoken of the time you would be joining him here.', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 3, 0, 'You should feel honored. You are the first of the master''s prospects to be shown our operation.', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 4, 0, 'The things I show you now must never be spoken of outside Voltarus. The world shall come to know our secret soon enough!', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 5, 0, 'Here lie our stores of blight crystal, without which our project would be impossible.', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 6, 0, 'I understand that you are to thank for the bulk of our supply.', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 7, 0, 'These trolls are among those you exposed on the battlefield. Masterfully done, indeed....', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 8, 0, 'We feel it best to position them here, where they might come in terms with their impending fate.', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 9, 0, 'This is their destiny....', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 10, 0, 'The blight slowly seeps into their bodies, gradually preparing them for their conversion.', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 11, 0, 'This special preparation grants them unique powers far greater than they would otherwise know.', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 12, 0, 'Soon, the master will grant them the dark gift, making them fit to server the Lich King for eternity!', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 13, 0, 'Stay for as long as you like, $N. Glory in the fruits of your labor!', 12, 0, 100, 0, 0, 0, 'Malmortis say'),
(28948, 14, 0, 'Your service has been invaluable in fulfilling the master''s plan. May you forever grow in power....', 12, 0, 100, 0, 0, 0, 'Malmortis say');


DELETE FROM `waypoints` WHERE entry = @MALMORTIS;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `point_comment`) VALUES
(@MALMORTIS, 1,  6246.076, -1959.903, 484.7817, ''),
(@MALMORTIS, 2,  6239.468, -1963.94, 484.5479,  ''),
(@MALMORTIS, 3,  6235.218, -1964.69, 484.5479,  ''),
(@MALMORTIS, 4,  6232.341, -1965.397, 484.7817, ''),
(@MALMORTIS, 5,  6229.812, -1960.545, 484.832,  ''),
(@MALMORTIS, 6,  6229.805, -1960.542, 484.832,  ''),
(@MALMORTIS, 7,  6225.805, -1959.542, 484.832,  ''),
(@MALMORTIS, 8,  6218.658, -1962.031, 484.8823, ''), -- Say 3
(@MALMORTIS, 9,  6213.883, -1954.917, 484.6498, ''),
(@MALMORTIS, 10, 6211.883, -1951.667, 484.6498, ''),
(@MALMORTIS, 11, 6205.607, -1941.303, 484.9172, ''),
(@MALMORTIS, 12, 6192.572, -1931.705, 484.9854, ''),
(@MALMORTIS, 13, 6178.136, -1937.173, 484.6558, ''),
(@MALMORTIS, 14, 6175.831, -1938.89,  484.9104, ''),
(@MALMORTIS, 15, 6171.331, -1943.14,  484.6604, ''),
(@MALMORTIS, 16, 6163.581, -1951.14, 484.9104,  ''),
(@MALMORTIS, 17, 6157.331, -1952.89, 484.6604,  ''),
(@MALMORTIS, 18, 6156.749, -1953.028, 484.9022, ''), -- Say 4
(@MALMORTIS, 19, 6149.743, -1957.582, 484.655,  ''),
(@MALMORTIS, 20, 6147.993, -1958.832, 484.905,  ''),
(@MALMORTIS, 21, 6144.993, -1960.832, 484.905,  ''),
(@MALMORTIS, 22, 6140.993, -1963.332, 484.905,  ''),
(@MALMORTIS, 23, 6137.743, -1965.332, 484.905,  ''),
(@MALMORTIS, 24, 6132.743, -1968.582, 484.905,  ''), 
(@MALMORTIS, 25, 6128.993, -1970.832, 484.905,  ''), 
(@MALMORTIS, 26, 6125.993, -1972.832, 484.905,  ''),
(@MALMORTIS, 27, 6123.243, -1974.332, 484.655,  ''),
(@MALMORTIS, 28, 6119.237, -1976.635, 484.9079, ''),
(@MALMORTIS, 29, 6116.115, -1977.373, 484.6002,  ''),
(@MALMORTIS, 30, 6112.615, -1979.373, 484.6002,  ''),
(@MALMORTIS, 31, 6103.115, -1984.623, 484.6002,  ''),
(@MALMORTIS, 32, 6096.115, -1989.123, 484.6002,  ''),
(@MALMORTIS, 33, 6094.615, -1990.123, 484.8502,  ''),
(@MALMORTIS, 34, 6093.954, -1990.445, 484.918,  ''),
(@MALMORTIS, 35, 6089.347, -2014.297, 484.8763, ''),
(@MALMORTIS, 36, 6099.82, -2021.594, 484.9467,  ''),
(@MALMORTIS, 37, 6102.82, -2024.344, 484.9467,  ''),
(@MALMORTIS, 38, 6105.32, -2027.094, 484.9467,  ''),
(@MALMORTIS, 39, 6114.07, -2034.844, 484.9467,  ''),
(@MALMORTIS, 40, 6113.57, -2037.844, 484.9467,  ''),
(@MALMORTIS, 41, 6112.82, -2040.594, 484.6967,  ''),
(@MALMORTIS, 42, 6113.093, -2041.11, 484.8785,  ''),
(@MALMORTIS, 43, 6103.914, -2049.32, 484.8252,  ''),
(@MALMORTIS, 44, 6103.414, -2052.07, 484.8252,  ''),
(@MALMORTIS, 45, 6102.664, -2054.57, 484.5752,  ''),
(@MALMORTIS, 46, 6103.664, -2055.57, 484.5752,  ''),
(@MALMORTIS, 47, 6108.405, -2060.931, 484.7817, ''), -- say 5 & say 6
(@MALMORTIS, 48, 6111.582, -2063.279, 484.5828, ''),
(@MALMORTIS, 49, 6117.082, -2066.779, 484.5828, ''),
(@MALMORTIS, 50, 6118.082, -2067.279, 484.8328, ''),
(@MALMORTIS, 51, 6122.082, -2069.779, 484.8328, ''),
(@MALMORTIS, 52, 6127.582, -2073.529, 484.8328, ''), 
(@MALMORTIS, 53, 6129.582, -2074.779, 484.8328, ''), 
(@MALMORTIS, 54, 6136.759, -2078.627, 484.8839, ''),
(@MALMORTIS, 55, 6135.021, -2082.232, 484.9813, ''),
(@MALMORTIS, 56, 6137.021, -2085.232, 484.7313, ''),
(@MALMORTIS, 57, 6143.271, -2093.232, 484.9813, ''),
(@MALMORTIS, 58, 6145.771, -2097.232, 484.9813, ''),
(@MALMORTIS, 59, 6149.521, -2102.232, 484.9813, ''),
(@MALMORTIS, 60, 6152.771, -2104.482, 484.9813, ''),
(@MALMORTIS, 61, 6157.708, -2107.487, 485.1209, ''),
(@MALMORTIS, 62, 6152.734, -2117.464, 484.878, ''),
(@MALMORTIS, 63, 6155.484, -2121.714, 485.1281, ''),
(@MALMORTIS, 64, 6146.211, -2124.778, 485.1514, ''),
(@MALMORTIS, 65, 6145.211, -2124.778, 485.1514, ''),
(@MALMORTIS, 66, 6140.628, -2128.341, 485.3621, ''),
(@MALMORTIS, 67, 6126.711, -2123.778, 473.1514, ''),
(@MALMORTIS, 68, 6125.211, -2123.778, 473.1514, ''),
(@MALMORTIS, 69, 6119.711, -2123.278, 473.4014,  ''),
(@MALMORTIS, 70, 6118.48, -2123.076, 473.5551, ''),
(@MALMORTIS, 71, 6120.804, -2116.018, 473.4532, ''),
(@MALMORTIS, 72, 6121.228, -2108.079, 473.5628, ''),
(@MALMORTIS, 73, 6123.12, -2108.537, 473.5413, ''),
(@MALMORTIS, 74, 6124.12, -2108.537, 473.5413, ''),
(@MALMORTIS, 75, 6128.12, -2108.787, 473.2913, ''),
(@MALMORTIS, 76, 6137.730, -2111.003, 465.857, ''),
(@MALMORTIS, 77, 6143.918, -2112.493, 461.311, ''),
(@MALMORTIS, 78, 6152.609, -2110.294, 461.309, ''),
(@MALMORTIS, 79, 6156.999, -2110.611, 461.3106, ''),
(@MALMORTIS, 80, 6157.26, -2087.746, 461.0578,  ''), -- Say 7
(@MALMORTIS, 81, 6148.678, -2072.781, 461.3044, ''), -- Say 8 
(@MALMORTIS, 82, 6154.87, -2058.052, 461.2998,  ''),
(@MALMORTIS, 83, 6146.364, -2056.77, 460.8798,  ''),
(@MALMORTIS, 84, 6145.364, -2055.52, 460.8798,  ''),
(@MALMORTIS, 85, 6141.864, -2051.27, 460.8798,  ''),
(@MALMORTIS, 86, 6139.778, -2046.457, 461.3102, ''), -- say 9 & say 10 & say 11 & say 12
(@MALMORTIS, 87, 6143.079, -2043.717, 461.6264, ''),
(@MALMORTIS, 88, 6150.579, -2037.467, 461.6264, ''),
(@MALMORTIS, 89, 6156.329, -2032.717, 459.6264, ''),
(@MALMORTIS, 90, 6158.579, -2031.217, 458.8764, ''),
(@MALMORTIS, 91, 6161.379, -2028.978, 458.9426, ''),
(@MALMORTIS, 92, 6168.36, -2022.986, 454.9367,  ''),
(@MALMORTIS, 93, 6172.36, -2019.708, 455.1223,  ''); -- Say 13 & 14
 
 
/* 
* sql\updates\world\2013_09_03_04_world_sai.sql 
*/ 
DELETE FROM `smart_scripts` WHERE `entryorguid`= 24189 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES 
(24189, 0, 0, 0, 19, 0, 100, 0, 11288, 0, 0, 0, 85, 43202, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Ares - On target quest accepted 11288 - Cast spell Shining Light'),
(24189, 0, 1, 0, 19, 0, 100, 0, 11289, 0, 0, 0, 85, 43228, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Ares - On target quest accepted 11289 - Cast Guided by the Oathbound QC');
 
 
/* 
* sql\updates\world\2013_09_04_00_world_sai.sql 
*/ 
-- Putting Olakin Back Together Again (13220)
SET @QUEST               := 13220;
SET @NPC_OLAKIN          := 31235;  -- Crusader Olakin Sainrith
SET @GO_CLEAVER          := 193092; -- The Doctor's Cleaver
SET @GO_SPOOL            := 193091; -- Spool of Thread
SET @EVENT_SCRIPT        := 20269;  -- Event from 58856 Reanimate Crusader Olakin
SET @SPELL_FD            := 35356;  -- Feign Death
SET @SPELL_FAKE_BLOOD    := 37692;  -- Fake Blood Spurt
SET @SPELL_RESURRECTION  := 58854;  -- Resurrection

DELETE FROM `gameobject` WHERE `id` IN (@GO_CLEAVER,@GO_SPOOL);
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(16974,@GO_SPOOL,571,1,1,6668.17,3268.54,669.539,2.54818,0,0,0.956304,0.292373,120,255, 1),
(16976,@GO_CLEAVER,571,1,1,6601.1,3147.78,666.916,-2.77507,0,0,-0.983254,0.182238,120,255,1);

DELETE FROM `event_scripts` WHERE `id`=@EVENT_SCRIPT;
INSERT INTO `event_scripts` (`id`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`) VALUES
(@EVENT_SCRIPT,0,10,@NPC_OLAKIN,60000,0,6636.792,3211.102,668.6439,0.8901179);

DELETE FROM `creature_template_addon` WHERE `entry`=@NPC_OLAKIN;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`auras`) VALUES
(@NPC_OLAKIN,0,0x0,0x1,'35356'); -- 31235 - 35356

DELETE FROM `creature_text` WHERE `entry`=@NPC_OLAKIN;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@NPC_OLAKIN,0,0,'Thank the Light for granting me another chance. And thank you, $N.',12,0,100,1,0,0,'Crusader Olakin Sainrith'),
(@NPC_OLAKIN,1,0,'Without your help, I would''ve been doomed to a life of undeath among the Lich King''s gruesome creations.', 12,0,100,1,0,0,'Crusader Olakin Sainrith'),
(@NPC_OLAKIN,2,0,'There will be time for a proper thanks later, but there is still a battle to be fought!', 12,0,100,25,0,0,'Crusader Olakin Sainrith');

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@NPC_OLAKIN;
DELETE FROM `smart_scripts` WHERE (`source_type`=0 AND `entryorguid`=@NPC_OLAKIN) OR (`source_type`=9 AND `entryorguid`=@NPC_OLAKIN*100);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_OLAKIN,0,0,0,54,0,100,0,0,0,0,0,80,@NPC_OLAKIN*100,0,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On Just summoned - Run Script'),
(@NPC_OLAKIN,0,1,0,40,0,100,0,3,0,0,0,41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On WP Reached - Despawn'),
-- 17,26
(@NPC_OLAKIN*100,9,0,0,0,0,100,0,2000,2000,0,0,11,@SPELL_FAKE_BLOOD,0,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On Script - Cast Spell'),
(@NPC_OLAKIN*100,9,1,0,0,0,100,0,2000,2000,0,0,11,@SPELL_RESURRECTION,0,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On Script - Cast Spell'),
(@NPC_OLAKIN*100,9,2,0,0,0,100,0,0,0,0,0,28,@SPELL_FD,0,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On Script - Remove Aura'),
(@NPC_OLAKIN*100,9,3,0,0,0,100,0,0,0,0,0,96,32,0,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On Script - Remove dynamic flag'),
(@NPC_OLAKIN*100,9,4,0,0,0,100,0,1000,1000,0,0,19,1,1,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On Script - Remove Unit Flag_2 1 {dead)'),
(@NPC_OLAKIN*100,9,5,0,0,0,100,0,4000,4000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On Script - Say 0'),
(@NPC_OLAKIN*100,9,6,0,0,0,100,0,4000,4000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On Script - Say 1'),
(@NPC_OLAKIN*100,9,7,0,0,0,100,0,4000,4000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On Script - Say 2'),
(@NPC_OLAKIN*100,9,8,0,0,0,100,0,3000,3000,0,0,33,@NPC_OLAKIN,0,0,0,0,0,17,0,30,0,0,0,0,0,'Crusader Olakin Sainrith - On Script - Quest Credit'),
(@NPC_OLAKIN*100,9,9,0,0,0,100,0,0,0,0,0,53,1,@NPC_OLAKIN,0,0,0,0,1,0,0,0,0,0,0,0,'Crusader Olakin Sainrith - On Script -Start WP movement');

DELETE FROM `waypoints` WHERE entry =@NPC_OLAKIN;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `point_comment`) VALUES
(@NPC_OLAKIN, 1, 6632.227, 3223.6350, 666.7750,'Olakin'),
(@NPC_OLAKIN, 2, 6624.2558, 3230.2343, 666.857, 'Olakin'),
(@NPC_OLAKIN, 3, 6608.985, 3234.5588, 668.779, 'Olakin');

 
 
/* 
* sql\updates\world\2013_09_04_01_world_sai.sql 
*/ 
-- A Cleansing Song (12735)
SET @KOOSU        := 29034;
SET @HA_KHALAN    := 29018;
SET @ATHA         := 29033;

-- Spirit of Koosu
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@KOOSU;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@KOOSU;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@KOOSU;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@KOOSU,0,0,0,4,0,100,1,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Spirit of Koosu - Set Phase 1 - on Aggro'),
(@KOOSU,0,1,0,4,1,100,1,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Spirit of Koosu -  Stop Moving - on Aggro'),
(@KOOSU,0,2,0,4,1,100,1,0,0,0,0,11,21971,0,0,0,0,0,2,0,0,0,0,0,0,0,'Spirit of Koosu - Cast bolt - on Aggro'),
(@KOOSU,0,3,0,9,1,100,0,5,30,3500,4100,11,21971,0,0,0,0,0,2,0,0,0,0,0,0,0,'Spirit of Koosu - Cast bolt - In Range'),
(@KOOSU,0,4,0,9,1,100,0,30,100,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Spirit of Koosu -  Start Moving - When not in bolt Range'),
(@KOOSU,0,5,0,9,1,100,0,9,15,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Spirit of Koosu - Stop Moving - 15 Yards'),
(@KOOSU,0,6,0,9,1,100,0,0,5,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Spirit of Koosu - Start Moving - when not in bolt Range'),
(@KOOSU,0,7,0,9,1,100,0,5,30,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Spirit of Koosu - Stop Moving - when in bolt Range');

-- Spirit of Ha-Khalan
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@HA_KHALAN;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@HA_KHALAN;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@HA_KHALAN;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@HA_KHALAN,0,0,0,0,0,100,0,1000,1000,125000,125000,11,50502,0,0,0,0,0,1,0,0,0,0,0,0,0,'Spirit of Ha-Khalan - IC - Cast Thick Hide'),
(@HA_KHALAN,0,1,0,0,0,100,0,5000,10000,12000,16000,11,34370,0,0,0,0,0,2,0,0,0,0,0,0,0,'Spirit of Ha-Khalan - IC - Cast Jagged Tooth Snap'),
(@HA_KHALAN,0,2,0,0,0,100,0,3000,5000,7000,11000,11,48287,0,0,0,0,0,2,0,0,0,0,0,0,0,'Spirit of Ha-Khalan - IC - Cast Powerful Bite');

-- Spirit of Atha
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@ATHA;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@ATHA;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=@ATHA;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ATHA,0,0,0,0,0,100,0,8000,13000,12000,16000,11,21790,0,0,0,0,0,1,0,0,0,0,0,0,0,'Spirit of Atha - IC - Cast Aqua Jet'),
(@ATHA,0,1,0,0,0,100,0,2000,4000,5000,7000,11,3391,0,0,0,0,0,1,0,0,0,0,0,0,0,'Spirit of Atha - IC - Cast Thrash');

UPDATE `creature_template` SET `unit_flags`=`unit_flags`|8 WHERE `entry`=29018; -- Spirit of Ha-Khalan
-- Addon data for creature 29018 (Spirit of Ha-Khalan)
DELETE FROM `creature_template_addon` WHERE `entry`=29018;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(29018,0,0,1,0,''); -- Spirit of Ha-Khalan
 
 
/* 
* sql\updates\world\2013_09_04_02_world_spawns_sai.sql 
*/ 
-- Corpulen Horror spawns in area The Fleshwerks
SET @CGUID = 127272;

DELETE FROM `creature_ai_scripts` WHERE `creature_id`=30696;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=30696;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=30696;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30696,0,0,0,9,0,100,0,8,40,3500,4100,11,50335,0,0,0,0,0,2,0,0,0,0,0,0,0,'Corpulent Horror - Cast Scourge Hook - In Range');

DELETE FROM `creature_template_addon` WHERE `entry`=30696;
INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `bytes2`, `auras`) VALUES
(30696, 0, 0x0, 0x1, ''); -- Corpulent Horror

UPDATE `creature_template` SET `faction_A`=2102, `faction_H`=2102, `speed_walk`=1.142857, `speed_run`=1, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=30696; -- Corpulent Horror
DELETE FROM `creature` WHERE `id` = 30696;
INSERT INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`) VALUES 
(@CGUID+0, 30696, 571, 1, 1, 0, 0, 6975.386, 3462.006, 710.9403, 6.126106, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+1, 30696, 571, 1, 1, 0, 0, 6982.377, 3478.588, 710.9403, 5.811946, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+2, 30696, 571, 1, 1, 0, 0, 6920.697, 3446.544, 710.2005, 3.097477, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks) 
(@CGUID+3, 30696, 571, 1, 1, 0, 0, 6932.927, 3502.471, 705.0461, 3.281219, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+4, 30696, 571, 1, 1, 0, 0, 6903.668, 3478.428, 700.0414, 3.093731, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+5, 30696, 571, 1, 1, 0, 0, 6895.87, 3460.794, 700.7824, 1.592374, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks) 
(@CGUID+6, 30696, 571, 1, 1, 0, 0, 6868.874, 3435.562, 705.6059, 1.542484, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+7, 30696, 571, 1, 1, 0, 0, 6869.054, 3493.792, 695.7783, 5.440073, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+8, 30696, 571, 1, 1, 0, 0, 6875.154, 3513.065, 698.8162, 3.944444, 120, 0, 0, 0,  0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+9, 30696, 571, 1, 1, 0, 0, 6836.296, 3505.824, 690.3577, 0.5061455, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+10, 30696, 571, 1, 1, 0, 0, 6823.636, 3484.259, 688.4615, 6.278303, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+11, 30696, 571, 1, 1, 0, 0, 6729.185, 3433.822, 682.3103, 2.64319, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+12, 30696, 571, 1, 1, 0, 0, 6676.063, 3349.062, 704.616, 2.582512, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+13, 30696, 571, 1, 1, 0, 0, 6699.958, 3422.957, 679.4948, 3.363122, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+14, 30696, 571, 1, 1, 0, 0, 6548.099, 3309.558, 665.8171, 2.951326, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+15, 30696, 571, 1, 1, 0, 0, 6535.431, 3322.088, 664.9422, 5.877358, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+16, 30696, 571, 1, 1, 0, 0, 6530.748, 3296.081, 664.9409, 3.446935, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+17, 30696, 571, 1, 1, 0, 0, 6534.971, 3260.271, 666.9742, 0.2021571, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+18, 30696, 571, 1, 1, 0, 0, 6477.204, 3257.901, 643.6331, 3.804818, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+19, 30696, 571, 1, 1, 0, 0, 6488.242, 3194.719, 652.9039, 1.48353, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks)
(@CGUID+20, 30696, 571, 1, 1, 0, 0, 6412.273, 3236.912, 640.3326, 0.7460284, 120, 0, 0, 0, 0, 0, 0, 0, 0), -- Corpulent Horror (Area: The Fleshwerks
(@CGUID+21, 30696, 571, 1, 1, 0, 0, 6413.427, 3218.029, 638.4678, 0.122173, 120, 0, 0, 0, 0, 0, 0, 0, 0); -- Corpulent Horror (Area: The Fleshwerks)
 
 
/* 
* sql\updates\world\2013_09_04_03_world_isle_of_conquest.sql 
*/ 
DELETE FROM `spell_linked_spell` WHERE `spell_trigger` IN (66548,66549,66550,66551);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (66550,66551);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,66550,0,0,31,0,3,22515,0,0,0,0,'','Isle of Conquest - Teleport Fortress Out'),
(13,1,66550,0,0,35,0,1,10,1,0,0,0,'','Isle of Conquest - Teleport Fortress Out'),
(13,1,66551,0,0,31,0,3,22515,0,0,0,0,'','Isle of Conquest - Teleport Fortress In'),
(13,1,66551,0,0,35,0,1,10,1,0,0,0,'','Isle of Conquest - Teleport Fortress In');

SET @CGUID := 90179;
DELETE FROM `creature` WHERE `guid` BETWEEN @CGUID+0 AND @CGUID+13;
INSERT INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `MovementType`) VALUES
(@CGUID+0, 22515, 628, 3, 1, 392.4965, -859.4583, 48.99871, 3.036873, 7200, 0, 0), -- A IN
(@CGUID+1, 22515, 628, 3, 1, 313.2344, -918.0452, 48.85597, 4.869469, 7200, 0, 0), -- A OUT
(@CGUID+2, 22515, 628, 3, 1, 279.8698, -832.8073, 51.55094, 0, 7200, 0, 0), -- A CENTER
(@CGUID+3, 22515, 628, 3, 1, 323.4965, -883.8021, 48.99959, 1.466077, 7200, 0, 0), -- A IN
(@CGUID+4, 22515, 628, 3, 1, 430.6007, -857.0052, 48.31177, 0.1396263, 7200, 0, 0), -- A OUT
(@CGUID+5, 22515, 628, 3, 1, 325.9167, -781.8993, 49.00521, 4.590216, 7200, 0, 0), -- A IN
(@CGUID+6, 22515, 628, 3, 1, 326.2135, -744.0243, 49.43576, 1.308997, 7200, 0, 0), -- A OUT
(@CGUID+7, 22515, 628, 3, 1, 1139.498, -779.4739, 48.73496, 3.001966, 7200, 0, 0), -- H OUT
(@CGUID+8, 22515, 628, 3, 1, 1162.913, -745.908, 48.71506, 0.1396263, 7200, 0, 0), -- H IN
(@CGUID+9, 22515, 628, 3, 1, 1234.304, -688.2986, 49.22296, 4.677482, 7200, 0, 0), -- H IN
(@CGUID+10, 22515, 628, 3, 1, 1232.524, -666.3246, 48.13402, 2.303835, 7200, 0, 0), -- H OUT
(@CGUID+11, 22515, 628, 3, 1, 1233.106, -838.316, 48.99958, 1.466077, 7200, 0, 0), -- H IN
(@CGUID+12, 22515, 628, 3, 1, 1232.387, -861.0243, 48.99959, 3.560472, 7200, 0, 0), -- H OUT
(@CGUID+13, 22515, 628, 3, 1, 1296.526, -766.1823, 50.70293, 3.089233, 7200, 0, 0); -- H CENTER
 
 
/* 
* sql\updates\world\2013_09_06_00_world_misc.sql 
*/ 
-- Fix few startup errors
UPDATE `smart_scripts` SET `event_param3`=12555 WHERE `entryorguid`=27727 AND `source_type`=0 AND `id`=2 AND `link`=0;
DELETE FROM `creature_addon` WHERE `guid`=66177;
DELETE FROM `waypoint_data` WHERE `id`=661770;
 
 
/* 
* sql\updates\world\2013_09_06_01_world_misc.sql 
*/ 
DELETE FROM `smart_scripts` WHERE `entryorguid`=28481 AND `source_type`=0;
UPDATE `creature_template` SET `AIName`='' WHERE `entry`=28481;

DELETE FROM `spell_script_names` WHERE `spell_id` IN (51769,51770,58941);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES 
(51769,'spell_q12619_emblazon_runeblade'),
(51770,'spell_q12619_emblazon_runeblade_effect'),
(58941,'spell_archavon_rock_shards');

DELETE FROM `spelldifficulty_dbc` WHERE `id` IN (58695,58696);
INSERT INTO `spelldifficulty_dbc`(`id`,`spellid0`,`spellid1`) VALUES 
(58695,58695,60883),
(58696,58696,60884);
 
 
/* 
* sql\updates\world\2013_09_06_02_world_misc.sql 
*/ 
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=28481;
DELETE FROM `smart_scripts` WHERE `entryorguid`=28481 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(28481, 0, 0, 0, 8, 0, 100, 0, 51769, 0, 0, 0, 11, 51738, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Runeforge (SE) - On Spellhit Emblazon Runeblade - Cast Shadow Storm');
 
 
/* 
* sql\updates\world\2013_09_07_00_world_updates.sql 
*/ 
-- Scourge Tactics
UPDATE `smart_scripts` SET `link`=1 WHERE `entryorguid`=30273 AND `id`=0;
UPDATE `smart_scripts` SET `event_type`=61 WHERE `entryorguid`=30273 AND `id`=1;
-- Abjurist Belmara & Conjurer Luminrath 
UPDATE `smart_scripts` SET `target_type`=7 WHERE `entryorguid`=19546 AND `id`=2;
UPDATE `smart_scripts` SET `target_type`=7, `target_param1`=0 WHERE `entryorguid`=19580 AND `id`=2;
 
 
/* 
* sql\updates\world\2013_09_07_01_world_sai.sql 
*/ 
-- Do not delete query id 0
DELETE FROM `smart_scripts` WHERE `entryorguid` =21797 AND `source_type`=0 AND `id`>0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(21797, 0, 1, 0, 19, 0, 100, 0, 10645, 0, 0, 0, 80, 2179700, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Ancient Shadowmoon Spirit - On Quest Accept - Run Script');
 
 
/* 
* sql\updates\world\2013_09_08_00_world_sai.sql 
*/ 
-- Trapping the Light Fantastic (10674) & Gather the Orbs (10859)
SET @GOB_TRAP           := 185011;	-- Multi-Spectrum Light Trap
SET @NPC_BUNNY          := 21926;   -- Multi-Spectrum Light Trap Bunny
SET @ORB_TOTEM          := 22333;   -- Orb Collecting Totem
SET @NPC_CREDIT         := 21929;   -- Trapping the Light Kill Credit Trigger
SET @NPC_ORB1           := 20635;   -- Razaani Light Orb
SET @NPC_ORB2           := 20771;   -- Razaani Light Orb - Mini
SET @SPELL_PULL         := 28337;   -- Magnetic Pull
SET @ARC_EXPLOSION      := 35426;   -- Arcane Explosion

DELETE FROM `creature_template_addon` WHERE `entry` IN (@NPC_ORB1,@NPC_ORB2);
INSERT INTO `creature_template_addon` (`entry`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(20635,0,0,0,4097,0,'32566'),
(20771,0,0,0,4097,0,'32566');

UPDATE `creature_template` SET `AIName`='SmartAI',`unit_flags`=unit_flags|0x02000000,`flags_extra`=130,`ScriptName`='' WHERE `entry` IN (@NPC_ORB1,@NPC_ORB2);
DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (@NPC_ORB1,@NPC_ORB2);
UPDATE `creature` SET `MovementType`=0 WHERE `id`=@NPC_ORB1;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_ORB1,@NPC_ORB1*100,@NPC_ORB1*101,@NPC_ORB2,@NPC_ORB2*100,@NPC_ORB2*101) AND `source_type` IN (0,9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- Alliance Version
(@NPC_ORB1,0,0,0,8,0,100,0,@SPELL_PULL,0,0,0,80,@NPC_ORB1*100,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Orb Bunny - On Spellhit - Start Action Script'),
(@NPC_ORB1*100,9,0,0,0,0,100,0,1000,1000,0,0,11,@ARC_EXPLOSION,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Orb Bunny - On Script - Cast Arcane Explosion'),
(@NPC_ORB1*100,9,1,0,0,0,100,0,500,500,0,0,45,1,1,0,0,0,0,19,@NPC_BUNNY,5,0,0,0,0,0, 'Orb Bunny - On Script - Cast Arcane Explosion'),
(@NPC_ORB1*100,9,2,0,0,0,100,0,0,0,0,0,41,100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Orb Bunny - On Script - Despawn'),
-- Horde Version
(@NPC_ORB1,0,1,0,38,0,100,0,0,1,30000,30000,69,1,0,0,0,0,0,19,@ORB_TOTEM,20,0,0,0,0,0, 'Light Orb - On Data Set 0 1 - Move to totem'),
(@NPC_ORB1,0,2,3,34,0,100,1,8,1,0,0,11,@ARC_EXPLOSION,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Light Orb - On point 1 reached - Cast arcane explosion'),
(@NPC_ORB1,0,3,4,61,0,100,0,0,0,0,0,33,@NPC_CREDIT,0,0,0,0,0,12,1,0,0,0,0,0,0, 'Light Orb - On Link - Call kill credit'),
(@NPC_ORB1,0,4,0,61,0,100,0,0,0,0,0,80,@NPC_ORB1*101,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Light Orb - On Link - Start action list to display arcase explosion'),
(@NPC_ORB1*101,9,0,0,0,0,100,0,0,0,0,0,47,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Light Orb - Action 0 - Set unseen'),
(@NPC_ORB1*101,9,1,0,0,0,100,0,0,0,0,0,41,100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Light Orb - Action 1 - Despawn in 100 ms'),
-- Alliance Version
(@NPC_ORB2,0,0,0,8,0,100,0,@SPELL_PULL,0,0,0,80,@NPC_ORB2*100,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Orb Bunny - On Spellhit - Start Action Script'),
(@NPC_ORB2*100,9,0,0,0,0,100,0,1000,1000,0,0,11,@ARC_EXPLOSION,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Orb Bunny - On Script - Cast Arcane Explosion'),
(@NPC_ORB2*100,9,1,0,0,0,100,0,500,500,0,0,45,1,1,0,0,0,0,19,@NPC_BUNNY,5,0,0,0,0,0, 'Orb Bunny - On Script - Cast Arcane Explosion'),
(@NPC_ORB2*100,9,2,0,0,0,100,0,0,0,0,0,41,100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Orb Bunny - On Script - Despawn'),
-- Horde Version
(@NPC_ORB2,0,1,0,38,0,100,0,1,1,30000,30000,69,1,0,0,0,0,0,19,@ORB_TOTEM,20,0,0,0,0,0, 'Light Orb - On Data Set 0 1 - Move to totem'),
(@NPC_ORB2,0,2,3,34,0,100,1,8,1,0,0,11,@ARC_EXPLOSION,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Light Orb - On point 1 reached - Cast arcane explosion'),
(@NPC_ORB2,0,3,4,61,0,100,0,0,0,0,0,33,@NPC_CREDIT,0,0,0,0,0,12,1,0,0,0,0,0,0, 'Light Orb - On Link - Call kill credit'),
(@NPC_ORB2,0,4,0,61,0,100,0,0,0,0,0,80,@NPC_ORB2*101,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Light Orb - On Link - Start action list to display arcase explosion'),
(@NPC_ORB2*101,9,0,0,0,0,100,0,0,0,0,0,47,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Light Orb - Action 0 - Set unseen'),
(@NPC_ORB2*101,9,1,0,0,0,100,0,0,0,0,0,41,100,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Light Orb - Action 1 - Despawn in 100 ms');

-- Alliance Multi-Spectrum Light Trap
UPDATE `creature_template` SET `AIName`='SmartAI',`flags_extra`=130,`ScriptName`='' WHERE `entry`=@NPC_BUNNY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_BUNNY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_BUNNY,0,0,0,54,0,100,1,0,0,0,0,50,@GOB_TRAP,30000,0,0,0,0,1,0,0,0,0,0,0,0, 'Multi-Spectrum Light Trap - On spawn - Summon gob'),
(@NPC_BUNNY,0,1,0,1,0,100,1,0,0,0,0,9,0,0,0,0,0,0,15,@GOB_TRAP,0,0,0,0,0,0, 'Multi-Spectrum Light Trap - OOC - Activate gob'),
--
(@NPC_BUNNY,0,2,0,1,0,100,1,3000,3000,3000,3000,11,@SPELL_PULL,0,0,0,0,0,19,@NPC_ORB1,20,0,0,0,0,0, 'Multi-Spectrum Light Trap - OOC 3 sec - Pull Razaani Light Orb'),
(@NPC_BUNNY,0,3,0,1,0,100,1,3000,3000,3000,3000,11,@SPELL_PULL,0,0,0,0,0,19,@NPC_ORB2,20,0,0,0,0,0, 'Multi-Spectrum Light Trap - OOC 3 sec - Pull Razaani Light Orb - Mini'),
(@NPC_BUNNY,0,4,5,38,0,100,1,1,1,0,0,33,@NPC_CREDIT,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Multi-Spectrum Light Trap - On Data Set - Give Quest Credit'),
(@NPC_BUNNY,0,5,0,61,0,100,1,0,0,0,0,9,0,0,0,0,0,0,15,@GOB_TRAP,0,0,0,0,0,0, 'Link - Activate gob - Gob');

-- Horde Totem
UPDATE `creature_template` SET `AIName`='SmartAI',`flags_extra`=0,`ScriptName`='' WHERE `entry`=@ORB_TOTEM;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ORB_TOTEM;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ORB_TOTEM,0,0,1,54,0,100,0,0,0,0,0,45,0,1,0,0,0,0,19,@NPC_ORB1,20,0,0,0,0,0, 'Orb collecting totem - On spawned - Set Data 0 1'),
(@ORB_TOTEM,0,1,2,61,0,100,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Orb collecting totem - On Link - Store invoker'),
(@ORB_TOTEM,0,2,0,61,0,100,0,0,0,0,0,100,1,0,0,0,0,0,19,@NPC_ORB1,20,0,0,0,0,0, 'Orb collecting totem - On Link - Send stored target list 1'),
--
(@ORB_TOTEM,0,3,4,54,0,100,0,0,0,0,0,45,1,1,0,0,0,0,19,@NPC_ORB2,20,0,0,0,0,0, 'Orb collecting totem - On spawned - Set Data 0 1'),
(@ORB_TOTEM,0,4,5,61,0,100,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Orb collecting totem - On Link - Store invoker'),
(@ORB_TOTEM,0,5,0,61,0,100,0,0,0,0,0,100,1,0,0,0,0,0,19,@NPC_ORB2,20,0,0,0,0,0, 'Orb collecting totem - On Link - Send stored target list 1');
 
 
/* 
* sql\updates\world\2013_09_08_01_world_update.sql 
*/ 
-- -.- >.> <.< -_- ._. 
UPDATE `creature` SET `spawndist`=0 WHERE`id`=20635;
 
 
/* 
* sql\updates\world\2013_09_09_00_world_sai.sql 
*/ 
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN (30135,30144,29974);
DELETE FROM `smart_scripts` WHERE entryorguid IN (30135,30144,29974);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES 
-- Niffelem Forefather
(29974, 0, 0, 0, 0, 0, 100, 0, 1000, 5000, 8000, 13000, 11, 57454, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Niffelem Forefather - IC - Cast Ice Spike'),
(29974, 0, 1, 2, 8, 0, 100, 0, 55983, 0, 0, 0, 33, 30138, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Niffelem Forefather - On Spellhit - Give Kill Credit'),
(29974, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Niffelem Forefather - Linked with Previous Event Despawn'),
-- Restless Frostborn Warrior
(30135, 0, 0, 0, 0, 0, 100, 0, 1000, 5000, 8000, 13000, 11, 57456, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Restless Frostborn Warrior - IC - Cast Frostbite'),
(30135, 0, 1, 2, 8, 0, 100, 0, 55983, 0, 0, 0, 33, 30139, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Restless Frostborn Warrior - On Spellhit - Give Kill Credit'),
(30135, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Restless Frostborn Warrior - Linked with Previous Event Despawn'),
-- Restless Frostborn Ghost
(30144, 0, 0, 0, 0, 0, 100, 0, 1000, 5000, 8000, 13000, 11, 57456, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Restless Frostborn Ghost - IC - Cast Frostbite'),
(30144, 0, 1, 2, 8, 0, 100, 0, 55983, 0, 0, 0, 33, 30139, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Restless Frostborn Ghost - On Spellhit - Give Kill Credit'),
(30144, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Restless Frostborn Ghost - Linked with Previous Event Despawn');
 
 
/* 
* sql\updates\world\2013_09_10_00_world_conditions.sql 
*/ 
DELETE FROM `conditions` WHERE `SourceEntry` = 55983;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(17, 0, 55983, 0, 0, 31, 1, 3, 29974, 0, 0, 0, 0, '', 'Blow Hodir''s Horn can hit Niffelem Forefather'),
(17, 0, 55983, 0, 0, 36, 1, 0, 0, 0, 1, 0, 0, '', 'Blow Hodir''s Horn can only hit dead Niffelem Forefather'),
(17, 0, 55983, 0, 1, 31, 1, 3, 30144, 0, 0, 0, 0, '', 'Blow Hodir''s Horn can hit Restless Frostborn Ghost'),
(17, 0, 55983, 0, 1, 36, 1, 0, 0, 0, 1, 0, 0, '', 'Blow Hodir''s Horn can only hit dead Restless Frostborn Ghost'),
(17, 0, 55983, 0, 2, 31, 1, 3, 30135, 0, 0, 0, 0, '', 'Blow Hodir''s Horn can hit Restless Frostborn Warrior'),
(17, 0, 55983, 0, 2, 36, 1, 0, 0, 0, 1, 0, 0, '', 'Blow Hodir''s Horn can only hit dead Restless Frostborn Warrior');
 
 
/* 
* sql\updates\world\2013_09_10_01_world_command.sql 
*/ 
/* cs_group.cpp */

SET @id = 472;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0  WHERE `name` = 'group';
UPDATE `command` SET `permission` = @id+1  WHERE `name` = 'group leader';
UPDATE `command` SET `permission` = @id+2  WHERE `name` = 'group disband';
UPDATE `command` SET `permission` = @id+3  WHERE `name` = 'group remove';
UPDATE `command` SET `permission` = @id+4  WHERE `name` = 'group join';
UPDATE `command` SET `permission` = @id+5  WHERE `name` = 'group list';

UPDATE `command` SET `permission` = @id+6, `name` = 'group summon', `help` =
'Syntax: .group summon [$charactername]\r\n\r\nTeleport the given character and his group to you. Teleported only online characters but original selected group member can be offline.'
WHERE `name` = 'groupsummon';
 
 
/* 
* sql\updates\world\2013_09_10_02_world_command.sql 
*/ 
/* cs_pet.cpp */

SET @id = 479;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0  WHERE `name` = 'pet';
UPDATE `command` SET `permission` = @id+1  WHERE `name` = 'pet create';
UPDATE `command` SET `permission` = @id+2  WHERE `name` = 'pet learn';
UPDATE `command` SET `permission` = @id+3  WHERE `name` = 'pet unlearn';
 
 
/* 
* sql\updates\world\2013_09_10_03_world_sai.sql 
*/ 
-- Test Flight Quests
-- 10557 - The Zephyrium Capacitorium(part 1)
-- 10710 - The Singing Ridge(part 2)
-- 10711 - Razaan's Landing
-- 10712 - Ruuan Weald
SET @ENTRY              := 21461; -- Rally Zapnabber
SET @ENTRY2             := 21393; -- Cannon Channeler Dummy npc
SET @BEAM               := 36795; -- Cannon Channel(dnd) - Visual cannon beam
SET @MENUID             := 8304;  -- Gossip
SET @A_MENU             := 8454;  -- Action Gossip
SET @A_MENU2            := 8455;  -- Action Gossip 2
SET @OPTION             := 0;
SET @SPEACH             := 10360; -- Text 1
SET @SPEACH2            := 10561; -- Text 2

-- Disable obsolete quest
DELETE FROM `disables` WHERE `entry`=10716;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(1,10716,0,'','','Deprecated quest Test Flight: Raven''s Wood');
-- Make Canon Channeler float & Update position to match cannon
UPDATE `creature_template` SET `InhabitType`=4, `modelid1`= 11686 ,`modelid2`=0 WHERE `entry`=@ENTRY2;
UPDATE `creature` SET `position_x`=1924.6457, `position_y`= 5575.660, `position_z`=272.1429 WHERE  `guid`=74872;-- Gossip & menus  1924.1457, 5575.647, 272.1429

UPDATE `creature_template` SET `gossip_menu_id`=@MENUID, `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY2;
DELETE FROM `gossip_menu` WHERE `entry` IN (@MENUID,@A_MENU);
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(@MENUID,@SPEACH),
(@A_MENU,@SPEACH2);

DELETE FROM `gossip_menu_option` WHERE `menu_id` IN (@MENUID,@A_MENU2,@A_MENU);
INSERT INTO `gossip_menu_option` (`menu_id`, `id`, `option_icon`, `option_text`, `option_id`, `npc_option_npcflag`, `action_menu_id`, `action_poi_id`, `box_coded`, `box_money`, `box_text`) VALUES
(@MENUID,@OPTION+0,0,'I''m ready for my test flight!',1,1,0,0,0,0,''), -- Test Flight: The Zephyrium Capacitorium
(@MENUID,@OPTION+1,0,'Take me to Singing Ridge!',1,1,@A_MENU,0,0,0,''), -- Test Flight: The Singing Ridge
(@MENUID,@OPTION+2,0,'Take me to Razaan''s Landing!',1,1,0,0,0,0,''), -- Test Flight: Razaan's Landing
(@MENUID,@OPTION+3,0,'Take me to Ruuan Weald!',1,1,0,0,0,0,''), -- Test Flight: Ruuan Weald
(@MENUID,@OPTION+4,0,'I want to fly to an old location!',1,1,@A_MENU2,0,0,0,''), -- Old locations from completed quests
(@A_MENU2,@OPTION+1,0,'Take me to Singing Ridge.',1,1,0,0,0,0,''),
(@A_MENU2,@OPTION+2,0,'Take me to Razaan''s Landing.',1,1,0,0,0,0,''),
(@A_MENU2,@OPTION+3,0,'Take me to Ruuan Weald.',1,1,0,0,0,0,''),
(@A_MENU,@OPTION+0,0,'I have the signed Waiver! Fire me into The Singing Ridge!',1,1,0,0,0,0,'');

-- Fix teleport spell position
DELETE FROM `spell_target_position` WHERE `Id` IN(37908,24831);
INSERT INTO `spell_target_position` (`id`, `effIndex`, `target_map`, `target_position_x`, `target_position_y`, `target_position_z`, `target_orientation`) VALUES 
(24831, 0, 530, 1920.07, 5582.04, 269.222, 5.1846);

DELETE FROM `spell_linked_spell` WHERE `spell_trigger`= 37908;
INSERT INTO `spell_linked_spell` (`spell_trigger`, `spell_effect`, `type`, `comment`) VALUES 
(37908, 24831, 0, 'Aura Visual Teleport - teleport');

-- SAI
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@ENTRY,@ENTRY*100,@ENTRY*101,@ENTRY*102,@ENTRY*103,@ENTRY2);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@MENUID,@OPTION+0,0,0,80,@ENTRY*100,0,0,0,0,0,1,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Run script'),
(@ENTRY,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Close gossip'),
(@ENTRY,0,2,3,62,0,100,0,@A_MENU,@OPTION+0,0,0,80,@ENTRY*101,0,0,0,0,0,1,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Run script'),
(@ENTRY,0,3,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Close gossip'),
(@ENTRY,0,4,5,62,0,100,0,@MENUID,@OPTION+2,0,0,80,@ENTRY*102,0,0,0,0,0,1,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Run script'),
(@ENTRY,0,5,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Close gossip'),
(@ENTRY,0,6,7,62,0,100,0,@MENUID,@OPTION+3,0,0,80,@ENTRY*103,0,0,0,0,0,1,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Run script'),
(@ENTRY,0,7,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Close gossip'),

(@ENTRY,0,8,9,62,0,100,0,@A_MENU2,@OPTION+1,0,0,80,@ENTRY*101,0,0,0,0,0,1,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Run script'),
(@ENTRY,0,9,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Close gossip'),
(@ENTRY,0,10,11,62,0,100,0,@A_MENU2,@OPTION+2,0,0,80,@ENTRY*102,0,0,0,0,0,1,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Run script'),
(@ENTRY,0,11,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Close gossip'),
(@ENTRY,0,12,13,62,0,100,0,@A_MENU2,@OPTION+3,0,0,80,@ENTRY*103,0,0,0,0,0,1,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Run script'),
(@ENTRY,0,13,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Close gossip'),
--
(@ENTRY*100,9,0,0,1,0,100,0,2000,2000,2000,2000,85,37908,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Zephyrium Capacitorium - After 2 seconds - Port visual'),
(@ENTRY*100,9,1,0,1,0,100,0,2000,2000,2000,2000,45,1,1,0,0,0,0,10,74872,@ENTRY2,0,0,0,0,0,'The Zephyrium Capacitorium - After 2 seconds - Port visual'),
(@ENTRY*100,9,2,0,1,0,100,0,3000,3000,3000,3000,85,36790,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Zephyrium Capacitorium - OOC Update - Invoker,cast charge state 2'),
(@ENTRY*100,9,3,0,1,0,100,0,3000,3000,3000,3000,85,36792,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Zephyrium Capacitorium - OOC Update - Invoker,cast charge state 3'),
(@ENTRY*100,9,4,0,1,0,100,0,3000,3000,3000,3000,85,36800,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Zephyrium Capacitorium - OOC Update - Invoker,cast charge state 4'),
(@ENTRY*100,9,5,0,1,0,100,0,3000,3000,3000,3000,85,37910,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Zephyrium Capacitorium - OOC Update - Invoker,cast Soar&Credit'),
(@ENTRY*100,9,6,0,1,0,100,0,0,0,0,0,85,37108,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Zephyrium Capacitorium - OOC Update - Invoker,cast Debuff'),
--
(@ENTRY*101,9,0,0,1,0,100,0,2000,2000,2000,2000,85,37908,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Singing Ridge - After 2 seconds - Port visual'),
(@ENTRY*101,9,1,0,1,0,100,0,2000,2000,2000,2000,45,1,1,0,0,0,0,10,74872,@ENTRY2,0,0,0,0,0,'The Zephyrium Capacitorium - After 2 seconds - Set Data on Channeler'),
(@ENTRY*101,9,2,0,1,0,100,0,3000,3000,3000,3000,85,36790,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Singing Ridge - OOC Update - Invoker,cast charge state 2'),
(@ENTRY*101,9,3,0,1,0,100,0,3000,3000,3000,3000,85,36792,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Singing Ridge - OOC Update - Invoker,cast charge state 3'),
(@ENTRY*101,9,4,0,1,0,100,0,3000,3000,3000,3000,85,36800,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Singing Ridge - OOC Update - Invoker,cast charge state 4'),
(@ENTRY*101,9,5,0,1,0,100,0,3000,3000,3000,3000,85,37962,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Singing Ridge - OOC Update - Invoker,cast Soar&Credit'),
(@ENTRY*101,9,6,0,1,0,100,0,0,0,0,0,85,37108,0,0,0,0,0,7,0,0,0,0,0,0,0,'The Singing Ridge - OOC Update - Invoker,cast Debuff'),
--
(@ENTRY*102,9,0,0,1,0,100,0,2000,2000,2000,2000,85,37908,0,0,0,0,0,7,0,0,0,0,0,0,0,'Razaan''s Landing - After 2 seconds - Port visual'),
(@ENTRY*102,9,1,0,1,0,100,0,2000,2000,2000,2000,45,1,1,0,0,0,0,10,74872,@ENTRY2,0,0,0,0,0,'The Zephyrium Capacitorium - After 2 seconds - Set Data on Channeler'),
(@ENTRY*102,9,2,0,1,0,100,0,3000,3000,3000,3000,85,36790,0,0,0,0,0,7,0,0,0,0,0,0,0,'Razaan''s Landing - OOC Update - Invoker,cast charge state 2'),
(@ENTRY*102,9,3,0,1,0,100,0,3000,3000,3000,3000,85,36792,0,0,0,0,0,7,0,0,0,0,0,0,0,'Razaan''s Landing - OOC Update - Invoker,cast charge state 3'),
(@ENTRY*102,9,4,0,1,0,100,0,3000,3000,3000,3000,85,36800,0,0,0,0,0,7,0,0,0,0,0,0,0,'Razaan''s Landing - OOC Update - Invoker,cast charge state 4'),
(@ENTRY*102,9,5,0,1,0,100,0,3000,3000,3000,3000,85,36812,0,0,0,0,0,7,0,0,0,0,0,0,0,'Razaan''s Landing - OOC Update - Invoker,cast Soar&Credit'),
(@ENTRY*102,9,6,0,1,0,100,0,0,0,0,0,85,37108,0,0,0,0,0,7,0,0,0,0,0,0,0,'Razaan''s Landing - OOC Update - Invoker,cast Debuff'),
--
(@ENTRY*103,9,0,0,1,0,100,0,2000,2000,2000,2000,85,37908,0,0,0,0,0,7,0,0,0,0,0,0,0,'Ruuan Weald - After 2 seconds - Port visual'),
(@ENTRY*103,9,1,0,1,0,100,0,2000,2000,2000,2000,45,1,1,0,0,0,0,10,74872,@ENTRY2,0,0,0,0,0,'The Zephyrium Capacitorium - After 2 seconds - Set Data on Channeler'),
(@ENTRY*103,9,2,0,1,0,100,0,3000,3000,3000,3000,85,36790,0,0,0,0,0,7,0,0,0,0,0,0,0,'Ruuan Weald - OOC Update - Invoker,cast charge state 2'),
(@ENTRY*103,9,3,0,1,0,100,0,3000,3000,3000,3000,85,36792,0,0,0,0,0,7,0,0,0,0,0,0,0,'Ruuan Weald - OOC Update - Invoker,cast charge state 3'),
(@ENTRY*103,9,4,0,1,0,100,0,3000,3000,3000,3000,85,36800,0,0,0,0,0,7,0,0,0,0,0,0,0,'Ruuan Weald - OOC Update - Invoker,cast charge state 4'),
(@ENTRY*103,9,5,0,1,0,100,0,3000,3000,3000,3000,85,37968,0,0,0,0,0,7,0,0,0,0,0,0,0,'Ruuan Weald - OOC Update - Invoker,cast Soar&Credit'),
(@ENTRY*103,9,6,0,1,0,100,0,0,0,0,0,85,37108,0,0,0,0,0,7,0,0,0,0,0,0,0,'Ruuan Weald - OOC Update - Invoker,cast Debuff'),
--
(@ENTRY2,0,0,0,38,0,100,0,1,1,0,0,11,36795,0,0,0,0,0,1,0,0,0,0,0,0,0,'Beam Channel Bunny - On Data Set - Cast Cannon Beam');

DELETE FROM `conditions` WHERE `SourceEntry`=@BEAM OR `SourceGroup` IN (@MENUID,@A_MENU2,@A_MENU);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(15, @A_MENU2, 3, 0, 0, 1, 0, 37108, 0, 0, 1, 0, 0, '', 'Show gossip option 3 if player does not have aura Zephyrium Charged'),
(15, @A_MENU2, 3, 0, 0, 8, 0, 10712, 0, 0, 0, 0, 0, '', 'Show gossip option 3 if player has quest Ruuan Weald marked as rewarded'),
(15, @A_MENU2, 2, 0, 0, 8, 0, 10711, 0, 0, 0, 0, 0, '', 'Show gossip option 2 if player has quest Razaan''s Landing marked as rewarded'),
(15, @A_MENU2, 2, 0, 0, 1, 0, 37108, 0, 0, 1, 0, 0, '', 'Show gossip option 2 if player does not have aura Zephyrium Charged'),
(15, @A_MENU2, 1, 0, 0, 1, 0, 37108, 0, 0, 1, 0, 0, '', 'Show gossip option 1 if player does not have aura Zephyrium Charged'),
(15, @A_MENU2, 1, 0, 0, 8, 0, 10710, 0, 0, 0, 0, 0, '', 'Show gossip option 1 if player has quest The Singing Ridge marked as rewarded'),
(15, @A_MENU2, 4, 0, 0, 8, 0, 10557, 0, 0, 0, 0, 0, '', 'Show gossip option 4 if player has quest The Zephyrium Capacitorium marked as rewarded'),
(15, @A_MENU, 0, 0, 0, 2, 0, 30539, 1, 0, 0, 0, 0, '', 'Show gossip option 0 if player has item Tally''s Waiver (Signed)'),
(15, @MENUID, 3, 0, 0, 9, 0, 10712, 0, 0, 0, 0, 0, '', 'Show gossip option 3 if player has quest Ruuan Weald marked as taken'),
(15, @MENUID, 3, 0, 0, 1, 0, 37108, 0, 0, 1, 0, 0, '', 'Show gossip option 3 if player does not have aura Zephyrium Charged'),
(15, @MENUID, 2, 0, 0, 9, 0, 10711, 0, 0, 0, 0, 0, '', 'Show gossip option 2 if player has quest Razaan''s Landing marked as taken'),
(15, @MENUID, 2, 0, 0, 1, 0, 37108, 0, 0, 1, 0, 0, '', 'Show gossip option 2 if player does not have aura Zephyrium Charged'),
(15, @MENUID, 1, 0, 0, 9, 0, 10710, 0, 0, 0, 0, 0, '', 'Show gossip option 1 if player has quest The Singing Ridge marked as taken'),
(15, @MENUID, 1, 0, 0, 1, 0, 37108, 0, 0, 1, 0, 0, '', 'Show gossip option 1 if player does not have aura Zephyrium Charged'),
(15, @MENUID, 0, 0, 0, 9, 0, 10557, 0, 0, 0, 0, 0, '', 'Show gossip option 0 if player has quest The Zephyrium Capacitorium marked as taken'),
(15, @MENUID, 0, 0, 0, 1, 0, 37108, 0, 0, 1, 0, 0, '', 'Show gossip option 0 if player does not have aura Zephyrium Charged'),
--
(13, 1, 36795, 0, 0, 31, 0, 4, 0, 0, 0, 0, 0, '', 'Spell Cannon Channel(dnd) target player');

-- SAI for Rally (Questgiver)
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=21460;
DELETE FROM `smart_scripts` WHERE `entryorguid`=21460;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(21460,0,0,1,62,0,100,0,8303,0,0,0,56,30540,1,0,0,0,0,7,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Give Item '),
(21460,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Rally Zapnabber - On gossip option select - Close gossip');

DELETE FROM `conditions` WHERE `SourceGroup` = 8303;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(15, 8303, 0, 0, 0, 2, 0, 30540, 1, 1, 1, 0, 0, '', 'Only allow gossip option to be visible if player doesn''t have item'),
(15, 8303, 0, 0, 0, 9, 0, 10710, 0, 0, 0, 0, 0, '', 'Only allow gossip option to be visible if player has quest taken');
 
 
/* 
* sql\updates\world\2013_09_10_04_world_command.sql 
*/ 
/* cs_send.cpp */

SET @id = 483;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0  WHERE `name` = 'send';
UPDATE `command` SET `permission` = @id+1  WHERE `name` = 'send items';
UPDATE `command` SET `permission` = @id+2  WHERE `name` = 'send mail';
UPDATE `command` SET `permission` = @id+3  WHERE `name` = 'send message';
UPDATE `command` SET `permission` = @id+4  WHERE `name` = 'send money';
 
 
/* 
* sql\updates\world\2013_09_10_05_world_command.sql 
*/ 
/* cs_misc.cpp */

SET @id = 488;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'additem';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'additemset';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'appear';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'aura';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'bank';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'bindsight';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'combatstop';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'cometome';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'commands';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'cooldown';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'damage';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'dev';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'die';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'dismount';
UPDATE `command` SET `permission` = @id+14 WHERE `name` = 'distance';
UPDATE `command` SET `permission` = @id+15 WHERE `name` = 'flusharenapoints';
UPDATE `command` SET `permission` = @id+16 WHERE `name` = 'freeze';
UPDATE `command` SET `permission` = @id+17 WHERE `name` = 'gps';
UPDATE `command` SET `permission` = @id+18 WHERE `name` = 'guid';
UPDATE `command` SET `permission` = @id+19 WHERE `name` = 'help';
UPDATE `command` SET `permission` = @id+20 WHERE `name` = 'hidearea';
UPDATE `command` SET `permission` = @id+21 WHERE `name` = 'itemmove';
UPDATE `command` SET `permission` = @id+22 WHERE `name` = 'kick';
UPDATE `command` SET `permission` = @id+23 WHERE `name` = 'linkgrave';
UPDATE `command` SET `permission` = @id+24 WHERE `name` = 'listfreeze';
UPDATE `command` SET `permission` = @id+25 WHERE `name` = 'maxskill';
UPDATE `command` SET `permission` = @id+26 WHERE `name` = 'movegens';
UPDATE `command` SET `permission` = @id+27 WHERE `name` = 'mute';
UPDATE `command` SET `permission` = @id+28 WHERE `name` = 'neargrave';
UPDATE `command` SET `permission` = @id+29 WHERE `name` = 'pinfo';
UPDATE `command` SET `permission` = @id+30 WHERE `name` = 'playall';
UPDATE `command` SET `permission` = @id+31 WHERE `name` = 'possess';
UPDATE `command` SET `permission` = @id+32 WHERE `name` = 'recall';
UPDATE `command` SET `permission` = @id+33 WHERE `name` = 'repairitems';
UPDATE `command` SET `permission` = @id+34 WHERE `name` = 'respawn';
UPDATE `command` SET `permission` = @id+35 WHERE `name` = 'revive';
UPDATE `command` SET `permission` = @id+36 WHERE `name` = 'saveall';
UPDATE `command` SET `permission` = @id+37 WHERE `name` = 'save';
UPDATE `command` SET `permission` = @id+38 WHERE `name` = 'setskill';
UPDATE `command` SET `permission` = @id+39 WHERE `name` = 'showarea';
UPDATE `command` SET `permission` = @id+40 WHERE `name` = 'summon';
UPDATE `command` SET `permission` = @id+41 WHERE `name` = 'unaura';
UPDATE `command` SET `permission` = @id+42 WHERE `name` = 'unbindsight';
UPDATE `command` SET `permission` = @id+43 WHERE `name` = 'unfreeze';
UPDATE `command` SET `permission` = @id+44 WHERE `name` = 'unmute';
UPDATE `command` SET `permission` = @id+45 WHERE `name` = 'unpossess';
UPDATE `command` SET `permission` = @id+46 WHERE `name` = 'unstuck';
UPDATE `command` SET `permission` = @id+47 WHERE `name` = 'wchange';
 
 
/* 
* sql\updates\world\2013_09_10_06_world_command.sql 
*/ 
/* cs_mmaps.cpp */

SET @id = 536;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'mmap';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'mmap loadedtiles';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'mmap loc';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'mmap path';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'mmap stats';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'mmap testarea';
 
 
/* 
* sql\updates\world\2013_09_10_07_world_command.sql 
*/ 
/* cs_modify.cpp */

SET @id = 542;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'morph';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'demorph';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'modify';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'modify arenapoints';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'modify bit';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'modify drunk';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'modify energy';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'modify faction';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'modify gender';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'modify honor';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'modify hp';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'modify mana';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'modify money';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'modify mount';
UPDATE `command` SET `permission` = @id+14 WHERE `name` = 'modify phase';
UPDATE `command` SET `permission` = @id+15 WHERE `name` = 'modify rage';
UPDATE `command` SET `permission` = @id+16 WHERE `name` = 'modify reputation';
UPDATE `command` SET `permission` = @id+17 WHERE `name` = 'modify runicpower';
UPDATE `command` SET `permission` = @id+18 WHERE `name` = 'modify scale';
UPDATE `command` SET `permission` = @id+19 WHERE `name` = 'modify speed';
UPDATE `command` SET `permission` = @id+20 WHERE `name` = 'modify speed all';
UPDATE `command` SET `permission` = @id+21 WHERE `name` = 'modify speed backwalk';
UPDATE `command` SET `permission` = @id+22 WHERE `name` = 'modify speed fly';
UPDATE `command` SET `permission` = @id+23 WHERE `name` = 'modify speed walk';
UPDATE `command` SET `permission` = @id+24 WHERE `name` = 'modify speed swim';
UPDATE `command` SET `permission` = @id+25 WHERE `name` = 'modify spell';
UPDATE `command` SET `permission` = @id+26 WHERE `name` = 'modify standstate';
UPDATE `command` SET `permission` = @id+27 WHERE `name` = 'modify talentpoints';
 
 
/* 
* sql\updates\world\2013_09_10_08_world_command.sql 
*/ 
/* cs_npc.cpp */

SET @id = 570;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'npc';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'npc add';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'npc add formation';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'npc add item';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'npc add move';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'npc add temp';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'npc add delete';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'npc add delete item';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'npc add follow';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'npc add follow stop';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'npc set';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'npc set allowmove';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'npc set entry';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'npc set factionid';
UPDATE `command` SET `permission` = @id+14 WHERE `name` = 'npc set flag';
UPDATE `command` SET `permission` = @id+15 WHERE `name` = 'npc set level';
UPDATE `command` SET `permission` = @id+16 WHERE `name` = 'npc set link';
UPDATE `command` SET `permission` = @id+17 WHERE `name` = 'npc set model';
UPDATE `command` SET `permission` = @id+18 WHERE `name` = 'npc set movetype';
UPDATE `command` SET `permission` = @id+19 WHERE `name` = 'npc set phase';
UPDATE `command` SET `permission` = @id+20 WHERE `name` = 'npc set spawndist';
UPDATE `command` SET `permission` = @id+21 WHERE `name` = 'npc set spawntime';
UPDATE `command` SET `permission` = @id+22 WHERE `name` = 'npc set data';
UPDATE `command` SET `permission` = @id+23 WHERE `name` = 'npc info';
UPDATE `command` SET `permission` = @id+24 WHERE `name` = 'npc near';
UPDATE `command` SET `permission` = @id+25 WHERE `name` = 'npc move';
UPDATE `command` SET `permission` = @id+26 WHERE `name` = 'npc playemote';
UPDATE `command` SET `permission` = @id+27 WHERE `name` = 'npc say';
UPDATE `command` SET `permission` = @id+28 WHERE `name` = 'npc textemote';
UPDATE `command` SET `permission` = @id+29 WHERE `name` = 'npc whisper';
UPDATE `command` SET `permission` = @id+30 WHERE `name` = 'npc yell';
UPDATE `command` SET `permission` = @id+31 WHERE `name` = 'npc tame';
 
 
/* 
* sql\updates\world\2013_09_10_09_world_command.sql 
*/ 
/* cs_quest.cpp */

SET @id = 602;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'quest';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'quest add';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'quest complete';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'quest remove';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'quest reward';
 
 
/* 
* sql\updates\world\2013_09_10_10_world_command.sql 
*/ 
/* cs_reload.cpp */

SET @id = 607;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'reload';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'reload access_requirement';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'reload achievement_criteria_data';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'reload achievement_reward';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'reload all';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'reload all achievement';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'reload all area';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'reload all eventai';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'reload all gossips';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'reload all item';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'reload all locales';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'reload all loot';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'reload all npc';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'reload all quest';
UPDATE `command` SET `permission` = @id+14 WHERE `name` = 'reload all scripts';
UPDATE `command` SET `permission` = @id+15 WHERE `name` = 'reload all spell';
UPDATE `command` SET `permission` = @id+16 WHERE `name` = 'reload areatrigger_involvedrelation';
UPDATE `command` SET `permission` = @id+17 WHERE `name` = 'reload areatrigger_tavern';
UPDATE `command` SET `permission` = @id+18 WHERE `name` = 'reload areatrigger_teleport';
UPDATE `command` SET `permission` = @id+19 WHERE `name` = 'reload auctions';
UPDATE `command` SET `permission` = @id+20 WHERE `name` = 'reload autobroadcast';
UPDATE `command` SET `permission` = @id+21 WHERE `name` = 'reload command';
UPDATE `command` SET `permission` = @id+22 WHERE `name` = 'reload conditions';
UPDATE `command` SET `permission` = @id+23 WHERE `name` = 'reload config';
UPDATE `command` SET `permission` = @id+24 WHERE `name` = 'reload creature_text';
UPDATE `command` SET `permission` = @id+25 WHERE `name` = 'reload creature_ai_scripts';
UPDATE `command` SET `permission` = @id+26 WHERE `name` = 'reload creature_ai_texts';
UPDATE `command` SET `permission` = @id+27 WHERE `name` = 'reload creature_questender';
UPDATE `command` SET `permission` = @id+28 WHERE `name` = 'reload creature_linked_respawn';
UPDATE `command` SET `permission` = @id+29 WHERE `name` = 'reload creature_loot_template';
UPDATE `command` SET `permission` = @id+30 WHERE `name` = 'reload creature_onkill_reputation';
UPDATE `command` SET `permission` = @id+31 WHERE `name` = 'reload creature_queststarter';
UPDATE `command` SET `permission` = @id+32 WHERE `name` = 'reload creature_summon_groups';
UPDATE `command` SET `permission` = @id+33 WHERE `name` = 'reload creature_template';
UPDATE `command` SET `permission` = @id+34 WHERE `name` = 'reload disables';
UPDATE `command` SET `permission` = @id+35 WHERE `name` = 'reload disenchant_loot_template';
UPDATE `command` SET `permission` = @id+36 WHERE `name` = 'reload event_scripts';
UPDATE `command` SET `permission` = @id+37 WHERE `name` = 'reload fishing_loot_template';
UPDATE `command` SET `permission` = @id+38 WHERE `name` = 'reload game_graveyard_zone';
UPDATE `command` SET `permission` = @id+39 WHERE `name` = 'reload game_tele';
UPDATE `command` SET `permission` = @id+40 WHERE `name` = 'reload gameobject_questender';
UPDATE `command` SET `permission` = @id+41 WHERE `name` = 'reload gameobject_loot_template';
UPDATE `command` SET `permission` = @id+42 WHERE `name` = 'reload gameobject_queststarter';
UPDATE `command` SET `permission` = @id+43 WHERE `name` = 'reload gm_tickets';
UPDATE `command` SET `permission` = @id+44 WHERE `name` = 'reload gossip_menu';
UPDATE `command` SET `permission` = @id+45 WHERE `name` = 'reload gossip_menu_option';
UPDATE `command` SET `permission` = @id+46 WHERE `name` = 'reload item_enchantment_template';
UPDATE `command` SET `permission` = @id+47 WHERE `name` = 'reload item_loot_template';
UPDATE `command` SET `permission` = @id+48 WHERE `name` = 'reload item_set_names';
UPDATE `command` SET `permission` = @id+49 WHERE `name` = 'reload lfg_dungeon_rewards';
UPDATE `command` SET `permission` = @id+50 WHERE `name` = 'reload locales_achievement_reward';
UPDATE `command` SET `permission` = @id+51 WHERE `name` = 'reload locales_creature';
UPDATE `command` SET `permission` = @id+52 WHERE `name` = 'reload locales_creature_text';
UPDATE `command` SET `permission` = @id+53 WHERE `name` = 'reload locales_gameobject';
UPDATE `command` SET `permission` = @id+54 WHERE `name` = 'reload locales_gossip_menu_option';
UPDATE `command` SET `permission` = @id+55 WHERE `name` = 'reload locales_item';
UPDATE `command` SET `permission` = @id+56 WHERE `name` = 'reload locales_item_set_name';
UPDATE `command` SET `permission` = @id+57 WHERE `name` = 'reload locales_npc_text';
UPDATE `command` SET `permission` = @id+58 WHERE `name` = 'reload locales_page_text';
UPDATE `command` SET `permission` = @id+59 WHERE `name` = 'reload locales_points_of_interest';
UPDATE `command` SET `permission` = @id+60 WHERE `name` = 'reload locales_quest';
UPDATE `command` SET `permission` = @id+61 WHERE `name` = 'reload mail_level_reward';
UPDATE `command` SET `permission` = @id+62 WHERE `name` = 'reload mail_loot_template';
UPDATE `command` SET `permission` = @id+63 WHERE `name` = 'reload milling_loot_template';
UPDATE `command` SET `permission` = @id+64 WHERE `name` = 'reload npc_spellclick_spells';
UPDATE `command` SET `permission` = @id+65 WHERE `name` = 'reload npc_trainer';
UPDATE `command` SET `permission` = @id+66 WHERE `name` = 'reload npc_vendor';
UPDATE `command` SET `permission` = @id+67 WHERE `name` = 'reload page_text';
UPDATE `command` SET `permission` = @id+68 WHERE `name` = 'reload pickpocketing_loot_template';
UPDATE `command` SET `permission` = @id+69 WHERE `name` = 'reload points_of_interest';
UPDATE `command` SET `permission` = @id+70 WHERE `name` = 'reload prospecting_loot_template';
UPDATE `command` SET `permission` = @id+71 WHERE `name` = 'reload quest_poi';
UPDATE `command` SET `permission` = @id+72 WHERE `name` = 'reload quest_template';
UPDATE `command` SET `permission` = @id+73 WHERE `name` = 'reload rbac';
UPDATE `command` SET `permission` = @id+74 WHERE `name` = 'reload reference_loot_template';
UPDATE `command` SET `permission` = @id+75 WHERE `name` = 'reload reserved_name';
UPDATE `command` SET `permission` = @id+76 WHERE `name` = 'reload reputation_reward_rate';
UPDATE `command` SET `permission` = @id+77 WHERE `name` = 'reload reputation_spillover_template';
UPDATE `command` SET `permission` = @id+78 WHERE `name` = 'reload skill_discovery_template';
UPDATE `command` SET `permission` = @id+79 WHERE `name` = 'reload skill_extra_item_template';
UPDATE `command` SET `permission` = @id+80 WHERE `name` = 'reload skill_fishing_base_level';
UPDATE `command` SET `permission` = @id+81 WHERE `name` = 'reload skinning_loot_template';
UPDATE `command` SET `permission` = @id+82 WHERE `name` = 'reload smart_scripts';
UPDATE `command` SET `permission` = @id+83 WHERE `name` = 'reload spell_required';
UPDATE `command` SET `permission` = @id+84 WHERE `name` = 'reload spell_area';
UPDATE `command` SET `permission` = @id+85 WHERE `name` = 'reload spell_bonus_data';
UPDATE `command` SET `permission` = @id+86 WHERE `name` = 'reload spell_group';
UPDATE `command` SET `permission` = @id+87 WHERE `name` = 'reload spell_learn_spell';
UPDATE `command` SET `permission` = @id+88 WHERE `name` = 'reload spell_loot_template';
UPDATE `command` SET `permission` = @id+89 WHERE `name` = 'reload spell_linked_spell';
UPDATE `command` SET `permission` = @id+90 WHERE `name` = 'reload spell_pet_auras';
UPDATE `command` SET `permission` = @id+91 WHERE `name` = 'reload spell_proc_event';
UPDATE `command` SET `permission` = @id+92 WHERE `name` = 'reload spell_proc';
UPDATE `command` SET `permission` = @id+93 WHERE `name` = 'reload spell_scripts';
UPDATE `command` SET `permission` = @id+94 WHERE `name` = 'reload spell_target_position';
UPDATE `command` SET `permission` = @id+95 WHERE `name` = 'reload spell_threats';
UPDATE `command` SET `permission` = @id+96 WHERE `name` = 'reload spell_group_stack_rules';
UPDATE `command` SET `permission` = @id+97 WHERE `name` = 'reload trinity_string';
UPDATE `command` SET `permission` = @id+98 WHERE `name` = 'reload warden_action';
UPDATE `command` SET `permission` = @id+99 WHERE `name` = 'reload waypoint_scripts';
UPDATE `command` SET `permission` = @id+100 WHERE `name` = 'reload waypoint_data';
UPDATE `command` SET `permission` = @id+101 WHERE `name` = 'reload vehicle_accessory';
UPDATE `command` SET `permission` = @id+102 WHERE `name` = 'reload vehicle_template_accessory';
 
 
/* 
* sql\updates\world\2013_09_10_11_world_command.sql 
*/ 
/* cs_reset.cpp */

SET @id = 710;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'reset';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'reset achievements';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'reset honor';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'reset level';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'reset spells';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'reset stats';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'reset talents';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'reset all';
 
 
/* 
* sql\updates\world\2013_09_10_12_world_command.sql 
*/ 
/* cs_server.cpp */

SET @id = 718;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'server';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'server corpses';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'server exit';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'server idlerestart';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'server idlerestart cancel';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'server idleshutdown';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'server idleshutdown cancel';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'server info';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'server plimit';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'server restart';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'server restart cancel';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'server set';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'server set closed';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'server set difftime';
UPDATE `command` SET `permission` = @id+14 WHERE `name` = 'server set loglevel';
UPDATE `command` SET `permission` = @id+15 WHERE `name` = 'server set motd';
UPDATE `command` SET `permission` = @id+16 WHERE `name` = 'server shutdown';
UPDATE `command` SET `permission` = @id+17 WHERE `name` = 'server shutdown cancel';
UPDATE `command` SET `permission` = @id+18 WHERE `name` = 'server motd';
 
 
/* 
* sql\updates\world\2013_09_10_13_world_command.sql 
*/ 
/* cs_tele.cpp */

SET @id = 737;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'tele';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'tele add';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'tele del';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'tele name';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'tele group';
 
 
/* 
* sql\updates\world\2013_09_10_14_world_command.sql 
*/ 
/* cs_ticket.cpp */

SET @id = 742;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'ticket';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'ticket assign';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'ticket close';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'ticket closedlist';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'ticket comment';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'ticket complete';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'ticket delete';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'ticket escalate';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'ticket escalatedlist';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'ticket list';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'ticket onlinelist';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'ticket reset';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'ticket response';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'ticket response append';
UPDATE `command` SET `permission` = @id+14 WHERE `name` = 'ticket response appendln';
UPDATE `command` SET `permission` = @id+15 WHERE `name` = 'ticket togglesystem';
UPDATE `command` SET `permission` = @id+16 WHERE `name` = 'ticket unassign';
UPDATE `command` SET `permission` = @id+17 WHERE `name` = 'ticket viewid';
UPDATE `command` SET `permission` = @id+18 WHERE `name` = 'ticket viewname';
 
 
/* 
* sql\updates\world\2013_09_10_15_world_command.sql 
*/ 
/* cs_titles.cpp & cs_wp.cpp */

SET @id = 761;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'titles';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'titles add';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'titles current';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'titles remove';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'titles set';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'titles set mask';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'wp';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'wp add';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'wp event';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'wp load';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'wp modify';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'wp unload';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'wp reload';
UPDATE `command` SET `permission` = @id+13 WHERE `name` = 'wp show';
 
 
/* 
* sql\updates\world\2013_09_10_16_world_command.sql 
*/ 
-- Update command table and remove obsolete permissions (0 = non existent permission)
UPDATE `command` SET `permission` = 0 WHERE `permission` IN (7, 8, 9, 10, 12);
 
 
/* 
* sql\updates\world\2013_09_10_17_world_command.sql 
*/ 
-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = 201 WHERE `name` = 'rbac account';
UPDATE `command` SET `permission` = 202 WHERE `name` = 'rbac account group';
UPDATE `command` SET `permission` = 203 WHERE `name` = 'rbac account group add';
UPDATE `command` SET `permission` = 204 WHERE `name` = 'rbac account group remove';
UPDATE `command` SET `permission` = 205 WHERE `name` = 'rbac account role';
UPDATE `command` SET `permission` = 206 WHERE `name` = 'rbac account role grant';
UPDATE `command` SET `permission` = 207 WHERE `name` = 'rbac account role deny';
UPDATE `command` SET `permission` = 208 WHERE `name` = 'rbac account role revoke';
UPDATE `command` SET `permission` = 209 WHERE `name` = 'rbac account permission';
UPDATE `command` SET `permission` = 210 WHERE `name` = 'rbac account permission grant';
UPDATE `command` SET `permission` = 211 WHERE `name` = 'rbac account permission deny';
UPDATE `command` SET `permission` = 212 WHERE `name` = 'rbac account permission revoke';
UPDATE `command` SET `permission` = 214 WHERE `name` = 'rbac account list groups';
UPDATE `command` SET `permission` = 215 WHERE `name` = 'rbac account list roles';
UPDATE `command` SET `permission` = 216 WHERE `name` = 'rbac account list permissions';
 
 
/* 
* sql\updates\world\2013_09_10_18_world_command.sql 
*/ 
UPDATE `command` SET `permission`=214 WHERE `name`='rbac list groups';
UPDATE `command` SET `permission`=215 WHERE `name`='rbac list roles';
UPDATE `command` SET `permission`=216 WHERE `name`='rbac list permissions';
UPDATE `command` SET `permission`=262 WHERE `name`='bf enable';
UPDATE `command` SET `permission`=576 WHERE `name`='npc delete';
UPDATE `command` SET `permission`=577 WHERE `name`='npc delete item';
UPDATE `command` SET `permission`=578 WHERE `name`='npc follow';
UPDATE `command` SET `permission`=579 WHERE `name`='npc follow stop';
UPDATE `command` SET `permission`=316 WHERE `name`='debug play cinematic';
 
 
/* 
* sql\updates\world\2013_09_10_19_world_command.sql 
*/ 
DELETE FROM `command` WHERE `name` = 'account email';
DELETE FROM `command` WHERE `name` = 'account set sec email';
DELETE FROM `command` WHERE `name` = 'account set sec regmail';

INSERT INTO `command` (`name`, `permission`, `help`) VALUES
('account email', 263, 'Syntax: .account email $oldemail $currentpassword $newemail $newemailconfirmation\r\n\r\n Change your account email. You may need to check the actual security mode to see if email input is necessary for password change'),
('account set sec email', 265, 'Syntax: .account set sec email $accountname $email $emailconfirmation\r\n\r\nSet the email for entered player account.'),
('account set sec regmail', 266, 'Syntax: .account set sec regmail $account $regmail $regmailconfirmation\r\n\r\nSets the regmail for entered player account.');

/* cs_cast.cpp */

SET @id = 267;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'cast';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'cast back';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'cast dist';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'cast self';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'cast target';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'cast dest';

/* cs_go.cpp */

SET @id = 377;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'go';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'go creature';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'go graveyard';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'go grid';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'go object';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'go taxinode';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'go ticket';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'go trigger';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'go xyz';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'go zonexy';

/* cs_gobject.cpp */

SET @id = 387;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'gobject';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'gobject activate';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'gobject add';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'gobject add temp';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'gobject delete';
UPDATE `command` SET `permission` = @id+5 WHERE `name` = 'gobject info';
UPDATE `command` SET `permission` = @id+6 WHERE `name` = 'gobject move';
UPDATE `command` SET `permission` = @id+7 WHERE `name` = 'gobject near';
UPDATE `command` SET `permission` = @id+8 WHERE `name` = 'gobject set';
UPDATE `command` SET `permission` = @id+9 WHERE `name` = 'gobject set phase';
UPDATE `command` SET `permission` = @id+10 WHERE `name` = 'gobject set state';
UPDATE `command` SET `permission` = @id+11 WHERE `name` = 'gobject target';
UPDATE `command` SET `permission` = @id+12 WHERE `name` = 'gobject turn';

/* cs_instance.cpp */

SET @id = 412;

-- Update command table with new RBAC permissions
UPDATE `command` SET `permission` = @id+0 WHERE `name` = 'instance';
UPDATE `command` SET `permission` = @id+1 WHERE `name` = 'instance listbinds';
UPDATE `command` SET `permission` = @id+2 WHERE `name` = 'instance unbind';
UPDATE `command` SET `permission` = @id+3 WHERE `name` = 'instance stats';
UPDATE `command` SET `permission` = @id+4 WHERE `name` = 'instance savedata';
 
 
/* 
* sql\updates\world\2013_09_10_20_world_creature_template.sql 
*/ 
UPDATE `creature_template` SET `modelid1`=1126,`modelid2`=16925 WHERE `entry`=21393;
 
 
/* 
* sql\updates\world\2013_09_10_21_world_updates.sql 
*/ 
-- Update for Forgotten npcs to award credit.
UPDATE `smart_scripts` SET `action_type`=85 WHERE  `entryorguid`=27224 AND `source_type`=0 AND `id`=0 AND `link`=1;
UPDATE `smart_scripts` SET `action_type`=85 WHERE  `entryorguid`=27225 AND `source_type`=0 AND `id`=0 AND `link`=1;
UPDATE `smart_scripts` SET `action_type`=85 WHERE  `entryorguid`=27229 AND `source_type`=0 AND `id`=0 AND `link`=1;
UPDATE `smart_scripts` SET `action_type`=85 WHERE  `entryorguid`=27226 AND `source_type`=0 AND `id`=0 AND `link`=1;
-- Forced model for Channel Bunny... should've used that earlier.
UPDATE `creature` SET `modelid`=16925, `position_x`=1924.63, `position_y`=5574.76, `position_z`=273.122 WHERE `guid`=74872;
 
 
/* 
* sql\updates\world\2013_09_11_00_world_cond.sql 
*/ 
DELETE FROM `conditions` WHERE  `SourceTypeOrReferenceId`=15 AND `SourceGroup`=8455 AND `SourceEntry`=4;
 
 
/* 
* sql\updates\world\2013_09_11_01_world_sai.sql 
*/ 
UPDATE `creature_template` SET`AIName`='SmartAI' WHERE `entry`=26321;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=26321;
DELETE FROM `smart_scripts` WHERE `entryorguid`=26321;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26321,0,0,0,8,0,100,1,47530,0,0,0,33,26321,0,0,0,0,0,7,0,0,0,0,0,0,0,'Lothalor Ancient - On Spellhit - Give Credit to Invoker');
 
 
/* 
* sql\updates\world\2013_09_12_00_world_sai.sql 
*/ 
-- [QUEST] War Is Hell
UPDATE `creature` SET `spawntimesecs`=60 WHERE `id` IN (24009,24010);

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (24009,24010);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (24009,24010) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
-- Alliance Corpse
(24009, 0, 0, 1, 8, 0, 100, 1, 42793, 0, 0, 0, 11, 43297, 2, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Alliance Corpse - SMART_EVENT_SPELLHIT - SMART_ACTION_CAST'),
(24009, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 41, 20000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Alliance Corpse - SMART_EVENT_LINK - SMART_ACTION_FORCE_DESPAWN'),
-- Forsaken Corpse
(24010, 0, 0, 1, 8, 0, 100, 1, 42793, 0, 0, 0, 11, 43297, 2, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Forsaken Corpse - SMART_EVENT_SPELLHIT - SMART_ACTION_CAST'),
(24010, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 41, 20000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Forsaken Corpse - SMART_EVENT_LINK - SMART_ACTION_FORCE_DESPAWN');

DELETE FROM `conditions` WHERE `SourceEntry`=42793 AND `SourceTypeOrReferenceId`=17;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(17, 0, 42793, 0, 0, 31, 1, 3, 24009, 0, 0, 0, 0, '', ''),
(17, 0, 42793, 0, 1, 31, 1, 3, 24010, 0, 0, 0, 0, '', '');
 
 
/* 
* sql\updates\world\2013_09_13_00_world_conditions.sql 
*/ 
UPDATE `conditions` SET `ElseGroup`=2 WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=75509;
 
 
/* 
* sql\updates\world\2013_09_14_00_world_update.sql 
*/ 
UPDATE `smart_scripts` SET `target_type`=24 WHERE  `entryorguid`=2935200 AND `source_type`=9 AND `id`=0 AND `link`=0;
 
 
/* 
* sql\updates\world\2013_09_14_01_world_gobject.sql 
*/ 
DELETE FROM `gameobject` WHERE `id`= 15885;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`) VALUES 
(99849, 15885, 1, 1, 1, 7853.95, -2212.3, 456.397, 0, 0, 0, 0, 0, 0, 0, 1);
 
 
/* 
* sql\updates\world\2013_09_16_00_world_sai.sql 
*/ 
-- Fate of the Titans (12986)
-- http://www.youtube.com/watch?v=H6HED6PaxIs

SET @NPC_DISK              := 30313; -- Mobile Databank
SET @NPC_BUNNY_INVENTION   := 30315; -- Temple of Invention Bunny
SET @NPC_BUNNY_LIFE        := 30316; -- Temple of Life Bunny
SET @NPC_BUNNY_WINTER      := 30317; -- Temple of Winter Bunny
SET @NPC_BUNNY_ORDER       := 30318; -- Temple of Order Bunny
SET @NPC_BUNNY_DATASCAN    := 30889; -- Data Scan Target Bunny
SET @SPELL_DATASCAN        := 56523; -- Data Scan
SET @SPELL_INVENTION_KC    := 56532; -- Temple of Invention Kill Credit
SET @SPELL_LIFE_KC         := 56534; -- Temple of Life Kill Credit
SET @SPELL_WINTER_KC       := 56533; -- Temple of Winter Kill Credit
SET @SPELL_ORDER_KC        := 56535; -- Temple of Order Kill Credit
SET @GUID                  := 127294;

UPDATE `creature_template` SET `AIName`='SmartAI',`speed_walk`=3.14286, `InhabitType`=4 WHERE `entry`=@NPC_DISK;
UPDATE `creature_template` SET `AIName`='SmartAI',`unit_flags`=`unit_flags`|33554432,`InhabitType`=7,`flags_extra`=`flags_extra`|128 WHERE `entry` IN (@NPC_BUNNY_INVENTION,@NPC_BUNNY_LIFE,@NPC_BUNNY_WINTER,@NPC_BUNNY_ORDER,@NPC_BUNNY_DATASCAN);

-- Sniffed
DELETE FROM `creature` WHERE `id` IN (@NPC_BUNNY_INVENTION,@NPC_BUNNY_LIFE,@NPC_BUNNY_WINTER,@NPC_BUNNY_ORDER,@NPC_BUNNY_DATASCAN);
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`dynamicflags`) VALUES
-- Databank should go from one to another and say text
(@GUID+0,@NPC_BUNNY_INVENTION,571,1,1,0,0,7865.214,-1397.313,1534.143,3.752458,300,0,0,1,0,0,0,0,0),
(@GUID+1,@NPC_BUNNY_LIFE,571,1,1,0,0,7994.017,-2734.839,1133.662,0.3316126,300,0,0,1,0,0,0,0,0),
(@GUID+2,@NPC_BUNNY_WINTER,571,1,1,0,0,7498.68,-1899.41,1473.61,0.132902,300,0,0,1,0,0,0,0,0),
(@GUID+3,@NPC_BUNNY_ORDER,571,1,1,0,0,8194.199,-1963.597,1738.56,1.954769,300,0,0,1,0,0,0,0,0),
-- At the Temple of Order:
(@GUID+4,@NPC_BUNNY_DATASCAN,571,1,1,0,0,8130.811,-1995.321,1781.117,0.05235988,300,0,0,1,0,0,0,0,0),
(@GUID+5,@NPC_BUNNY_DATASCAN,571,1,1,0,0,8213.646,-1901.764,1744.02,0.5759587,300,0,0,1,0,0,0,0,0),
(@GUID+6,@NPC_BUNNY_DATASCAN,571,1,1,0,0,8255.328,-1982.391,1742.117,4.031711,300,0,0,1,0,0,0,0,0),
-- At the Temple of Invention:
(@GUID+7,@NPC_BUNNY_DATASCAN,571,1,1,0,0,7868.994,-1375.799,1541.754,4.712389,300,0,0,1,0,0,0,0,0),
(@GUID+8,@NPC_BUNNY_DATASCAN,571,1,1,0,0,7924.429,-1385.165,1534.788,6.038839,300,0,0,1,0,0,0,0,0),
(@GUID+9,@NPC_BUNNY_DATASCAN,571,1,1,0,0,7903.273, -1424.807, 1539.821,2.048841,300,0,0,1,0,0,0,0,0),
(@GUID+10,@NPC_BUNNY_DATASCAN,571,1,1,0,0,7863.330, -1434.625, 1537.565,3.072831,300,0,0,1,0,0,0,0,0),
-- At the Temple of Life:
(@GUID+11,@NPC_BUNNY_DATASCAN,571,1,1,0,0,7924.706,-2748.963,1151.056,4.520403,300,0,0,1,0,0,0,0,0),
(@GUID+12,@NPC_BUNNY_DATASCAN,571,1,1,0,0,8010.217,-2750.608,1151.104,0.418879,300,0,0,1,0,0,0,0,0),
(@GUID+13,@NPC_BUNNY_DATASCAN,571,1,1,0,0,8027.505,-2728.616,1139.939,3.944444,300,0,0,1,0,0,0,0,0),
(@GUID+14,@NPC_BUNNY_DATASCAN,571,1,1,0,0,7978.187,-2714.357,1137.354,2.643541,300,0,0,1,0,0,0,0,0),
-- At the Temple of Winter:
(@GUID+15,@NPC_BUNNY_DATASCAN,571,1,1,0,0,7520.712,-1929.840,1482.500,4.520403,300,0,0,1,0,0,0,0,0),
(@GUID+16,@NPC_BUNNY_DATASCAN,571,1,1,0,0,7478.601, -1917.123, 1473.615,0.418879,300,0,0,1,0,0,0,0,0),
(@GUID+17,@NPC_BUNNY_DATASCAN,571,1,1,0,0,7473.774, -1875.455, 1473.614,3.944444,300,0,0,1,0,0,0,0,0);

-- Databank only executes SAI near Temple Bunnies
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=@NPC_DISK;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,1,@NPC_DISK,0,0,29,0,@NPC_BUNNY_INVENTION,15,0,0,0,'','Execute sai if near dummy npc'),
(22,2,@NPC_DISK,0,0,29,0,@NPC_BUNNY_WINTER,15,0,0,0,'','Execute sai if near dummy npc'),
(22,3,@NPC_DISK,0,0,29,0,@NPC_BUNNY_LIFE,15,0,0,0,'','Execute sai if near dummy npc'),
(22,4,@NPC_DISK,0,0,29,0,@NPC_BUNNY_ORDER,15,0,0,0,'','Execute sai if near dummy npc');

DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (@NPC_DISK,@NPC_BUNNY_INVENTION);
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (@NPC_DISK*100+0,@NPC_DISK*100+1,@NPC_DISK*100+2,@NPC_DISK*100+3);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_DISK,0,0,0,10,0,100,1,500,1000,500,1000,80,@NPC_DISK*100+0,2,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - OOC near npc -  Run script'),
--
(@NPC_DISK,0,1,0,10,0,100,1,500,1000,500,1000,80,@NPC_DISK*100+1,2,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - OOC near npc -  Run script'),
--
(@NPC_DISK,0,2,0,10,0,100,1,500,1000,500,1000,80,@NPC_DISK*100+2,2,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - OOC near npc -  Run script'),
-- 
(@NPC_DISK,0,3,0,10,0,100,1,500,1000,500,1000,80,@NPC_DISK*100+3,2,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - OOC near npc -  Run script'),
--
(@NPC_DISK*100+0,9,0,0,0,0,100,0,5000,5000,5000,5000,69,1,0,0,0,0,0,10,@GUID+7,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+0,9,1,0,0,0,100,0,3000,3000,3000,3000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+0,9,2,0,0,0,100,0,2000,2000,2000,2000,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+0,9,3,0,0,0,100,0,8000,8000,8000,8000,69,1,0,0,0,0,0,10,@GUID+8,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+0,9,4,0,0,0,100,0,7000,7000,7000,7000,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+0,9,5,0,0,0,100,0,9000,9000,9000,9000,69,1,0,0,0,0,0,10,@GUID+9,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+0,9,6,0,0,0,100,0,3000,3000,3000,3000,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+0,9,7,0,0,0,100,0,9000,9000,9000,9000,69,1,0,0,0,0,0,10,@GUID+10,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+0,9,8,0,0,0,100,0,3000,3000,3000,3000,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+0,9,9,0,0,0,100,0,0,0,0,0,11,@SPELL_INVENTION_KC,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On script - Cast Credit'),
--
(@NPC_DISK*100+1,9,0,0,0,0,100,0,5000,5000,5000,5000,69,1,0,0,0,0,0,10,@GUID+15,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+1,9,1,0,0,0,100,0,3000,3000,3000,3000,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+1,9,2,0,0,0,100,0,2000,2000,2000,2000,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+1,9,3,0,0,0,100,0,8000,8000,8000,8000,69,1,0,0,0,0,0,10,@GUID+16,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+1,9,4,0,0,0,100,0,7000,7000,7000,7000,1,7,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+1,9,5,0,0,0,100,0,9000,9000,9000,9000,69,1,0,0,0,0,0,10,@GUID+17,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+1,9,6,0,0,0,100,0,3000,3000,3000,3000,1,8,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+1,9,7,0,0,0,100,0,3000,3000,3000,3000,1,9,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+1,9,8,0,0,0,100,0,0,0,0,0,11,@SPELL_WINTER_KC,0,0,0,0,0,7,0,0,0,0,0,0,0,'Mobile Databank - On script - Cast Credit'),
--
(@NPC_DISK*100+2,9,0,0,0,0,100,0,5000,5000,5000,5000,69,1,0,0,0,0,0,10,@GUID+11,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+2,9,1,0,0,0,100,0,3000,3000,3000,3000,1,10,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+2,9,2,0,0,0,100,0,2000,2000,2000,2000,1,11,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+2,9,3,0,0,0,100,0,8000,8000,8000,8000,69,1,0,0,0,0,0,10,@GUID+12,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+2,9,4,0,0,0,100,0,7000,7000,7000,7000,1,12,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+2,9,5,0,0,0,100,0,9000,9000,9000,9000,69,1,0,0,0,0,0,10,@GUID+13,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+2,9,6,0,0,0,100,0,3000,3000,3000,3000,1,13,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+2,9,7,0,0,0,100,0,9000,9000,9000,9000,69,1,0,0,0,0,0,10,@GUID+14,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+2,9,8,0,0,0,100,0,3000,3000,3000,3000,1,14,0,0,0,0,0,1,0,0,0,0,0,0,0,'MMobile Databank - On Script - Say'),
(@NPC_DISK*100+2,9,9,0,0,0,100,0,0,0,0,0,11,@SPELL_LIFE_KC,0,0,0,0,0,7,0,0,0,0,0,0,0,'Mobile Databank - On script - Cast Credit'),
--
(@NPC_DISK*100+3,9,0,0,0,0,100,0,5000,5000,5000,5000,69,1,0,0,0,0,0,10,@GUID+4,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+3,9,1,0,0,0,100,0,3000,3000,3000,3000,1,15,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+3,9,2,0,0,0,100,0,2000,2000,2000,2000,1,16,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+3,9,3,0,0,0,100,0,8000,8000,8000,8000,69,1,0,0,0,0,0,10,@GUID+5,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+3,9,4,0,0,0,100,0,7000,7000,7000,7000,1,17,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+3,9,5,0,0,0,100,0,9000,9000,9000,9000,69,1,0,0,0,0,0,10,@GUID+6,@NPC_BUNNY_DATASCAN,0,0,0,0,0,'Mobile Databank - On Script - Move to Pos'),
(@NPC_DISK*100+3,9,6,0,0,0,100,0,3000,3000,3000,3000,1,18,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mobile Databank - On Script - Say'),
(@NPC_DISK*100+3,9,7,0,0,0,100,0,0,0,0,0,11,@SPELL_ORDER_KC,0,0,0,0,0,7,0,0,0,0,0,0,0,'Mobile Databank - On script - Cast Credit');


DELETE FROM `creature_text` WHERE `entry`=@NPC_DISK;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
-- At the Temple of Invention:
(@NPC_DISK,0,0,'Temple of Invention analysis commencing.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,1,0,'Temple of Invention verified to be in-tact.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,2,0,'Mechanical servants appear to have turned against each other. Several attendants have been piled together in an unorganized manner.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,3,0,'Remaining mechagnome guardians corrupted by unknown source.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,4,0,'Watcher Mimir verified to no longer be present. Analysis complete.',12,0,100,15,0,0,'Mobile Databank'),
-- At the Temple of Winter:
(@NPC_DISK,5,0,'Temple of Winter analysis commencing.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,6,0,'Temple of Winter verified to be in-tact.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,7,0,'Temple guardians verified to be deceased. Sulfurous odor suggests that death resulted from a fire-base entity.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,8,0,'Previously established cold weather patterns at the temple have ceased.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,9,0,'Watcher Hodir verified to no longer be present. Analysis complete.',12,0,100,15,0,0,'Mobile Databank'),
-- At the Temple of Life:
(@NPC_DISK,10,0,'Temple of Life analysis commencing.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,11,0,'Temple of Life verified to be damaged beyond repair.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,12,0,'Evidence indicates a significant battle. The opponent of Watcher Freya estimated to be of similar size and strength to Watcher Freya.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,13,0,'Temple guardians are no longer present. Plant forms associated with temple are deceased.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,14,0,'Watcher Freya verified to no longer be present. Analysis complete.',12,0,100,15,0,0,'Mobile Databank'),
-- At the Temple of Order:
(@NPC_DISK,15,0,'Temple of Order analysis commencing.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,16,0,'Temple of Order verified to be in-tact.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,17,0,'No indications of struggle are present. No guardians are present.',12,0,100,15,0,0,'Mobile Databank'),
(@NPC_DISK,18,0,'Watcher Tyr verified to no longer be present. Analysis complete.',12,0,100,15,0,0,'Mobile Databank');
 
 
/* 
* sql\updates\world\2013_09_16_01_world_sai.sql 
*/ 
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceGroup`=1 AND `SourceEntry`=28739 AND `SourceId`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22,1,28739,0,0,1,1,52231,0,0,1,0,0,'','Execute sai only if aura is not presented');
DELETE FROM `disables` WHERE `entry` IN (52227,52228) AND `sourcetype`=0;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(0,52227,64,'','','Disable LOS check for Dilute Blight Cauldron'),
(0,52228,64,'','','Disable LOS check for Kill Credit (quest 12669)');
UPDATE `creature_template` SET `ainame`='SmartAI' WHERE `entry`=28739;
DELETE FROM `smart_scripts` WHERE `entryorguid`=28739 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(28739,0,0,1,8,0,100,0,52227,0,0,0,11,52228,0,0,0,0,0,7,0,0,0,0,0,0,0,'Blight Cauldron Bunny 00 - On Spell Hit - Give Quest Credit'),
(28739,0,1,0,61,0,100,0,0,0,0,0,11,52231,0,0,0,0,0,1,0,0,0,0,0,0,0,'Blight Cauldron Bunny 00 - Link With Previous Event - Cast Cauldron Diluted Effect'),
(28739,0,2,0,1,0,100,0,30000,30000,30000,30000,28,52231,0,0,0,0,0,1,0,0,0,0,0,0,0,'Blight Cauldron Bunny 00 - OOC - Remove Aura From Cauldron Diluted Effect');
 
 
/* 
* sql\updates\world\2013_09_16_02_world_sai.sql 
*/ 
-- 10146 - [Mission: The Murketh and Shaadraz Gateways]
-- 10129 - [Mission: Gateways Murketh and Shaadraz] 
DELETE FROM `creature_ai_scripts` WHERE `creature_id` in (19291,19292);
UPDATE `creature_template` SET `AIName`='SmartAI',`flags_extra`=130 WHERE `entry` IN (19291,19292);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (19291,19292) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(19291,0,0,0,8,0,100,0,33655,0,0,0,33,19291,0,0,0,0,0,7,0,0,0,0,0,0,0,'Legion Transporter: Alpha - Quest Credit on Dropping The Nether Modulator Spellhit'),
(19292,0,0,0,8,0,100,0,33655,0,0,0,33,19292,0,0,0,0,0,7,0,0,0,0,0,0,0,'Legion Transporter: Beta - Quest Credit on Dropping The Nether Modulator Spellhit');
 
 
/* 
* sql\updates\world\2013_09_17_00_world_error.sql 
*/ 
DELETE FROM `creature_addon` WHERE  `guid`=105665;
 
 
/* 
* sql\updates\world\2013_09_17_01_world_sai_comp.sql 
*/ 
-- Deep in the bowels of the Underhalls
UPDATE `smart_scripts` SET `target_type`=24 WHERE `entryorguid`=30409 AND `source_type`=0 AND `id`=4 AND `link`=0;
-- Guide our sights
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN(23957,23972);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (23957,23972);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(23957, 0, 0, 0, 8, 0, 100, 0, 43076, 0, 0, 0, 33, 23957   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Westguard Cannon Credit Trigger East - On Spellhit - Kill Credit'),
(23972, 0, 0, 0, 8, 0, 100, 0, 43076, 0, 0, 0, 33, 23972   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Westguard Cannon Credit Trigger West - On Spellhit - Kill Credit');
-- Baleheim Must Burn
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN(24182,24183,24184,24185);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (24182,24183,24184,24185);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(24182, 0, 0, 0, 8, 0, 100, 0, 43233, 0, 0, 0, 33, 24182   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Winterskorn Dwelling Credit - On Spellhit - Kill Credit'),
(24183, 0, 0, 0, 8, 0, 100, 0, 43233, 0, 0, 0, 33, 24183   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Winterskorn Watchtower Credit - On Spellhit - Kill Credit'),
(24184, 0, 0, 0, 8, 0, 100, 0, 43233, 0, 0, 0, 33, 24184   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Winterskorn Barracks Credit - On Spellhit - Kill Credit'),
(24185, 0, 0, 0, 8, 0, 100, 0, 43233, 0, 0, 0, 33, 24185   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Winterskorn Bridge Credit - On Spellhit - Kill Credit');
-- Forge Camp: Annihilated
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN(17998,17999,18000,18002);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (17998,17999,18000,18002);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(17998, 0, 0, 0, 8, 0, 100, 0, 31736, 0, 0, 0, 33, 17998   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Umbrafen Steam Pump Credit Marker - On Spellhit - Kill Credit'),
(17999, 0, 0, 0, 8, 0, 100, 0, 31736, 0, 0, 0, 33, 17999   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Lagoon Steam Pump Credit Marker - On Spellhit - Kill Credit'),
(18000, 0, 0, 0, 8, 0, 100, 0, 31736, 0, 0, 0, 33, 18000   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Serpent Steam Pump Credit Marker - On Spellhit - Kill Credit'),
(18002, 0, 0, 0, 8, 0, 100, 0, 31736, 0, 0, 0, 33, 18002   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Marshlight Steam Pump Credit Marker - On Spellhit - Kill Credit');
-- Balance Must Be Preserved
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN(17998,17999,18000,18002);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (17998,17999,18000,18002);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(17998, 0, 0, 0, 8, 0, 100, 0, 31736, 0, 0, 0, 33, 17998   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Umbrafen Steam Pump Credit Marker - On Spellhit - Kill Credit'),
(17999, 0, 0, 0, 8, 0, 100, 0, 31736, 0, 0, 0, 33, 17999   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Lagoon Steam Pump Credit Marker - On Spellhit - Kill Credit'),
(18000, 0, 0, 0, 8, 0, 100, 0, 31736, 0, 0, 0, 33, 18000   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Serpent Steam Pump Credit Marker - On Spellhit - Kill Credit'),
(18002, 0, 0, 0, 8, 0, 100, 0, 31736, 0, 0, 0, 33, 18002   , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Marshlight Steam Pump Credit Marker - On Spellhit - Kill Credit');
-- Burn in Effigy
UPDATE `smart_scripts` SET `event_flags`=0 WHERE `entryorguid` BETWEEN 25510 AND 25513 AND `source_type`=0;
-- A Necessary Distraction
UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` IN (21506);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (21506);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(21506, 0, 0, 0, 8, 0, 100, 0, 37834, 0, 0, 0, 33, 21892, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Azaloth - On Spellhit - Kill Credit');
-- Monitoring the Rift: Sundered Chasm 3.3.5
UPDATE `creature_template` SET `ainame`='SmartAI' WHERE `entry`=25308;
DELETE FROM `smart_scripts` WHERE `entryorguid`=25308 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(25308,0,0,0,8,0,100,0,45414,0,0,0,33,25308,0,0,0,0,0,7,0,0,0,0,0,0,0,'Borean - Westrift Chasm Anomaly - On Spell Hit - Give Quest Credit');

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=25309;
DELETE FROM `smart_scripts` WHERE `entryorguid`=25309 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(25309,0,0,0,8,0,100,0,45414,0,0,0,33,25309,0,0,0,0,0,7,0,0,0,0,0,0,0,'Borean - Westrift Cavern Anomaly - On Spell Hit - Give Quest Credit');
 
 
/* 
* sql\updates\world\2013_09_18_00_world_sai.sql 
*/ 
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN(19067,19210);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (19067,19210);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(19067, 0, 0, 0, 8,  0, 100, 0, 33531, 0, 0, 0, 33, 19067   , 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 'Fel Cannon: Hate - On Spellhit - Kill Credit'),
(19210, 0, 0, 0, 8,  0, 100, 0, 33532, 0, 0, 0, 33, 19210   , 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 'Fel Cannot: Fear - On Spellhit - Kill Credit');
 
 
/* 
* sql\updates\world\2013_09_18_01_world_achievement_criteria_data.sql 
*/ 
UPDATE `achievement_criteria_data` SET `value2` = 3 WHERE `type`=8 AND `criteria_id` IN (2358, 2412, 3384);
UPDATE `achievement_criteria_data` SET `type` = 0 WHERE `type`=8 AND `criteria_id` IN (12066, 12067, 12132);

DELETE FROM `achievement_criteria_data` WHERE `criteria_id` IN (4944,4946,4948,4949,4950,4951,4952,4953,4954,4955,4956,4957,4958);
INSERT INTO `achievement_criteria_data` (`criteria_id`, `type`, `value1`, `value2`, `ScriptName`) VALUES
(4944, 0, 0,  0, ''), -- no criteria data
(4946,11, 0,  0, 'achievement_killed_exp_or_honor_target'),
(4948, 8, 1,  0, ''), -- Beast
(4949, 8, 3,  0, ''), -- Dragonkin
(4950, 8, 2,  0, ''), -- drachkin
(4951, 8, 4,  0, ''), -- Elemental
(4952, 8, 5,  0, ''), -- Giant
(4953, 8, 7,  0, ''), -- Humanoid
(4954, 8, 9,  0, ''), -- Mechanical
(4955, 8, 6,  0, ''), -- Undead
(4956, 8, 10, 0, ''), -- Not specified
(4957, 8, 11, 0, ''), -- Totem
(4958, 8, 12, 0, ''); -- Non-Combat Pet
 
 
/* 
* sql\updates\world\2013_09_19_00_world_db_errors.sql 
*/ 
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=41427 WHERE `entryorguid`=23219 AND `id`=6 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=43384 WHERE `entryorguid`=23652 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=43341 WHERE `entryorguid`=23678 AND `id`=6 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=43174 WHERE `entryorguid`=23689 AND `id`=2 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=43174 WHERE `entryorguid`=24170 AND `id`=1 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=43806 WHERE `entryorguid`=24439 AND `id`=3 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=45627 WHERE `entryorguid`=25471 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=45628 WHERE `entryorguid`=25472 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=45629 WHERE `entryorguid`=25473 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=46443 WHERE `entryorguid`=25752 AND `id`=2 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=46445 WHERE `entryorguid`=25752 AND `id`=2 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=47009 WHERE `entryorguid`=26270 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=47665 WHERE `entryorguid`=26482 AND `id`=1 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=47664 WHERE `entryorguid`=26615 AND `id`=2 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=50473 WHERE `entryorguid`=27409 AND `id`=5 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=48813 WHERE `entryorguid`=27482 AND `id`=4 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=50290 WHERE `entryorguid`=28013 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=51279 WHERE `entryorguid`=28156 AND `id`=1 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=56940 WHERE `entryorguid`=29445 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=55289 WHERE `entryorguid`=29747 AND `id`=1 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=58599 WHERE `entryorguid`=31048 AND `id`=2 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=58955 WHERE `entryorguid`=31304 AND `id`=7 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=61748 WHERE `entryorguid`=32588 AND `id`=5 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=65374 WHERE `entryorguid`=34365 AND `id`=1 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=40347 WHERE `entryorguid`=2061000 AND `id`=1 AND `source_type`=9;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=40347 WHERE `entryorguid`=2077700 AND `id`=2 AND `source_type`=9;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=47683 WHERE `entryorguid`=2642000 AND `id`=5 AND `source_type`=9;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=47685 WHERE `entryorguid`=2648400 AND `id`=5 AND `source_type`=9;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=59876 WHERE `entryorguid`=3244501 AND `id`=0 AND `source_type`=9;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=75197 WHERE `entryorguid`=4032900 AND `id`=7 AND `source_type`=9;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=11024,`action_param2`=0,`action_param3`=0,`target_type`=1,`target_x`=0,`target_y`=0,`target_z`=0,`target_o`=0 WHERE `entryorguid`=7572 AND `source_type`=0 AND `id`=3 AND `link`=4;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=43160,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=23777 AND `source_type`=0 AND `id`=2 AND `link`=3;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=43326,`action_param2`=0,`target_type`=1,`target_x`=0,`target_y`=0,`target_z`=0,`target_o`=0 WHERE `entryorguid`=23931 AND `source_type`=0 AND `id`=5 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=43289,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=24210 AND `source_type`=0 AND `id`=0 AND `link`=1;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=43787,`action_param2`=0,`action_param3`=0,`target_type`=1,`target_x`=0,`target_y`=0,`target_z`=0 WHERE `entryorguid`=24399 AND `source_type`=0 AND `id`=5 AND `link`=0;
UPDATE `smart_scripts` SET `event_param3`=0,`event_param4`=0 WHERE `entryorguid`=12900 AND `source_type`=0 AND `id` IN (0,1) AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=48550,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=26633 AND `source_type`=0 AND `id`=4 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=47315,`action_param2`=0 WHERE `entryorguid`=26699 AND `source_type`=0 AND `id`=0 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=52030 WHERE `entryorguid`=28565 AND `source_type`=0 AND `id`=1 AND `link`=2;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=52220 WHERE `entryorguid`=28669 AND `source_type`=0 AND `id`=2 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=57911,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=30829 AND `source_type`=0 AND `id`=1 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=57892,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=30830 AND `source_type`=0 AND `id`=1 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=57917,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=30831 AND `source_type`=0 AND `id`=1 AND `link`=0;
-- Remove SPELL_AURA_CONTROL_VEHICLE from addon template
UPDATE `creature_template_addon` SET `auras`='50494' WHERE `entry`=28006;
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry` IN (27661,28093,29838);
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=74154 WHERE `entryorguid`=1268 AND `id`=4 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=42337 WHERE `entryorguid`=4351 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=42337 WHERE `entryorguid`=4352 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=42486 WHERE `entryorguid`=4393 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=42486 WHERE `entryorguid`=4394 AND `id`=0 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=60111 WHERE `entryorguid`=5284 AND `id`=0 AND `source_type`=2;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=60112 WHERE `entryorguid`=5285 AND `id`=0 AND `source_type`=2;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=60115 WHERE `entryorguid`=5286 AND `id`=0 AND `source_type`=2;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=60117 WHERE `entryorguid`=5287 AND `id`=0 AND `source_type`=2;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=74156 WHERE `entryorguid`=6119 AND `id`=4 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=74155 WHERE `entryorguid`=7955 AND `id`=3 AND `source_type`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=61314 WHERE `entryorguid` IN (15273,15274,15294,15298) AND `id` IN (0,1) AND `source_type`=0;


-- Meeting the Warchief prevquest
UPDATE `quest_template` SET `PrevQuestId`=9812 WHERE  `Id`=9813;

-- Report to Orgnil prevquest
UPDATE `quest_template` SET `PrevQuestId`=805 WHERE `Id`=823;
 
 
/* 
* sql\updates\world\2013_09_19_01_world_db_errors.sql 
*/ 
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=57910,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=30838 AND `source_type`=0 AND `id`=1 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=57890,`action_param2`=0,`action_param3`=0,`target_type`=1,`target_x`=0,`target_y`=0,`target_z`=0,`target_o`=0 WHERE `entryorguid`=30838 AND `source_type`=0 AND `id`=7 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=57916,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=30839 AND `source_type`=0 AND `id`=1 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=57916,`action_param2`=0,`action_param3`=0,`target_type`=1,`target_x`=0,`target_y`=0,`target_z`=0,`target_o`=0 WHERE `entryorguid`=30839 AND `source_type`=0 AND `id`=7 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=57910,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=30840 AND `source_type`=0 AND `id`=1 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=57913,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=30840 AND `source_type`=0 AND `id`=4 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=57910,`action_param2`=0,`action_param3`=0,`target_type`=1,`target_x`=0,`target_y`=0,`target_z`=0,`target_o`=0 WHERE `entryorguid`=30840 AND `source_type`=0 AND `id`=9 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=34539,`action_param2`=0 WHERE `entryorguid` IN (1972300,1972400) AND `source_type`=9 AND `id`=0 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=39217,`action_param2`=0,`action_param3`=0,`target_type`=1,`target_x`=0,`target_y`=0,`target_z`=0 WHERE `entryorguid`=2245801 AND `source_type`=9 AND `id`=7 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=47303,`action_param2`=0,`action_param3`=0 WHERE `entryorguid`=2667800 AND `source_type`=9 AND `id` IN (0,1,2,3,4);
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=55383,`action_param2`=0,`action_param3`=0,`target_type`=0,`target_x`=0,`target_y`=0,`target_z`=0,`target_o`=0 WHERE `entryorguid`=2986100 AND `source_type`=9 AND `id`=0 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=56243,`action_param2`=0,`action_param3`=0,`action_param5`=0 WHERE `entryorguid`=2991401 AND `source_type`=9 AND `id`=0 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=46443 WHERE `entryorguid` IN (25753,25758) AND `source_type`=0 AND `id`=4 AND `link`=0;
UPDATE `smart_scripts` SET `action_type`=11,`action_param1`=46443 WHERE `entryorguid`=25792 AND `source_type`=0 AND `id`=2 AND `link`=0;
 
 
/* 
* sql\updates\world\2013_09_20_00_world_gameobject_template.sql 
*/ 
DELETE FROM `gameobject_template` WHERE `entry`=188509;
INSERT INTO `gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `faction`, `flags`, `size`, `questItem1`, `questItem2`, `questItem3`, `questItem4`, `questItem5`, `questItem6`, `data0`, `data1`, `data2`, `data3`, `data4`, `data5`, `data6`, `data7`, `data8`, `data9`, `data10`, `data11`, `data12`, `data13`, `data14`, `data15`, `data16`, `data17`, `data18`, `data19`, `data20`, `data21`, `data22`, `data23`, `AIName`, `ScriptName`, `WDBVerified`) VALUES
(188509, 6, 2770, 'Dark Iron Mole Machine (Minion Summoner Trap)', '', '', '', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 47375, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', 17371);
 
 
/* 
* sql\updates\world\2013_09_20_01_world_sai.sql 
*/ 
-- Quest Chain: http://www.wowhead.com/quest=13213/battle-at-valhalas#see-also
-- Battle at Valhalas: Fallen Heroes
-- Battle at Valhalas: Khit'rix the Dark Master
-- Battle at Valhalas: The Return of Sigrid Iceborn
-- Battle at Valhalas: Carnage!
-- Battle at Valhalas: Thane Deathblow
-- Battle at Valhalas: Final Challenge
SET @NPC_GEIRRVIF           := 31135;
SET @QUEST_FALLENHEROES     := 13214;
SET @NPC_ELDRETH_13214      := 31195;
SET @NPC_GENESS_13214       := 31193;
SET @NPC_JHADRAS_13214      := 31191;
SET @NPC_MASUD_13214        := 31192;
SET @NPC_RITH_13214         := 31196;
SET @NPC_TALLA_13214        := 31194;
SET @QUEST_KDARKMASTER      := 13215;
SET @NPC_KHITRIX_13215      := 31222;
SET @NPC_BONESPIDER_13215   := 32484;
SET @QUEST_SIGRIDICEBORN    := 13216;
SET @NPC_SIGRID_13216       := 31242;
SET @NPC_SIGRID_MOUNT       := 30159;
SET @QUEST_CARNAGE          := 13217;
SET @NPC_CARNAGE_13217      := 31271;
SET @QUEST_THANE            := 13218;
SET @NPC_THANE_13218        := 31277;
SET @QUEST_FINCHAL          := 13219;
SET @NPC_PRINCESAND_13219   := 14688;
SET @NPC_GENERIC_BUNNY      := 24110;
SET @CHEER_SOUND            := 14998;
SET @KILL_13214             := 20;
SET @WIPE_13214             := 19;
SET @CREDIT_13214           := 1;
SET @CREDIT_13215           := 2;
SET @CREDIT_13216           := 3;
SET @CREDIT_13217           := 4;
SET @CREDIT_13218           := 5;
SET @CREDIT_13219           := 6;
SET @DESPAWN_13219          := 7;
-- Quest Progression
UPDATE `creature_template` SET `InhabitType` = 4 WHERE `entry` = 31135;
UPDATE `quest_template` SET `PrevQuestId`=13213 WHERE `Id`=13214;
UPDATE `quest_template` SET `PrevQuestId`=13214 WHERE `Id`=13215;
UPDATE `quest_template` SET `PrevQuestId`=13215 WHERE `Id`=13216;
UPDATE `quest_template` SET `PrevQuestId`=13216 WHERE `Id`=13217;
UPDATE `quest_template` SET `PrevQuestId`=13217 WHERE `Id`=13218;
UPDATE `quest_template` SET `PrevQuestId`=13218 WHERE `Id`=13219;
-- Proper template data
UPDATE `creature_template` SET `minlevel`=80, `maxlevel`=80, `mindmg`=311, `maxdmg`=474, `attackpower`=478, `minrangedmg`=344, `maxrangedmg`=490, `rangedattackpower`=80 WHERE `entry`=31242;
UPDATE `creature_template` SET `minlevel`=80, `maxlevel`=80, `mindmg`=417, `maxdmg`=582, `attackpower`=608, `minrangedmg`=341, `maxrangedmg`=506, `rangedattackpower`=80  WHERE  `entry`=31271;
UPDATE `creature_template` SET `minlevel`=80, `maxlevel`=80, `mindmg`=445, `maxdmg`=621, `attackpower`=642, `minrangedmg`=289, `maxrangedmg`=381, `rangedattackpower`=69 WHERE  `entry`=31277;
UPDATE `creature_template` SET `mindmg`=217, `maxdmg`=389, `attackpower`=357, `minrangedmg`=211, `maxrangedmg`=378, `rangedattackpower`=80 WHERE  `entry`=31192;
UPDATE `creature_template` SET `mindmg`=299, `maxdmg`=411, `attackpower`=394, `minrangedmg`=373, `maxrangedmg`=541, `rangedattackpower`=69 WHERE  `entry`=31193;
UPDATE `creature_template` SET `mindmg`=254, `maxdmg`=371, `attackpower`=294, `minrangedmg`=344, `maxrangedmg`=490, `rangedattackpower`=80 WHERE  `entry`=31194;
UPDATE `creature_template` SET `mindmg`=417, `maxdmg`=682, `attackpower`=608, `minrangedmg`=341, `maxrangedmg`=506, `rangedattackpower`=80 WHERE  `entry`=31196;
 -- Template updates for creature 31191 (Father Jhadras)
UPDATE `creature_template` SET `faction_A`=21,`faction_H`=21,`unit_flags`=`unit_flags`|32768 WHERE `entry`=31191; -- Father Jhadras
-- Equipment of 31191 (Father Jhadras)
DELETE FROM `creature_equip_template` WHERE `entry`=31191;
INSERT INTO `creature_equip_template` (`entry`,`id`,`itemEntry1`,`itemEntry2`,`itemEntry3`) VALUES 
(31191,1,13220,0,0);
-- Model data 27584 (creature 31191 (Father Jhadras))
UPDATE `creature_model_info` SET `bounding_radius`=0.173611,`combat_reach`=0.75,`gender`=0 WHERE `modelid`=27584; -- Father Jhadras
-- Addon data for creature 31191 (Father Jhadras)
DELETE FROM `creature_template_addon` WHERE `entry`=31191;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(31191,0,0,1,0, NULL); -- Father Jhadras
-- Template updates for creature 31193 (Geness Half-Soul)
UPDATE `creature_template` SET `faction_A`=21,`faction_H`=21,`unit_flags`=`unit_flags`|32768 WHERE `entry`=31193; -- Geness Half-Soul
-- Model data 27580 (creature 31193 (Geness Half-Soul))
UPDATE `creature_model_info` SET `bounding_radius`=0.1909721,`combat_reach`=0.825,`gender`=0 WHERE `modelid`=27580; -- Geness Half-Soul
-- Addon data for creature 31193 (Geness Half-Soul)
DELETE FROM `creature_template_addon` WHERE `entry`=31193;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(31193,0,0,1,0, NULL); -- Geness Half-Soul
-- Template updates for creature 31192 (Masud)
UPDATE `creature_template` SET `faction_A`=21,`faction_H`=21,`unit_flags`=`unit_flags`|32768 WHERE `entry`=31192; -- Masud
-- Equipment of 31192 (Masud)
DELETE FROM `creature_equip_template` WHERE `entry`=31192;
INSERT INTO `creature_equip_template` (`entry`,`id`,`itemEntry1`,`itemEntry2`,`itemEntry3`) VALUES 
(31192,1,30388,0,0);
-- Model data 27582 (creature 31192 (Masud))
UPDATE `creature_model_info` SET `bounding_radius`=0.2951387,`combat_reach`=1.275,`gender`=0 WHERE `modelid`=27582; -- Masud
-- Addon data for creature 31192 (Masud)
DELETE FROM `creature_template_addon` WHERE `entry`=31192;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(31192,0,0,1,0, NULL); -- Masud
-- Template updates for creature 31196 (Rith)
UPDATE `creature_template` SET `faction_A`=21,`faction_H`=21,`unit_flags`=`unit_flags`|32768 WHERE `entry`=31196; -- Rith
-- Equipment of 31196 (Rith)
DELETE FROM `creature_equip_template` WHERE `entry`=31196;
INSERT INTO `creature_equip_template` (`entry`,`id`,`itemEntry1`,`itemEntry2`,`itemEntry3`) VALUES 
(31196,1,29631,0,0);
-- Model data 27583 (creature 31196 (Rith))
UPDATE `creature_model_info` SET `bounding_radius`=0.2083332,`combat_reach`=0.9,`gender`=0 WHERE `modelid`=27583; -- Rith
-- Addon data for creature 31196 (Rith)
DELETE FROM `creature_template_addon` WHERE `entry`=31196;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(31196,0,0,1,0, NULL); -- Rith
-- Template updates for creature 31194 (Talla)
UPDATE `creature_template` SET `faction_A`=21,`faction_H`=21,`unit_flags`=`unit_flags`|32768,`unit_class`=4 WHERE `entry`=31194; -- Talla
-- Equipment of 31194 (Talla)
DELETE FROM `creature_equip_template` WHERE `entry`=31194;
INSERT INTO `creature_equip_template` (`entry`,`id`,`itemEntry1`,`itemEntry2`,`itemEntry3`) VALUES 
(31194,1,34283,0,0);
-- Model data 27906 (creature 31194 (Talla))
UPDATE `creature_model_info` SET `bounding_radius`=0.1562499,`combat_reach`=0.675,`gender`=0 WHERE `modelid`=27906; -- Talla
-- Addon data for creature 31194 (Talla)
DELETE FROM `creature_template_addon` WHERE `entry`=31194;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(31194,0,0,1,0, NULL); -- Talla
-- Template updates for creature 31222 (Khit'rix the Dark Master)
UPDATE `creature_template` SET `faction_A`=21,`faction_H`=21,`unit_flags`=`unit_flags`|33600 WHERE `entry`=31222;
-- Khit'rix the Dark Master
-- Model data 25269 (creature 31222 (Khit'rix the Dark Master))
UPDATE `creature_model_info` SET `bounding_radius`=1.24,`combat_reach`=4,`gender`=0 WHERE `modelid`=25269; -- Khit'rix the Dark Master
-- Addon data for creature 31222 (Khit'rix the Dark Master)
DELETE FROM `creature_template_addon` WHERE `entry`=31222;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(31222,0,0,1,0, NULL); -- Khit'rix the Dark Master
-- Template updates for creature 31242 (Sigrid Iceborn)
UPDATE `creature_template` SET `faction_A`=14,`faction_H`=14,`exp`=2,`minlevel`=80,`maxlevel`=80,`unit_flags`=`unit_flags`|33600 WHERE `entry`=31242; -- Sigrid Iceborn
-- Equipment of 31242 (Sigrid Iceborn)
DELETE FROM `creature_equip_template` WHERE `entry`=31242;
INSERT INTO `creature_equip_template` (`entry`,`id`,`itemEntry1`,`itemEntry2`,`itemEntry3`) VALUES 
(31242,1,40436,0,0);
-- Model data 27528 (creature 31242 (Sigrid Iceborn))
UPDATE `creature_model_info` SET `bounding_radius`=0.465,`combat_reach`=1.5,`gender`=1 WHERE `modelid`=27528;
-- Sigrid Iceborn
-- Addon data for creature 31242 (Sigrid Iceborn)
DELETE FROM `creature_template_addon` WHERE `entry`=31242;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(31242,0,0,1,0, ''); 
-- Sigrid Iceborn
UPDATE `creature_template` SET `speed_run`=3.14286 WHERE  `entry`=30159; 
-- Sigrid Iceborn's Proto Drake
DELETE FROM `creature_template_addon` WHERE `entry`=30159;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(30159,0,33554432,1,0, ''); -- Addon data for creature 30159 (Sigrid Iceborn's Proto Drake)
-- Template updates for creature 31271 (Carnage)
UPDATE `creature_template` SET `faction_A`=14,`faction_H`=14,`exp`=2,`minlevel`=80,`maxlevel`=80,`unit_flags`=`unit_flags`|33600 WHERE `entry`=31271; -- Carnage
-- Model data 24301 (creature 31271 (Carnage))
UPDATE `creature_model_info` SET `bounding_radius`=0.62,`combat_reach`=9,`gender`=0 WHERE `modelid`=24301; -- Carnage
-- Addon data for creature 31271 (Carnage)
DELETE FROM `creature_template_addon` WHERE `entry`=31271;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(31271,0,0,1,0, NULL); -- Carnage
-- Template updates for creature 31277 (Thane Banahogg)
UPDATE `creature_template` SET `faction_A`=2116,`faction_H`=2116,`exp`=2,`minlevel`=80,`maxlevel`=80,`unit_flags`=`unit_flags`|33600,`speed_walk`=1.6,`speed_run`=1.71429 WHERE `entry`=31277; -- Thane Banahogg
-- Equipment of 31277 (Thane Banahogg)
DELETE FROM `creature_equip_template` WHERE `entry`=31277;
INSERT INTO `creature_equip_template` (`entry`,`id`,`itemEntry1`,`itemEntry2`,`itemEntry3`) VALUES 
(31277,1,43578,0,0);
-- Model data 27551 (creature 31277 (Thane Banahogg))
UPDATE `creature_model_info` SET `bounding_radius`=0.6076385,`combat_reach`=2.625,`gender`=0 WHERE `modelid`=27551; -- Thane Banahogg
-- Addon data for creature 31277 (Thane Banahogg)
DELETE FROM `creature_template_addon` WHERE `entry`=31277;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(31277,0,0,1,0, NULL); -- Thane Banahogg
-- Template updates for creature 14688 (Prince Sandoval)
UPDATE `creature_template` SET `faction_A`=21,`faction_H`=21,`unit_flags`=`unit_flags`|33600,`speed_walk`=2,`speed_run`=2.14286 WHERE `entry`=14688; -- Prince Sandoval
-- Equipment of 14688 (Prince Sandoval)
DELETE FROM `creature_equip_template` WHERE `entry`=14688;
INSERT INTO `creature_equip_template` (`entry`,`id`,`itemEntry1`,`itemEntry2`,`itemEntry3`) VALUES 
(14688,1,31311,0,0);
-- Model data 27555 (creature 14688 (Prince Sandoval))
UPDATE `creature_model_info` SET `bounding_radius`=0.62,`combat_reach`=2,`gender`=0 WHERE `modelid`=27555; -- Prince Sandoval
-- Addon data for creature 14688 (Prince Sandoval)
DELETE FROM `creature_template_addon` WHERE `entry`=14688;
INSERT INTO `creature_template_addon` (`entry`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(14688,0,0,0,0, NULL); -- Prince Sandoval

UPDATE `creature_template` SET `faction_A`=16, `faction_H`=16, `AIName`='SmartAI' WHERE `entry` IN (@NPC_ELDRETH_13214, @NPC_GENESS_13214, @NPC_JHADRAS_13214, @NPC_MASUD_13214, @NPC_TALLA_13214, @NPC_RITH_13214);
DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_ELDRETH_13214 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_ELDRETH_13214, 0, 0, 0, 0, 0, 80, 0, 0, 0, 6000, 12000, 11, 34829, 2, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Eldreth - IC - Cast Arcane Shot'),
(@NPC_ELDRETH_13214, 0, 1, 0, 0, 0, 80, 0, 10000, 20000, 10000, 20000, 11, 44475, 2, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Eldreth - IC - Cast Magic Dampening Field'),
(@NPC_ELDRETH_13214, 0, 2, 0, 9, 0, 80, 0, 5, 30, 3000, 6000, 11, 15620, 2, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Eldreth - On  range - Cast Shoot'),
(@NPC_ELDRETH_13214, 0, 3, 0, 6, 0, 100, 1, 0, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 11, @NPC_GENERIC_BUNNY, 100, 0, 0, 0, 0, 0, 'Eldreth - On  death - Set Data'),
(@NPC_ELDRETH_13214, 0, 4, 0, 21, 0, 100, 0, 0, 0, 0, 0, 41, 1000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Eldreth - On  reach home - Despawn self'),
(@NPC_ELDRETH_13214, 0, 5, 0, 21, 0, 100, 0, 0, 0, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Eldreth - On  reach home - Set Data'),
(@NPC_ELDRETH_13214, 0, 6, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0,0, 0, 0, 'Eldreth - On  kill target - Set Data');

DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_GENESS_13214 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_GENESS_13214, 0, 0, 0, 0, 0, 80, 0, 2000, 6000, 3000, 7000, 11, 61041, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Geness Half-Soul - IC - Cast Brutal Fist'),
(@NPC_GENESS_13214, 0, 1, 0, 13, 0, 80, 0, 10000, 15000, 0, 0, 11, 46182, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Geness Half-Soul - On  target Cast - Cast Snap Kick'),
(@NPC_GENESS_13214, 0, 2, 0, 6, 0, 100, 1, 0, 0, 0, 0, 45, 2, 2, 0, 0, 0, 0, 11, @NPC_GENERIC_BUNNY, 100, 0, 0, 0, 0, 0, 'Geness Half-Soul - On  death - Set Data'),
(@NPC_GENESS_13214, 0, 3, 0, 21, 0, 100, 0, 0, 0, 0, 0, 41, 1000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Geness Half-Soul - On  reach home - Despawn self'),
(@NPC_GENESS_13214, 0, 4, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Geness Half-Soul - On  kill target - Set Data'),
(@NPC_GENESS_13214, 0, 5, 0, 21, 0, 100, 0, 0, 0, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Geness Half-Soul - On  reach home - Set Data');

DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_JHADRAS_13214 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_JHADRAS_13214, 0, 0, 0, 14, 0, 80, 0, 50, 40, 10000, 30000, 11, 15586, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Father Jhadras - On  friendly hp deficit - Cast Heal'),
(@NPC_JHADRAS_13214, 0, 1, 0, 0, 0, 80, 0, 0, 3000, 8000, 12000, 11, 25054, 0, 0, 0, 0, 0, 5, 0, 0, 40, 0, 0, 0, 0, 'Father Jhadras - IC - Cast Holy Smite'),
(@NPC_JHADRAS_13214, 0, 2, 0, 6, 0, 100, 1, 0, 0, 0, 0, 45, 3, 3, 0, 0, 0, 0, 11, @NPC_GENERIC_BUNNY, 100, 0, 0, 0, 0, 0, 'Father Jhadras - On   death - Set Data'),
(@NPC_JHADRAS_13214, 0, 3, 0, 21, 0, 100, 0, 0, 0, 0, 0, 41, 5000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Father Jhadras - On  reach home - Despawn self'),
(@NPC_JHADRAS_13214, 0, 4, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Father Jhadras - On  kill target - Set Data'),
(@NPC_JHADRAS_13214, 0, 5, 0, 21, 0, 100, 0, 0, 0, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0,0, 'Father Jhadras - On  reach home - Set Data');

DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_MASUD_13214 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_MASUD_13214, 0, 0, 0, 0, 0, 80, 0, 0, 0, 15000, 25000, 11, 41056, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Masud - IC - Cast Whirlwind'),
(@NPC_MASUD_13214, 0, 1, 0, 0, 0, 80, 0, 0, 0, 10000, 20000, 11, 15496, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Masud - IC - Cast Cleave'),
(@NPC_MASUD_13214, 0, 2, 0, 6, 0, 100, 1, 0, 0, 0, 0, 45, 4, 4, 0, 0, 0, 0, 11, @NPC_GENERIC_BUNNY, 100, 0, 0, 0, 0, 0, 'Masud - On  death - Set Data'),
(@NPC_MASUD_13214, 0, 3, 0, 21, 0, 100, 0, 0, 0, 0, 0, 41, 1000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Masud - On  reach home - Despawn self'),
(@NPC_MASUD_13214, 0, 4, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Masud - On  kill target - Set Data'),
(@NPC_MASUD_13214, 0, 5, 0, 21, 0, 100, 0, 0, 0, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0,0, 'Masud - On  reach home - Set Data');

DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_RITH_13214 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_RITH_13214, 0, 0, 0, 0, 0, 80, 0, 0, 0, 10000, 20000, 11, 61044, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Rith - IC - Cast Demoralizing Shout'),
(@NPC_RITH_13214, 0, 1, 0, 0, 0, 80, 0, 0, 0, 20000, 30000, 11, 58461, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Rith - IC - Cast Sunder Armor'),
(@NPC_RITH_13214, 0, 2, 0, 6, 0, 100, 1, 0, 0, 0, 0, 45, 5, 5, 0, 0, 0, 0, 11, @NPC_GENERIC_BUNNY, 100, 0, 0, 0, 0, 0, 'Rith - On  death - Set Data'),
(@NPC_RITH_13214, 0, 3, 0, 21, 0, 100, 0, 0, 0, 0, 0, 41, 1000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Rith - On  reach home - Despawn self'),
(@NPC_RITH_13214, 0, 4, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Rith - On  kill target - Set Data'),
(@NPC_RITH_13214, 0, 5, 0, 21, 0, 100, 0, 0, 0, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0,0, 'Rith - On  reach home - Set Data');

DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_TALLA_13214 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_TALLA_13214, 0, 0, 0, 0, 0, 80, 0, 0, 0, 5000, 15000, 11, 14873, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Talla - IC - Cast Sinister Strike '),
(@NPC_TALLA_13214, 0, 1, 0, 0, 0, 80, 0, 0, 0, 20000, 25000, 11, 30981, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Talla - IC - Cast Crippling PoisOn  '),
(@NPC_TALLA_13214, 0, 2, 0, 6, 0, 100, 1, 0, 0, 0, 0, 45, 6, 6, 0, 0, 0, 0, 11, @NPC_GENERIC_BUNNY, 100, 0, 0, 0, 0, 0, 'Talla - On  death - Set Data'),
(@NPC_TALLA_13214, 0, 3, 0, 21, 0, 100, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Talla - On  reach home - Despawn self'),
(@NPC_TALLA_13214, 0, 4, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Talla - On  kill target - Set Data'),
(@NPC_TALLA_13214, 0, 5, 0, 21, 0, 100, 0, 0, 0, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0,0, 'Talla - On  reach home - Set Data');

UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@NPC_GENERIC_BUNNY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_GENERIC_BUNNY AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_GENERIC_BUNNY, 0, 0, 0, 38, 0, 100, 1, 1, 1, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kill trigger - On  data set - increment phase 1(1)'),
(@NPC_GENERIC_BUNNY, 0, 1, 0, 38, 0, 100, 1, 2, 2, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kill trigger - On  data set - increment phase 2(2)'),
(@NPC_GENERIC_BUNNY, 0, 2, 0, 38, 0, 100, 1, 3, 3, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kill trigger - On  data set - increment phase 3(4)'),
(@NPC_GENERIC_BUNNY, 0, 3, 0, 38, 0, 100, 1, 4, 4, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kill trigger - On  data set - increment phase 4(8)'),
(@NPC_GENERIC_BUNNY, 0, 4, 0, 38, 0, 100, 1, 5, 5, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kill trigger - On  data set - increment phase 5(16)'),
(@NPC_GENERIC_BUNNY, 0, 5, 0, 38, 0, 100, 1, 6, 6, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kill trigger - On  data set - increment phase 6(32)'),
(@NPC_GENERIC_BUNNY, 0, 6, 7, 1, 32, 100, 1, 0, 0, 0, 0, 45, @CREDIT_13214, @CREDIT_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Kill trigger - On  phase 6(32) - Set Data'),
(@NPC_GENERIC_BUNNY, 0, 7, 0, 61, 32, 100, 0, 0, 0, 0, 0, 78, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Kill trigger - On  phase 6(32) - Set Phase 0');

UPDATE `creature_template` SET `faction_A`=16, `faction_H`=16, `AIName`='SmartAI', `unit_flags`=0 WHERE `entry`=@NPC_KHITRIX_13215;
DELETE FROM `creature_text` WHERE `entry`=@NPC_KHITRIX_13215;
INSERT INTO `creature_text` VALUES
(@NPC_KHITRIX_13215,0,0,'When I am done here, I am going to mount your heads upon the walls of Azjol-Nerub!',14,0,0,0,0,0,'Dark Master say 1');

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_KHITRIX_13215, @NPC_KHITRIX_13215*100);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_KHITRIX_13215, 0, 0, 0, 0, 0, 80, 0, 0, 0, 10000, 20000, 11, 38243, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Khitrix the Dark Master - IC - Cast Mind Flay'),
(@NPC_KHITRIX_13215, 0, 1, 0, 0, 0, 80, 0, 5000, 25000, 5000, 25000, 11, 22884, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Khitrix the Dark Master - IC - Cast Psychic Scream'),
(@NPC_KHITRIX_13215, 0, 2, 0, 0, 0, 80, 0, 10000, 15000, 120000, 180000, 11, 61055, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Khitrix the Dark Master - IC - Cast Bone Spiders'),
(@NPC_KHITRIX_13215, 0, 3, 0, 54, 0, 100, 0, 0, 0, 0, 0, 80, @NPC_KHITRIX_13215*100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Khitrix the Dark Master - On  summon - Call script 1'),
--
(@NPC_KHITRIX_13215*100, 9, 0, 0, 1, 0, 100, 0, 0, 0, 0, 0, 69, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 8197.6045, 3502.557, 625.108032, 0.585, 'Khitrix the Dark Master - OOC script 1 - Move to position'),
(@NPC_KHITRIX_13215*100, 9, 1, 0, 1, 0, 100, 1, 4000, 4000, 0, 0, 1, 0, 10, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Khitrix the Dark Master - OOC script 1 - Say 1'),
--
(@NPC_KHITRIX_13215, 0, 5, 0, 1, 0, 100, 0, 500, 500, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 50, 0, 0, 0, 0, 0, 0, 'Khitrix the Dark Master - OOC - Start Attack'),
(@NPC_KHITRIX_13215, 0, 6, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Khitrix the Dark Master - On Kill target - Set Data'),
(@NPC_KHITRIX_13215, 0, 7, 0, 6, 0, 100, 0, 0, 0, 1, 0, 45, @CREDIT_13215, @CREDIT_13215, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Khitrix the Dark Master - On Death - Set Data'),
(@NPC_KHITRIX_13215, 0, 8, 0, 1, 0, 100, 1, 30000, 30000, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Khitrix the Dark Master - OOC - Set Data');

UPDATE `creature_template` SET `exp`=0, `mindmg`=200, `maxdmg`=300, `dmg_multiplier`=2, `AIName`='SmartAI',`Health_mod`=1 WHERE `entry`=@NPC_BONESPIDER_13215;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_BONESPIDER_13215 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_BONESPIDER_13215, 0, 0, 0, 0, 0, 80, 0, 0, 0, 10000, 20000, 11, 744, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Bone spiders - IC - Cast Poison'),
(@NPC_BONESPIDER_13215, 0, 1, 0, 1, 0, 100, 0, 500, 500, 0, 0, 49, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Bone Spiders - OOC - Start Attack Random Player');

DELETE FROM `creature_text` WHERE `entry` IN (@NPC_SIGRID_13216);
INSERT INTO `creature_text` VALUES
(@NPC_SIGRID_13216,0,0,'Ah, there you are! Remember me? Of course you do! Wait right there, I''m coming down.',14,0,0,0,0,0,'Sigrid Iceborn say 1'),
(@NPC_SIGRID_13216,1,0,'I told you I''d be better prepared when next we met. I''ve fought and won the Hyldsmeet, trained at Valkyrion, and here I am.  Come and get some!',14,0,0,0,0,0,'Sigrid Iceborn say 2');

-- Sigrid Flight WP's
DELETE FROM `waypoints` WHERE entry =@NPC_SIGRID_MOUNT;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `point_comment`) VALUES
(@NPC_SIGRID_MOUNT, 1, 8258.836, 3599.048, 677.6457, ''),
(@NPC_SIGRID_MOUNT, 2, 8258.059, 3598.419, 677.6457, ''),
(@NPC_SIGRID_MOUNT, 3, 8217.432, 3554.571, 677.6457, ''),
(@NPC_SIGRID_MOUNT, 4, 8169.096, 3473.421, 677.6457, ''),
(@NPC_SIGRID_MOUNT, 5, 8200.269, 3417.768, 673.563, ''),
(@NPC_SIGRID_MOUNT, 6, 8281.517, 3453.952, 673.535, ''),
(@NPC_SIGRID_MOUNT, 7, 8278.022, 3504.947, 677.6457, ''),
(@NPC_SIGRID_MOUNT, 8, 8222.471, 3532.925, 631.09, ''),
(@NPC_SIGRID_MOUNT, 9, 8222.471, 3532.925, 631.09, '');

UPDATE `creature_template` SET `InhabitType` =1 WHERE `entry` =@NPC_SIGRID_13216;
UPDATE `creature_template` SET `InhabitType` =7 WHERE `entry` =@NPC_SIGRID_MOUNT;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`IN (@NPC_SIGRID_13216,@NPC_SIGRID_MOUNT);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_SIGRID_13216, @NPC_SIGRID_13216*100,@NPC_SIGRID_MOUNT);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_SIGRID_13216, 0, 0, 0, 9, 0, 80, 0, 0, 2, 15000, 30000, 11, 57635, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On  range - Cast Disengage'),
(@NPC_SIGRID_13216, 0, 1, 2, 9, 0, 80, 0, 0, 3, 10000, 30000, 11, 61170, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - IC - Cast Flash Freeze'),
(@NPC_SIGRID_13216, 0, 2, 0, 61, 0, 80, 0, 0, 0, 0, 0, 89, 30, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On Link - Set Random Movement'),
(@NPC_SIGRID_13216, 0, 3, 0, 1, 0, 100, 1, 0, 0, 0, 0, 11, 61165, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - IC - Cast Frostbite Weapon'),
(@NPC_SIGRID_13216, 0, 4, 0, 9, 0, 80, 0, 5, 30, 5000, 25000, 11, 61168, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On  range - Cast Throw'),
(@NPC_SIGRID_13216, 0, 5, 0, 9, 0, 100, 0, 30, 100, 0, 0, 21, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - Start Moving - Not in Throw Range'),
(@NPC_SIGRID_13216, 0, 6, 0, 9, 0, 100, 0, 9, 15, 0, 0, 21, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - In Range - Stop Moving at 15 Yard'),
(@NPC_SIGRID_13216, 0, 7, 0, 9, 0, 100, 0, 0, 5, 0, 0, 21, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - Start Moving - Not in Throw Range'),
(@NPC_SIGRID_13216, 0, 8, 0, 9, 0, 100, 0, 5, 30, 0, 0, 21, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - Stop Moving - In Throw Range'),
(@NPC_SIGRID_13216, 0, 9, 0, 54, 0, 100, 0, 0, 0, 0, 0, 80, @NPC_SIGRID_13216*100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On  summon  - Call script 1'),
--
(@NPC_SIGRID_13216*100, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 2000, 2000, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On  summon  script 1 - Say 1'),
--
(@NPC_SIGRID_13216, 0, 10, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On  kill target - Set Data'),
(@NPC_SIGRID_13216, 0, 11, 0, 6, 0, 100, 0, 0, 0, 1, 0, 45, @CREDIT_13216, @CREDIT_13216, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On  death - Set Data'),
(@NPC_SIGRID_13216, 0, 12, 0, 1, 0, 100, 1, 30000, 30000, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Sigrid Iceborn - OOC - Set Data'),
--
(@NPC_SIGRID_MOUNT, 0, 0, 0, 27, 0, 100, 0, 0, 0, 0, 0, 53, 1, @NPC_SIGRID_MOUNT, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn Mount - On Respawn - Start WP movement'),
(@NPC_SIGRID_MOUNT, 0, 1, 2, 40, 0, 100, 1, 9, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn Mount - On WP reached - Despawn'),
(@NPC_SIGRID_MOUNT, 0, 2, 0, 61, 0, 100, 1, 9, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 11, @NPC_SIGRID_13216, 20, 0, 0, 0, 0, 0, 'Sigrid Iceborn Mount - On WP reached - Set Data on Sigrid'),
--
(@NPC_SIGRID_13216, 0, 13, 14, 54, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_SIGRID_MOUNT, 7, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On Link - Summon Mount'),
(@NPC_SIGRID_13216, 0, 14, 0, 61, 0, 100, 0, 0, 0, 0, 0, 11, 46598, 7, 0, 0, 0, 0, 11, @NPC_SIGRID_MOUNT, 100, 0, 0, 0, 0, 0, 'Sigrid Iceborn  - On Link - Mount Sigrid''s Proto Drake'),
(@NPC_SIGRID_13216, 0, 15, 16, 38, 0, 100, 1, 1, 1, 0, 0, 101, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On WP reached - Start Attack'),
(@NPC_SIGRID_13216, 0, 16, 17, 61, 0, 100, 1, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 50, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On WP reached - Start Attack'),
(@NPC_SIGRID_13216, 0, 17, 0, 61, 0, 100, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Sigrid Iceborn - On Link - Say 2');

UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@NPC_CARNAGE_13217;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_CARNAGE_13217, @NPC_CARNAGE_13217*100);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_CARNAGE_13217, 0, 1, 0, 0, 0, 80, 0, 10000, 30000, 20000, 40000, 11, 61065, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Carnage - IC - Cast War Stomp'),
(@NPC_CARNAGE_13217, 0, 2, 0, 0, 0, 80, 0, 5000, 12000, 5000, 12000, 11, 61070, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Carnage - IC - Cast Smash'),
(@NPC_CARNAGE_13217, 0, 3, 0, 54, 0, 100, 0, 0, 0, 0, 0, 80, @NPC_CARNAGE_13217*100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Carnage - On  summon - Call script 1'),
--
(@NPC_CARNAGE_13217*100, 9, 0, 0, 1, 0, 100, 1, 0, 0, 0, 0, 69, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 8193.264648, 3496.165771, 625.067322, 0.746269, 'Carnage - OOC script 1 - Move to position'),
--
(@NPC_CARNAGE_13217, 0, 4, 0, 1, 0, 100, 0, 5000, 5000, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 70, 0, 0, 0, 0, 0, 0, 'Carnage - OOC - Start Attack'),
(@NPC_CARNAGE_13217, 0, 5, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Carnage - On  kill target - Set Data'),
(@NPC_CARNAGE_13217, 0, 6, 0, 6, 0, 100, 0, 0, 0, 1, 0, 45, @CREDIT_13217, @CREDIT_13217, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Carnage - On  death - Set Data'),
(@NPC_CARNAGE_13217, 0, 7, 0, 1, 0, 100, 1,  30000, 30000, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Carnage - OOC - Set Data');

DELETE FROM `creature_text` WHERE `entry` IN (@NPC_THANE_13218);
INSERT INTO `creature_text` VALUES
(@NPC_THANE_13218,0,0,'ENOUGH! You tiny insects are not worthy to do battle within this sacred place!.',14,0,0,0,0,0,'Thane say 1'),
(@NPC_THANE_13218,1,0,'Fight me and die you cowards!',14,0,0,0,0,0,'Thane say 2'),
(@NPC_THANE_13218,2,0,'Haraak foln! ',12,0,0,0,0,0,'Thane say 3');

UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@NPC_THANE_13218;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_THANE_13218, @NPC_THANE_13218*100);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_THANE_13218, 0, 1, 0, 0, 0, 80, 0, 5000, 10000, 15000, 20000, 11, 13737, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Thane Banahogg - IC - Cast Mortal Strike'),
(@NPC_THANE_13218, 0, 2, 0, 0, 0, 80, 0, 5000, 10000, 5000, 10000, 11, 61133, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Thane Banahogg - IC - Cast Punt'),
(@NPC_THANE_13218, 0, 3, 0, 0, 0, 100, 0, 20000, 20000, 20000, 30000, 11, 61134, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Thane Banahogg - IC - Cast Leap'),
(@NPC_THANE_13218, 0, 5, 0, 12, 0, 100, 0, 0, 20, 5000, 10000, 11, 61140, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Thane Banahogg - On  %hp - Cast Execute'),
(@NPC_THANE_13218, 0, 6, 0, 54, 0, 100, 0, 0, 0, 0, 0, 80, @NPC_THANE_13218*100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Thane Banahogg - On  summon - call script 1'),
--
(@NPC_THANE_13218*100, 9, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Thane Banahogg - OOC script 1 - say 1'),
(@NPC_THANE_13218*100, 9, 1, 0, 0, 0, 100, 1, 5000, 5000, 0, 0, 97, 25, 30, 0, 0, 0, 0, 1, 0, 0, 0, 8169.0015, 3477.075, 626.4695, 0.673769, 'Thane Banahogg - OOC script 1 - Jump to position'),
(@NPC_THANE_13218*100, 9, 2, 0, 0, 0, 100, 1, 2000, 2000, 0, 0, 101, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Thane Banahogg - OOC script 1 - Set Home Pos'),
(@NPC_THANE_13218*100, 9, 3, 0, 0, 0, 100, 1, 1500, 1500, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Thane Banahogg - OOC script 1 - Say 2'),
(@NPC_THANE_13218*100, 9, 4, 0, 0, 0, 100, 1, 1000, 1000, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Thane Banahogg - OOC script 1 - Say 3'),
--
(@NPC_THANE_13218, 0, 8, 0, 1, 0, 100, 0, 12000, 12000, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 100, 0, 0, 0, 0, 0, 0, 'Thane Banahogg - OOC - Start Attack'),
(@NPC_THANE_13218, 0, 9, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Thane Banahogg - On  kill target - Set Data'),
(@NPC_THANE_13218, 0, 10, 0, 6, 0, 100, 0, 0, 0, 1, 0, 45, @CREDIT_13218, @CREDIT_13218, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Thane Banahogg - On  death - Set Data'),
(@NPC_THANE_13218, 0, 11, 0, 1, 0, 100, 1, 30000, 30000, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Thane Banahogg - OOC - Set Data');

DELETE FROM `creature_text` WHERE `entry` IN (@NPC_PRINCESAND_13219);
INSERT INTO `creature_text` VALUES
(@NPC_PRINCESAND_13219,0,0,'Hardly a fitting introduction , Spear-Wife. Now, who is this outsider that I''ve been hearing so much about?',14,0,0,0,0,0,'Prince Sandoval say 1'),
(@NPC_PRINCESAND_13219,1,0,'I will make this as easy as possible for you. Simply come here and die. That is all that I ask for your many trespasses. For your sullying this exlated place of battle. ',14,0,0,0,0,0,'Prince Sandoval say 2'),
(@NPC_PRINCESAND_13219,2,0,'FOR YOUR EFFRONTERY TO THE LICH KING!',14,0,0,0,0,0,'Prince Sandoval say 3');

UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@NPC_PRINCESAND_13219;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_PRINCESAND_13219, @NPC_PRINCESAND_13219*100);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_PRINCESAND_13219, 0, 0, 0, 0, 0, 80, 0, 0, 0, 10000, 20000, 11, 61162, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - IC - Cast Engulfing Strike'),
(@NPC_PRINCESAND_13219, 0, 1, 0, 0, 0, 80, 0, 15000, 20000, 30000, 30000, 11, 61163, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - IC - Cast Fire Nova'),
(@NPC_PRINCESAND_13219, 0, 2, 0, 0, 0, 100, 0, 30000, 30000, 30000, 30000, 11, 61144, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - IC - Cast Fire Shield'),
(@NPC_PRINCESAND_13219, 0, 3, 4, 0, 0, 100, 0, 31100, 31100, 30000, 30000, 11, 61145, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - IC - Cast Ember Shower'),
(@NPC_PRINCESAND_13219, 0, 4, 5, 61, 0, 100, 0, 0, 0, 0, 0, 21, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On Link - Change state'),
(@NPC_PRINCESAND_13219, 0, 5, 6, 61, 0, 100, 0, 0, 0, 0, 0, 18, 131077, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On Link - Change unit flag'),
(@NPC_PRINCESAND_13219, 0, 6, 0, 61, 0, 100, 0, 0, 0, 0, 0, 103, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On Link - Set Root'),
(@NPC_PRINCESAND_13219, 0, 7, 8, 0, 0, 100, 0, 45100, 45100, 30000, 30000, 19, 131077, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - IC - Change unit flag'),
(@NPC_PRINCESAND_13219, 0, 8, 9, 61, 0, 100, 0, 0, 0, 0, 0, 21, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On Link - Change state'),
(@NPC_PRINCESAND_13219, 0, 9, 10, 61, 0, 100, 0, 0, 0, 0, 0, 28, 61144, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On Link - Remove Fire Shield'),
(@NPC_PRINCESAND_13219, 0, 10, 11, 61, 0, 100, 0, 0, 0, 0, 0, 28, 61145, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On Link- Remove Ember Shower'),
(@NPC_PRINCESAND_13219, 0, 11, 0, 61, 0, 100, 0, 0, 0, 0, 0, 103, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On Link - Remove Root'),
(@NPC_PRINCESAND_13219, 0, 12, 0, 54, 0, 100, 0, 0, 0, 0, 0, 80, @NPC_PRINCESAND_13219*100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On  summon - Call script 1'),
(@NPC_PRINCESAND_13219, 0, 13, 0, 54, 0, 100, 0, 0, 0, 0, 0, 11, 4335, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On  summon - Cast Summon Smoke'),
--
(@NPC_PRINCESAND_13219*100, 9, 0, 0, 1, 0, 100, 1, 4000, 4000, 0, 0, 1, 1, 10, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - OOC script 1 - Say 1'),
(@NPC_PRINCESAND_13219*100, 9, 1, 0, 1, 0, 100, 1, 0, 0, 0, 0, 69, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 8197.6045, 3502.557, 625.108032, 0.585, 'Prince Sandoval - OOC script 1 - Move to position'),
(@NPC_PRINCESAND_13219*100, 9, 2, 0, 1, 0, 100, 1, 8000, 8000, 0, 0, 1, 2, 10, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - OOC script 1 - Say 2'),
--
(@NPC_PRINCESAND_13219, 0, 14, 0, 54, 0, 100, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - OOC script 1 - Say 3'),
(@NPC_PRINCESAND_13219, 0, 15, 0, 1, 0, 100, 0, 14000, 14000, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 100, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - OOC - Start Attack'),
(@NPC_PRINCESAND_13219, 0, 16, 0, 5, 0, 100, 0, 0, 0, 0, 0, 45, @KILL_13214, @KILL_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Prince Sandoval - On kill target - Set Data'),
(@NPC_PRINCESAND_13219, 0, 17, 0, 6, 0, 100, 0, 0, 0, 1, 0, 45, @CREDIT_13219, @CREDIT_13219, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Prince Sandoval - On death - Set Data'),
(@NPC_PRINCESAND_13219, 0, 18, 0, 1, 0, 100, 1,  30000,  30000, 0, 0, 45, @WIPE_13214, @WIPE_13214, 0, 0, 0, 0, 11, @NPC_GEIRRVIF, 100, 0, 0, 0, 0, 0, 'Prince Sandoval - OOC - Set Data'),
--
(@NPC_PRINCESAND_13219, 0, 19, 20, 1, 0, 100, 0, 0, 0, 0, 0, 19, 131077, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - OOC - Change state'),
(@NPC_PRINCESAND_13219, 0, 20, 21, 61, 0, 100, 0, 0, 0, 0, 0, 28, 61144, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On Link - Remove Fire Shield'),
(@NPC_PRINCESAND_13219, 0, 21, 22, 61, 0, 100, 0, 0, 0, 0, 0, 28, 61145, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On Link- Remove Ember Shower'),
(@NPC_PRINCESAND_13219, 0, 22, 0, 61, 0, 100, 0, 0, 0, 0, 0, 103, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Prince Sandoval - On Link - Remove Root');

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@NPC_GEIRRVIF;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_GEIRRVIF, @NPC_GEIRRVIF*100, @NPC_GEIRRVIF*100+1, @NPC_GEIRRVIF*100+2, @NPC_GEIRRVIF*100+3, @NPC_GEIRRVIF*100+4, @NPC_GEIRRVIF*100+5, @NPC_GEIRRVIF*100+6);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@NPC_GEIRRVIF, 0, 0, 0, 19, 0, 100, 0, @QUEST_FALLENHEROES, 0, 0, 0, 80, @NPC_GEIRRVIF*100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  accept quest 1 - Call script 1'),
--
(@NPC_GEIRRVIF*100, 9, 0, 0, 1, 0, 100, 1, 1000, 1000, 0, 0, 69, 8216, 3516, 653, 0, 0, 0, 8, 0, 0, 0, 8215.81, 3515.88, 652.885, 3.83972, 'Grieff - OOC script 1 - Move to position'),
(@NPC_GEIRRVIF*100, 9, 1, 0, 1, 0, 100, 1, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 1 - Change npc flag'),
(@NPC_GEIRRVIF*100, 9, 2, 0, 1, 0, 100, 1, 0, 0, 0, 0, 45, @DESPAWN_13214, @DESPAWN_13214, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 1 - Despawn corpse'),
(@NPC_GEIRRVIF*100, 9, 3, 0, 1, 0, 100, 1, 1000, 1000, 0, 0, 1, 0, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 1 - say 0'),
(@NPC_GEIRRVIF*100, 9, 4, 0, 1, 0, 100, 1, 4000, 4000, 0, 0, 1, 1, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 1 - say 1'),
(@NPC_GEIRRVIF*100, 9, 5, 0, 1, 0, 100, 1, 6000, 6000, 0, 0, 1, 2, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 1 - say 2'),
(@NPC_GEIRRVIF*100, 9, 6, 0, 1, 0, 100, 1, 5000, 5000, 0, 0, 1, 3, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 1 - say 3'),
(@NPC_GEIRRVIF*100, 9, 7, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_JHADRAS_13214, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8222, 3518, 625.162, 3.559, 'Grieff - OOC script 1 - Summon  Father Jhadras'),
(@NPC_GEIRRVIF*100, 9, 8, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_MASUD_13214, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8217, 3523, 624.908, 5.236, 'Grieff - OOC script 1 - Summon Masud'),
(@NPC_GEIRRVIF*100, 9, 9, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_GENESS_13214, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8210, 3517, 624.6, 6.143, 'Grieff - OOC script 1 - Summon Geness Half-Soul'),
(@NPC_GEIRRVIF*100, 9, 10, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_TALLA_13214, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8209, 3511, 625.117, 0.571, 'Grieff - OOC script 1 - Summon Talla'),
(@NPC_GEIRRVIF*100, 9, 11, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_ELDRETH_13214, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8198, 3517, 625.838, 0.089, 'Grieff - OOC script 1 - Summon Eldreth'),
(@NPC_GEIRRVIF*100, 9, 12, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_RITH_13214, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8200, 3507, 625.339, 0.514, 'Grieff - OOC script 1 - Summon Rith'),
--
(@NPC_GEIRRVIF, 0, 1, 2, 38, 0, 100, 0, @CREDIT_13214, @CREDIT_13214, 0, 0, 1, 4, 10, 0, 0, 1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  data set - Say 5'),
(@NPC_GEIRRVIF, 0, 2, 3, 61, 0, 100, 0, 0, 0, 0, 0, 69, 0, 0, 0, 0, 1, 0, 8, 0, 0, 0, 8216.25, 3516.23, 629.357, 3.83972, 'Grieff - On  linked - Move to position'),
(@NPC_GEIRRVIF, 0, 3, 4, 61, 0, 100, 0, 0, 0, 0, 0, 81, 3, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  linked - Change npc flag'),
(@NPC_GEIRRVIF, 0, 4, 0, 61, 0, 100, 0, 0, 0, 0, 0, 15, @QUEST_FALLENHEROES, 0, 0, 0, 0, 0, 18, 80, 0, 0, 0, 0, 0, 0, 'Grieff - On  linked - Kill credit'),
(@NPC_GEIRRVIF, 0, 5, 0, 19, 0, 100, 0, @QUEST_KDARKMASTER, 0, 0, 0, 80, @NPC_GEIRRVIF*100+1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  accept quest 2 - Call script 2'),
--
(@NPC_GEIRRVIF*100+1, 9, 0, 0, 1, 0, 100, 1, 1000, 1000, 0, 0, 69, 8216, 3516, 653, 0, 0, 0, 8, 0, 0, 0, 8215.81, 3515.88, 652.885, 3.83972, 'Grieff - OOC script 2 - Move to position'),
(@NPC_GEIRRVIF*100+1, 9, 1, 0, 1, 0, 100, 1, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 2 - Change npc flag'),
(@NPC_GEIRRVIF*100+1, 9, 2, 0, 1, 0, 100, 1, 0, 0, 0, 0, 45, @DESPAWN_13214, @DESPAWN_13214, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 2 - Despawn corpse'),
(@NPC_GEIRRVIF*100+1, 9, 3, 0, 1, 0, 100, 1, 1000, 1000, 0, 0, 1, 5, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 2 - say 5'),
(@NPC_GEIRRVIF*100+1, 9, 4, 0, 1, 0, 100, 1, 4000, 4000, 0, 0, 1, 6, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 2 - say 6'),
(@NPC_GEIRRVIF*100+1, 9, 5, 0, 1, 0, 100, 1, 6000, 6000, 0, 0, 1, 7, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 2 - say 7'),
(@NPC_GEIRRVIF*100+1, 9, 6, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_KHITRIX_13215, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8165, 3451, 627.199, 1.935, 'Grieff - OOC script 2 - Summon Khitrix the Dark Master'),
--
(@NPC_GEIRRVIF, 0, 6, 7, 38, 0, 100, 0, @CREDIT_13215, @CREDIT_13215, 0, 0, 1, 8, 10, 0, 0, 1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  data set - Say 8'),
(@NPC_GEIRRVIF, 0, 7, 8, 61, 0, 100, 0, 0, 0, 0, 0, 69, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 8216.25, 3516.23, 629.357, 3.83972, 'Grieff - On  linked - Move to position'),
(@NPC_GEIRRVIF, 0, 8, 9, 61, 0, 100, 0, 0, 0, 0, 0, 81, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  linked - Change npc flag'),
(@NPC_GEIRRVIF, 0, 9, 0, 61, 0, 100, 0, 0, 0, 0, 0, 15, @QUEST_KDARKMASTER, 0, 0, 0, 0, 0, 18, 80, 0, 0, 0, 0, 0, 0, 'Grieff - On  linked - Kill credit'),
(@NPC_GEIRRVIF, 0, 10, 0, 19, 0, 100, 0, @QUEST_SIGRIDICEBORN, 0, 0, 0, 80, @NPC_GEIRRVIF*100+2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  accept quest 3 - Call script 3'),
--
(@NPC_GEIRRVIF*100+2, 9, 0, 0, 1, 0, 100, 1, 1000, 1000, 0, 0, 69, 8216, 3516, 653, 0, 0, 0, 8, 0, 0, 0, 8215.81, 3515.88, 652.885, 3.83972, 'Grieff - OOC script 3 - Move to position'),
(@NPC_GEIRRVIF*100+2, 9, 1, 0, 1, 0, 100, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 3 - Change npc flag'),
(@NPC_GEIRRVIF*100+2, 9, 2, 0, 1, 0, 100, 1, 0, 0, 0, 0, 45, @DESPAWN_13214, @DESPAWN_13214, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 3 - Despawn corpse'),
(@NPC_GEIRRVIF*100+2, 9, 3, 0, 1, 0, 100, 1, 0, 0, 0, 0, 1, 9, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 3 - Say 9'),
(@NPC_GEIRRVIF*100+2, 9, 4, 0, 1, 0, 100, 1, 9000, 9000, 0, 0, 1, 10, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 3 - Say 10'),
(@NPC_GEIRRVIF*100+2, 9, 5, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_SIGRID_13216, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8258.836, 3599.048, 677.6457, 0.383, 'Grieff - OOC script 3 - summon Sigrid Iceborn'),
--
(@NPC_GEIRRVIF, 0, 11, 12, 38, 0, 100, 0, @CREDIT_13216, @CREDIT_13216, 0, 0, 1, 11, 10, 0, 0, 1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  data set - Say 11'),
(@NPC_GEIRRVIF, 0, 12, 13, 61, 0, 100, 0, 0, 0, 0, 0, 69, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 8216.25, 3516.23, 629.357, 3.83972, 'Grieff - On  linked - Move to position'),
(@NPC_GEIRRVIF, 0, 13, 14, 61, 0, 100, 0, 0, 0, 0, 0, 81, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  linked - Change npc flag'),
(@NPC_GEIRRVIF, 0, 14, 0, 61, 0, 100, 0, 0, 0, 0, 0, 15, @QUEST_SIGRIDICEBORN, 0, 0, 0, 0, 0, 18, 80, 0, 0, 0, 0, 0, 0, 'Grieff - On  linked - Kill credit'),
(@NPC_GEIRRVIF, 0, 15, 0, 19, 0, 100, 0, @QUEST_CARNAGE, 0, 0, 0, 80, @NPC_GEIRRVIF*100+3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  accept quest 4 - Call Script 4'),
--
(@NPC_GEIRRVIF*100+3, 9, 0, 0, 1, 0, 100, 1, 1000, 1000, 0, 0, 69, 8216, 3516, 653, 0, 0, 0, 8, 0, 0, 0, 8215.81, 3515.88, 652.885, 3.83972, 'Grieff - OOC script 4 - Move to position'),
(@NPC_GEIRRVIF*100+3, 9, 1, 0, 1, 0, 100, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 4 - Change npc flag'),
(@NPC_GEIRRVIF*100+3, 9, 2, 0, 1, 0, 100, 1, 0, 0, 0, 0, 45, @DESPAWN_13214, @DESPAWN_13214, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 4 - Despawn corpse'),
(@NPC_GEIRRVIF*100+3, 9, 3, 0, 1, 0, 100, 1, 0, 0, 0, 0, 1, 12, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 4 - say 13'),
(@NPC_GEIRRVIF*100+3, 9, 4, 0, 1, 0, 100, 1, 4000, 4000, 0, 0, 1, 13, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 4 - say 13'),
(@NPC_GEIRRVIF*100+3, 9, 5, 0, 1, 0, 100, 1, 6000, 6000, 0, 0, 1, 14, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 4 - say 14'),
(@NPC_GEIRRVIF*100+3, 9, 6, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_CARNAGE_13217, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8141.532715, 3488.100342, 626.986084, 3.662119, 'Grieff - OOC script 4 - summon Carnage'),
--
(@NPC_GEIRRVIF, 0, 16, 17, 38, 0, 100, 0, @CREDIT_13217, @CREDIT_13217, 0, 0, 1, 15, 10, 0, 0, 1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  data set - Say 15'),
(@NPC_GEIRRVIF, 0, 17, 18, 61, 0, 100, 0, 0, 0, 0, 0, 69, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 8216.25, 3516.23, 629.357, 3.83972, 'Grieff - On  linked - Move to position'),
(@NPC_GEIRRVIF, 0, 18, 19, 61, 0, 100, 0, 0, 0, 0, 0, 81, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  linked - Change npc flag'),
(@NPC_GEIRRVIF, 0, 19, 0, 61, 0, 100, 0, 0, 0, 0, 0, 15, @QUEST_CARNAGE, 0, 0, 0, 0, 0, 18, 80, 0, 0, 0, 0, 0, 0, 'Grieff - On Link - Kill credit'),
(@NPC_GEIRRVIF, 0, 20, 0, 19, 0, 100, 0, @QUEST_THANE, 0, 0, 0, 80, @NPC_GEIRRVIF*100+4, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  accept quest 5 - Call script 5'),
--
(@NPC_GEIRRVIF*100+4, 9, 0, 0, 1, 0, 100, 1, 1000, 1000, 0, 0, 69, 8216, 3516, 653, 0, 0, 0, 8, 0, 0, 0, 8215.81, 3515.88, 652.885, 3.83972, 'Grieff - OOC script 5 - Move to position'),
(@NPC_GEIRRVIF*100+4, 9, 1, 0, 1, 0, 100, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 5 - Change npc flag'),
(@NPC_GEIRRVIF*100+4, 9, 2, 0, 1, 0, 100, 1, 0, 0, 0, 0, 45, @DESPAWN_13214, @DESPAWN_13214, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 5 - Despawn corpse'),
(@NPC_GEIRRVIF*100+4, 9, 3, 0, 1, 0, 100, 1, 0, 0, 0, 0, 1, 16, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 5 - say 16'),
(@NPC_GEIRRVIF*100+4, 9, 4, 0, 1, 0, 100, 1, 4000, 4000, 0, 0, 1, 17, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 5 - say 17'),
(@NPC_GEIRRVIF*100+4, 9, 5, 0, 1, 0, 100, 1, 6000, 6000, 0, 0, 1, 18, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 5 - say 18'),
(@NPC_GEIRRVIF*100+4, 9, 6, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_THANE_13218, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8151.247559, 3462.894043, 672.115662, 0.6877, 'Grieff - OOC script 5 - summon Thane Banahogg'),
--
(@NPC_GEIRRVIF, 0, 21, 22, 38, 0, 100, 0, @CREDIT_13218, @CREDIT_13218, 0, 0, 1, 19, 10, 0, 0, 1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  data set - Say 19'),
(@NPC_GEIRRVIF, 0, 22, 23, 61, 0, 100, 0, 0, 0, 0, 0, 69, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 8216.25, 3516.23, 629.357, 3.83972, 'Grieff - On  linked - Move to position'),
(@NPC_GEIRRVIF, 0, 23, 24, 61, 0, 100, 0, 0, 0, 0, 0, 81, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  linked - Change npc flag'),
(@NPC_GEIRRVIF, 0, 24, 0, 61, 0, 100, 0, 0, 0, 0, 0, 15, @QUEST_THANE, 0, 0, 0, 0, 0, 18, 80, 0, 0, 0, 0, 0, 0, 'Grieff - On  linked - Kill credit'),
(@NPC_GEIRRVIF, 0, 25, 0, 19, 0, 100, 0, @QUEST_FINCHAL, 0, 0, 0, 80, @NPC_GEIRRVIF*100+5, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  accept quest 6 - Call script 6'),
--
(@NPC_GEIRRVIF*100+5, 9, 0, 0, 1, 0, 100, 1, 1000, 1000, 0, 0, 69, 8216, 3516, 653, 0, 0, 0, 8, 0, 0, 0, 8215.81, 3515.88, 652.885, 3.83972, 'Grieff - OOC script 6 - Move to position'),
(@NPC_GEIRRVIF*100+5, 9, 1, 0, 1, 0, 100, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 6 - Change npc flag'),
(@NPC_GEIRRVIF*100+5, 9, 2, 0, 1, 0, 100, 1, 0, 0, 0, 0, 45, @DESPAWN_13214, @DESPAWN_13214, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 6 - Despawn corpse'),
(@NPC_GEIRRVIF*100+5, 9, 3, 0, 1, 0, 100, 1, 0, 0, 0, 0, 1, 20, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 6 - Say 20'),
(@NPC_GEIRRVIF*100+5, 9, 4, 0, 1, 0, 100, 1, 6000, 6000, 0, 0, 1, 21, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 6 - Say 21'),
(@NPC_GEIRRVIF*100+5, 9, 5, 0, 1, 0, 100, 1, 6000, 6000, 0, 0, 1, 22, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 6 - Say 22'),
(@NPC_GEIRRVIF*100+5, 9, 6, 0, 1, 0, 100, 1, 6000, 6000, 0, 0, 1, 23, 10, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 6 - Say 23'),
(@NPC_GEIRRVIF*100+5, 9, 7, 0, 1, 0, 100, 1, 0, 0, 0, 0, 12, @NPC_PRINCESAND_13219, 7, 0, 0, 1, 0, 8, 0, 0, 0, 8182.54, 3489.78, 625.50519, 0.63625, 'Grieff - OOC script 6 - Summon Prince Sandoval'),
--
(@NPC_GEIRRVIF, 0, 26, 27, 38, 0, 100, 0, @CREDIT_13219, @CREDIT_13219, 0, 0, 80, @NPC_GEIRRVIF*100+6, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  data set - Call script 7'),
--
(@NPC_GEIRRVIF*100+6, 9, 0, 0, 1, 0, 100, 1, 0, 0, 0, 0, 1, 24, 10, 0, 0, 1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On data set - Say 24'),
(@NPC_GEIRRVIF*100+6, 9, 1, 0, 1, 0, 100, 0, 0, 0, 0, 0, 15, @QUEST_FINCHAL, 0, 0, 0, 0, 0, 18, 80, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 7 - Kill credit'),
(@NPC_GEIRRVIF*100+6, 9, 2, 0, 1, 0, 100, 1, 0, 0, 0, 0, 69, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 8216.25, 3516.23, 629.357, 3.83972, 'Grieff - On link - Move to position'),
(@NPC_GEIRRVIF*100+6, 9, 3, 0, 1, 0, 100, 1, 5000, 5000, 0, 0, 1, 25, 10, 0, 0, 1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 7 - Say 25'),
(@NPC_GEIRRVIF*100+6, 9, 4, 0, 1, 0, 100, 1, 6000, 6000, 0, 0, 1, 26, 10, 0, 0, 1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 7 - Say 26'),
(@NPC_GEIRRVIF*100+6, 9, 5, 0, 1, 0, 100, 1, 0, 0, 0, 0, 81, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - OOC script 7 - Change npc flag'),
--
(@NPC_GEIRRVIF, 0, 27, 0, 38, 0, 100, 0, @KILL_13214, @KILL_13214, 0, 0, 1, 27, 10, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Greiff - On  data set - Say kill'),
(@NPC_GEIRRVIF, 0, 28, 0, 38, 0, 100, 0, @WIPE_13214, @WIPE_13214, 0, 0, 69, 0, 0, 0, 0, 1, 0, 8, 0, 0, 0, 8216.25, 3516.23, 629.357, 3.83972, 'Grieff - On  data set - Move to position'),
(@NPC_GEIRRVIF, 0, 29, 0, 38, 0, 100, 0, @WIPE_13214, @WIPE_13214, 0, 0, 81, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  data set - Change npc flag'),
(@NPC_GEIRRVIF, 0, 30, 0, 38, 0, 100, 0, @WIPE_13214, @WIPE_13214, 0, 0, 78, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Grieff - On  data set - Script reset'),
(@NPC_GEIRRVIF, 0, 31, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_ELDRETH_13214, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse'),
(@NPC_GEIRRVIF, 0, 32, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_GENESS_13214, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse'),
(@NPC_GEIRRVIF, 0, 33, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_JHADRAS_13214, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse'),
(@NPC_GEIRRVIF, 0, 34, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_MASUD_13214, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse'),
(@NPC_GEIRRVIF, 0, 35, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_RITH_13214, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse'),
(@NPC_GEIRRVIF, 0, 36, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_TALLA_13214, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse'),
(@NPC_GEIRRVIF, 0, 37, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_KHITRIX_13215, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse'),
(@NPC_GEIRRVIF, 0, 38, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_SIGRID_13216, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse'),
(@NPC_GEIRRVIF, 0, 39, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_CARNAGE_13217, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse'),
(@NPC_GEIRRVIF, 0, 40, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_THANE_13218, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse'),
(@NPC_GEIRRVIF, 0, 41, 0, 38, 0, 100, 0, @DESPAWN_13219, @DESPAWN_13219, 0, 0, 41, 0, 0, 0, 0, 0, 0, 11, @NPC_PRINCESAND_13219, 200, 0, 0, 0, 0, 0, 'Grieff - On  data set - Despawn corpse');

DELETE FROM `creature_text` WHERE `entry`=@NPC_GEIRRVIF;
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES
(@NPC_GEIRRVIF, 0, 0, 'Valhalas is yours to win or die in, $N. But whatever you do, stay within the bounds of the arena. To flee is to lose and be dishonored.', 12, 0, 0, 0, 0, 0, 'Greiff quest 1 say 1'),
(@NPC_GEIRRVIF, 1, 1, '$N and $g his : her; comrades in arms have chosen to accept honorable combat within the sacred confines of Valhalas.', 14, 0, 0, 0, 0, 0, 'Greiff quest 1 say 2'),
(@NPC_GEIRRVIF, 2, 2, 'There can be only one outcome to such a battle: death for one side or the other. Let $N prove $g himself : herself; upon the bones of those outsiders who have fallen before!', 14, 0, 0, 0, 0, 0, 'Greiff quest 1 say 3'),
(@NPC_GEIRRVIF, 3, 3, 'The fallen heroes of Valhalas emerge from the ground to do battle once more!', 41, 0, 0, 0, 0, 14998, 'Greiff quest 1 say 4'),
(@NPC_GEIRRVIF, 4, 4, '$N has defeated the fallen heroes of Valhalas battles past. This is only a beginning, but it will suffice.', 14, 0, 0, 0, 0, 14998, 'Greiff quest 1 say 5'),
(@NPC_GEIRRVIF, 5, 5, 'Prepare yourself. Khit''rix will be entering Valhalas from the southeast. Remember, do not leave the ring or you will lose the battle.', 12, 0, 0, 0, 0, 0, 'Greiff quest 2 say 1'),
(@NPC_GEIRRVIF, 6, 6, '$N has accepted the challenge of Khit''rix the Dark Master. May the gods show mercy upon $g him : her; for Khit''rix surely will not.', 14, 0, 0, 0, 0, 0, 'Greiff quest 2 say 2'),
(@NPC_GEIRRVIF, 7, 7, 'Khit''rix the Dark Master skitters into Valhalas from the southeast!', 41, 0, 0, 0, 0, 14998, 'Greiff quest 2 say 3'),
(@NPC_GEIRRVIF, 8, 8, 'Khit''rix the Dark Master has been defeated by $N and $g his : her; band of companions. Let the next challenge be issued!', 14, 0, 0, 0, 0, 14998, 'Greiff quest 2 sasy 4'),
(@NPC_GEIRRVIF, 9, 9, 'Sigrid Iceborn has returned to the heights of Jotunheim to prove herself against $N. When last they met, $N bested her in personal combat. Let us see the outcome of this match.', 14, 0, 0, 0, 0, 0, 'Greiff quest 3 say 1'),
(@NPC_GEIRRVIF, 10, 10, 'Circling Valhalas, Sigrid Iceborn approaches to seek her revenge! ', 41, 0, 0, 0, 0, 14998, 'Greiff quest 3 say 2'),
(@NPC_GEIRRVIF, 11, 11, '$N has defeated Sigrid Iceborn for a second time.  Well, this time $g he : she; did it with the help of $g his : her; friends, but a win is a win!', 14, 0, 0, 0, 0, 14998, 'Greiff quest 3 say 3'),
(@NPC_GEIRRVIF, 12, 12, 'Carnage is coming! Remember, no matter what you do, do NOT leave the battle ring or I will disqualify you and your group.', 12, 0, 0, 0, 0, 0, 'Greiff quest 4 say 1'),
(@NPC_GEIRRVIF, 13, 13, 'From the bowels of the Underhalls comes Carnage.  Brave and foolish $N has accepted the challenge.  $G He : She; and $g his : her; group stand ready to face the monstrosity.', 14, 0, 0, 0, 0, 0, 'Greiff quest 4 say 2'),
(@NPC_GEIRRVIF, 14, 14, 'Lumbering in from the south, the smell of Carnage precedes him!', 41, 0, 0, 0, 0, 14998, 'Greiff quest 4 say 3'),
(@NPC_GEIRRVIF, 15, 15, 'The horror known as Carnage is no more. Could it be that $N is truly worthy of battle in Valhalas? We shall see.', 14, 0, 0, 0, 0, 14998, 'Greiff quest 4 say 4'),
(@NPC_GEIRRVIF, 16, 16, 'Look to the southeast and you will see the thane upon the platform near Gjonner the Merciless when he shows himself. Let him come down. Stay within the ring of Valhalas.', 12, 0, 0, 0, 0, 0, 'Greiff quest 5 say 1'),
(@NPC_GEIRRVIF, 17, 17, 'Thane Banahogg returns to Valhalas for the first time in ages to prove that the vrykul are the only beings worthy to fight within its sacred ring. Will $N prove him wrong?', 14, 0, 0, 0, 0, 0, 'Greiff quest 5 say 2'),
(@NPC_GEIRRVIF, 18, 18, 'Thane Banahogg appears upon the overlook to the southeast!', 41, 0, 0, 0, 0, 14998, 'Greiff quest 5 say 3'),
(@NPC_GEIRRVIF, 19, 19, 'Thane Banahogg the Deathblow has fallen to $N and $g his : her; fighting companions.  $G He : She; has but one challenge ahead of $g him : her;.  Who will it be?', 14, 0, 0, 0, 0, 14998, 'Greiff quest 5 say 4'),
(@NPC_GEIRRVIF, 20, 20, 'It''s too late to run now. Do not leave the ring. Die bravely, $N!', 12, 0, 0, 0, 0, 0, 'Greiff quest 6 say 1'),
(@NPC_GEIRRVIF, 21, 21, 'From the depths of Icecrown Citadel, one of the Lich King''s chosen comes to put an end to the existence of $N and $g his : her; friends.', 14, 0, 0, 0, 0, 0, 'Greiff quest 6 say 2'),
(@NPC_GEIRRVIF, 22, 22, 'Warriors of Jotunheim, I present to you, Blood Prince Sandoval!', 14, 0, 0, 0, 0, 0, 'Greiff quest 6 say 3'),
(@NPC_GEIRRVIF, 23, 23, 'Without warning, Prince Sandoval magically appears within Valhalas! ', 41, 0, 0, 0, 0, 14998, 'Greiff quest 6 say 4'),
(@NPC_GEIRRVIF, 24, 24, 'The unthinkable has happened... $N has slain Prince Sandoval!', 14, 0, 0, 0, 0, 0, 'Greiff quest 6 say 5'),
(@NPC_GEIRRVIF, 25, 25, 'In defeating him, $g he : she; and $g his : her; fighting companions have proven themselves worthy of battle in this most sacred place of vrykul honor.', 14, 0, 0, 0, 0, 0, 'Greiff quest 6 say 6'),
(@NPC_GEIRRVIF, 26, 26, 'ALL HAIL $N, CHAMPION OF VALHALAS!', 14, 0, 0, 0, 0, 14998, 'Greiff quest 6 say 7'),
(@NPC_GEIRRVIF, 27, 27, 'You were not prepared!', 14, 0, 0, 0, 0, 0, 'Greiff kill');
 
 
/* 
* sql\updates\world\2013_09_21_00_world_sai.sql 
*/ 
UPDATE `creature_template` SET `ainame`='SmartAI' WHERE `entry`=22177;
DELETE FROM `smart_scripts` WHERE `entryorguid`=22177 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(22177,0,0,0,8,0,100,0,38530,0,0,0,33,22177,0,0,0,0,0,7,0,0,0,0,0,0,0,'Eye of Grillok Quest Credit Bunny - On Spellhit (Quest Credit for Eye of Grillok) - Give Kill Credit');
 
 
/* 
* sql\updates\world\2013_09_22_00_world_sai.sql 
*/ 
UPDATE `smart_scripts` SET `link`=3 WHERE `entryorguid` IN (22401,21182,22402,22403) AND `source_type`=0 AND `id`=2 AND `link`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (22401,21182,22402,22403) AND `source_type`=0 AND `id`=3;
INSERT INTO `smart_scripts` (`entryorguid`, `id`, `event_type`, `action_type`, `action_param1`, `target_type`, `comment`) VALUES
(22401,3,61,33,22401,7,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On spell hit - Give Quest Credit'),
(21182,3,61,33,21182,7,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On spell hit - Give Quest Credit'), 
(22402,3,61,33,22402,7,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On spell hit - Give Quest Credit'),
(22403,3,61,33,22403,7,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On spell hit - Give Quest Credit');
 
 
/* 
* sql\updates\world\2013_09_24_00_world_sai.sql 
*/ 
UPDATE `smart_scripts` SET `event_flags`=0 WHERE  `entryorguid`=18110 AND `source_type`=0 AND `id`=0 AND `link`=1;
UPDATE `smart_scripts` SET `event_flags`=0 WHERE  `entryorguid`=18142 AND `source_type`=0 AND `id`=0 AND `link`=1;
UPDATE `smart_scripts` SET `event_flags`=0 WHERE  `entryorguid`=18143 AND `source_type`=0 AND `id`=0 AND `link`=1;
UPDATE `smart_scripts` SET `event_flags`=0 WHERE  `entryorguid`=18144 AND `source_type`=0 AND `id`=0 AND `link`=1;
-- It's all fun and games
UPDATE `smart_scripts` SET `action_type`=85 WHERE  `entryorguid`=29747 AND `source_type`=0 AND `id`=1 AND `link`=0;
 
 
/* 
* sql\updates\world\2013_09_26_00_world_sai.sql 
*/ 
UPDATE `smart_scripts` SET `action_type`=33, `action_param1`=28019 WHERE  `entryorguid`=27409 AND `source_type`=0 AND `id`=5 AND `link`=6;
 
 
/* 
* sql\updates\world\2013_09_26_01_world_sai.sql 
*/ 
UPDATE `creature_template` SET `AIName`= 'SmartAI',`ScriptName`='',`speed_walk`=1.428571,`speed_run`=1.6, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=12 WHERE `entry` =27002;

DELETE FROM `creature_text` WHERE `entry`=27002;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(27002,0,0,'I''ll consume your flesh and pick my teeth with your bones!',14,0,100,0,0,0,'Grom''thar the Thunderbringer'),
(27002,1,0,'You''re no magnataur!  Where... did you... find... such strength?',14,0,100,0,0,0,'Grom''thar the Thunderbringer');

DELETE FROM `event_scripts` WHERE `id`=17767;
INSERT INTO `event_scripts` (`id`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`) VALUES
(17767,0,10,27002,300000,0,2791.477,381.7451,77.19083,2.6067);

DELETE FROM `conditions` WHERE `SourceEntry` = 48328;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ScriptName`, `Comment`) VALUES
(17,0,48328,0,0,29,0,27002,100,0,1,'',"Do not summon Grom'thar, if he is already spawned (100 Yards)"),
(17,0,48328,0,0,28,0,12151,0,0,1,'',"Do not summon Grom'thar, if player has quest objective completed, but not yet rewarded.");

DELETE FROM `creature_ai_scripts` WHERE `creature_id` = 27002;
DELETE FROM `smart_scripts` WHERE `entryorguid` =27002;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(27002,0,0,0,9,0,100,0,5,45,4000,8000,11,52167,0,0,0,0,0,5,0,0,0,0,0,0,0,'Grom''thar the Thunderbringer - On Range - Cast Magnataur Charge'),
(27002,0,1,0,9,0,100,0,0,5,7000,11000,11,52166,0,0,0,0,0,1,0,0,0,0,0,0,0,'Grom''thar the Thunderbringer - In Combat - Cast Thunder'),
(27002,0,2,3,54,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Grom''thar the Thunderbringer - On Just Summoned - Say'),
(27002,0,3,0,61,0,100,0,0,0,0,0,53,1,27002,0,0,0,2,1,0,0,0,0,0,0,0,'Grom''thar the Thunderbringer - Linked with Previous Event - Start WP'),
(27002,0,4,5,40,0,100,0,1,27002,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Grom''thar the Thunderbringer - On Reached WP1 - Set Home Position'),
(27002,0,5,0,61,0,100,0,0,0,0,0,49,0,0,0,0,0,0,21,50,0,0,0,0,0,0,'Grom''thar the Thunderbringer - Linked with Previous Event - Attack'),
(27002,0,6,0,6,0,100,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Grom''thar the Thunderbringer - On Death - Say');

DELETE FROM `waypoints` WHERE `entry`=27002;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `point_comment`) VALUES
(27002, 1, 2746.325195,420.078369,67.982117, 'Grom''thar the Thunderbringer');
 
 
/* 
* sql\updates\world\2013_09_27_00_world_sai.sql 
*/ 
-- The Storm King's Vengeance (12919)
-- http://www.youtube.com/watch?v=hq9lmWNkXGA&feature=related
SET @GYMER                  := 29884; -- Gymer <King of Storm Giants>
SET @CAGED_GYMER            := 29647; -- Gymer
SET @ALGAR                  := 29872; -- Algar the Chosen
SET @NAVARIUS               := 29821; -- Prince Navarius
SET @THRYM                  := 29895; -- Thrym <The Hope Ender>
SET @NAVARIUS_CREDIT        := 55660; -- Navarius Kill Credit
SET @ALGAR_CREDIT           := 55661; -- Algar Kill Credit
SET @THYRM_CREDIT           := 55662; -- Thrym Kill Credit
-- Used in spell script
/*
SET @GRABBED                := 55424;
SET @EXPLOSION              := 55569;
SET @STORM_COULD            := 29939;
SET @HEALING_WINDS          := 55549;
*/

DELETE FROM `spell_script_names` WHERE `spell_id` IN (55516,55421);
INSERT INTO `spell_script_names` (`spell_id` ,`ScriptName`) VALUES
(55516, 'spell_q12919_gymers_grab'),
(55421, 'spell_q12919_gymers_throw');

UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE entry IN (@CAGED_GYMER,@GYMER,@ALGAR,@NAVARIUS,@THRYM,29889,29893,29894,29890,29891,29887);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN(@CAGED_GYMER*100,@CAGED_GYMER);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES 
(@CAGED_GYMER,0,0,1,62,0,100,0,9852,2,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Gymer - On Gossip Option Select -  Close Gossip'),
(@CAGED_GYMER,0,1,2,61,0,100,0,0,0,0,0,1,7,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gymer - On Link -  Say'),
(@CAGED_GYMER,0,2,0,61,0,100,0,0,0,0,0,80,@CAGED_GYMER*100,2,0,0,0,0,1,0,0,0,0,0,0,0,'Gymer - On Link - Start Timed Script'),
(@CAGED_GYMER*100,9,0,0,0,0,100,0,1500,1500,0,0,12,@GYMER,2,600000,0,0,0,7,0,0,0,0,0,0,0,'Gymer - On Script - Summon Gymer '),
(@CAGED_GYMER*100,9,1,0,0,0,100,0,1500,1500,0,0,85,55430,0,0,0,0,0,7,0,0,0,0,0,0,0,'Gymer - On Script - Cast Gymer''s Buddy Invoker'),
--
(@CAGED_GYMER,0,4,0,1,0,100,0,10000,20000,30000,40000,1,1,5000,0,0,0,0,1,0,0,0,0,0,0,0,'Gymer - OOC - Say Random');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` IN (14,15) AND `SourceGroup`=9852;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(14, 9852, 13639, 0, 0, 14, 0, 12919, 0, 0, 0, 0, 0, '', 'Show text if player doesn''t have quest rewarded'),
(14, 9852, 13640, 0, 0, 9, 0, 12919, 0, 0, 0, 0, 0, '', 'Show text if player has quest rewarded'),
(15, 9852, 0, 0, 0, 9, 0, 12919, 0, 0, 0, 0, 0, '', 'Show gossip option if player is on quest'),
(15, 9852, 1, 0, 0, 9, 0, 12919, 0, 0, 0, 0, 0, '', 'Show gossip option if player is on quest'),
(15, 9852, 2, 0, 0, 9, 0, 12919, 0, 0, 0, 0, 0, '', 'Show gossip option if player is on quest');

-- Gymer's Buddy
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`= 29884;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES 
(29884, 55430, 1, 0);

-- Gymer Summon Pos
DELETE FROM `spell_target_position` WHERE `id` = 55431;
INSERT INTO `spell_target_position` (`id`, `target_map`, `target_position_x`, `target_position_y`, `target_position_z`, `target_orientation`) VALUES 
(55431, 571, 5799.29, -1597.31, 237.17, 2.14);

DELETE FROM `gossip_menu` WHERE (`entry`=9852 AND `text_id`=13639) OR (`entry`=9852 AND `text_id`=13640) OR (`entry`=9855 AND `text_id`=13647) OR (`entry`=9860 AND `text_id`=13656);
INSERT INTO `gossip_menu` (`entry`, `text_id`) VALUES
(9852, 13639), -- 29647
(9852, 13640), -- 29647
(9855, 13647), -- 29647
(9860, 13656); -- 29647

DELETE FROM `gossip_menu_option` WHERE (`menu_id`=9852 AND `id`=0) OR (`menu_id`=9852 AND `id`=1) OR (`menu_id`=9852 AND `id`=2);
INSERT INTO `gossip_menu_option` (`menu_id`, `id`, `option_icon`, `option_text`, `option_id`, `npc_option_npcflag`, `action_menu_id`, `action_poi_id`, `box_coded`, `box_money`, `box_text`) VALUES 
(9852, 0, 0, 'Gymer, where are Algar, Navarius and Thrym?', 1, 3, 9855, 0, 0, 0, ''),
(9852, 1, 0, 'Gymer, what do I need to know? I''ve never ridden on a giant.', 1, 3, 9860, 0, 0, 0, ''),
(9852, 2, 0, 'I''m ready, Gymer. Let''s go!', 1, 3, 0, 0, 0, 0, '');

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@GYMER,@ALGAR,@NAVARIUS,@THRYM,@THRYM*100,29889,29893,29894,29890,29891,29887) AND `source_type` IN (0,9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@GYMER,0,0,1,27,0,100,1,0,0,0,0,1,8,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gymer - On Passenger boarded - Say'),
(@GYMER,0,1,0,61,0,100,0,0,0,0,0,1,9,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gymer - On Link - Say'),
(@GYMER,0,2,0,28,0,100,1,0,0,0,0,1,10,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gymer - On Passenger Removed - Say'),
(@GYMER,0,3,0,54,0,100,1,0,0,0,0,11,55461,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gymer - On Spawn - Cast Storm Aura'),
(@GYMER,0,4,0,54,0,100,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gymer - On Spawn - Cast Storm Aura'),
(@GYMER,0,5,0,54,0,100,0,0,0,0,0,44,256,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gymer - On Spawn - Set Phase'),
(@GYMER,0,6,0,73,0,100,0,0,0,0,0,11,46598,0,0,0,0,0,7,0,0,0,0,0,0,0,'Gymer - On Link - Cast Summon Gymer Force cast'),
-- Algar the Chosen
(@ALGAR,0,0,0,0,0,100,0,6000,10000,16000,23000,11,42729,0,0,0,0,0,1,0,0,0,0,0,0,0,'Algar the Chosen - IC - Cast Dreadful Roar'),
(@ALGAR,0,1,0,6,0,100,0,0,0,0,0,11,@ALGER_CREDIT,2,0,0,0,0,7,0,0,0,0,0,0,0,'Algar the Chosen - On Death - Cast criteria credit'),
-- Prince Navarius
(@NAVARIUS,0,0,0,11,0,100,1,0,0,0,0,11,55706,0,0,0,0,0,1,0,0,0,0,0,0,0,'Prince Navarius - Cast Sinister Shield- On Spawn'),
(@NAVARIUS,0,1,0,0,0,100,0,7000,16000,15000,19000,11,51009,1,0,0,0,0,2,0,0,0,0,0,0,0,'Prince Navarius - IC - Cast Soul Deflection'),
(@NAVARIUS,0,2,0,0,0,100,0,9000,15000,18000,21000,11,51016,1,0,0,0,0,2,0,0,0,0,0,0,0,'Prince Navarius - IC - Cast Vampiric Bolt'),
(@NAVARIUS,0,3,0,0,0,100,0,16000,28000,26000,34000,11,50992,1,0,0,0,0,2,0,0,0,0,0,0,0,'Prince Navarius - IC -Cast Soul Blast'),
(@NAVARIUS,0,4,5,6,0,100,1,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Prince Navarius - On Death  - Say 1'),
(@NAVARIUS,0,5,6,61,0,100,0,0,0,0,0,12,@THRYM,1,120000,0,0,0,8,0,0,0,5611.733, -2302.771, 289.4654, 1.745329,'Prince Navarius - On Link  - Spawn Thrym'),
(@NAVARIUS,0,6,0,61,0,100,0,0,0,0,0,11,@NAVARIUS_CREDIT,2,0,0,0,0,7,0,0,0,0,0,0,0,'Prince Navarius - On Link - Cast criteria credit'),
(@NAVARIUS,0,7,0,4,0,100,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Prince Navarius - On Aggro  - Say 0'),
-- Thrym 
(@THRYM,0,0,4,11,0,100,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thrym - On spawn - Yell'),
(@THRYM,0,1,0,0,0,100,0,8000,16000,15000,21000,11,28167,0,0,0,0,0,5,0,0,0,0,0,0,0,'Thrym - IC - Cast Chain Lightning'),
(@THRYM,0,2,0,0,0,100,1,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thrym - IC - Yell'),
(@THRYM,0,3,0,6,0,100,0,0,0,0,0,11,@THRYM_CREDIT,2,0,0,0,0,7,0,0,0,0,0,0,0,'Thrym - On Death - Cast criteria credit'),
(@THRYM,0,4,0,11,0,100,0,0,0,0,0,97,40,30,0,0,0,0,1,0,0,0,5555.583, -2223.97, 235.967,0,'Thrym - On Script - Jump to pos'),
(@THRYM,0,5,0,61,0,100,1,0,0,0,0,80,@THRYM*100,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thrym - On spawn - Yell'),
(@THRYM*100,9,0,0,61,0,100,0,3000,3000,3000,3000,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thrym - On spawn - Yell'),
-- Vargul Plaguehound
(29889,0,0,0,0,0,100,0,6000,10000,16000,23000,11,50047,0,0,0,0,0,2,0,0,0,0,0,0,0,'Vargul Plaguehound - IC - Cast Broken Bone'),
(29889,0,1,0,0,0,100,0,2000,15000,26000,33000,11,50046,0,0,0,0,0,2,0,0,0,0,0,0,0,'Vargul Plaguehound - IC - Cast Gnaw Bone'),
-- Banshee Soulclaimer 
(29893,0,0,0,0,0,100,0,4000,7000,9000,12000,11,28993,0,0,0,0,0,2,0,0,0,0,0,0,0,'Banshee Soulclaimer - IC - Cast Banshee''s Wail'),
-- Vargul Plaguetalon
(29894,0,0,0,0,0,100,0,3000,9000,14000,21000,11,55079,0,0,0,0,0,2,0,0,0,0,0,0,0,'Vargul Plaguetalon - IC - Cast Swoop'),
-- Vargul Deathwaker
(29890,0,0,0,0,0,100,0,3000,13000,19000,26000,11,56038,0,0,0,0,0,2,0,0,0,0,0,0,0,'Vargul Deathwaker - IC - Cast Plaguebolt'),
-- Vargul Runelord 
(29891,0,0,0,0,0,100,0,3000,13000,19000,26000,11,56036,0,0,0,0,0,2,0,0,0,0,0,0,0,'Vargul Runelord - IC - Cast Rune of Destruction'),
-- Vargul Doombringer
(29887,0,0,0,0,0,100,0,2000,20000,30000,40000,1,1,5000,0,0,0,0,1,0,0,0,0,0,0,0,'Vargul Doombringer - IC - Say Random');


UPDATE `creature_model_info` SET `bounding_radius`=10,`combat_reach`=12,`gender`=0 WHERE `modelid`=26656; -- Gymer
-- Caged Gymer
UPDATE `creature_template` SET  `gossip_menu_id`=9852, `speed_walk`=2, `speed_run`=1.42857146263123, `minlevel`=77, `maxlevel`=77, `unit_flags`=0x8000, `modelid1`=26656, `npcflag`=0x3 WHERE `entry`=29647;
-- Gymer <King of Storm Giants>
UPDATE `creature_template` SET  `IconName`='vehichleCursor', `speed_walk`=4, `speed_run`=4, `spell1`=55426,`spell2`=55429,`spell3`=55516,`spell4`=55421,`VehicleId`=205, `minlevel`=80, `maxlevel`=80, `faction_A`=1629, `faction_H`=1629, `unit_flags`=0x8, `modelid1`=26656, `unit_class`=4 WHERE `entry`=29884;
-- Vargul Runelord
UPDATE `creature_template` SET `faction_A`=1885, `faction_H`=1885, `speed_walk`=1.071429, `speed_run`=1, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=29891;
-- Vargul Slayer
UPDATE `creature_template` SET `faction_A`=1885, `faction_H`=1885, `speed_walk`=1.428571, `speed_run`=2, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=29892;
-- Vargul Plaguetalon
UPDATE `creature_template` SET `faction_A`=1885, `faction_H`=1885, `speed_walk`=2.285714, `speed_run`=2, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=29894; 
-- Vargul Deathwaker
UPDATE `creature_template` SET `faction_A`=1885, `faction_H`=1885, `speed_walk`=1.071429, `speed_run`=1, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=29890;
-- Vargul Blighthound
UPDATE `creature_template` SET `faction_A`=1885, `faction_H`=1885, `speed_walk`=1.428571, `speed_run`=1.6, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=29889;
-- Banshee Soulclaimer
UPDATE `creature_template` SET `faction_A`=1885, `faction_H`=1885, `speed_walk`=1.142857, `speed_run`=1, `InhabitType`=5, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=29893;
-- Storm Cloud
UPDATE `creature_template` SET `speed_run`=1, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0, `ScriptName`='npc_storm_cloud' WHERE `entry`=29939;
-- Reanimated Corpse
UPDATE `creature_template` SET `faction_A`=1885, `faction_H`=1885, `speed_walk`=1.142857, `speed_run`=0.777776, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=29897;
-- Vargul Doombringer
UPDATE `creature_template` SET `faction_A`=1885, `faction_H`=1885, `speed_walk`=1.071429, `speed_run`=1, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=29887;
 -- Prince Navarius
UPDATE `creature_template` SET `faction_A`=1885, `faction_H`=1885, `speed_run`=1, `rangeattacktime`=2000, `unit_flags`=32832, `dynamicflags`=0 WHERE `entry`=29821;
 -- Acolyte of Pain
UPDATE `creature_template` SET `faction_A`=1885, `faction_H`=1885, `speed_walk`=1.142857, `speed_run`=1, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=29935;
 -- Acolyte of Agony
UPDATE `creature_template` SET `maxlevel`=75, `faction_A`=1885, `faction_H`=1885, `speed_walk`=1.142857, `speed_run`=1, `rangeattacktime`=2000, `unit_flags`=32768, `dynamicflags`=0 WHERE `entry`=29934;
 -- Algar the Chosen
UPDATE `creature_template` SET `faction_A`=2068, `faction_H`=2068, `speed_walk`=1.385714, `speed_run`=4, `rangeattacktime`=2000, `unit_flags`=32832, `dynamicflags`=0 WHERE `entry`=29872;
 -- Thrym
UPDATE `creature_template` SET `faction_A`=974, `faction_H`=974, `speed_walk`=3.571429, `speed_run`=4, `rangeattacktime`=2000, `unit_flags`=64, `dynamicflags`=0 WHERE `entry`=29895;

DELETE FROM `creature_text` WHERE `entry`IN (@THRYM,@GYMER,@CAGED_GYMER,@NAVARIUS,29887);
INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES
-- Thrym
(29895, 0, 0, 'MASTER! NO!', 14, 0, 100, 53, 0, 0, 'Thrym to Gymer'),
(29895, 1, 1, 'THRYM CRUSH!', 14, 0, 100, 25, 0, 0, 'Thrym to Gymer'),
-- Gymer
(29884, 1, 0, 'Taste Gymer''s size 600!', 14, 0, 100, 0, 0, 0, 'Gymer to Reanimated Corpse'),
(29884, 1, 1, 'I will crush you under foot!', 14, 0, 100, 0, 0, 0, 'Gymer to Reanimated Corpse'),
(29884, 1, 2, 'STORMS GRANT ME POWER!', 14, 0, 100, 0, 0, 0, 'Gymer'),
(29884, 1, 3, 'Tiny creatures, I trample you!', 14, 0, 100, 0, 0, 0, 'Gymer to Reanimated Corpse'),
(29884, 1, 4, 'I''ll wipe you off of my boots later!', 14, 0, 100, 0, 0, 0, 'Gymer to Reanimated Corpse'),
(29884, 1, 5, 'AAARRRRRRGGGGGGHHHHHHH!! SUCH POWER!', 14, 0, 100, 0, 0, 0, 'Gymer'),
(29884, 1, 6, 'LIGHTNING GUIDE MY FURY!', 14, 0, 100, 0, 0, 0, 'Gymer'),
(29884, 1, 7, 'THE LIGHTNING COURSES THROUGH ME!', 14, 0, 100, 0, 0, 0, 'Gymer'),
(29884, 8, 8, 'Prince Navarius is on the other side of the Dead Fields to the east.', 42, 0, 100, 0, 0, 0, 'Gymer'),
(29884, 9, 9, 'Algar the Chosen is at the Reliquary of Pain to the northeast.', 42, 0, 100, 0, 0, 0, 'Gymer'),
(29884, 10, 10, 'Farewell, friend. May we meet again under better circumstances. I''ll never forget what you did for me!', 12, 0, 100, 0, 0, 0, 'Gymer'),
-- Caged Gymer random ooc text
(29647, 1, 0, 'My brothers will come for me and then you will see what true power is!', 12, 0, 100, 1, 0, 0, 'Gymer to Vargul Runelord'),
(29647, 1, 1, 'I will crush you all!', 12, 0, 100, 1, 0, 0, 'Gymer to Vargul Deathwaker'),
(29647, 1, 2, 'Ugly little monsters, pray I don''t get out!', 12, 0, 100, 1, 0, 0, 'Gymer to Vargul Slayer'),
(29647, 1, 3, 'Your torture only adds to my rage!', 12, 0, 100, 1, 0, 0, 'Gymer to Vargul Slayer'),
(29647, 1, 4, 'Ugly little monsters, pray I don''t get out!', 12, 0, 100, 1, 0, 0, 'Gymer to Vargul Runelord'),
(29647, 1, 5, 'Wretched beasts!', 12, 0, 100, 1, 0, 0, 'Gymer to Vargul Slayer'),
(29647, 1, 6, 'I will devour you whole!', 12, 0, 100, 1, 0, 0, 'Gymer to Vargul Runelord'),
(29647, 7, 7, 'FREE!!! Soon you will feel the wrath of the storm king!', 14, 0, 100, 53, 0, 0, 'Gymer'),
(29647, 1, 8, 'Wretched beasts!', 12, 0, 100, 1, 0, 0, 'Gymer to Vargul Runelord'),
(29647, 1, 9, 'Ugly little monsters, pray I don''t get out!', 12, 0, 100, 1, 0, 0, 'Gymer to Vargul Deathwaker'),
(29647, 1, 10, 'Your torture only adds to my rage!', 12, 0, 100, 1, 0, 0, 'Gymer to Vargul Runelord'),
-- Prince Navarius
(29821, 0, 0, 'Oh, you freed him, did you? No matter, his death and reconstruction will only be slightly delayed.', 14, 0, 100, 0, 0, 0, 'Prince Navarius to Gymer'),
(29821, 1, 1, 'Thrym... Av... Avenge me...', 14, 0, 100, 0, 0, 0, 'Prince Navarius to Gymer'),
-- Vargul Doombringer
(29887, 1, 0, 'I''ll eat your heart!', 12, 0, 100, 0, 0, 13537, 'Vargul Doombringer to Gymer'),
(29887, 1, 1, 'Sniveling pig!', 12, 0, 100, 0, 0, 13539, 'Vargul Doombringer to Gymer'),
(29887, 1, 2, 'I will feed you to the dogs!', 12, 0, 100, 0, 0, 13534, 'Vargul Doombringer to Gymer'),
(29887, 1, 3, 'Die, maggot!', 12, 0, 100, 0, 0, 13536, 'Vargul Doombringer to Gymer'),
(29887, 1, 4, 'Ugglin oo bjorr!', 12, 0, 100, 0, 0, 13540, 'Vargul Doombringer to Gymer'),
(29887, 1, 5, 'I''ll eat your heart!', 12, 0, 100, 0, 0, 13540, 'Vargul Doombringer to Gymer'),
(29887, 1, 6, 'I spit on you!', 12, 0, 100, 0, 0, 13538, 'Vargul Doombringer to Gymer'),
(29887, 1, 7, 'Your entrails will make a fine necklace.', 12, 0, 100, 0, 0, 13535, 'Vargul Doombringer to Gymer');

DELETE FROM `creature_equip_template` WHERE `entry` IN (29891,29892,29890,29887,29872);
INSERT INTO `creature_equip_template` (`entry`, `itemEntry1`, `itemEntry2`, `itemEntry3`) VALUES
(29891, 40605, 0, 0),       -- Vargul Runelord
(29892, 40609, 40609, 0),   -- Vargul Slayer
(29890, 40606, 0, 0),       -- Vargul Deathwaker
(29887, 34818, 0, 0),       -- Vargul Doombringer
(29872, 34820, 0, 0);       -- Algar the Chosen

DELETE FROM `creature_template_addon` WHERE `entry` IN (29452,29449,29646,29451,29453,29450,29939,29890,29887,29664,29872,29895,29884);
INSERT INTO `creature_template_addon` (`entry`, `mount`, `bytes1`, `bytes2`, `auras`) VALUES
(29452, 0, 0x0, 0x1, ''),               	-- Vargul Blighthound
(29449, 0, 0x0, 0x1, ''),               	-- Vargul Deathwaker
(29646, 0, 0x3000000, 0x1, ''),         	-- Banshee Soulclaimer
(29451, 0, 0x0, 0x1, '56035'),          	-- Vargul Slayer - Diminish Soul
(29453, 0, 0x3000000, 0x1, ''),         	-- Vargul Plaguetalon
(29450, 0, 0x0, 0x1, '54512'),          	-- Vargul Runelord - Plague Shield
(29939, 0, 0x2000000, 0x1, ''),    			-- Storm Cloud 
(29664, 0, 0x0, 0x1, '54942'),          	-- Ragemane - Cosmetic Orange Cloud
(29890, 0, 0x0, 0x1, ''),          			-- Vargul Deathwaker 
(29887, 0, 0x0, 0x1, ''),          			-- Vargul Doombringer
(29872, 26645, 0x3000000, 0x1, ''),     	-- Algar the Chosen + mount
(29895, 0, 0x0, 0x1, ''),               	-- Thrym
(29884, 0, 0, 257, ''); 						-- Gymer

-- Condition for passenger removal, only needs to execute if passenger is player.
DELETE FROM `conditions` WHERE `SourceEntry`=29884;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(22, 3, 29884, 0, 0, 32, 0, 16, 0, 0, 0, 0, 0, '', 'Execute event only if type is player');

-- Conditions for Throw Explosion
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`= 13 AND `SourceEntry`=55571;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(13, 1, 55571, 0, 1, 31, 0, 3, 29887, 0, 0, 0, 0, '', 'Throw only hits 29887'),
(13, 1, 55571, 0, 2, 31, 0, 3, 29889, 0, 0, 0, 0, '', 'Throw only hits 29989'),
(13, 1, 55571, 0, 3, 31, 0, 3, 29890, 0, 0, 0, 0, '', 'Throw only hits 29890'),
(13, 1, 55571, 0, 4, 31, 0, 3, 29891, 0, 0, 0, 0, '', 'Throw only hits 29891'),
(13, 1, 55571, 0, 5, 31, 0, 3, 29892, 0, 0, 0, 0, '', 'Throw only hits 29892'),
(13, 1, 55571, 0, 6, 31, 0, 3, 29893, 0, 0, 0, 0, '', 'Throw only hits 29893'),
(13, 1, 55571, 0, 7, 31, 0, 3, 29894, 0, 0, 0, 0, '', 'Throw only hits 29894'),
(13, 1, 55571, 0, 8, 31, 0, 3, 29897, 0, 0, 0, 0, '', 'Throw only hits 29897'),
(13, 1, 55571, 0, 9, 31, 0, 3, 29934, 0, 0, 0, 0, '', 'Throw only hits 29934'),
(13, 1, 55571, 0, 10, 31, 0, 3, 29935, 0, 0, 0, 0, '', 'Throw only hits 29935');

-- Conditions for Gymer's Grab
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`= 13 AND `SourceEntry`=55516;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(13, 1, 55516, 0, 1, 31, 0, 3, 29887, 0, 0, 0, 0, '', 'Gymer''s Grab only hits29887'),
(13, 1, 55516, 0, 2, 31, 0, 3, 29889, 0, 0, 0, 0, '', 'Gymer''s Grab only hits 29989'),
(13, 1, 55516, 0, 3, 31, 0, 3, 29890, 0, 0, 0, 0, '', 'Gymer''s Grab only hits 29890'),
(13, 1, 55516, 0, 4, 31, 0, 3, 29891, 0, 0, 0, 0, '', 'Gymer''s Grab only hits 29891'),
(13, 1, 55516, 0, 5, 31, 0, 3, 29892, 0, 0, 0, 0, '', 'Gymer''s Grab only hits 29892'),
(13, 1, 55516, 0, 6, 31, 0, 3, 29893, 0, 0, 0, 0, '', 'Gymer''s Grab only hits 29893'),
(13, 1, 55516, 0, 7, 31, 0, 3, 29894, 0, 0, 0, 0, '', 'Gymer''s Grab only hits 29894'),
(13, 1, 55516, 0, 8, 31, 0, 3, 29897, 0, 0, 0, 0, '', 'Gymer''s Grab only hits 29897'),
(13, 1, 55516, 0, 9, 31, 0, 3, 29934, 0, 0, 0, 0, '', 'Gymer''s Grab only hits 29934'),
(13, 1, 55516, 0, 10, 31, 0, 3, 29939, 0, 0, 0, 0, '', 'Gymer''s Grab only hits 29935');

-- 209 Spawns in phase 256; that's the phase the player goes in when Gymer's vehicle spell is cast on him.
DELETE FROM `creature` WHERE phasemask=256 AND id IN (29821,29872,29887,29889,29890,29891,29892,29893,29894,29895,29897,29934,29935,29939);
INSERT INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`) VALUES 
(142488, 29821, 571, 1, 256, 0, 0, 5543.87, -2221.51, 235.402, 0.62832, 600, 0, 0, 88008, 54645, 0, 0, 0, 0),
(142489, 29872, 571, 1, 256, 0, 0, 6234.94, -2034.97, 234.052, 1.44615, 600, 0, 0, 176550, 3809, 1, 0, 0, 0),
(142490, 29887, 571, 1, 256, 0, 0, 6193.72, -1980.32, 231.695, 2.38464, 300, 10, 0, 34137, 0, 1, 0, 0, 0),
(142491, 29887, 571, 1, 256, 0, 0, 6204.54, -1968.83, 233.226, 2.37286, 300, 10, 0, 34137, 0, 1, 0, 0, 0),
(142492, 29887, 571, 1, 256, 0, 0, 6133.42, -2001.64, 231.773, 2.49538, 300, 10, 0, 34137, 0, 1, 0, 0, 0),
(142493, 29887, 571, 1, 256, 0, 0, 6145.06, -1986.18, 231.879, 2.49931, 300, 10, 0, 34137, 0, 1, 0, 0, 0),
(142494, 29887, 571, 1, 256, 0, 0, 6153.54, -1974.82, 231.927, 2.49931, 300, 10, 0, 34137, 0, 1, 0, 0, 0),
(142495, 29887, 571, 1, 256, 0, 0, 6161.59, -1964.07, 233.557, 2.49145, 300, 10, 0, 34137, 0, 1, 0, 0, 0),
(142496, 29887, 571, 1, 256, 0, 0, 6135.05, -1977.74, 232.608, 2.56214, 300, 10, 0, 34137, 0, 1, 0, 0, 0),
(142497, 29889, 571, 1, 256, 0, 0, 5674.37, -1468.56, 234.446, 4.52842, 600, 10, 0, 10282, 0, 1, 0, 0, 0),
(142498, 29889, 571, 1, 256, 0, 0, 5586.2, -1480.24, 229.789, 3.65192, 600, 10, 0, 10282, 0, 1, 0, 0, 0),
(142499, 29889, 571, 1, 256, 0, 0, 5820.47, -1406.84, 232.627, 2.12275, 600, 10, 0, 10282, 0, 1, 0, 0, 0),
(142500, 29889, 571, 1, 256, 0, 0, 5751.21, -1573.51, 229.397, 4.99966, 600, 10, 0, 10282, 0, 1, 0, 0, 0),
(142501, 29889, 571, 1, 256, 0, 0, 5786.81, -1626.29, 235.068, 1.75989, 600, 10, 0, 10282, 0, 1, 0, 0, 0),
(142502, 29889, 571, 1, 256, 0, 0, 5722.32, -1609.86, 235.452, 3.01653, 600, 10, 0, 10282, 0, 1, 0, 0, 0),
(142503, 29889, 571, 1, 256, 0, 0, 5655.16, -1554.06, 229.985, 3.86084, 600, 10, 0, 10282, 0, 1, 0, 0, 0),
(142504, 29890, 571, 1, 256, 0, 0, 5781.15, -1338.38, 231.596, 5.94606, 600, 10, 0, 10635, 3561, 1, 0, 0, 0),
(142505, 29890, 571, 1, 256, 0, 0, 5826.03, -1513.24, 229.113, 5.01536, 600, 10, 0, 10635, 3561, 1, 0, 0, 0),
(142506, 29890, 571, 1, 256, 0, 0, 5636.28, -1549.44, 229.052, 3.26393, 600, 10, 0, 10635, 3561, 1, 0, 0, 0),
(142507, 29890, 571, 1, 256, 0, 0, 5682.03, -1341.61, 231.087, 2.83117, 600, 10, 0, 10635, 3561, 1, 0, 0, 0),
(142508, 29891, 571, 1, 256, 0, 0, 5685.83, -1450.21, 233.333, 4.78681, 600, 10, 0, 8508, 7981, 1, 0, 0, 0),
(142509, 29891, 571, 1, 256, 0, 0, 5732.31, -1566.44, 230.02, 4.73184, 600, 10, 0, 8508, 7981, 1, 0, 0, 0),
(142510, 29891, 571, 1, 256, 0, 0, 5769.41, -1604.24, 234.079, 0.137435, 600, 0, 0, 8508, 7981, 1, 0, 0, 0),
(142511, 29891, 571, 1, 256, 0, 0, 5745.56, -1634.73, 236.355, 5.56829, 600, 10, 0, 8508, 7981, 1, 0, 0, 0),
(142512, 29892, 571, 1, 256, 0, 0, 5738.29, -1312.05, 232.462, 4.10745, 600, 10, 0, 10635, 0, 1, 0, 0, 0),
(142513, 29892, 571, 1, 256, 0, 0, 5565.59, -1317.36, 235.014, 5.94056, 600, 10, 0, 10635, 0, 1, 0, 0, 0),
(142514, 29892, 571, 1, 256, 0, 0, 5606.09, -1331.94, 234.324, 1.26352, 600, 10, 0, 10635, 0, 1, 0, 0, 0),
(142515, 29893, 571, 1, 256, 0, 0, 5853.59, -1697.84, 244.965, 2.67236, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142516, 29893, 571, 1, 256, 0, 0, 5695.74, -2009.43, 244.807, 0.124677, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142517, 29893, 571, 1, 256, 0, 0, 5572.47, -1652.34, 253.619, 4.17072, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142518, 29893, 571, 1, 256, 0, 0, 5696.37, -1678.93, 251.9, 4.39571, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142519, 29893, 571, 1, 256, 0, 0, 5631.35, -1681.11, 250.731, 1.85807, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142520, 29893, 571, 1, 256, 0, 0, 5704.06, -1720.49, 251.043, 2.9409, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142521, 29893, 571, 1, 256, 0, 0, 5778.87, -1719.28, 245.041, 3.77237, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142522, 29893, 571, 1, 256, 0, 0, 5915.15, -1649.44, 240.979, 1.88691, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142523, 29893, 571, 1, 256, 0, 0, 5569.31, -2202.47, 237.294, 4.03964, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142524, 29893, 571, 1, 256, 0, 0, 5897.1, -1919.8, 247.544, 3.42085, 300, 5, 0, 10635, 3561, 0, 1, 0, 0),
(142525, 29893, 571, 1, 256, 0, 0, 5689.67, -2208.27, 247.099, 0.162255, 300, 5, 0, 10635, 3561, 1, 0, 0, 0), 
(142526, 29893, 571, 1, 256, 0, 0, 5713.66, -2105.41, 249.516, 5.98828, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142527, 29893, 571, 1, 256, 0, 0, 5702.55, -1917.11, 253.197, 3.79182, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142528, 29893, 571, 1, 256, 0, 0, 5690.33, -2185.8, 242.179, 2.57271, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142529, 29893, 571, 1, 256, 0, 0, 5740.76, -1773.32, 245.511, 2.31348, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142530, 29893, 571, 1, 256, 0, 0, 5614.24, -2037.16, 250.149, 1.40832, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142531, 29893, 571, 1, 256, 0, 0, 5575.29, -2000.67, 248.223, 6.19776, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142532, 29893, 571, 1, 256, 0, 0, 5677.27, -1851.13, 251.113, 3.90297, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142533, 29893, 571, 1, 256, 0, 0, 5577.02, -2066.85, 250.604, 1.07166, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142534, 29893, 571, 1, 256, 0, 0, 5571, -2199.84, 237.131, 2.6764, 300, 0, 5, 10635, 3561, 1, 0, 0, 0),
(142535, 29893, 571, 1, 256, 0, 0, 5720.52, -2249.46, 248.994, 2.89725, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142536, 29893, 571, 1, 256, 0, 0, 5572.56, -2191.33, 237.752, 4.12593, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142537, 29893, 571, 1, 256, 0, 0, 5753.41, -1810.86, 250.933, 5.99866, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142538, 29893, 571, 1, 256, 0, 0, 5618.3, -1752.46, 247.552, 1.09956, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142539, 29893, 571, 1, 256, 0, 0, 5859.25, -1685.61, 245.065, 3.36587, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142540, 29893, 571, 1, 256, 0, 0, 5775.25, -1814.98, 250.933, 5.39307, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142541, 29893, 571, 1, 256, 0, 0, 5743.85, -1852.16, 254.482, 1.90241, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142542, 29893, 571, 1, 256, 0, 0, 5587.08, -2148.03, 245.513, 6.16101, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142543, 29893, 571, 1, 256, 0, 0, 5523.55, -2117.92, 247.714, 1.53589, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142544, 29893, 571, 1, 256, 0, 0, 5565.29, -2073.18, 250.604, 2.82743, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142545, 29893, 571, 1, 256, 0, 0, 5677.37, -2149.39, 246.073, 3.49066, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142546, 29893, 571, 1, 256, 0, 0, 5648.6, -2249.16, 244.455, 4.83456, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142547, 29893, 571, 1, 256, 0, 0, 5567.93, -1993.53, 248.223, 1.74533, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142548, 29893, 571, 1, 256, 0, 0, 5675.13, -2209.69, 247.099, 3.05433, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142549, 29893, 571, 1, 256, 0, 0, 5698.65, -2027.66, 249.799, 5.37561, 300, 5, 0, 10635, 3561, 1, 0, 0, 0),
(142550, 29894, 571, 1, 256, 0, 0, 5665, -1415.25, 246.314, 5.39472, 600, 20, 0, 10282, 0, 1, 0, 0, 0),
(142551, 29894, 571, 1, 256, 0, 0, 5752.15, -1436.29, 258.409, 5.41043, 600, 20, 0, 10282, 0, 1, 0, 0, 0),
(142552, 29894, 571, 1, 256, 0, 0, 5761.66, -1565.35, 253.843, 5.16774, 600, 20, 0, 10282, 0, 1, 0, 0, 0),
(142553, 29894, 571, 1, 256, 0, 0, 5506.99, -2078.6, 240.758, 3.26877, 600, 0, 0, 10282, 0, 1, 0, 0, 0),
(142554, 29897, 571, 1, 256, 0, 0, 5800.41, -1949.86, 237.777, 0.0841148, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142555, 29897, 571, 1, 256, 0, 0, 5809.66, -1961.18, 237.623, 2.90301, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142556, 29897, 571, 1, 256, 0, 0, 5787.87, -1945.98, 237.981, 2.64831, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142557, 29897, 571, 1, 256, 0, 0, 5849.52, -1938.72, 238.759, 2.37365, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142558, 29897, 571, 1, 256, 0, 0, 5851.52, -1936.72, 238.759, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142559, 29897, 571, 1, 256, 0, 0, 5874.93, -1958.73, 237.907, 5.48033, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142560, 29897, 571, 1, 256, 0, 0, 5876.93, -1956.73, 237.907, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142561, 29897, 571, 1, 256, 0, 0, 5784.08, -2089.96, 248.134, 4.30029, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142562, 29897, 571, 1, 256, 0, 0, 5781.4, -2100.23, 248.13, 2.21899, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142563, 29897, 571, 1, 256, 0, 0, 5806.27, -2085.21, 248.853, 1.87123, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142564, 29897, 571, 1, 256, 0, 0, 5681.57, -1835.14, 239.37, 1.60886, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142565, 29897, 571, 1, 256, 0, 0, 5676.56, -1831.26, 238.047, 3.34263, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142566, 29897, 571, 1, 256, 0, 0, 5684.2, -1865.81, 245.472, 6.17889, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142567, 29897, 571, 1, 256, 0, 0, 5757.26, -2150.57, 239.183, 1.30925, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142568, 29897, 571, 1, 256, 0, 0, 5755.93, -2143.23, 239.517, 0.826811, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142569, 29897, 571, 1, 256, 0, 0, 5758.19, -2165.01, 236.708, 0.435639, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142570, 29897, 571, 1, 256, 0, 0, 5740.36, -1981.64, 239.12, 5.9877, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142571, 29897, 571, 1, 256, 0, 0, 5744.67, -1988.91, 237.913, 2.8217, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142572, 29897, 571, 1, 256, 0, 0, 5610.19, -1785.61, 237.507, 3.07515, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142573, 29897, 571, 1, 256, 0, 0, 5618.3, -1764.02, 238.151, 1.66464, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142574, 29897, 571, 1, 256, 0, 0, 5689.57, -1791.99, 242.42, 0.379977, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142575, 29897, 571, 1, 256, 0, 0, 5695.83, -1804.17, 243.797, 5.64564, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142576, 29897, 571, 1, 256, 0, 0, 5700.72, -1802.74, 243.412, 0.951114, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142577, 29897, 571, 1, 256, 0, 0, 5817.31, -1985.64, 235.536, 0.737231, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142578, 29897, 571, 1, 256, 0, 0, 5772.95, -1971.71, 238.367, 5.41063, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142579, 29897, 571, 1, 256, 0, 0, 5781.42, -2002.12, 235.408, 4.67777, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142580, 29897, 571, 1, 256, 0, 0, 5505.86, -1980.04, 245.708, 4.13413, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142581, 29897, 571, 1, 256, 0, 0, 5715.38, -1850.36, 244.283, 5.24594, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142582, 29897, 571, 1, 256, 0, 0, 5720.33, -1854.51, 244.441, 4.60288, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142583, 29897, 571, 1, 256, 0, 0, 5707.95, -1840.12, 243.55, 3.37615, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142584, 29897, 571, 1, 256, 0, 0, 5745.64, -2214.74, 237.548, 0.0771936, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142585, 29897, 571, 1, 256, 0, 0, 5747.11, -2186.19, 235.212, 1.23232, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142586, 29897, 571, 1, 256, 0, 0, 5753.6, -1818.86, 242.801, 5.70552, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142587, 29897, 571, 1, 256, 0, 0, 5708.97, -1818.38, 242.586, 0.27079, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142588, 29897, 571, 1, 256, 0, 0, 5775.08, -1818.34, 241.528, 3.04571, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142589, 29897, 571, 1, 256, 0, 0, 5699.57, -1814.88, 243.044, 2.8075, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142590, 29897, 571, 1, 256, 0, 0, 5722.35, -1809.84, 242.035, 5.9219, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142591, 29897, 571, 1, 256, 0, 0, 5672.66, -1752.98, 242.189, 0.176776, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142592, 29897, 571, 1, 256, 0, 0, 5749.24, -1916.05, 236.765, 1.57848, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142593, 29897, 571, 1, 256, 0, 0, 5770.94, -1947.83, 238.676, 3.24534, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142594, 29897, 571, 1, 256, 0, 0, 5760.04, -1930.67, 236.939, 2.48637, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142595, 29897, 571, 1, 256, 0, 0, 5718.87, -1725.81, 241.258, 2.40457, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142596, 29897, 571, 1, 256, 0, 0, 5704.41, -1761.31, 238.276, 1.08268, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142597, 29897, 571, 1, 256, 0, 0, 5692.77, -1742.78, 241.834, 0.59012, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142598, 29897, 571, 1, 256, 0, 0, 5811.15, -1806.3, 239.144, 3.31613, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142599, 29897, 571, 1, 256, 0, 0, 5812.15, -1805.3, 239.144, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142600, 29897, 571, 1, 256, 0, 0, 5813.15, -1804.3, 239.144, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142601, 29897, 571, 1, 256, 0, 0, 5741.6, -1938.87, 239.001, 5.39812, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142602, 29897, 571, 1, 256, 0, 0, 5771.44, -1953.53, 238.606, 0.393825, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142603, 29897, 571, 1, 256, 0, 0, 5743.02, -1972.59, 238.874, 2.11055, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142604, 29897, 571, 1, 256, 0, 0, 5703.15, -1794.12, 242.065, 3.34446, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142605, 29897, 571, 1, 256, 0, 0, 5746.18, -1782.44, 235.463, 0.797146, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142606, 29897, 571, 1, 256, 0, 0, 5619.11, -1717.61, 238.613, 3.22571, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142607, 29897, 571, 1, 256, 0, 0, 5548.48, -2014.94, 241.625, 6.14212, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142608, 29897, 571, 1, 256, 0, 0, 5574.68, -2047.1, 241.07, 3.84426, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142609, 29897, 571, 1, 256, 0, 0, 5581.1, -2026.65, 240.496, 2.87268, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142610, 29897, 571, 1, 256, 0, 0, 5579.34, -2052.01, 242.07, 6.14826, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142611, 29897, 571, 1, 256, 0, 0, 5636.66, -2065.46, 239.827, 3.88282, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142612, 29897, 571, 1, 256, 0, 0, 5624.29, -2040.4, 242.369, 2.36517, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142613, 29897, 571, 1, 256, 0, 0, 5637.19, -2045.61, 240.353, 2.54655, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142614, 29897, 571, 1, 256, 0, 0, 5616.15, -2050.24, 240.595, 0.793553, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142615, 29897, 571, 1, 256, 0, 0, 5609.08, -2065.27, 240.629, 3.25117, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142616, 29897, 571, 1, 256, 0, 0, 5608.1, -2066.92, 240.892, 6.16573, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142617, 29897, 571, 1, 256, 0, 0, 5678.65, -2105.46, 235.457, 1.91448, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142618, 29897, 571, 1, 256, 0, 0, 5679.89, -2099.35, 235.438, 5.22669, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142619, 29897, 571, 1, 256, 0, 0, 5672.36, -2099.72, 236.885, 1.76984, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142620, 29897, 571, 1, 256, 0, 0, 5735.15, -1916.51, 238.14, 2.53114, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142621, 29897, 571, 1, 256, 0, 0, 5767.14, -1922.78, 236.386, 5.84969, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142622, 29897, 571, 1, 256, 0, 0, 5774.57, -1924.63, 236.931, 2.64557, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142623, 29897, 571, 1, 256, 0, 0, 5817.63, -1736.84, 234.032, 1.06323, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142624, 29897, 571, 1, 256, 0, 0, 5808.32, -1768.02, 237.835, 2.35965, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142625, 29897, 571, 1, 256, 0, 0, 5781.59, -1770.5, 237.636, 1.57177, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142626, 29897, 571, 1, 256, 0, 0, 5776.26, -1770.25, 237.259, 0.302035, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142627, 29897, 571, 1, 256, 0, 0, 5789.37, -1769.62, 237.983, 5.76186, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142628, 29897, 571, 1, 256, 0, 0, 5644.87, -1849.57, 238.036, 6.24801, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142629, 29897, 571, 1, 256, 0, 0, 5698.37, -1935.3, 244.483, 4.06009, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142630, 29897, 571, 1, 256, 0, 0, 5702.1, -1939.35, 245.179, 2.22602, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142631, 29897, 571, 1, 256, 0, 0, 5708.07, -1941.57, 245.273, 5.95941, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142632, 29897, 571, 1, 256, 0, 0, 5617.93, -1927.98, 238.178, 1.42268, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142633, 29897, 571, 1, 256, 0, 0, 5665.75, -1960.17, 246.384, 3.74366, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142634, 29897, 571, 1, 256, 0, 0, 5618.41, -1918.89, 236.543, 5.94885, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142635, 29897, 571, 1, 256, 0, 0, 5640.05, -1896.65, 237.268, 2.27912, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142636, 29897, 571, 1, 256, 0, 0, 5646.57, -2073.42, 239.16, 4.57035, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142637, 29897, 571, 1, 256, 0, 0, 5648.18, -2044.24, 240.082, 2.20481, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142638, 29897, 571, 1, 256, 0, 0, 5651.94, -2049.16, 239.93, 1.42876, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142639, 29897, 571, 1, 256, 0, 0, 5682.93, -1925.03, 240.591, 6.18927, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142640, 29897, 571, 1, 256, 0, 0, 5666.15, -1926.56, 236.313, 3.40826, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142641, 29897, 571, 1, 256, 0, 0, 5680.71, -1919.09, 240.538, 6.25585, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142642, 29897, 571, 1, 256, 0, 0, 5635.86, -1918.02, 236.563, 2.58564, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142643, 29897, 571, 1, 256, 0, 0, 5630.83, -1923.23, 236.676, 5.98849, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142644, 29897, 571, 1, 256, 0, 0, 5622.87, -1988.8, 242.277, 5.95495, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142645, 29897, 571, 1, 256, 0, 0, 5624.85, -1887.39, 238.361, 3.35814, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142646, 29897, 571, 1, 256, 0, 0, 5631.73, -1946.06, 240.503, 2.14675, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142647, 29897, 571, 1, 256, 0, 0, 5641.32, -1940.9, 237.796, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142648, 29897, 571, 1, 256, 0, 0, 5642.32, -1939.9, 237.796, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142649, 29897, 571, 1, 256, 0, 0, 5611.14, -1791.48, 237.011, 1.11064, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142650, 29897, 571, 1, 256, 0, 0, 5620.56, -1791.42, 235.489, 4.90098, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142651, 29897, 571, 1, 256, 0, 0, 5648.79, -1756.16, 238.444, 3.77298, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142652, 29897, 571, 1, 256, 0, 0, 5610.22, -1747.1, 238.102, 4.15958, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142653, 29897, 571, 1, 256, 0, 0, 5612.51, -1738.41, 237.053, 1.85177, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142654, 29897, 571, 1, 256, 0, 0, 5755, -1817.13, 242.671, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142655, 29897, 571, 1, 256, 0, 0, 5756, -1816.13, 242.671, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142656, 29897, 571, 1, 256, 0, 0, 5776.57, -1793.26, 236.417, 1.48353, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142657, 29897, 571, 1, 256, 0, 0, 5777.57, -1792.26, 236.417, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142658, 29897, 571, 1, 256, 0, 0, 5778.57, -1791.26, 236.417, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142659, 29897, 571, 1, 256, 0, 0, 5801.6, -1765.91, 238.43, 2.58309, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142660, 29897, 571, 1, 256, 0, 0, 5802.6, -1764.91, 238.43, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142661, 29897, 571, 1, 256, 0, 0, 5803.6, -1763.91, 238.43, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142662, 29897, 571, 1, 256, 0, 0, 5785.24, -1852.96, 237.379, 6.26573, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142663, 29897, 571, 1, 256, 0, 0, 5787.24, -1850.96, 237.379, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142664, 29897, 571, 1, 256, 0, 0, 5742.22, -1871.72, 244.595, 5.06145, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142665, 29897, 571, 1, 256, 0, 0, 5744.22, -1869.72, 244.595, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142666, 29897, 571, 1, 256, 0, 0, 5697.92, -2029.47, 240.357, 5.14872, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142667, 29897, 571, 1, 256, 0, 0, 5823.94, -1876.77, 235.48, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142668, 29897, 571, 1, 256, 0, 0, 5824.94, -1875.77, 235.48, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142669, 29897, 571, 1, 256, 0, 0, 5682.56, -1792.18, 241.997, 0.0174533, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142670, 29897, 571, 1, 256, 0, 0, 5683.56, -1791.18, 241.997, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142671, 29897, 571, 1, 256, 0, 0, 5684.56, -1790.18, 241.997, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142672, 29897, 571, 1, 256, 0, 0, 5761.16, -1965.01, 237.3, 0.628319, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142673, 29897, 571, 1, 256, 0, 0, 5762.16, -1964.01, 237.3, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142674, 29897, 571, 1, 256, 0, 0, 5763.16, -1963.01, 237.3, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142675, 29897, 571, 1, 256, 0, 0, 5852.36, -1944.45, 239.13, 2.12984, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142676, 29897, 571, 1, 256, 0, 0, 5602.24, -2077.07, 242.888, 5.5676, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142677, 29897, 571, 1, 256, 0, 0, 5603.24, -2076.07, 242.888, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142678, 29897, 571, 1, 256, 0, 0, 5604.24, -2075.07, 242.888, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142679, 29897, 571, 1, 256, 0, 0, 5606.16, -2054.38, 240.52, 0.733038, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142680, 29897, 571, 1, 256, 0, 0, 5608.16, -2052.38, 240.52, 0, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142681, 29897, 571, 1, 256, 0, 0, 5739.8, -1806.04, 240.445, 2.14916, 120, 0, 0, 10635, 3561, 0, 0, 0, 0),
(142682, 29934, 571, 1, 256, 0, 0, 5536.93, -2222.53, 235.536, 0.942478, 300, 0, 0, 106350, 17805, 0, 0, 0, 0),
(142683, 29935, 571, 1, 256, 0, 0, 5545.14, -2227.4, 236.246, 0.907571, 300, 0, 0, 106350, 17805, 0, 0, 0, 0),
(142684, 29939, 571, 1, 256, 0, 0, 5715.978, -1471.326, 233.7377, 5.707227, 120, 0, 0, 0, 1, 0, 0, 0, 0), 
(142685, 29939, 571, 1, 256, 0, 0, 5546.167, -1869.288, 238.3516, 2.426008, 120, 0, 0, 0, 1, 0, 0, 0, 0), 
(142686, 29939, 571, 1, 256, 0, 0, 5645.932, -1925.377, 236.6502, 4.118977, 120, 0, 0, 0, 1, 0, 0, 0, 0),
(142687, 29939, 571, 1, 256, 0, 0, 5587.249, -1965.734, 242.4379, 4.420742, 120, 0, 0, 0, 1, 0, 0, 0, 0), 
(142688, 29939, 571, 1, 256, 0, 0, 5505.981, -2078.141, 240.9521, 2.356194, 120, 0, 0, 0, 1, 0, 0, 0, 0),
(142689, 29939, 571, 1, 256, 0, 0, 5521.792, -2245.884, 236.2022, 3.036873, 120, 0, 0, 0, 1, 0, 0, 0, 0),
(142690, 29939, 571, 1, 256, 0, 0, 5793.679, -2095.737, 249.0007, 5.235988, 120, 0, 0, 0, 1, 0, 0, 0, 0),
(142691, 29939, 571, 1, 256, 0, 0, 6175.099, -2017.251, 245.3769, 1.099557, 120, 0, 0, 0, 1, 0, 0, 0, 0),
(142692, 29939, 571, 1, 256, 0, 0, 6210.14, -2071.388, 235.3288, 0.4347768, 120, 0, 0, 0, 1, 0, 0, 0, 0),
(142693, 29939, 571, 1, 256, 0, 0, 5505.981, -2078.141, 240.9521, 2.356194, 120, 0, 0, 0, 1, 0, 0, 0, 0),
(142694, 29939, 571, 1, 256, 0, 0, 5645.932, -1925.377, 236.6502, 4.118977, 120, 0, 0, 0, 1, 0, 0, 0, 0), 
(142695, 29939, 571, 1, 256, 0, 0, 5521.792, -2245.884, 236.2022, 3.036873, 120, 0, 0, 0, 1, 0, 0, 0, 0), 
(142696, 29939, 571, 1, 256, 0, 0, 5645.932, -1925.377, 236.6502, 4.118977, 120, 0, 0, 0, 1, 0, 0, 0, 0),
(142697, 29939, 571, 1, 256, 0, 0, 5521.792, -2245.884, 236.2022, 3.036873, 120, 0, 0, 0, 1, 0, 0, 0, 0); 
 
/* 
* sql\updates\world\2013_09_28_00_world_update.sql 
*/ 
UPDATE `creature` SET `spawndist`=0 WHERE  `guid`=142524;
UPDATE `creature` SET `spawndist`=5 WHERE  `guid`=142489;
UPDATE `creature` SET `spawndist`=5 WHERE  `guid`=142510;
UPDATE `creature` SET `spawndist`=5 WHERE  `guid`=142534;
UPDATE `creature` SET `spawndist`=5 WHERE  `guid`=142553;
 
 
/* 
* sql\updates\world\2013_09_28_01_world_update.sql 
*/ 
UPDATE `creature_template` SET `spell1` = 52497, `spell2` = 52510 WHERE `entry` = 28843;
 
 
/* 
* sql\updates\world\2013_09_29_00_world_misc.sql 
*/ 
DELETE FROM `trinity_string` WHERE `entry` IN (65, 66, 67, 68, 69, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 93, 94);
UPDATE `trinity_string` SET `entry` = 65 WHERE `entry` = 90;
UPDATE `trinity_string` SET `entry` = 66 WHERE `entry` = 91;
UPDATE `trinity_string` SET `entry` = 68 WHERE `entry` = 95;
UPDATE `trinity_string` SET `entry` = `entry` - 10 WHERE `entry` BETWEEN 82 AND 89;

INSERT INTO `trinity_string` (`entry`, `content_default`) VALUES
(67, 'Account %u (%s) inherited permissions by sec level %u:'),
(69, 'Linked permissions:');

DELETE FROM `command` WHERE `permission` BETWEEN 200 AND 213;
INSERT INTO `command` (`name`, `permission`, `help`) VALUES
('.rbac account list',   202, 'Syntax: rbac account list [$account]\n\nView permissions of selected player or given account\nNote: Only those that affect current realm'),
('.rbac account grant',  203, 'Syntax: rbac account grant [$account] #id [#realmId]\n\nGrant a permission to selected player or given account.\n\n#reamID may be -1 for all realms.'),
('.rbac account deny',   204, 'Syntax: rbac account deny [$account] #id [#realmId]\n\nDeny a permission to selected player or given account.\n\n#reamID may be -1 for all realms.'),
('.rbac account revoke', 205, 'Syntax: rbac account revoke [$account] #id\n\nRemove a permission from an account\n\nNote: Removes the permission from granted or denied permissions'),
('.rbac list',           206, 'Syntax: rbac list [$id]\n\nView list of all permissions. If $id is given will show only info for that permission.');
 
 
/* 
* sql\updates\world\2013_09_29_01_world_sai.sql 
*/ 
-- 11610 Leading the Ancestors Home
UPDATE `creature_template` SET `ainame`='SmartAI' WHERE `entry` IN(25397,25398,25399);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN(25397,25398,25399) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(25397,0,0,0,8,0,100,0,45536,0,0,0,33,25397,0,0,0,0,0,7,0,0,0,0,0,0,0,'Elder Kesuk - On Spell Hit - Give Quest Credit'),
(25398,0,0,0,8,0,100,0,45536,0,0,0,33,25398,0,0,0,0,0,7,0,0,0,0,0,0,0,'Elder Sagani - On Spell Hit - Give Quest Credit'),
(25399,0,0,0,8,0,100,0,45536,0,0,0,33,25399,0,0,0,0,0,7,0,0,0,0,0,0,0,'Elder Takret - On Spell Hit - Give Quest Credit');
 
 
/* 
* sql\updates\world\2013_09_29_02_world_sai.sql 
*/ 
DELETE FROM `creature_ai_scripts` WHERE  `creature_id` IN (27355,27450);
DELETE FROM `smart_scripts` WHERE `entryorguid`IN(27355,27449,27450) AND `source_type`=0;
UPDATE `creature_template` SET AIName='SmartAI' WHERE entry IN(27355,27449,27450);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27450,0,0,1,8,0,100,0,48790,0,0,0,33,27450,0,0,0,0,0,7,0,0,0,0,0,0,0,'Neltharions Flame Control Bunny - On Spellhit (Neltharions Flame) - Give Kill Credit'),
(27450,0,1,2,61,0,100,0,0,0,0,0,45,1,1,0,0,0,0,9,27449,0,200,0,0,0,0, 'Neltharions Flame Control Bunny - Linked with Previous Event - Set Data 1 1 on Neltharions Flame Fire Bunny'),
(27450,0,2,0,61,0,100,0,0,0,0,0,45,1,1,0,0,0,0,9,27355,0,200,0,0,0,0, 'Neltharions Flame Control Bunny - Linked with Previous Event - Set Data 1 1 on Rothin the Decaying'),
(27449,0,0,1,38,0,100,0,1,1,0,0,45,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Neltharions Flame Fire Bunny - On Data set 1 1 - Set Data 1 0 on self'),
(27449,0,1,0,61,0,100,0,0,0,0,0,11,48786,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Neltharions Flame Fire Bunny - Linked with Previous Event - Cast Neltharions Flame Fire Bunny: Periodic Fire Aura'),
(27355,0,0,1,25,0,100,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Reset - Disable Combat Movement'),
(27355,0,1,0,61,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - Linked with Previous Event - Set Phase 0'),
(27355,0,2,3,4,0,100,0,0,0,0,0,11,9613,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Agro - Cast Shadowbolt'),
(27355,0,3,0,61,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - Linked with Previous Event - Set Phase 1'),
(27355,0,4,0,9,1,100,0,0,40,3400,4800,11,9613,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - Linked with Previous Event - On Range (Phase 1) - Cast Shadow Bolt'),
(27355,0,5,6,3,1,100,0,0,7,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Less than 7% Mana - Allow Combat Movement'),
(27355,0,6,0,61,1,100,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - Linked with Previous Event - Set Phase 2'),
(27355,0,7,0,9,1,100,0,35,80,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Target More than 35 Yards away - Allow Combat Movement'),
(27355,0,8,0,9,1,100,0,5,15,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Target less than 15 Yards away - Disable Combat Movement'),
(27355,0,9,0,9,1,100,0,0,5,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Target less than 5 Yards away - Allow Combat Movement'),
(27355,0,10,0,3,3,100,0,15,100,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On More than 15% Mana - Set Phase 1'),
(27355,0,11,0,0,0,100,0,12000,17000,15000,20000,11,51337,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - IC - On Range (Phase 1) - Cast Shadow Flame'),
(27355,0,12,0,2,0,100,1,0,30,9500,11000,11,51512,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Less than 30% HP - Cast Aegis of Neltharion'),
(27355,0,13,0,7,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Evade - Set Phase 0'),
(27355,0,14,0,25,0,100,0,0,0,0,0,18,768,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Reset/Spawn - Disable Combat'),
(27355,0,15,16,38,0,100,0,1,1,0,0,45,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Data set 1 1 - Set Data 1 0 on self'),
(27355,0,16,17,61,0,100,0,0,0,0,0,19,768,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - Linked with Previous Event - Enable Combat'),
(27355,0,17,0,61,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - Linked with Previous Event - Say'),
(27355,0,18,0,4,0,100,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Agro - Say'),
(27355,0,19,0,6,0,100,0,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Rothin the Decaying <Cult of the Damned> - On Death - Say');

DELETE FROM `creature_text` WHERE `entry`=27355;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(27355,0,0,'No... NO! What have you done?! So many ancient wyrms wasted... what magic could do this?',14,0,100,1,0,0,'Rothin the Decaying <Cult of the Damned>'),
(27355,1,0,'Foolish errand $g boy:girl; ... you will die for interrupting my work!',14,0,100,1,0,0,'Rothin the Decaying <Cult of the Damned>'),
(27355,2,0,'This is not the end... death only... strengthens...',14,0,100,1,0,0,'Rothin the Decaying <Cult of the Damned>');
 
 
/* 
* sql\updates\world\2013_09_29_03_world_sai.sql 
*/ 
UPDATE `creature_template` SET `ainame`='SmartAI' WHERE `entry`=10541;
DELETE FROM `smart_scripts` WHERE `entryorguid`IN(-23712,-23713,-23714,-23715,-23716,10541) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(-23712,0,0,1,8,0,100,0,16378,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krakle''s Thermometer - On Spell Hit (Temperature Reading)- Say'),
(-23713,0,0,1,8,0,100,0,16378,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krakle''s Thermometer - On Spell Hit (Temperature Reading)- Say'),
(-23714,0,0,1,8,0,100,0,16378,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krakle''s Thermometer - On Spell Hit (Temperature Reading)- Say'),
(-23715,0,0,1,8,0,100,0,16378,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krakle''s Thermometer - On Spell Hit (Temperature Reading)- Say'),
(-23716,0,0,1,8,0,100,0,16378,0,0,0,33,10541,0,0,0,0,0,7,0,0,0,0,0,0,0,'Krakle''s Thermometer - On Spell Hit (Temperature Reading)- Give Kill Credit'),
(-23716,0,1,0,61,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krakle''s Thermometer - Linked with Previous Event - Say');

DELETE FROM `creature_text` WHERE `entry` =10541;

INSERT INTO `creature_text` (`entry`, `groupid`, `id`, `text`, `type`, `language`, `probability`, `emote`, `duration`, `sound`, `comment`) VALUES 
(10541, 0, 0, 'It''s 428,000 degrees Kraklenheit... What''s happening, hot stuff?', 12, 0, 100, 0, 0, 0, 'Krakle''s Thermometer'),
(10541, 0, 1, 'DING! 428,000 degrees Kraklenheit, exactly! Well, approximately. Almost. Somewhere around there...', 12, 0, 100, 0, 0, 0, 'Krakle''s Thermometer'),
(10541, 0, 2, 'Measuring by Kraklenheit, it is 428,000 dewgrees! That''s Krakley!', 12, 0, 100, 0, 0, 0, 'Krakle''s Thermometer'),
(10541, 1, 0, 'The temperature is 122 degrees Kraklenheit.', 12, 0, 100, 0, 0, 0, 'Krakle''s Thermometer'),
(10541, 1, 1, 'The temperature is 9280 degrees Kraklenheit! That''s HOT!', 12, 0, 100, 0, 0, 0, 'Krakle''s Thermometer'),
(10541, 1, 2, 'Wow, it''s 3 degrees Kraklenheit.  Keep Looking.', 12, 0, 100, 0, 0, 0, 'Krakle''s Thermometer');
 
 
/* 
* sql\updates\world\2013_09_29_04_world_updatesi.sql 
*/ 
UPDATE `smart_scripts` SET `link`=12 WHERE `entryorguid`=8503 AND `source_type`=0 AND `id`=11;
UPDATE `smart_scripts` SET `event_type`=61,`event_param2`=0 WHERE `entryorguid`=8503 AND `source_type`=0 AND `id`=12;
UPDATE `smart_scripts` SET `event_type`=61,`link`=0 WHERE `entryorguid`=8503 AND `source_type`=0 AND `id`=13;
 
 
/* 
* sql\updates\world\2013_09_29_05_world_updates.sql 
*/ 
UPDATE `conditions` SET `NegativeCondition`=1 WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=9155 AND `SourceEntry`=0 AND `SourceId`=0 AND `ElseGroup`=0 AND `ConditionTypeOrReference`=2 AND `ConditionTarget`=0 AND `ConditionValue1`=34842 AND `ConditionValue2`=10 AND `ConditionValue3`=0; 
UPDATE `conditions` SET `NegativeCondition`=1 WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=9156 AND `SourceEntry`=0 AND `SourceId`=0 AND `ElseGroup`=0 AND `ConditionTypeOrReference`=2 AND `ConditionTarget`=0 AND `ConditionValue1`=34842 AND `ConditionValue2`=10 AND `ConditionValue3`=0; 
 
 
/* 
* sql\updates\world\2013_09_29_06_world_sai.sql 
*/ 
UPDATE `creature_template` SET `ainame`='SmartAI' WHERE `entry` IN (25442,25441,25443);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (25442,25441,25443) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(25441,0,0,0,8,0,100,0,45583,0,0,0,33,25441,0,0,0,0,0,7,0,0,0,0,0,0,0,'North Platform - On Spell Hit - Give Quest Credit'),
(25442,0,0,0,8,0,100,0,45583,0,0,0,33,25442,0,0,0,0,0,7,0,0,0,0,0,0,0,'East Platform - On Spell Hit - Give Quest Credit'),
(25443,0,0,0,8,0,100,0,45583,0,0,0,33,25443,0,0,0,0,0,7,0,0,0,0,0,0,0,'West Platform - On Spell Hit - Give Quest Credit');
 
 
/* 
* sql\updates\world\2013_09_29_07_world_sai.sql 
*/ 
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceGroup`=1 AND `SourceEntry`=57852;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13,1,57852,0,0,31,0,3,30742,0,0,0,0,'','Destroy Altar can hit First Summoning Altar'),
(13,1,57852,0,1,31,0,3,30744,0,0,0,0,'','Destroy Altar can hit Second Summoning Altar'),
(13,1,57852,0,2,31,0,3,30745,0,0,0,0,'','Destroy Altar can hit Third Summoning Altar'),
(13,1,57852,0,3,31,0,3,30950,0,0,0,0,'','Destroy Altar can hit Fourth Summoning Altar');

UPDATE `creature_template` SET `ainame`='SmartAI' WHERE `entry` IN (30742,30744,30745,30950);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (30742,30744,30745,30950) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(30742,0,0,0,8,0,100,0,57852,0,0,0,33,30742,0,0,0,0,0,7,0,0,0,0,0,0,0,'First Summoning Altar - On Spell Hit - Give Quest Credit'),
(30744,0,0,0,8,0,100,0,57852,0,0,0,33,30744,0,0,0,0,0,7,0,0,0,0,0,0,0,'Second Summoning Altar - On Spell Hit - Give Quest Credit'),
(30745,0,0,0,8,0,100,0,57852,0,0,0,33,30745,0,0,0,0,0,7,0,0,0,0,0,0,0,'Third Summoning Altar - On Spell Hit - Give Quest Credit'),
(30950,0,0,0,8,0,100,0,57852,0,0,0,33,30950,0,0,0,0,0,7,0,0,0,0,0,0,0,'Fourth Summoning Altar - On Spell Hit - Give Quest Credit');
 
 
/* 
* sql\updates\world\2013_09_30_00_world_item_loot_template.sql 
*/ 
SET @Reference := 10036;  -- Needs 26 reference loot template entries
DELETE FROM `item_loot_template` WHERE `entry` BETWEEN 51999 AND 52005;
INSERT INTO `item_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
-- Satchel of Helpfull Goods (level 0-25)
(51999,1,100,1,1,-@Reference,1),  -- Cloth
(51999,2,100,1,2,-@Reference-1,1),  -- Leather
(51999,3,100,1,3,-@Reference-2,1),  -- Mail
-- Satchel of Helpfull Goods (level 26-35)
(52000,1,100,1,1,-@Reference-3,1),  -- Cloth
(52000,2,100,1,2,-@Reference-4,1),  -- Leather
(52000,3,100,1,3,-@Reference-5,1),  -- Mail
-- Satchel of Helpfull Goods (level 36-45)
(52001,1,100,1,1,-@Reference-6,1),  -- Cloth
(52001,2,100,1,2,-@Reference-7,1),  -- Leather
(52001,3,100,1,3,-@Reference-8,1),  -- Mail
(52001,4,100,1,4,-@Reference-9,1),  -- Plate
-- Satchel of Helpfull Goods (level 46-55)
(52002,1,100,1,1,-@Reference-10,1), -- Cloth
(52002,2,100,1,2,-@Reference-11,1), -- Leather
(52002,3,100,1,3,-@Reference-12,1), -- Mail
(52002,4,100,1,4,-@Reference-13,1), -- Plate
-- Satchel of Helpfull Goods (level 56-60)
(52003,1,100,1,1,-@Reference-14,1), -- Cloth
(52003,2,100,1,2,-@Reference-15,1), -- leather
(52003,3,100,1,3,-@Reference-16,1), -- Mail
(52003,4,100,1,4,-@Reference-17,1), -- Plate
-- Satchel of Helpfull Goods (level 61-64)
(52004,1,100,1,1,-@Reference-18,1), -- Cloth
(52004,2,100,1,2,-@Reference-19,1), -- leather
(52004,3,100,1,3,-@Reference-20,1), -- mail
(52004,4,100,1,4,-@Reference-21,1), -- plate
-- Satchel of Helpfull Goods (level 65-70)
(52005,1,100,1,1,-@Reference-22,1),  -- Cloth
(52005,2,100,1,2,-@Reference-23,1),  -- leather
(52005,3,100,1,3,-@Reference-24,1),  -- mail
(52005,4,100,1,4,-@Reference-25,1);  -- plate
DELETE FROM `reference_loot_template` WHERE `entry` BETWEEN @Reference AND @Reference+25;
INSERT INTO `reference_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
-- Satchel of Helpfull Goods (level 0-25)
(@Reference,51968,0,1,1,1,1), -- Enumerated Wrap
(@Reference,51994,0,1,1,1,1), -- Tumultuous Cloak
(@Reference+1,51964,0,1,2,1,1), -- Vigorous Belt
(@Reference+1,51994,0,1,2,1,1), -- Tumultuous Cloak
(@Reference+2,51978,0,1,3,1,1), -- Earthbound Girdle
(@Reference+2,51994,0,1,3,1,1), -- Tumultuous Cloak
-- Satchel of Helpfull Goods (level 26-35)
(@Reference+3,51973,0,1,1,1,1), -- Enumerated Handwraps
(@Reference+3,51996,0,1,1,1,1), -- Tumultuous Necklace
(@Reference+4,51965,0,1,2,1,1), -- Vigorous Handguards
(@Reference+4,51996,0,1,2,1,1), -- Tumultuous Necklace
(@Reference+5,51980,0,1,3,1,1), -- Earthbound Handgrips
(@Reference+5,51996,0,1,3,1,1), -- Tumultuous Necklace
-- Satchel of Helpfull Goods (level 36-45)
(@Reference+6,51974,0,1,1,1,1), -- Enumerated Shoulderpads
(@Reference+6,51992,0,1,1,1,1), -- Tumultuous Ring
(@Reference+7,51966,0,1,2,1,1), -- Vigorous Spaulders
(@Reference+7,51992,0,1,2,1,1), -- Tumultuous Ring
(@Reference+8,51976,0,1,3,1,1), -- Earthbound Shoulderguards
(@Reference+8,51992,0,1,3,1,1), -- Tumultuous Ring
(@Reference+9,51984,0,1,4,1,1), -- Stalwart Shoulderpads
(@Reference+9,51992,0,1,4,1,1), -- Tumultuous Ring
-- Satchel of Helpfull Goods (level 46-55)
(@Reference+10,51967,0,1,1,1,1), -- Enumerated Sandals
(@Reference+10,51972,0,1,1,1,1), -- Enumerated Bracers
(@Reference+11,51962,0,1,2,1,1), -- Vigorous Bracers
(@Reference+11,51963,0,1,2,1,1), -- Vigorous Stompers
(@Reference+12,51981,0,1,3,1,1), -- Earthbound Wristguards
(@Reference+12,51982,0,1,3,1,1), -- Earthbound Boots
(@Reference+13,51989,0,1,4,1,1), -- Stalwart Bands
(@Reference+13,51990,0,1,4,1,1), -- Stalwart Treads
-- Satchel of Helpfull Goods (level 56-60)
(@Reference+14,51971,0,1,1,1,1), -- Enumerated Belt
(@Reference+14,51993,0,1,1,1,1), -- Turbulent Cloak
(@Reference+15,51959,0,1,2,1,1), -- Vigorous Belt
(@Reference+15,51993,0,1,2,1,1), -- Turbulent Cloak
(@Reference+16,51977,0,1,3,1,1), -- Earthbound Girdle
(@Reference+16,51993,0,1,3,1,1), -- Turbulent Cloak
(@Reference+17,51985,0,1,4,1,1), -- Stalwart Belt
(@Reference+17,51993,0,1,4,1,1), -- Turbulent Cloak
-- Satchel of Helpfull Goods (level 61-64)
(@Reference+18,51970,0,1,1,1,1), -- Enumerated Gloves
(@Reference+18,51995,0,1,1,1,1), -- Turbulent Necklace
(@Reference+19,51960,0,1,2,1,1), -- Vigorous Gloves
(@Reference+19,51995,0,1,2,1,1), -- Turbulent Necklace
(@Reference+20,51979,0,1,3,1,1), -- Earthbound Grips
(@Reference+20,51995,0,1,3,1,1), -- Turbulent Necklace
(@Reference+21,51987,0,1,4,1,1), -- Stalwart Grips
(@Reference+21,51995,0,1,4,1,1), -- Turbulent Necklace
-- Satchel of Helpfull Goods (level 65-70)
(@Reference+22,51961,0,1,1,1,1), -- Vigorous Shoulderguards
(@Reference+22,51991,0,1,1,1,1), -- Turbulent Signet
(@Reference+23,51969,0,1,2,1,1), -- Enumerated Shoulders
(@Reference+23,51991,0,1,2,1,1), -- Turbulent Signet
(@Reference+24,51975,0,1,3,1,1), -- Earthbound Shoulders
(@Reference+24,51991,0,1,3,1,1), -- Turbulent Signet
(@Reference+25,51983,0,1,4,1,1), -- Stalwart Shoulderguards
(@Reference+25,51991,0,1,4,1,1); -- Turbulent Signet

-- -------------------------------------------------------------------
-- Set some Parameters
-- -------------------------------------------------------------------
SET @Cloth := 400; -- Class Bitmask: 16 (Priest) +128 (Mage) +256 (Warlock)
SET @Leather1 := 1100; -- Class Bitmask: 4 (Hunter) +8 (Rogue) +64 (Shaman) +1024 (Druid)
SET @Leather2 := 1032; -- Class Bitmask: 8 (Rogue) +1024 (Druid)
SET @Mail1 := 3; -- Class Bitmask: 1 (Warrior) +2 (Paladin)
SET @Mail2 := 68; -- Class Bitmask: 4 (Hunter) +8 (Shaman)
SET @Plate := 35; -- Class Bitmask: 1 (Warrior) +2 (Paladin) +32 (DeathKnight)
-- Add conditions to make sure everyone gets beneficial loot for their class
-- -------------------------------------------------------------------
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=5 AND `SourceGroup` BETWEEN 51999 AND 52005;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=10 AND `SourceGroup` BETWEEN @Reference AND @Reference+25;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
-- Cloth Items
(10,@Reference,51968,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Enumerated Wrap only for clothusers'),
(10,@Reference,51994,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Tumultuous Cloak only for clothusers'),
(10,@Reference+3,51973,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Enumerated Handwraps only for clothusers'),
(10,@Reference+3,51996,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Tumultuous Necklace only for clothusers'),
(10,@Reference+6,51974,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Enumerated Shoulderpads only for clothusers'),
(10,@Reference+6,51992,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Tumultuous Ring only for clothusers'),
(10,@Reference+10,51967,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Enumerated Sandals only for clothusers'),
(10,@Reference+10,51972,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Enumerated Bracers only for clothusers'),
(10,@Reference+14,51971,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Enumerated Belt only for clothusers'),
(10,@Reference+14,51993,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Turbulent Cloak only for clothusers'),
(10,@Reference+18,51970,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Enumerated Gloves only for clothusers'),
(10,@Reference+18,51995,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Turbulent Necklace only for clothusers'),
(10,@Reference+22,51969,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Enumerated Shoulders only for clothusers'),
(10,@Reference+22,51991,0,0,15,0,@Cloth,0,0,0,0,'','SOHG: Turbulent Signet only for clothusers'),
-- Leather Items
(10,@Reference+1,51964,0,0,15,0,@Leather1,0,0,0,0,'','SOHG: Vigorous Belt only for leatherusers'),
(10,@Reference+1,51994,0,0,15,0,@Leather1,0,0,0,0,'','SOHG: Tumultuous Cloak only for leatherusers'),
(10,@Reference+4,51965,0,0,15,0,@Leather1,0,0,0,0,'','SOHG: Vigorous Handguards only for leatherusers'),
(10,@Reference+4,51996,0,0,15,0,@Leather1,0,0,0,0,'','SOHG: Tumultuous Necklace only for leatherusers'),
(10,@Reference+7,51966,0,0,15,0,@Leather2,0,0,0,0,'','SOHG: Vigorous Spaulders only for leatherusers'),
(10,@Reference+7,51992,0,0,15,0,@Leather2,0,0,0,0,'','SOHG: Tumultuous ring only for leatherusers'),
(10,@Reference+11,51962,0,0,15,0,@Leather2,0,0,0,0,'','SOHG: Vigorous Bracers only for leatherusers'),
(10,@Reference+11,51963,0,0,15,0,@Leather2,0,0,0,0,'','SOHG: Vigorous Stompers only for leatherusers'),
(10,@Reference+15,51959,0,0,15,0,@Leather2,0,0,0,0,'','SOHG: Vigorous Belt only for leatherusers'),
(10,@Reference+15,51993,0,0,15,0,@Leather2,0,0,0,0,'','SOHG: Turbulent Cloak only for leatherusers'),
(10,@Reference+19,51960,0,0,15,0,@Leather2,0,0,0,0,'','SOHG: Vigorous Gloves only for leatherusers'),
(10,@Reference+19,51995,0,0,15,0,@Leather2,0,0,0,0,'','SOHG: Turbulent Necklace only for leatherusers'),
(10,@Reference+23,51961,0,0,15,0,@Leather2,0,0,0,0,'','SOHG: Vigorous Shoulderguards only for leatherusers'),
(10,@Reference+23,51991,0,0,15,0,@Leather2,0,0,0,0,'','SOHG: Turbulent Signet only for leatherusers'),
-- Mail Items
(10,@Reference+2,51978,0,0,15,0,@Mail1,0,0,0,0,'','SOHG: Earthbound Girdle only for mail users'),
(10,@Reference+2,51994,0,0,15,0,@Mail1,0,0,0,0,'','SOHG: Tumultuous Cloak only for mail users'),
(10,@Reference+5,51980,0,0,15,0,@Mail1,0,0,0,0,'','SOHG: Earthbound Handgrips only for mail users'),
(10,@Reference+5,51996,0,0,15,0,@Mail1,0,0,0,0,'','SOHG: Tumultuous Necklace only for Mail users'),
(10,@Reference+8,51976,0,0,15,0,@Mail2,0,0,0,0,'','SOHG: Earthbound Shoulderguards only for mail users'),
(10,@Reference+8,51992,0,0,15,0,@Mail2,0,0,0,0,'','SOHG: Tumultuous Ring only for mail users'),
(10,@Reference+12,51982,0,0,15,0,@Mail2,0,0,0,0,'','SOHG: Earthbound Boots only for mail users'),
(10,@Reference+12,51981,0,0,15,0,@Mail2,0,0,0,0,'','SOHG: Earthbound Wristguards only for mail users'),
(10,@Reference+16,51977,0,0,15,0,@Mail2,0,0,0,0,'','SOHG: Earthbound Girdle only for mail users'),
(10,@Reference+16,51993,0,0,15,0,@Mail2,0,0,0,0,'','SOHG: Turbulent Cloak only for mail users'),
(10,@Reference+20,51979,0,0,15,0,@Mail2,0,0,0,0,'','SOHG: Earthbound Grips only for mail users'),
(10,@Reference+20,51995,0,0,15,0,@Mail2,0,0,0,0,'','SOHG: Turbulent Necklace only for mail users'),
(10,@Reference+24,51975,0,0,15,0,@Mail2,0,0,0,0,'','SOHG: Earthbound Shoulders only for mail users'),
(10,@Reference+24,51991,0,0,15,0,@Mail2,0,0,0,0,'','SOHG: Turbulent Signet only for Mail users'),
-- Plate Items
(10,@Reference+9,51984,0,0,15,0,@Plate,0,0,0,0,'','SOHG: Stalwart Shoulderpads only for plate users'),
(10,@Reference+9,51992,0,0,15,0,@Plate,0,0,0,0,'','SOHG: Tumultuous Ring only for plate users'),
(10,@Reference+13,51989,0,0,15,0,@Plate,0,0,0,0,'','SOHG: Stalwart Bands only for plate users'),
(10,@Reference+13,51990,0,0,15,0,@Plate,0,0,0,0,'','SOHG: Stalwart Treads only for plate users'),
(10,@Reference+17,51985,0,0,15,0,@Plate,0,0,0,0,'','SOHG: Stalwart Belt only for plate users'),
(10,@Reference+17,51993,0,0,15,0,@Plate,0,0,0,0,'','SOHG: Turbulent Cloak only for plate users'),
(10,@Reference+21,51987,0,0,15,0,@Plate,0,0,0,0,'','SOHG: Stalwart Grips only for plate users'),
(10,@Reference+21,51995,0,0,15,0,@Plate,0,0,0,0,'','SOHG: Turbulent Necklace only for plate users'),
(10,@Reference+25,51983,0,0,15,0,@Plate,0,0,0,0,'','SOHG: Stalwart Shoulderguards only for plate users'),
(10,@Reference+25,51991,0,0,15,0,@Plate,0,0,0,0,'','SOHG: Turbulent Signet only for plate users');
 
 
/* 
* sql\updates\world\2013_09_30_01_world_item_loot_template.sql 
*/ 
DELETE FROM `reference_loot_template` WHERE `entry`=11112;
UPDATE `reference_loot_template` SET `entry`=11114 WHERE `item`= 34831 AND `entry`=11115;
DELETE FROM `item_loot_template` WHERE `entry`=35348;
INSERT INTO `item_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
(35348,1,100,1,0,-11113,1), -- Garanteed Drops
(35348,2, 60,1,0,-11116,1), -- Rare Pets
(35348,4, 60,1,0,-11115,1), -- Junk items
(35348,3,  5,1,0,-11114,1); -- Lesser Treasures
 
 
/* 
* sql\updates\world\2013_09_30_02_world_sai_335.sql 
*/ 
-- DB/Quest: Fix: [A/H] The Summoning
-- Note: This warrior quest was deleted in 4.0.1.
SET @ENTRY := 6176; -- Bath'rah the Windwatcher
DELETE FROM `waypoints` WHERE `entry` = @ENTRY AND `pointid` BETWEEN 8 AND 14;
UPDATE `smart_scripts` SET `event_type` = 40 WHERE `entryorguid` = @ENTRY AND `id` = 1;
 
 
/* 
* sql\updates\world\2013_09_30_03_world_misc.sql 
*/ 
DELETE FROM `command` WHERE `permission` BETWEEN 200 AND 216;
INSERT INTO `command` (`name`, `permission`, `help`) VALUES
('rbac account list',   202, 'Syntax: rbac account list [$account]\n\nView permissions of selected player or given account\nNote: Only those that affect current realm'),
('rbac account grant',  203, 'Syntax: rbac account grant [$account] #id [#realmId]\n\nGrant a permission to selected player or given account.\n\n#reamID may be -1 for all realms.'),
('rbac account deny',   204, 'Syntax: rbac account deny [$account] #id [#realmId]\n\nDeny a permission to selected player or given account.\n\n#reamID may be -1 for all realms.'),
('rbac account revoke', 205, 'Syntax: rbac account revoke [$account] #id\n\nRemove a permission from an account\n\nNote: Removes the permission from granted or denied permissions'),
('rbac list',           206, 'Syntax: rbac list [$id]\n\nView list of all permissions. If $id is given will show only info for that permission.');
 
 
/* 
* sql\updates\world\2013_09_30_04_world_update.sql 
*/ 
UPDATE `creature_template_addon` SET `mount`=25678, `bytes2`=0x1 WHERE `entry`=37845;
UPDATE `smart_scripts` SET `action_param1`=45492, `comment`='Quel''Delar Skull Target - on spell hit - Cast Shadow Nova' WHERE `entryorguid`=37852 AND `source_type`=0 AND `id`=1 AND `link`=0;
 
 
/* 
* sql\updates\world\2013_10_01_00_misc.sql 
*/ 
UPDATE `creature_template` SET `npcflag`=4227 WHERE `entry`=38316;

DELETE FROM `gossip_menu_option` WHERE `menu_id`=10996 AND `id`=5;
INSERT INTO `gossip_menu_option` (`menu_id`, `id`, `option_icon`, `option_text`, `option_id`, `npc_option_npcflag`, `action_menu_id`, `action_poi_id`, `box_coded`, `box_money`, `box_text`) VALUES 
(10996, 5, 1, 'Show me the armor of Scourge lords, Ormus.', 3, 128, 0, 0, 0, 0, '');

DELETE FROM `conditions` WHERE  `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10996 AND `SourceEntry`=5;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(15, 10996, 5, 0, 0, 15, 0, 32, 0, 0, 0, 0, 0, '', 'Ormus the Penitent - Show gossip option if player is a Death Knight');
 
 
/* 
* sql\updates\world\2013_10_01_00_world_sai.sql 
*/ 
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN(10977,10978,7583);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (10977,10978,7583);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10977, 0, 0, 0, 8,  0, 100, 0, 17166, 0, 0, 0, 33, 10977 , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Quixxil - On Spellhit (Release Umis Yeti) - Kill Credit'),
(10978, 0, 0, 0, 8,  0, 100, 0, 17166, 0, 0, 0, 33, 10978 , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Legacki - On Spellhit (Release Umis Yeti)- Kill Credit'),
(7583, 0, 0, 0, 8,  0, 100, 0, 17166, 0, 0, 0, 33, 7583 , 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Sprinkle - On Spellhit (Release Umis Yeti)- Kill Credit');
 
 
/* 
* sql\updates\world\2013_10_05_00_world_sai.sql 
*/ 
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=48188;

INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES 
(13, 1, 48188, 0, 0, 31, 0, 3, 27349, 0, 0, 0, 0, '', 'Flask of Blight Targets Scarlet Onslaught Prisoner');

DELETE FROM `disables` WHERE `sourceType`=0 AND `entry`=48188;

INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES 
(0, 48188, 64, '', '', 'Ignore LOS on Flask of Blight');
 
 
/* 
* sql\updates\world\2013_10_06_00_world_sai.sql 
*/ 
UPDATE `gameobject_template` SET `AIName`='SmartGameObjectAI', `ScriptName`='' WHERE  `entry`=184725;
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN(21039,21898,20767,21504) ;

DELETE FROM `smart_scripts` WHERE `source_type`=1 AND `entryorguid`=184725;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`IN(21039,21898,20767,21504);
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=2103900;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(184725, 1, 0 ,1, 70, 0, 100, 0, 2, 0, 0,0,45,1,1,0,0,0,0,10,73864,21039,0,0,0,0,0, 'Mana Bomb - On State Changed - Set Data Mana Bomb Kill Credit Trigger'),
(184725, 1, 1 ,2, 61, 0, 100, 0, 0, 0, 0,0,33,21039,0,0,0,0,0,16,0,0,0,0,0,0,0, 'Mana Bomb - Linked with Previous Event - Quest Credit'),
(184725, 1, 2 ,0, 61, 0, 100, 0, 0, 0, 0,0,45,1,1,0,0,0,0,9,16769,0,50,0,0,0,0, 'Mana Bomb - Linked with Previous Event - Set Data'),
--
(21039, 0, 0 ,1, 38, 0, 100, 0, 1, 1, 0,0,45,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - On Data Set - Set Data'),
(21039, 0, 1 ,2, 61, 0, 100, 0, 0, 0, 0,0,1,0,3000,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - Linked with Previous Event - Say'),
(21039, 0, 2 ,0, 61, 0, 100, 0, 0, 0, 0,0,80,2103900,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - Linked with Previous Event - Run Script'),
(21039, 0, 3 ,4, 52, 0, 100, 0, 0, 21039, 0,0,1,1,3000,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - On Text Over - Say'),
(21039, 0, 4 ,0, 61, 0, 100, 0, 0, 0, 0,0,80,2103900,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - Linked with Previous Event - Run Script'),
(21039, 0, 5 ,6, 52, 0, 100, 0, 1, 21039, 0,0,1,2,3000,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - On Text Over Event - Say'),
(21039, 0, 6 ,0, 61, 0, 100, 0, 0, 0, 0,0,80,2103900,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - Linked with Previous Event - Run Script'),
(21039, 0, 7 ,8, 52, 0, 100, 0, 2, 21039, 0,0,1,3,3000,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - On Text Over - Say'),
(21039, 0, 8 ,0, 61, 0, 100, 0, 0, 0, 0,0,80,2103900,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - Linked with Previous Event - Run Script'),
(21039, 0, 9 ,10, 52, 0, 100, 0, 3, 21039, 0,0,1,4,3000,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - On Text Over - Say'),
(21039, 0, 10 ,0, 61, 0, 100, 0, 0, 0, 0,0,80,2103900,2,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Kill Credit Trigger - Linked with Previous Event - Run Script'),
--
(21039, 0, 12 ,0, 52, 0, 100, 0, 4, 21039, 0,0,45,1,1,0,0,0,0,9,20767,0,200,0,0,0,0, 'Mana Bomb Kill Credit Trigger - On Text Over - Set Data Mana Bomb Explosion Trigger'),
(20767, 0, 0 ,1, 38, 0, 100, 0, 1, 1, 0,0,45,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Explosion  Trigger - On Data Set - Set Data'),
(20767, 0, 1 ,2, 61, 0, 100, 0, 0, 0, 0,0,11,35513,0,0,0,0,0,1,0,0,0,0, 0, 0, 0, 'Mana Bomb Explosion  Trigger - Linked with Previous Event - Cast Mana Bomb Explosion'),
--
(21898, 0, 0 ,1, 38, 0, 100, 0, 1, 1, 0,0,45,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Mana Bomb Lightning  Trigger - On Data Set - Set Data'),
(21898, 0, 1 ,0, 61, 0, 100, 0, 0, 0, 0,0,11,37843,0,0,0,0,0,9,21899,0,200,0, 0, 0, 0, 'Mana Bomb Lightning  Trigger - Linked with Previous Event - Cast Mana Bomb Lightning'),
(2103900, 9, 0 ,0, 0, 0, 100, 0, 0, 0, 0,0,45,1,1,0,0,0,0,9,21898,0,200,0, 0, 0, 0, 'Mana Bomb - Script - Set Data');


DELETE FROM `creature_text` WHERE `entry` IN(21039,18554,16769);
DELETE FROM `creature_text` WHERE `entry` =21504 AND `groupid`>3;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(21039,0,0,'5...',41,0,100,0,0,0,'Mana Bomb'),
(21039,1,0,'4...',41,0,100,0,0,0,'Mana Bomb'),
(21039,2,0,'3...',41,0,100,0,0,0,'Mana Bomb'),
(21039,3,0,'2...',41,0,100,0,0,0,'Mana Bomb'),
(21039,4,0,'1...',41,0,100,0,0,0,'Mana Bomb'),
(18554,0,0,'You come into my house and threaten ME? I think not!',12,0,100,0,0,0,'Sharth Voldoun'),
(18554,1,0,'All goes exceedingly well, my lord. Testing of the smaller prototype at the Cenarion Thicket was a complete success. The second bomb is being ritually fueled in the courtyard below even as we speak. And, I''ve sent a courier to Tuurem to bring the rest of the parts to us here.',12,0,100,0,0,0,'Sharth Voldoun'),
(18554,2,0,'You are satisfied?',12,0,100,0,0,0,'Sharth Voldoun'),
(18554,3,0,'I can assure you that we will not fail, my master. I am personally overseeing every aspect of the construction, and I hold the final codes, myself. Within a day''s time, I will have the bomb detonated on those nearby pests.',12,0,100,0,0,0,'Sharth Voldoun'),
(16769,0,0,'Knowing there isn''t enough time, the Firewing Warlock doesn''t even try to run.', 16,0,100,0,0,0,'Firewing Warlock'),
--
(21504,4,0,'For the time being, yes. However, allow my presence to be a motivator. Prince Kael''thas was displeased with the failure of the crystal experiment on Fallen Sky Ridge. This is one of the reasons for why we chose the Cenarion druids as the testing grounds for the bomb.',12,0,100,0,0,0,'Pathaleon the Calculators Image'),
(21504,5,0,'I need not tell you what will happen should the mana bomb down in the courtyard fail to be used on its target soon? Since moving into the forest, they''ve become increasingly annoying to our operations: here, at Tuurem and to the south at the Bonechewer Ruins.',12,0,100,0,0,0,'Pathaleon the Calculators Image'),
(21504,6,0,'I think that we should teach a lesson to both the Horde and the Alliance. One that they will not soon forget!',12,0,100,0,0,0,'Pathaleon the Calculators Image'),
(21504,7,0,'See to it that you do, Sharth, or I will personally see to your slow torture and death.',12,0,100,0,0,0,'Pathaleon the Calculators Image'),
(21504,8,0,'I believe I may recognize them. Deal with this quickly, Sharth. Then take the mana bomb and destroy their town!',12,0,100,0,0,0,'Pathaleon the Calculators Image');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=35958;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 3, 35958, 0, 0, 31, 0, 3, 16769, 0, 0, 0, '','Mana Bomb Explosion Targets Firewing Warlock'),
(13, 3, 35958, 0, 1, 31, 0, 3, 5355, 0, 0, 0, '','Mana Bomb Explosion Targets Firewing Defender');

UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`= 18554;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=18554;
DELETE FROM `smart_scripts` WHERE `entryorguid`=18554;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(21504,0,0,0,38,0,100,0,1,1,0,0,41,5000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Pathaleon the Calculators Image - On Data Set - Despawn'),
--
(18554,0,0,0,0,0,100,0,3000,5000,40000,45000,11,15277,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Sharth Voldoun - IC - Cast    Seal of Reckoning'),
(18554,0,1,0,2,0,100,0,0,40,15000,20000,11,13952,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Sharth Voldoun - On Below 40% HP - Cast Holy Light'),
(18554,0,2,3,4,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,2000,0,0,0,0,0, 'Sharth Voldoun - On Agro - Say'),
(18554,0,3,4,61,0,100,0,0,0,0,0,45,1,1,0,0,0,0,9,21504,0,200,0,0,0,0, 'Sharth Voldoun - Linked with Previous Event - Despawn Pathaleon the Calculators Image'),
(18554,0,4,0,61,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Sharth Voldoun - Linked with Previous Event - Set Phase 0'),
--
(18554,0,5,6,25,0,100,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Sharth Voldoun - On Reset - Set Phase 2'),
(18554,0,6,0,61,0,100,0,0,0,0,0,12,21504,8,0,0,0,0,8,0,0,0,-2281.936523,3099.178711,152.817734,3.699372, 'Sharth Voldoun - Linked with Previous Event - Spawn Pathaleon the Calculators Image'),
(18554,0,7,0,10,2,100,0,1,200,60000,60000,1,1,6000,0,0,0,0,1,0,0,0,0,0,0,0, 'Sharth Voldoun - Linked with Previous Event - Spawn Pathaleon the Calculators Image'),
(18554,0,8,0,52,2,100,0,1,18554,0,0,1,2,3000,0,0,0,0,1,0,0,0,0,0,0,0, 'Sharth Voldoun - On Text Over Event - Say'),
(18554,0,9,0,52,2,100,0,2,18554,0,0,1,4,6000,0,0,0,0,9,21504,0,200,0,0,0,0, 'Sharth Voldoun - On Text Over Event - Say'),
(18554,0,10,0,52,2,100,0,4,21504,0,0,1,5,6000,0,0,0,0,9,21504,0,200,0,0,0,0, 'Sharth Voldoun - On Text Over Event - Say'),
(18554,0,11,0,52,2,100,0,5,21504,0,0,1,6,6000,0,0,0,0,9,21504,0,200,0,0,0,0, 'Sharth Voldoun - On Text Over Event - Say'),
(18554,0,12,0,52,2,100,0,6,21504,0,0,1,3,6000,0,0,0,0,1,0,0,0,0,0,0,0, 'Sharth Voldoun - On Text Over Event - Say'),
(18554,0,13,0,52,2,100,0,3,18554,0,0,1,7,6000,0,0,0,0,9,21504,0,200,0,0,0,0, 'Sharth Voldoun - On Text Over Event - Say'),
(18554,0,14,0,52,0,100,0,0,18554,0,0,1,8,6000,0,0,0,0,9,21504,0,200,0,0,0,0, 'Sharth Voldoun - On Text Over Event - Say');

UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`= 16769;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=16769;
DELETE FROM `smart_scripts` WHERE `entryorguid`=16769;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16769,0,0,0,25,0,100,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - On Reset - Prevent Combat Movement'),
(16769,0,1,2,4,0,100,0,0,0,0,0,11,9613,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Firewing Warlock - On Agro - Cast Shadow Bolt'),
(16769,0,2,0,61,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - Linked with Previous Event - Set Phase 1'),
(16769,0,3,0,9,1,100,0,0,40,2400,3800,11,9613,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Firewing Warlock - On Range - Cast Shadow Bolt'),
(16769,0,4,5,3,1,100,0,0,15,0,0,21,1,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Firewing Warlock - On Less than 15% Mana - Allow Combat Movement'),
(16769,0,5,0,61,1,100,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - Linked with Previous Event - Set Phase 2'),
(16769,0,6,0,9,1,100,0,35,80,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - On Range - Allow Combat Movement'),
(16769,0,7,0,9,1,100,0,5,15,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - On Range - Prevent Combat Movement'),
(16769,0,8,0,9,1,100,0,0,5,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - On Range - Allow Combat Movement'),
(16769,0,9,0,3,2,100,0,30,0,0,0,22,1,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Firewing Warlock - On More than 30% Mana - Set Phase 1'),
(16769,0,10,0,0,0,100,0,5000,9000,25000,35000,11,33483,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - IC - Cast Mana Tap'),
(16769,0,11,0,0,0,100,0,9000,15000,15000,20000,11,33390,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Firewing Warlock - IC - Cast Arcane Torrent'),
(16769,0,12,0,0,0,100,0,3000,5000,18000,24000,11,11962,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Firewing Warlock - IC - Cast Immolate'),
(16769,0,13,0,2,0,100,1,0,30,0,0,11,32932,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - On Less than 30% HP - Cast Sun Shield'),
(16769,0,14,0,2,0,100,1,0,15,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - On Less than 15% HP - Flee for Assist'),
(16769,0,15,0,7,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - On Evade - Set Phase 0'),
(16769,0,16,0,38,0,100,0,1,1,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Firewing Warlock - On Data Set - Say');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=16769;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 17, 16769, 0, 0, 36, 1, 0, 0, 0, 0, 0, '','Only execute SAI if firewing warlock alive');
 
 
/* 
* sql\updates\world\2013_10_07_00_world_cond.sql 
*/ 
UPDATE `quest_template` SET `ExclusiveGroup`=13104 WHERE  `Id` IN (13104,13105);
UPDATE `quest_template` SET `PrevQuestId`=0 WHERE  `Id`IN (13110,13122,13118,13125);
UPDATE `quest_template` SET `RequiredClasses`=1503 WHERE  `Id`=13104;
UPDATE `quest_template` SET `RequiredClasses`=32 WHERE  `Id`=13105;
DELETE FROM  `conditions` WHERE `SourceEntry` IN (13122,13110,13118,13125);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(20, 0, 13110, 0, 0, 8, 0, 13104, 0, 0, 0, 0, '', 'The Restless Dead after Once More Unto The Breach, Hero'),
(19, 0, 13110, 0, 0, 8, 0, 13104, 0, 0, 0, 0, '', 'The Restless Dead after Once More Unto The Breach, Hero'),
(20, 0, 13110, 0, 1, 8, 0, 13105, 0, 0, 0, 0, '', 'The Restless Dead after Once More Unto The Breach, Hero'),
(19, 0, 13110, 0, 1, 8, 0, 13105, 0, 0, 0, 0, '', 'The Restless Dead after Once More Unto The Breach, Hero'),
(20, 0, 13122, 0, 0, 8, 0, 13104, 0, 0, 0, 0, '', 'The Scourgestone after Once More Unto The Breach, Hero'),
(19, 0, 13122, 0, 0, 8, 0, 13104, 0, 0, 0, 0, '', 'The Scourgestone after Once More Unto The Breach, Hero'),
(20, 0, 13122, 0, 1, 8, 0, 13105, 0, 0, 0, 0, '', 'The Scourgestone after Once More Unto The Breach, Hero'),
(19, 0, 13122, 0, 1, 8, 0, 13105, 0, 0, 0, 0, '', 'The Scourgestone after Once More Unto The Breach, Hero'),
(20, 0, 13118, 0, 0, 8, 0, 13104, 0, 0, 0, 0, '', 'The Purging Of Scourgeholme  after Once More Unto The Breach, Hero'),
(19, 0, 13118, 0, 0, 8, 0, 13104, 0, 0, 0, 0, '', 'The Purging Of Scourgeholme  after Once More Unto The Breach, Hero'),
(20, 0, 13118, 0, 1, 8, 0, 13105, 0, 0, 0, 0, '', 'The Purging Of Scourgeholme  after Once More Unto The Breach, Hero'),
(19, 0, 13118, 0, 1, 8, 0, 13105, 0, 0, 0, 0, '', 'The Purging Of Scourgeholme  after Once More Unto The Breach, Hero'),
(20, 0, 13125, 0, 0, 8, 0, 13104, 0, 0, 0, 0, '', 'The Air Stands Still  after Once More Unto The Breach, Hero'),
(19, 0, 13125, 0, 0, 8, 0, 13104, 0, 0, 0, 0, '', 'The Air Stands Still  after Once More Unto The Breach, Hero'),
(20, 0, 13125, 0, 1, 8, 0, 13105, 0, 0, 0, 0, '', 'The Air Stands Still  after Once More Unto The Breach, Hero'),
(19, 0, 13125, 0, 1, 8, 0, 13105, 0, 0, 0, 0, '', 'The Air Stands Still  after Once More Unto The Breach, Hero');
 
 
/* 
* sql\updates\world\2013_10_07_01_world_sai.sql 
*/ 
-- Shattertusk Bull
SET @ENTRY      := 28380;
SET @SOURCETYPE := 0;

DELETE FROM `creature_ai_scripts` WHERE  `creature_id`=28380;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=@SOURCETYPE;
UPDATE `creature_template` SET AIName='SmartAI' WHERE entry=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,@SOURCETYPE,0,0,0,0,100,0,2000,5000,5000,8000,11,51944,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,"Shattertusk Bull - In Combat - Cast Trample"),
(@ENTRY,@SOURCETYPE,1,0,0,0,100,0,7000,10000,13000,16000,11,55196,1,0,0,0,0,2,0,0,0,0.0,0.0,0.0,0.0,"Shattertusk Bull - In Combat - Cast Stomp");

-- Dreadsaber
SET @ENTRY      := 28001;
SET @SOURCETYPE := 0;

DELETE FROM `creature_ai_scripts` WHERE  `creature_id`=28001;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=@SOURCETYPE;
UPDATE `creature_template` SET AIName='SmartAI' WHERE entry=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,@SOURCETYPE,0,0,0,0,100,0,3000,6000,5000,7000,11,24187,0,0,0,0,0,2,0,0,0,0.0,0.0,0.0,0.0,"Dreadsaber - In Combat - Cast Claw");

-- Shardhorn Rhino
SET @ENTRY      := 28009;
SET @SOURCETYPE := 0;

DELETE FROM `creature_ai_scripts` WHERE  `creature_id`=28009;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=@SOURCETYPE;
UPDATE `creature_template` SET AIName='SmartAI' WHERE entry=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,@SOURCETYPE,0,0,4,0,100,0,0,0,0,0,11,55193,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,"Shardhorn Rhino - On Aggro - Cast Rhino Charge"),
(@ENTRY,@SOURCETYPE,1,0,0,0,100,0,5000,9000,7000,12000,11,32019,32,0,0,0,0,4,0,0,0,0.0,0.0,0.0,0.0,"Shardhorn Rhino - In Combat - Cast Gore");

-- Shango
SET @ENTRY      := 28297;
SET @SOURCETYPE := 0;

DELETE FROM `creature_ai_scripts` WHERE  `creature_id`=28297;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=@SOURCETYPE;
UPDATE `creature_template` SET AIName='SmartAI' WHERE entry=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,@SOURCETYPE,0,0,0,0,100,0,5000,9000,7000,12000,11,32019,32,0,0,0,0,4,0,0,0,0.0,0.0,0.0,0.0,"Shango - In Combat - Cast Gore");

-- Mangal Crocolisk
SET @ENTRY      := 28002;
SET @SOURCETYPE := 0;

DELETE FROM `creature_ai_scripts` WHERE  `creature_id`=28002;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=@SOURCETYPE;
UPDATE `creature_template` SET AIName='SmartAI' WHERE entry=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,@SOURCETYPE,0,0,4,0,100,0,0,0,0,0,11,50502,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,"Mangal Crocolisk - On Aggro - Cast Thick Hide"),
(@ENTRY,@SOURCETYPE,1,0,0,0,100,0,3000,6000,6000,9000,11,48287,0,0,0,0,0,2,0,0,0,0.0,0.0,0.0,0.0,"Mangal Crocolisk - In Combat - Cast Powerfull Bite");

-- Emperor Cobra
SET @ENTRY      := 28011;
SET @SOURCETYPE := 0;

DELETE FROM `creature_ai_scripts` WHERE  `creature_id`=28011;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=@SOURCETYPE;
UPDATE `creature_template` SET AIName='SmartAI' WHERE entry=@ENTRY;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,@SOURCETYPE,0,1,1,0,100,0,0,0,0,0,21,0,0,0,0,0,0,0,0,0,0,0.0,0.0,0.0,0.0,"Emperor Cobra - On Spawn - Prevent Combat"),
(@ENTRY,@SOURCETYPE,1,0,61,0,100,0,0,0,0,0,22,0,0,0,0,0,0,0,0,0,0,0.0,0.0,0.0,0.0,"Emperor Cobra - Link - Set Phase to 0 on Spawn"),
(@ENTRY,@SOURCETYPE,2,3,4,0,100,0,0,0,0,0,11,32093,0,0,0,0,0,2,0,0,0,0.0,0.0,0.0,0.0,"Emperor Cobra - On Aggro - Cast Poison"),
(@ENTRY,@SOURCETYPE,3,0,61,0,100,0,0,0,0,0,23,1,0,0,0,0,0,0,0,0,0,0.0,0.0,0.0,0.0,"Emperor Cobra - On Link - Set Phase 1"),
(@ENTRY,@SOURCETYPE,4,0,9,1,100,0,0,40,3400,4800,11,32093,32,0,0,0,0,2,0,0,0,0.0,0.0,0.0,0.0,"Emperor Cobra - Cast Poison Spit (Phase 1)"),
(@ENTRY,@SOURCETYPE,5,0,9,1,100,0,35,80,0,0,21,1,0,0,0,0,0,0,0,0,0,0.0,0.0,0.0,0.0,"Emperor Cobra - Start Combat Movement at 35 Yards (Phase 1)"),
(@ENTRY,@SOURCETYPE,6,0,9,1,100,0,5,15,0,0,21,0,0,0,0,0,0,0,0,0,0,0.0,0.0,0.0,0.0,"Emperor Cobra - Prevent Combat Movement at 15 Yards (Phase 1)"),
(@ENTRY,@SOURCETYPE,7,0,9,1,100,0,0,5,0,0,21,1,0,0,0,0,0,0,0,0,0,0.0,0.0,0.0,0.0,"Emperor Cobra - Start Combat Movement Below 5 Yards (Phase 1)"),
(@ENTRY,@SOURCETYPE,8,0,7,0,100,0,0,0,0,0,22,0,0,0,0,0,0,0,0,0,0,0.0,0.0,0.0,0.0,"Emperor Cobra - Set Phase to 0 on Evade");
 
 
/* 
* sql\updates\world\2013_10_08_00_world_conditions.sql 
*/ 
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (69708,70194,69784,70224,70225,69768,69767);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 3, 69708, 0, 0, 31, 0, 3, 36954, 0, 0, 0, 0, '', 'Spell Ice Prison only hits Lich King'),
(13, 3, 70194, 0, 0, 31, 0, 3, 36954, 0, 0, 0, 0, '', 'Spell Dark Binding only hits Lich King'),
(13, 1, 69784, 0, 0, 31, 0, 3, 37014, 0, 0, 0, 0, '', 'Spell Destroy Wall only hits Ice Wall Target'),
(13, 1, 70224, 0, 0, 31, 0, 3, 37014, 0, 0, 0, 0, '', 'Spell Destroy Wall only hits Ice Wall Target'),
(13, 1, 70225, 0, 0, 31, 0, 3, 37014, 0, 0, 0, 0, '', 'Spell Destroy Wall only hits Ice Wall Target'),
(13, 1, 69768, 0, 0, 31, 0, 3, 37014, 0, 0, 0, 0, '', 'Spell Summon Ice Wall only hits Ice Wall Target'),
(13, 5, 69767, 0, 0, 31, 0, 3, 37014, 0, 0, 0, 0, '', 'Spell Summon Ice Wall only hits Ice Wall Target');
 
 
/* 
* sql\updates\world\2013_10_09_00_world_update.sql 
*/ 
UPDATE `smart_scripts` SET `action_type`=85, `action_param2`=2 WHERE  `entryorguid`=32588 AND `source_type`=0 AND `id`=5;
 
 
/* 
* sql\updates\world\2013_10_10_00_world_misc.sql 
*/ 
UPDATE `creature` SET `spawndist`=0 WHERE `guid`=142524;

UPDATE `smart_scripts` SET `event_param2`=100 WHERE `entryorguid`=16769 AND `source_type`=0 AND `id`=9;
UPDATE `smart_scripts` SET `action_param1`=55661 WHERE `entryorguid`=29872 AND `source_type`=0 AND `id`=1;
UPDATE `smart_scripts` SET `action_param1`=55662 WHERE `entryorguid`=29895 AND `source_type`=0 AND `id`=3;

UPDATE `conditions` SET `SourceGroup`=10059 WHERE `SourceTypeOrReferenceId`=10 AND `SourceGroup`=10058 AND `SourceEntry`=51969;
UPDATE `conditions` SET `SourceGroup`=10058 WHERE `SourceTypeOrReferenceId`=10 AND `SourceGroup`=10059 AND `SourceEntry`=51961;
 
 
/* 
* sql\updates\world\2013_10_10_01_world_update.sql 
*/ 
UPDATE `smart_scripts` SET `event_flags` = 1 WHERE `entryorguid` IN (16325,16326) AND `source_type` = 0 AND `id` = 0 AND `link` = 1;
 
 
/* 
* sql\updates\world\2013_10_11_00_world_sai.sql 
*/ 
UPDATE `creature_template` SET `ainame`='SmartAI' WHERE `entry` IN (18305,18306,18307);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (18305,18306,18307) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(18305,0,0,0,8,0,100,0,32205,0,0,0,33,18305,0,0,0,0,0,7,0,0,0,0,0,0,0,'Burning Blade Pyre (01) - On Spell Hit (Place Maghar Battle Standard)- Give Quest Credit'),
(18306,0,0,0,8,0,100,0,32205,0,0,0,33,18306,0,0,0,0,0,7,0,0,0,0,0,0,0,'Burning Blade Pyre (02) - On Spell Hit (Place Maghar Battle Standard)- Give Quest Credit'),
(18307,0,0,0,8,0,100,0,32205,0,0,0,33,18307,0,0,0,0,0,7,0,0,0,0,0,0,0,'Burning Blade Pyre (03) - On Spell Hit (Place Maghar Battle Standard)- Give Quest Credit');

UPDATE `creature_template` SET `ainame`='SmartAI' WHERE `entry`=23439;
DELETE FROM `smart_scripts` WHERE `entryorguid`= 23439 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(23439,0,0,1,38,0,100,0,1,1,0,0,45,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Hungry Nether Ray - On Data set - Set Data'),
(23439,0,1,0,61,0,100,0,0,0,0,0,11,41427,0,0,0,0,0,23,0,0,0,0,0,0,0,'Hungry Nether Ray - Linked with Previous Event - Cast Lucille Feed Credit Trigger');

DELETE FROM  `smart_scripts`  WHERE  `entryorguid`=23219 AND  `id`=6;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(23219, 0, 6, 0, 6, 0, 100, 0, 0, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 9, 23439, 0, 50, 0, 0, 0, 0, 'Blackwind Warp Chaser - On Death - Set Data Hungry Nether Ray');
 
 
/* 
* sql\updates\world\2013_10_12_00_world_sai.sql 
*/ 
-- Fix I've Got a Flying Machine
-- Steel Gate Chief Archaeologist SAI & Text & Condition
SET @ENTRY			:= 24399;
SET @ENTRY1			:= 24418;
SET @ENTRY2			:= 24439;
SET @ENTRY3			:= 24438;
SET @STALKER		:= 105997;
SET @MENUID			:= 8954;
SET @OPTION			:= 0;

DELETE FROM `creature_template_addon` WHERE `entry`=24418;
INSERT INTO `creature_template_addon` (`entry`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(24418, 0, 0, 0, 0x1, 0x1, '43775 43889'); -- Steel Gate Flying Machine - Flight Drop Off Buff

UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=@ENTRY;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY,0,0,1,62,0,100,0,@MENUID,@OPTION,0,0,11,45973,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Steel Gate Chief Archaeologist - On gossip option select - Cast spell'),
(@ENTRY,0,1,2,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Steel Gate Chief Archaeologist - On Link - Close gossip'),
(@ENTRY,0,2,0,61,0,100,0,0,0,0,0,11,43767,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Steel Gate Chief Archaeologist - On Link - Cast Invoker'),
(@ENTRY,0,3,4,19,0,100,0,11390,0,0,0,11,45973,1,0,0,0,0,7,0,0,0,0,0,0,0, 'Steel Gate Chief Archaeologist - On Quest Accept - Cast spell'),
(@ENTRY,0,4,0,61,0,100,0,0,0,0,0,11,43767,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Steel Gate Chief Archaeologist - On Link - Cast Invoker'),
(@ENTRY,0,5,6,19,0,100,0,11390,0,0,0,12,@ENTRY3,3,120000,0,0,0,8,0,0,0,1972.773,-3265.381,134.719,0, 'Steel Gate Chief Archaeologist - On Quest Accept - Summon Graple Target');

DELETE FROM `spell_area` WHERE `spell`=43889;
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`, `quest_start_status`, `quest_end_status`) VALUES 
(43889, 3999, 11390, 0, 0, 0, 2, 1, 8, 0);

UPDATE `creature_template` SET `modelid1`=11686, `modelid2`=0, `AIName`= 'SmartAI', `type_flags`=1048576 WHERE `entry`=@ENTRY3;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY3; 
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@ENTRY3,0,0,0,54,0,100,0,0,0,0,0,11,43890,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Grapple Target - Just Summoned - Cast Invisibility on self');

DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`= @ENTRY1;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES 
(@ENTRY1, 43768, 1, 0); 

-- Gossip conditions
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=@MENUID AND `SourceEntry`=@OPTION;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,@MENUID,@OPTION,0,9,11390,0,0,0,'','Show gossip option 0 if player has quest I''ve got a Flying Machine');

DELETE FROM `conditions` WHERE `SourceEntry`=@ENTRY1;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(16, 0, @ENTRY1, 0, 23, 3999, 0, 0, 0, '', 'Dismount player when not in intended zone');
-- Condition for Grappling Hook spell(43770)
DELETE FROM `conditions` WHERE `SourceEntry`=43770;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13, 1, 43770, 0, 31, 3, 24439, 0, 0, '', 'Spell 43770(Grappling Hook) targets npc 24439(Sack of Relics)');
-- Spell Conditions
DELETE FROM `conditions` WHERE `SourceEntry`IN (43891,43892,43789);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13, 1, 43892, 0, 31, 3, 24439, 0, 0, '', 'Spell 43892 targets npc 24439'),
(13, 1, 43891, 0, 29, @ENTRY2, 1, 0, 0, '', 'Spell 43892 targets npc 24439'),
(13, 1, 43789, 0, 31, 3, 24439, 0, 0, '', 'Spell 43892 targets npc 24439');

-- Sack of Relics SAI
DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY2 AND `source_type`=0;
UPDATE `creature_template` SET AIName='SmartAI' WHERE entry=@ENTRY2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES 
(@ENTRY2,0,0,0,8,0,100,0,43770,0,0,0,11,46598,0,0,0,0,0,7,0,0,0,0.0,0.0,0.0,0.0,'Sack of Relics - On Link - Mount Sack to vehicle'),
(@ENTRY2,0,1,2,8,0,100,1,43892,0,0,0,11,46598,0,0,0,0,0,10,105997,15214,0,0.0,0.0,0.0,0.0,' Sack of Relics - Remove Vehicle - In range'),
(@ENTRY2,0,2,3,61,0,100,1,0,0,0,0,11,36553,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Sack of Relics - On Link - Cast pet stay(36553)'),
(@ENTRY2,0,3,4,61,0,100,1,0,0,0,0,33,24439,0,0,0,0,0,21,20,0,0,0.0,0.0,0.0,0.0,'Sack of Relics - On Link - Quest Credit'),
(@ENTRY2,0,4,0,61,0,100,1,0,0,0,0,41,10000,0,0,0,0,0,1,0,0,0,0.0,0.0,0.0,0.0,'Sack of Relics - On Link - Despawn');

DELETE FROM `spell_linked_spell` WHERE `spell_trigger`=43770;
INSERT INTO `spell_linked_spell` (`spell_trigger`,`spell_effect`,`type`,`comment`) VALUES
(43770,43789,1,'Trigger grip beam');

DELETE FROM `smart_scripts` WHERE `entryorguid`=-@STALKER AND `source_type`=0;
UPDATE `creature_template` SET AIName='SmartAI' WHERE entry=15214;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-@STALKER,0,0,0,1,0,100,0,0,0,0,0,11,43892,0,0,0,0,0,11,@ENTRY2,10,0,0.0,0.0,0.0,0.0,'Invisible Stalker - OOC - Cast Spell');
 
 
