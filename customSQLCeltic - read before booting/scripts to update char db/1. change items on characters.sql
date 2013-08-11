-- PVE DONORS
update item_instance set itemEntry = 500000 where itemEntry = 90075; -- trinket 1
update item_instance set itemEntry = 500001 where itemEntry = 90077; -- trinket 2
update item_instance set itemEntry = 500002 where itemEntry = 821020; -- trinket 3


-- TOKENS
-- select * from item_template where entry IN (102049,333333,333334,103129,30010,103128);
update item_instance set itemEntry = 600003 where itemEntry = 102049; -- guild house token
update item_instance set itemEntry = 600006 where itemEntry = 333334; -- vote token
update item_instance set itemEntry = 600005 where itemEntry = 333333; -- vip token
update item_instance set itemEntry = 600007 where itemEntry = 103129; -- BG token
update item_instance set itemEntry = 600002 where itemEntry = 300010; -- pvp medal
update item_instance set itemEntry = 600008 where itemEntry = 103128; -- gem token
update item_instance set itemEntry = 600010 where itemEntry = 80189; -- honor IOU
update item_instance set itemEntry = 600011 where itemEntry = 80196; -- arena IOU
update item_instance set itemEntry = 600012 where itemEntry = 1000002; -- 200k gold
update item_instance set itemEntry = 600013 where itemEntry = 1000001; -- 100k gold
update item_instance set itemEntry = 600014 where itemEntry = 190106; -- 50k gold



-- VOTE REWARDS: INFINITE BUFFS
-- select * FROM item_template where entry in (80318,80319,80320,80321,80322,80323,80324,80325,80326,80327,80328,80329,80330,80331,80332);
-- select * FROM item_template where entry BETWEEN 80318 AND 80323;
update item_instance set itemEntry = 500101 where itemEntry = 80318;
update item_instance set itemEntry = 500102 where itemEntry = 80319;
update item_instance set itemEntry = 500103 where itemEntry = 80320;
update item_instance set itemEntry = 500104 where itemEntry = 80321;
update item_instance set itemEntry = 500105 where itemEntry = 80322;
update item_instance set itemEntry = 500106 where itemEntry = 80323;
update item_instance set itemEntry = 500107 where itemEntry = 80324;
update item_instance set itemEntry = 500108 where itemEntry = 80325;
update item_instance set itemEntry = 500109 where itemEntry = 80326;
update item_instance set itemEntry = 500110 where itemEntry = 80327;
update item_instance set itemEntry = 500111 where itemEntry = 80328;
update item_instance set itemEntry = 500112 where itemEntry = 80329;
update item_instance set itemEntry = 500113 where itemEntry = 80330;
update item_instance set itemEntry = 500114 where itemEntry = 80331;
update item_instance set itemEntry = 500115 where itemEntry = 80332;


-- VOTE REWARDS: GLOWS
-- select * FROM item_template where entry BETWEEN 105005 AND 105025;
update item_instance set itemEntry = 500130 where itemEntry = 105005;
update item_instance set itemEntry = 500131 where itemEntry = 105006;
update item_instance set itemEntry = 500132 where itemEntry = 105007;
update item_instance set itemEntry = 500133 where itemEntry = 105008;
update item_instance set itemEntry = 500134 where itemEntry = 105009;
update item_instance set itemEntry = 500135 where itemEntry = 105010;
update item_instance set itemEntry = 500136 where itemEntry = 105011;
update item_instance set itemEntry = 500137 where itemEntry = 105012;
update item_instance set itemEntry = 500138 where itemEntry = 105013;
update item_instance set itemEntry = 500139 where itemEntry = 105014;
update item_instance set itemEntry = 500140 where itemEntry = 105015;
update item_instance set itemEntry = 500141 where itemEntry = 105016;
update item_instance set itemEntry = 500142 where itemEntry = 105017;
update item_instance set itemEntry = 500143 where itemEntry = 105018;
update item_instance set itemEntry = 500144 where itemEntry = 105019;
update item_instance set itemEntry = 500145 where itemEntry = 105020;
update item_instance set itemEntry = 500146 where itemEntry = 105021;
update item_instance set itemEntry = 500147 where itemEntry = 105022;
update item_instance set itemEntry = 500148 where itemEntry = 105023;
update item_instance set itemEntry = 500149 where itemEntry = 105024;
update item_instance set itemEntry = 500150 where itemEntry = 105025;


