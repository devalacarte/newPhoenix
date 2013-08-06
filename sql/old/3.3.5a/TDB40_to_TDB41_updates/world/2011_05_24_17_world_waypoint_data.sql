DELETE FROM `waypoint_data` WHERE `id`=0;
SET @NPC := 107626;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `spawndist`=0,`MovementType`=2,`position_x`=847.8322,`position_y`=-4441.198,`position_z`=159.749 WHERE `guid`=@NPC;
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`bytes2`,`mount`,`auras`) VALUES (@NPC,@PATH,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`delay`,`move_flag`,`action`,`action_chance`,`wpguid`) VALUES
(@PATH,1,838.0903,-4421.268,159.749,0,0,0,100,0),
(@PATH,2,801.8729,-4407.143,179.2211,0,0,0,100,0),
(@PATH,3,782.8507,-4413.701,194.3322,0,0,0,100,0),
(@PATH,4,777.4731,-4419.182,198.0821,0,0,0,100,0),
(@PATH,5,774.1382,-4438.679,206.8877,0,0,0,100,0),
(@PATH,6,814.439,-4462.499,206.8877,0,0,0,100,0),
(@PATH,7,848.4948,-4489.605,206.8877,0,0,0,100,0),
(@PATH,8,876.2105,-4490.642,206.8877,0,0,0,100,0),
(@PATH,9,896.0039,-4450.317,192.8044,0,0,0,100,0),
(@PATH,10,897.2634,-4422.887,179.6656,0,0,0,100,0),
(@PATH,11,907.506,-4392.95,179.6656,0,0,0,100,0),
(@PATH,12,933.834,-4369.785,166.0267,0,0,0,100,0),
(@PATH,13,956.7077,-4379.646,166.0267,0,0,0,100,0),
(@PATH,14,967.011,-4400.757,158.8045,0,0,0,100,0),
(@PATH,15,966.2571,-4425.053,159.749,0,0,0,100,0),
(@PATH,16,932.5647,-4461.108,159.749,0,0,0,100,0),
(@PATH,17,891.5416,-4476.208,159.749,0,0,0,100,0),
(@PATH,18,861.6124,-4460.188,159.749,0,0,0,100,0),
(@PATH,19,847.8322,-4441.198,159.749,0,0,0,100,0);
