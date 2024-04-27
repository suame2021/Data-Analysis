/*
Queries used for PowerBI Project
*/




--1

select Continent,sum(population) as Total_Population,sum(cast(total_cases as bigint)) as Total_Cases
,sum(cast(total_deaths as bigint)) as Total_Deaths ,SUM(cast(total_deaths as int))/SUM(total_Cases) as Death_Percentage
from PortfolioProject..CovidDeaths
where continent is not NULL
Group by continent
order by continent 

--2

select dea.location,dea.population,dea.date,sum(cast(vac.new_vaccinations as bigint)) as Total_NewVaccinations 
,sum(cast(vac.total_vaccinations as bigint)) as Total_Vaccinations ,sum(cast(vac.total_vaccinations as bigint))/sum(dea.population) as Vaccination_Percentage  from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not NULL
group by dea.location,dea.date,dea.population
order by population  desc , date desc


--3 

select continent ,sum(population) as Total_Population , sum(cast(total_vaccinations as bigint))  as Total_Vaccination 
, sum(cast(total_vaccinations as bigint))/sum(population)  as Vaccination_Percentage
from PortfolioProject..CovidVaccination
where continent is not NULL
group by continent
order by Vaccination_Percentage desc





