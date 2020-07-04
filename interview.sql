USE social_network;

-- структура таблицы users
create table social_network.users
(
	user_id int auto_increment
		primary key,
	name varchar(255) not null
);

-- структура таблицы likes
create table likes
(
    id     int auto_increment
        primary key,
    sender int not null,
    target int not null,
    constraint fk_likes_sender
        foreign key (sender) references users (user_id),
    constraint fk_likes_target
        foreign key (target) references users (user_id)
);

create index fk_likes_sender_idx
    on likes (sender);

create index fk_likes_target_idx
    on likes (target);

-- данные для таблиц (просто для примера)
INSERT INTO social_network.users (user_id, name) VALUES (1, 'Alice');
INSERT INTO social_network.users (user_id, name) VALUES (2, 'Bob');
INSERT INTO social_network.users (user_id, name) VALUES (3, 'Charlie');
INSERT INTO social_network.users (user_id, name) VALUES (4, 'Dave');
INSERT INTO social_network.users (user_id, name) VALUES (5, 'Eve');

INSERT INTO social_network.likes (id, sender, target) VALUES (1, 1, 2);
INSERT INTO social_network.likes (id, sender, target) VALUES (2, 2, 3);
INSERT INTO social_network.likes (id, sender, target) VALUES (3, 1, 3);
INSERT INTO social_network.likes (id, sender, target) VALUES (4, 3, 1);
INSERT INTO social_network.likes (id, sender, target) VALUES (5, 1, 4);
INSERT INTO social_network.likes (id, sender, target) VALUES (6, 4, 1);
INSERT INTO social_network.likes (id, sender, target) VALUES (7, 4, 2);
INSERT INTO social_network.likes (id, sender, target) VALUES (8, 5, 1);
INSERT INTO social_network.likes (id, sender, target) VALUES (9, 5, 2);
INSERT INTO social_network.likes (id, sender, target) VALUES (10, 5, 4);
INSERT INTO social_network.likes (id, sender, target) VALUES (11, 1, 5);

-- задача 1
SELECT
	u.user_id,
    u.name,
    IFNULL(l_r.likes_received, 0) AS likes_received,
    IFNULL(l_s.likes_sent, 0) AS likes_sent,
    m_l.mutual_likes
FROM
	users AS u
LEFT JOIN (
	SELECT
		u.user_id,
		COUNT(*) AS likes_received
	FROM
		users AS u
	INNER JOIN
		likes AS l ON
		u.user_id = l.target
	GROUP BY u.user_id
) AS l_r ON
	l_r.user_id = u.user_id
LEFT JOIN (
	SELECT
		u.user_id,
		COUNT(*) AS likes_sent
	FROM
		users AS u
	INNER JOIN
		likes AS l ON
		u.user_id = l.sender
	GROUP BY u.user_id
) AS l_s ON
	l_s.user_id = u.user_id
LEFT JOIN (
	SELECT DISTINCT
		l1.sender AS user_id,
		GROUP_CONCAT(DISTINCT l2.sender ORDER BY l2.sender ASC SEPARATOR ', ') AS mutual_likes
	FROM
		likes AS l1
	INNER JOIN
		likes AS l2 ON
		l1.sender = l2.target AND
		l1.target = l2.sender
	GROUP BY
		l1.sender
	ORDER BY l1.sender
    ) AS m_l ON
	m_l.user_id = u.user_id;


-- задача 2
SET @a = 1;
SET @b = 2;
SET @c = 4;

SELECT
	u.user_id, u.name
FROM
	users AS u
WHERE
	(u.user_id IN (SELECT l.sender FROM likes AS l WHERE l.target = @a)
			AND
			u.user_id IN (SELECT l.sender FROM likes AS l WHERE l.target = @b))
	AND
        (u.user_id NOT IN (SELECT l.sender FROM likes AS l WHERE l.target = @c));


-- задача 3

SELECT * FROM entities_likes;

create table social_network.entities_types
(
	id int auto_increment
		primary key,
	entity_name varchar(128) not null,
	constraint entities_types_entity_name_uindex
		unique (entity_name)
);