-- VOTE REWARDS: PVE WEAPS
-- select * FROM item_template where entry in (18680,18756,19968,22816,22988,27490,28386,28540,28782,29185,30865,31134,34349,35514,37216,102051);
update item_instance set itemEntry = 102051 where itemEntry = 500170;


-- EVENT REWARDS: MOUNTS
update item_instance set itemEntry = 500200 where itemEntry = 80401;
update item_instance set itemEntry = 500201 where itemEntry = 80402;
update item_instance set itemEntry = 500202 where itemEntry = 80403;
update item_instance set itemEntry = 500203 where itemEntry = 80404;
update item_instance set itemEntry = 500204 where itemEntry = 80405;
update item_instance set itemEntry = 500205 where itemEntry = 80406;
update item_instance set itemEntry = 500206 where itemEntry = 80407;
update item_instance set itemEntry = 500207 where itemEntry = 80408;
update item_instance set itemEntry = 500209 where itemEntry = 80409;
update item_instance set itemEntry = 500209 where itemEntry = 80410;
update item_instance set itemEntry = 500210 where itemEntry = 80411;
update item_instance set itemEntry = 500211 where itemEntry = 80412;
update item_instance set itemEntry = 500212 where itemEntry = 80413;
update item_instance set itemEntry = 500213 where itemEntry = 80414;
update item_instance set itemEntry = 500214 where itemEntry = 80415;
update item_instance set itemEntry = 500215 where itemEntry = 80416;
update item_instance set itemEntry = 500216 where itemEntry = 80417;
update item_instance set itemEntry = 500217 where itemEntry = 80418;
update item_instance set itemEntry = 500218 where itemEntry = 80419;
update item_instance set itemEntry = 500219 where itemEntry = 80420;
update item_instance set itemEntry = 500220 where itemEntry = 80421;
update item_instance set itemEntry = 500221 where itemEntry = 80422;
update item_instance set itemEntry = 500222 where itemEntry = 80423;
update item_instance set itemEntry = 500223 where itemEntry = 80424;
update item_instance set itemEntry = 500224 where itemEntry = 80425;
update item_instance set itemEntry = 500225 where itemEntry = 80426;
update item_instance set itemEntry = 500226 where itemEntry = 80427;
update item_instance set itemEntry = 500227 where itemEntry = 80428;
update item_instance set itemEntry = 500228 where itemEntry = 80429;
update item_instance set itemEntry = 500229 where itemEntry = 80430;
update item_instance set itemEntry = 500230 where itemEntry = 80431;
update item_instance set itemEntry = 500231 where itemEntry = 80432;

-- TABARDS AND SHIRTS (item_drops)
update item_instance set itemEntry = 500250 where itemEntry = 103011;
update item_instance set itemEntry = 500250 where itemEntry = 600000;
update item_instance set itemEntry = 500251 where itemEntry = 600001;
update item_instance set itemEntry = 500252 where itemEntry = 600002;
update item_instance set itemEntry = 500253 where itemEntry = 600003;
update item_instance set itemEntry = 500254 where itemEntry = 600004;
update item_instance set itemEntry = 500255 where itemEntry = 600005;
update item_instance set itemEntry = 500256 where itemEntry = 600006;
update item_instance set itemEntry = 500257 where itemEntry = 600007;


-- BAGS (item drops)
update item_instance set itemEntry = 500270 where itemEntry = 80179;
update item_instance set itemEntry = 500271 where itemEntry = 80180;
update item_instance set itemEntry = 500272 where itemEntry = 80181;
update item_instance set itemEntry = 500273 where itemEntry = 80182;
update item_instance set itemEntry = 500274 where itemEntry = 80183;
update item_instance set itemEntry = 500275 where itemEntry = 80184;
update item_instance set itemEntry = 500276 where itemEntry = 80185;
update item_instance set itemEntry = 500277 where itemEntry = 80186;
update item_instance set itemEntry = 500278 where itemEntry = 80187;


-- POP PEAK ITEMS










