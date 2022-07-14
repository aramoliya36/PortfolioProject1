select * from PortfolioProject..CovidDeaths$;

select * from PortfolioProject..CovidDeaths$ where continent='Africa';

select * from PortfolioProject..CovidDeaths$ where continent='Africa' order by location;

select COUNT(iso_code) from PortfolioProject..CovidDeaths$ where continent='Africa';

select COUNT(iso_code) from PortfolioProject..CovidDeaths$;

select COUNT(total_cases) from PortfolioProject..CovidDeaths$

select COUNT(total_cases) from PortfolioProject..CovidDeaths$ where continent='Africa';

select SUM(total_cases) from PortfolioProject..CovidDeaths$

select SUM(total_cases) from PortfolioProject..CovidDeaths$ where continent='Africa';

select SUM(total_cases) from PortfolioProject..CovidDeaths$ where continent='Africa';

select distinct continent,location, SUM(total_cases) OVER(Partition by location) As Total_Cases from PortfolioProject..CovidDeaths$ where continent is not null and Total_Cases is not null;

select SUM(total_cases) from PortfolioProject..CovidDeaths$ where location='Afghanistan';

select * from PortfolioProject..CovidDeaths$ order by 3, 4;

select * from PortfolioProject..CovidVaccinations$ order by 3, 4;


--Select data that i am going to use

select location,date,total_cases,new_cases,total_deaths,population 
from PortfolioProject..CovidDeaths$
order by 1,2

--Looking at total cases vs total deaths
select location,date,total_cases,total_deaths , (total_deaths/total_cases)*100 As DeathPercentages
from PortfolioProject..CovidDeaths$
order by 1,2

--Looking at total cases vs total deaths in perticular location
select location,date,total_cases,total_deaths , (total_deaths/total_cases)*100 As DeathPercentages
from PortfolioProject..CovidDeaths$
where location like '%rus%'
order by 1,2

--Looking at total cases vs population
select location,date,total_cases,population , (total_cases/population)*100 As PopulationInfected
from PortfolioProject..CovidDeaths$
where location like '%rus%'
order by 1,2



select location,population,Max(total_cases) , MAX((total_cases/population))*100 As PopulationInfected
from PortfolioProject..CovidDeaths$
--where location like '%rus%'
Group by location,population
order by PopulationInfected desc;


--Showing countries with highest death count per population

select location,Max(cast(new_deaths as int)) As HighestDeathCount
from PortfolioProject..CovidDeaths$
--where location like '%rus%'
Group by location
order by HighestDeathCount desc;


select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) As TotalDeath, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentages
from PortfolioProject..CovidDeaths$
where continent is not NULL
--Group by location
order by 1,2;

--Join Two Tables

Select * from PortfolioProject..CovidDeaths$ dec
join PortfolioProject..CovidVaccinations$ dev
on dec.location=dev.location and
dec.date=dev.date;


--

--Looking total_population vs vaccinations

Select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations,
SUM(CAST(dev.new_vaccinations as int))OVER(partition by dea.location) as SumOfNEWVactination
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ dev
on dea.location=dev.location and
dea.date=dev.date
where dea.continent is not null
order by 2,3

--USe CTE

With PopvsVac(Continent,Location,Date,Population,New_Vactinations,SumOfNEWVactination)
as
(
Select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations,
SUM(CAST(dev.new_vaccinations as int))OVER(partition by dea.location) as SumOfNEWVactination
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ dev
on dea.location=dev.location and
dea.date=dev.date
where dea.continent is not null
--order by 2,3
)
select * from PopvsVac


-----Temporary table
Drop table if exists #PercentPopulationVactinated
Create table #PercentPopulationVactinated
(
Continent nvarchar(255),Location
nvarchar(255),
Date datetime,
Population numeric,
New_Vactinations numeric,
SumOfNEWVactination numeric
)

Insert into #PercentPopulationVactinated
Select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations,
SUM(CAST(dev.new_vaccinations as int))OVER(partition by dea.location) as SumOfNEWVactination
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ dev
on dea.location=dev.location and
dea.date=dev.date
where dea.continent is not null

select * from #PercentPopulationVactinated



---Create View

CREATE VIEW PercentPopulationVactinated
AS
Select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations,
SUM(CAST(dev.new_vaccinations as int))OVER(partition by dea.location) as SumOfNEWVactination
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ dev
on dea.location=dev.location and
dea.date=dev.date
where dea.continent is not null

SELECT * FROM PercentPopulationVactinated
