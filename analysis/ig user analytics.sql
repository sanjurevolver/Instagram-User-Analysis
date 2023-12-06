-- Instagram User Analytics 
-- Description:
-- User analysis is the process by which how users engange and interact with our digital product(software or mobile application)
-- In an attempt to derive business insights for marketing, product & development teams.

use ig_clone;

# 1. Find the 5 oldest users of the Instagram from the dataset provided 

select * from users;
select username,created_at from users order by created_at limit 5;

# 2. Find the users who have never posted a single photo on Instagram

select * from photos,users;
select u.username from users u left join photos p on p.user_id=u.id where p.image_url is null order by u.username;

# 3. Identify the winner of the contest and provide their details to the team

select * from likes,photos,users;
select users.username,count(likes.user_id) as no_of_likes 
from likes inner join photos on likes.photo_id=photos.id
inner join users on photos.user_id=users.id 
group by likes.photo_id,users.username
order by no_of_likes desc limit 1;

# 4. Identify and suggest the top 5 most commonly used hastags on the platform 

select * from photo_tags,tags;
select t.tag_name,count(photo_id) as hst from photo_tags p 
inner join tags t on t.id=p.tag_id group by t.tag_name order by hst desc limit 5;

# 5. What day of the week do most users register on? Provide insights on when to schedule an ad campaign?

select * from users;
select date_format((created_at), '%W') as dayy, count(username) from users group by 1 order by 2 desc;
-- %W = gives us day from the date...

# 6. Provide how many times does average user posts on Instagram.
# Also provide total no.of photos on Instagram (257)/Total no of users(100)
select * from photos,users;

with base as (select u.id as userid,count(p.id) as photoid from users u left join photos p on p.user_id=u.id group by u.id)
select sum(photoid) as totalphotos, count(userid) as total_users,sum(photoid)/count(userid) as photo_per_user
from base;

# 7. Provide data on users(bots) who have liked every single photo on the site

select * from users,likes;
with base as( select u.username, count(l.photo_id) as likess from likes l inner join users u on u.id=l.user_id
group by username)
select username,likess from base where likess = (select count(*) from photos) order by username;


