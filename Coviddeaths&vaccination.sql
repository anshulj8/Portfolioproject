Select *
from portfolioproject..covidDeaths
order by 3,5

--Select *
--from portfolioproject..covidvaccination
--order by 3,5

select location,date,total_cases,new_cases,total_deaths,population
from portfolioproject..covidDeaths
order by 1,2


--finding death percentage of a country
select location,date,total_cases,total_deaths,(cast (total_deaths as float)/cast (total_cases as float))*100 as deathpercentage
from portfolioproject..covidDeaths
where location ='India'
order by 1,2

-- finding how much % of the population is infected
select location,date,population,total_cases,(total_cases / population)*100 as percentpopulationinfected
from portfolioproject..covidDeaths
--where location ='India'
order by 1,2

--finding the highest infection rate compared to population
select location,population,cast(MAX(total_cases) as int) as highestinfectioncount ,cast(MAX((total_cases/population))*100 as int) as percentpopulationinfected
from portfolioproject..covidDeaths
group by location,population 
order by percentpopulationinfected desc


--countries with highest death count per population
select location, max(cast(total_deaths as int)) as totaldeathcount
from portfolioproject..covidDeaths
where continent is not null
group by location
order by totaldeathcount desc


--break the things by continent
select continent,max(cast(total_deaths as int)) as totaldeathcount
from portfolioproject..covidDeaths
where continent is not null
group by continent
order by totaldeathcount desc


-- global numbers
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as totaldeathpercentage
from portfolioproject..covidDeaths
where continent is not null
--group by date


-- total population which has been vaccinated
-- cte(common table expression)
with popvsvac(continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(float,new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portfolioproject..covidDeaths dea
join portfolioproject..covidvaccination vac
on    dea.location=vac.location
and   dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(rollingpeoplevaccinated/population)*100 as vaccinatedpercenatgeperpopulation
from popvsvac
order by 2,3


-- temp table
drop table if exists percentpopulationvaccinated
create table percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
total_vaccinations numeric,
rollingpeoplevaccinated numeric
)
Insert into percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.total_vaccinations,
SUM(convert(float,new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portfolioproject..covidDeaths dea
join portfolioproject..covidvaccination vac
on dea.location=vac.location
and
   dea.date=vac.date
--where continent is not null

Select *,(rollingpeoplevaccinated/population)*100 as vaccinatedpopulation
from percentpopulationvaccinated
order by 2,3 desc
