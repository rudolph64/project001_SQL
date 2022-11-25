# https://www.youtube.com/watch?v=I3YvjFfn478
Select * from project001.dataset1;
Select * from project001.dataset2;

# number of rows in a dataset
select count(*) from project001.dataset1;

# data for jarkhand & bihar
Select * from project001.dataset1 where state in ('Jharkhand', 'Bihar');

# popuation of india
Select sum(Population) from project001.dataset2;

# Average growth of india
Select avg(Growth)*100 from project001.dataset1;

# Average growth of india state wise
Select State,avg(Growth)*100 from project001.dataset1 group by State;

# Average sex of india state wise
Select State, round(avg(Sex_Ratio),0) as sex_ra from project001.dataset1 group by State;

# Average sex ratio of india state wise sorted by lowest to highest
Select State, round(avg(Sex_Ratio),0) as sex_ra from project001.dataset1 group by State order by sex_ra;

# Average literacy of india state wise sorted by lowest to highest
Select State, round(avg(Literacy),0) as li_ra from project001.dataset1 group by State order by li_ra;

# Average literacy of state with above 90
Select State, round(avg(Literacy),0) as li_ra from project001.dataset1 
group by State having round(avg(Literacy),0) >90 order by li_ra;

# top 3 states showing highest growth %
Select State, avg(Growth*100) as Gro from project001.dataset1 group by State order by Gro desc limit 3;

# top 3 and bottom 3 literacy rates state wise
Select State, Literacy as liter from project001.dataset1 group by State order by liter desc limit 3;

# state staritng with letter a
Select distinct State from project001.dataset1 where lower(State) like 'A%';

# join both tables for to get the below columns
SELECT one.District, one.State, one.Sex_Ratio/1000 as Sex_Ra, two.Population FROM project001.dataset1 AS one INNER JOIN project001.dataset2 AS two ON one.District = two.District;

# Find sex ratio, Total male and females
#females/males=sex ratio......eq1
#females+males=population.....eq2 so females=population-males
#(population-males)=(sex ratio)*males from eq1 & eq2
#population=(sex ratio+1)*males
#males=population/(sex ratio+1)
#females=(population*sex ratio+1)/(sex ratio+1)
Select c.District, c.State, c.Population/(Sex_Ratio+1)*1000 as male, (c.population*c.Sex_Ratio+1)/(c.Sex_Ratio+1) as female from 
(SELECT one.District, one.State, one.Sex_Ratio, two.Population FROM project001.dataset1 AS one INNER JOIN project001.dataset2 AS two ON one.District = two.District) as c;

# Total literacy rate
# total_lit_people/Population=Literacy so we get Literacy*Population=total_lit_people
# total_illlit_people= (1-Literacy)*Population
Select d.District, d.State, round(d.lit1*d.Population,0) as total_lit_people, round((1-d.lit1)*d.Population,0) as total_illlit_people from
(SELECT a.District, a.State, a.Literacy/100 as lit1, b.Population FROM project001.dataset1 AS a INNER JOIN project001.dataset2 AS b ON a.District = b.District) as d;

# Group the Total literacy rate by state wise
Select c.State,sum(total_lit_people),sum(total_illlit_people) from
(Select d.District, d.State, round(d.lit1*d.Population,0) as total_lit_people, round((1-d.lit1)*d.Population,0) as total_illlit_people from
(SELECT a.District, a.State, a.Literacy/100 as lit1, b.Population FROM project001.dataset1 AS a INNER JOIN project001.dataset2 AS b ON a.District = b.District) as d) as c
group by c.state;

# popul in previous census
# Population=prev_cen+(Growth*prev_cen)
# prev_cen=Population/(1+Growth)
Select d.District, d.State, round(d.Population/(1+d.Grow),0) as prev_cen, d.Population from
(Select a.District, a.State, a.Growth as Grow, b.Population FROM project001.dataset1 AS a INNER JOIN project001.dataset2 AS b ON a.District = b.District) as d


# Group the  popul in previous census by state wise
Select c.State, sum(prev_cen), sum(Population) from
(Select d.District, d.State, round(d.Population/(1+d.Grow),0) as prev_cen, d.Population from
(Select a.District, a.State, a.Growth as Grow, b.Population FROM project001.dataset1 AS a INNER JOIN project001.dataset2 AS b ON a.District = b.District) as d) as c
group by c.State;
