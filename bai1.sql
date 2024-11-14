-- ex2
use congtrinh5;
alter table building
add foreign key (host_id) references host(id);
alter table building 
add foreign key (contractor_id) references contractor(id);
alter table `work`
add foreign key (building_id) references building(id);
alter table `work`
add foreign key (worker_id) references worker(id);
alter table `design`
add foreign key (building_id) references building(id);
alter table `design`
add foreign key (architect_id) references architect(id);
-- ex3
-- hiển thị thông tin công trình có chi phí cao nhất
select*from building
where cost = (select max(cost) from building);
-- hiển thị thông tin công trình có chi phí lớn hơn tất cả các công trình được xây dựng ở cần thơ
select*from building
where cost > all(select cost from building where city='can tho');
-- hiển thị thông tin công trình có chi phí lớn hơn 1 trong các công trình đc xây dựng ở cần thơ
select*from building
where cost > any(select cost from building where city = 'can tho');
-- Hiển thị thông tin công trình chưa có kiến trúc sư thiết kế
select*from architect a left join design d on d.architect_id = a.id
where building_id is null;
-- Hiển thị thông tin các kiến trúc sư cùng năm sinh và cùng nơi tốt nghiệp
SELECT *
FROM architect
WHERE (birthday, place) IN (
    SELECT birthday, place
    FROM architect
    GROUP BY birthday, place
    HAVING COUNT(*) > 1
);
-- hiển thị thù lao trung bình của từng kiến trúc sư
select a.name, sum(d.benefit) as 'thù lao trung bình'  from architect a join design d on a.id = d.architect_id
group by name;
-- Hiển thị chi phí đầu tư cho các công trình ở mỗi thành phố
select name as 'tên công trình', cost as 'chi phí đầu tư' from building;
-- Tìm các công trình có chi phí trả cho kiến trúc sư lớn hơn 50
select b.name as'tên công trình', d.benefit, a.name as 'tên kiến trúc sư'from building b join design d on d.building_id = b.id join architect a on d.architect_id = a.id
where d.benefit>50;
-- Tìm các thành phố có ít nhất một kiến trúc sư tốt nghiệp
select place from architect
group by place
having count(*)>=1;
-- ex5
-- Hiển thị tên công trình, tên chủ nhân và tên chủ thầu của công trình đó
select b.name as 'tên công trình', h.name as 'tên chủ nhân', c.name as 'tên chủ thầu' from building b join host h on b.host_id = h.id join contractor c on b.contractor_id = c.id;
-- Hiển thị tên công trình (building), tên kiến trúc sư (architect) và thù lao của kiến trúc sư ở mỗi công trình (design)
select b.name as 'tên công trình', a.name as 'tên kiến trúc sư', d.benefit as 'thù lao' from building b join  design d on b.id = d.building_id join architect a on d.architect_id = a.id;
-- Hãy cho biết tên và địa chỉ công trình (building) do chủ thầu Công ty xây dựng số 6 thi công (contractor)
select b.name as 'tên công trình', b.address as 'địa chỉ' from building b join contractor c on c.id = b.contractor_id 
where c.name='cty xd so 6';
-- Tìm tên và địa chỉ liên lạc của các chủ thầu (contractor) thi công công trình ở Cần Thơ (building) do kiến trúc sư Lê Kim Dung thiết kế (architect, design)
select c.name, c.address from building b join contractor c on b.contractor_id = c.id join design d on b.id = d.building_id join architect a on a.id = d.architect_id
where b.city='can tho' and a.name = 'le kim dung';
-- Hãy cho biết nơi tốt nghiệp của các kiến trúc sư (architect) đã thiết kế (design) công trình Khách Sạn Quốc Tế ở Cần Thơ (building)
select a.place as 'nơi tốt nghiệp', b.name, a.name from architect a join design d on d.architect_id = a.id join building b on d.building_id = b.id
where b.name =  'khach san quoc te';
-- Cho biết họ tên, năm sinh, năm vào nghề của các công nhân có chuyên môn hàn hoặc điện (worker) đã tham gia các công trình (work) mà chủ thầu Lê Văn Sơn (contractor) đã trúng thầu (building)
select w.name as 'họ tên', w.birthday as 'năm sinh', w.year as 'năm vào nghề' from worker w join work on work.worker_id = w.id join building b on b.id=work.building_id join contractor c on c.id = b.contractor_id 
where w.skill = ('han' or 'dien') and c.name='le van son';
-- Những công nhân nào (worker) đã bắt đầu tham gia công trình Khách sạn Quốc Tế ở Cần Thơ (building) trong giai đoạn từ ngày 15/12/1994 đến 31/12/1994 (work) số ngày tương ứng là bao nhiêu(chưa hiểu đề bài lắm)
select * from worker w join work on work.worker_id = w.id join building b on b.id=work.building_id;
-- Cho biết họ tên và năm sinh của các kiến trúc sư đã tốt nghiệp ở TP Hồ Chí Minh (architect) và đã thiết kế ít nhất một công trình (design) có kinh phí đầu tư trên 400 triệu đồng (building)
select a.name as 'tên kiến trúc sư', a.birthday as 'năm sinh' from architect a join design d on d.architect_id = a.id join building b on b.id = d.building_id
where a.place= 'tp hcm' and b.cost >400;
-- Cho biết tên công trình có kinh phí cao nhất
select*from building 
where cost = (select max(cost) from building);
-- Cho biết tên các kiến trúc sư (architect) vừa thiết kế các công trình (design) do Phòng dịch vụ sở xây dựng (contractor) thi công vừa thiết kế các công trình do chủ thầu Lê Văn Sơn thi công
select a.name from architect a join design d on d.architect_id = a.id join building b on b.id = d.building_id join contractor c on c.id = b.contractor_id
where c.name=('phong dich vu so xay dung' and 'le van son')
group by a.name;
-- Tìm các cặp tên của chủ thầu có trúng thầu các công trình tại cùng một thành phố
SELECT DISTINCT c1.name, c2.name
FROM contractor c1
JOIN building b1 ON c1.id = b1.contractor_id
JOIN contractor c2 ON c2.id = b1.contractor_id
JOIN building b2 ON c2.id = b2.contractor_id
WHERE b1.city = b2.city AND c1.id != c2.id;

