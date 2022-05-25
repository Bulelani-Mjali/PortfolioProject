
select *
from PotfolioProject..covidDeaths
order by 3,4;

select location, date, total_cases, new_cases, total_deaths, population
from PotfolioProject..covidDeaths
order by 1,2;

-- Looking at Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PotfolioProject..CovidDeaths
order by 1,2;

--Looking at Total Cases vs Population

select location, date, population, total_cases, (total_cases / population) * 100 as populationPercentage
from PotfolioProject..covidDeaths
order by 1,2;


--Looking at Country with Highest infection rate compared to population

select distinct location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as percentagePopulationInfection
from PotfolioProject..covidDeaths
where continent is null
Group by location, population
order by percentagePopulationInfection desc;

--BY CONTINENT
select location, MAX(total_deaths) as totalDeathCount
from PotfolioProject..covidDeaths
where continent is not null
Group by location
order by totalDeathCount desc;

select continent, MAX(total_deaths) as totalDeathCount
from PotfolioProject..covidDeaths
where continent is not null
and total_cases is not null
and population is not null
Group by continent
order by totalDeathCount desc;



--Global Numbers
select SUM(cast(new_cases as float)) as total_cases, sum(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float)) / SUM(cast(new_cases as float)) * 100 as DeathPercentage
from PotfolioProject..CovidDeaths
where continent is not null
--and cast(new_cases as float) > 0
--and new_deaths > 0
--group by date
order by 1,2;


--loocking at total population vs vaccination

--USE CTE
with PopulationVsVaccinations(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations, SUM(cast(vaccine.new_vaccinations as float)) OVER (Partition by death.Location Order by death.location, death.date) 
as RollingPeopleVaccinated
from PotfolioProject..covidDeaths death
join PotfolioProject..covidVaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
where death.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population) * 100
from PopulationVsVaccinations

--TEMP TABLE
Drop Table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date date, 
Population nvarchar(255), 
New_Vaccinations float, 
RollingPeopleVaccinated float
)

Insert into #PercentPopulationVaccinated
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations, SUM(cast(vaccine.new_vaccinations as float)) OVER (Partition by death.Location Order by death.location, death.date) 
as RollingPeopleVaccinated
from PotfolioProject..covidDeaths death
join PotfolioProject..covidVaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
--where death.continent is not null
--where cast(vaccine.new_vaccinations as float) > 0
order by 2,3

select *, ROUND((RollingPeopleVaccinated/population) * 100, 2) as #PercentPopulationVaccinated
from #PercentPopulationVaccinated

