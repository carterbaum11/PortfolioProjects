select *
from PortfolioProject..Covid_deaths
where continent is not null
order by 3,4

--select *
--from `articulate-ego-345816.PortfolioProject.Covid_vaccinations`
--order by 3,4
--Select data that we are using
select
location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..Covid_deaths
order by 1, 2

--Looking at Total Cases vs Total Deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..Covid_deaths
where location like '%States%'
order by 1, 2

--Looking at Total Cases vs Population
--Shows percentage of pipulaiton that got Covid
select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..Covid_deaths
where location like '%States%'
order by 1, 2

--Looking at counties with highest infection rate compared to population
--Shows percentage ofpipulaiton that got Covid
select location, population, max(total_cases) as Highest_infection_count, max((total_cases/population))*100 as
PercentPopulationInfected
from PortfolioProject..Covid_deaths
group by population, location
order by PercentPopulationInfected desc

-- Showing the counties with highest death count per population
select location, population, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..Covid_deaths
where continent is not null
group by population, location
order by TotalDeathCount desc

--Showing death count by continent
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..Covid_deaths
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global Numbers
select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from PortfolioProject..Covid_deaths
where continent is not null
--group by date
order by 1, 2

-- Use CTE
-- Create Table to use RollingPeopleVaccinated as formula
With PopVsVac (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as (
--Looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as
RollingPeopleVaccinated
from PortfolioProject..Covid_deaths dea
join PortfolioProject..Covid_vaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopVsVac


-- Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)
Insert Into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as
RollingPeopleVaccinated
from PortfolioProject..Covid_deaths dea
join PortfolioProject..Covid_vaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

--Creating View to store data for visualizations
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as
RollingPeopleVaccinated
from PortfolioProject..Covid_deaths dea
join PortfolioProject..Covid_vaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--order by 2,3