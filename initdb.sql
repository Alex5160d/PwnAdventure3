CREATE TABLE users (id SERIAL, team INTEGER, name VARCHAR(32), canonical_name VARCHAR(32), password VARCHAR(96), user_type INTEGER);
CREATE TABLE teams (id SERIAL, name VARCHAR(32), canonical_name VARCHAR(32), hash VARCHAR(72), admin INTEGER);
CREATE TABLE team_state (team_id INTEGER, state_id INTEGER, val INTEGER);
CREATE TABLE characters (id SERIAL, user_id INTEGER, name VARCHAR(32), canonical_name VARCHAR(32), avatar INTEGER, color1 INTEGER, color2 INTEGER, color3 INTEGER, color4 INTEGER, location INTEGER, active_slot INTEGER, active_quest INTEGER);
CREATE TABLE char_items (char_id INTEGER, item_id INTEGER, item_count INTEGER, loaded_ammo INTEGER);
CREATE TABLE char_slots (char_id INTEGER, slot INTEGER, item_id INTEGER);
CREATE TABLE char_quests (char_id INTEGER, quest_id INTEGER, state_id INTEGER, kills INTEGER);
CREATE TABLE char_pickups (char_id INTEGER, state_id INTEGER);
CREATE TABLE names (id SERIAL, name VARCHAR(32));
CREATE TABLE info (name VARCHAR(32), contents VARCHAR(256));
CREATE UNIQUE INDEX idx_user_names ON users(canonical_name);
CREATE UNIQUE INDEX idx_char_names ON characters(canonical_name);
CREATE INDEX idx_user_chars ON characters(user_id);
CREATE UNIQUE INDEX idx_team_names ON teams(canonical_name);
CREATE UNIQUE INDEX idx_team_hashes ON teams(hash);
CREATE INDEX idx_team_members ON users(team);
CREATE INDEX idx_team_state ON team_state(team_id);
CREATE INDEX idx_char_items ON char_items(char_id);
CREATE INDEX idx_char_quests ON char_quests(char_id);
CREATE INDEX idx_char_pickups ON char_pickups(char_id);
CREATE INDEX idx_char_slots ON char_slots(char_id);
CREATE UNIQUE INDEX idx_names ON names(name);
CREATE UNIQUE INDEX idx_info ON info(name);

-- Create gameserver account
-- Useranme: GameServer
-- Password: PasswordForGameServer!!!
INSERT INTO teams(name, canonical_name, hash, admin) VALUES ('GameServer', 'gameserver', '6cddbc33b017c6d93cf843d1de72af2d', 0);
INSERT INTO users(team, name, canonical_name, password, user_type) VALUES (1, 'GameServer', 'gameserver', '1122334455667788:0233d8f6be526042538b57455534eb23011690dd2e209857ce2471fdcd62aa72', 2);

-- Create admin team
-- Join with the hash db1e797da308f027c876c61786682f3b
INSERT INTO teams(name, canonical_name, hash, admin) VALUES ('WeAreRoot', 'weareroot', 'db1e797da308f027c876c61786682f3b', 1);

-- Customise welcome banner
INSERT INTO info(name, contents) VALUES ('login_title', 'PwnAdventure 3 - Docker');
INSERT INTO info(name, contents) VALUES ('login_text', 'Welcome to Pwnie Island! For more info about the game and how to hack it, visit GitHub.com/beaujeant.');