INSERT INTO social_network.entities_types (id, entity_name) VALUES (1, 'photo'); -- фото
INSERT INTO social_network.entities_types (id, entity_name) VALUES (2, 'photo_commentary'); -- комментарий к фото

create table social_network.entities
(
	id int auto_increment
		primary key,
	entity_type int not null,
	owner_user_id int null,
	constraint entities_entities_types_id_fk
		foreign key (entity_type) references social_network.entities_types (id),
	constraint entities_users_user_id_fk
		foreign key (owner_user_id) references social_network.users (user_id)
);

INSERT INTO social_network.entities (id, entity_type, owner_user_id) VALUES (1, 1, 1); -- фото Алисы
INSERT INTO social_network.entities (id, entity_type, owner_user_id) VALUES (2, 2, 2); -- комментарий Боба к фото Алисы

create table social_network.entities_attributes
(
	id int auto_increment
		primary key,
	entity_id int not null,
	attribute_name varchar(128) not null,
	attribute_value mediumtext null,
	constraint entities_attributes_entity_id_attribute_name_uindex
		unique (entity_id, attribute_name),
	constraint entities_attributes_entities_id_fk
		foreign key (entity_id) references social_network.entities (id)
);

INSERT INTO social_network.entities_attributes (id, entity_id, attribute_name, attribute_value) VALUES (1, 1, 'commentary', 'Me and Bob at cafe'); -- описание фото Алисы
INSERT INTO social_network.entities_attributes (id, entity_id, attribute_name, attribute_value) VALUES (2, 1, 'date_and_time', '20200704103222'); -- дата/время фото Алисы
INSERT INTO social_network.entities_attributes (id, entity_id, attribute_name, attribute_value) VALUES (3, 1, 'public', 'true'); -- показывать ли фото всем
INSERT INTO social_network.entities_attributes (id, entity_id, attribute_name, attribute_value) VALUES (4, 2, 'text', 'Looking good!'); -- текст комментария Боба
INSERT INTO social_network.entities_attributes (id, entity_id, attribute_name, attribute_value) VALUES (5, 2, 'date_and_time', '20200704144812'); -- дата/время комментария Боба
INSERT INTO social_network.entities_attributes (id, entity_id, attribute_name, attribute_value) VALUES (6, 2, 'photo_id', '1'); -- к какому фото относится комментарий

create table social_network.entities_likes
(
	id int auto_increment
		primary key,
	user_id int not null,
	entity_id int not null,
	constraint entities_likes_user_id_entity_id_uindex
		unique (user_id, entity_id)
);
                                                                                     -- лайки:
INSERT INTO social_network.entities_likes (id, user_id, entity_id) VALUES (3, 1, 2); -- от Алисы на комм. Боба
INSERT INTO social_network.entities_likes (id, user_id, entity_id) VALUES (1, 2, 1); -- от Боба на фото Алисы
INSERT INTO social_network.entities_likes (id, user_id, entity_id) VALUES (2, 3, 1); -- от Чарли на фото Алисы
INSERT INTO social_network.entities_likes (id, user_id, entity_id) VALUES (4, 3, 2); -- от Чарли на комм. Боба

-- кто лайкнул фото Алисы?
SET @entity = 1;
SELECT
       u.user_id, u.name
FROM
    users AS u
        INNER JOIN entities_likes AS e_l
            ON u.user_id = e_l.user_id
WHERE
    e_l.entity_id = @entity;

-- сколько было лайкнувших?
SET @entity = 1;
SELECT
        COUNT(*)
FROM
     entities_likes AS e_l
WHERE
    e_l.entity_id = @entity;

-- все комментарии, относящиеся к фото
SET @entity = 1;
SELECT
        e.id
FROM
    entities AS e
        INNER JOIN entities_attributes ea on e.id = ea.entity_id
WHERE
    e.entity_type = 2 -- (SELECT e_t.id FROM entities_types AS e_t WHERE e_t.entity_name = 'photo')
        AND ea.attribute_name = 'photo_id'
        AND ea.attribute_value = CONVERT(@entity, char);
