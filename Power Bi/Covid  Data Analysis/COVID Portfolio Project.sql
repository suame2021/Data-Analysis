Select * 
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select * 
--From PortfolioProject..CovidVaccination
--order by 3,4

--Select Data we are going to use

Select Location,date,total_cases,new_cases,total_deaths,population 
From PortfolioProject..CovidDeaths
where continent is not null

--Looking at Total Cases vs Total Deaths
--Shows Likelihood of dying if you contract covid in your Country

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%india%' and continent is not null

--Looking at Total Cases vs Population
--Shows what percent of population get Covid

Select Location,date,total_cases,population,(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where location like '%india%' and continent is not null

--Looking at Countries with Higest Infection Rate as Compared to Population

Select Location,population,MAX(total_cases) as HigestInfectedCount,MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%india%'
where continent is not null
Group by Location,population
order by PercentPopulationInfected desc

--showing Countries with Highest Death Count per Population

Select Location,MAX(cast(total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--Let's bfreak things down by Continent

--showing the continent with higest death count

Select continent,MAX(cast(total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS

select date , SUM(new_cases) as Total_Cases , SUM(cast(new_deaths as bigint)) as Total_Death , SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by date

--Looking at Total Population  vs Vaccinations


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,
SUM(CONVERT(bigint ,vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null  


--use CTE

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,
SUM(CONVERT(bigint ,vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null  
)
select * ,(RollingPeopleVaccinated/population)*100
from PopvsVac


--Temp Table

Drop table if exists #PercentPopulationVaccinated 
create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,
SUM(CONVERT(bigint ,vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
    on dea.location = vac.location
    and dea.date = vac.date
--where dea.continent is not null  

select * ,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating View to Store data for later Visualization

USE PortfolioProject
GO
CREATE VIEW PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,
SUM(CONVERT(bigint ,vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null  

select * from PercentPopulationVaccinated