-- Tìm tổng kinh phí của tất cả các công trình theo từng chủ thầu
SELECT c.name, SUM(b.cost) AS `Tổng kinh phí`
FROM contractor c
JOIN building b ON c.id = b.contractor_id
GROUP BY c.name;

-- Cho biết họ tên các kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu
SELECT a.name
FROM architect a
JOIN design d ON a.id = d.architect_id
JOIN building b ON d.building_id = b.id
GROUP BY a.name
HAVING SUM(b.cost) > 25000000;

-- Cho biết số lượng các kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu
SELECT COUNT(DISTINCT a.name)
FROM architect a
JOIN design d ON a.id = d.architect_id
JOIN building b ON d.building_id = b.id
GROUP BY a.name
HAVING SUM(b.cost) > 25000000;

-- Tìm tổng số công nhân đã than gia ở mỗi công trình
SELECT b.name AS building_name, COUNT(wk.worker_id) AS total_workers
FROM building b
JOIN work wk ON b.id = wk.building_id
GROUP BY b.name;

-- Tìm tên và địa chỉ công trình có tổng số công nhân tham gia nhiều nhất
SELECT b.name, b.address
FROM building b
JOIN work w ON b.id = w.building_id
GROUP BY b.name, b.address
ORDER BY COUNT(w.worker_id) DESC
LIMIT 1;

-- Cho biêt tên các thành phố và kinh phí trung bình cho mỗi công trình của từng thành phố tương ứng
SELECT b.city, AVG(b.cost) AS avg_cost
FROM building b
GROUP BY b.city;

-- Cho biêt tên các thành phố và kinh phí trung bình cho mỗi công trình của từng thành phố tương ứng
SELECT wk.name
FROM worker AS wk
JOIN work AS w ON wk.id = w.worker_id
GROUP BY wk.id
HAVING SUM(CAST(w.total AS SIGNED)) > 
    (SELECT SUM(CAST(w2.total AS SIGNED))
     FROM work AS w2 
     JOIN worker AS wk2 ON wk2.id = w2.worker_id 
     WHERE wk2.name = 'Nguyễn Hồng Vân');

-- Cho biết tổng số công trình mà mỗi chủ thầu đã thi công tại mỗi thành phố
SELECT c.name AS contractor_name, b.city, COUNT(b.id) AS `Tống số công trình`
FROM contractor AS c
JOIN building AS b ON c.id = b.contractor_id
GROUP BY c.id, b.city;

-- Cho biết họ tên công nhân có tham gia ở tất cả các công trình
SELECT wk.name
FROM worker AS wk
JOIN work AS w ON wk.id = w.worker_id
GROUP BY wk.id
HAVING COUNT(DISTINCT w.building_id) = (SELECT COUNT(id) FROM building);


    



