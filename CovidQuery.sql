Select location, date, total_cases, new_cases, total_deaths, population from [Portfolio Project]..CovidDeaths
order by location, date


--Looking at Total Cases v/s Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage from [Portfolio Project]..CovidDeaths
where location = 'India'
order by location, date


--Looking at Total Cases v/s Population
--Shows what percentage of Population got covid
Select location, date, total_cases, population, (total_cases/population)*100 as InfectedPopulationPercent from [Portfolio Project]..CovidDeaths
where location = 'India'
order by location, date


--Looking at countries with most Infection rate compared to Population
Select location, population, max(total_cases) as HighestInfectCount, max((total_cases/population))*100 as InfectedPopulationPercent
from [Portfolio Project]..CovidDeaths
where continent is not NULL
group by location, population
order by InfectedPopulationPercent desc

--Looking at countries with most Deaths compared to population
Select location, population, max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..CovidDeaths
where continent is not NULL
group by location, population
order by TotalDeathCount desc


--Breaking things down by Continent
--Continents with highest Death Count
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


--Global Numbers
Select date, sum(new_cases) as NewCases, sum(cast(new_deaths as int)) as NewDeaths, 
(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercent 
from [Portfolio Project]..CovidDeaths
where continent is not null
group by date
order by 1, 2


--Looking at Total Population v/s Vaccinations
With Pop_vs_Vac(Continent, Location, Date, Population, New_Vaccinations, RollingCountVaccinations)
as
(
Select cv.continent, cv.location, cv.date, cd.population, cv.new_vaccinations,
sum(cast(new_vaccinations as bigint)) over(partition by cv.location order by cv.location, cv.date) as RollingCountVaccinations
from [Portfolio Project]..CovidVaccinations cv join [Portfolio Project]..CovidDeaths cd
on cv.location = cd.location and cv.date = cd.date
--where cv.continent is not null
)
Select *, (RollingCountVaccinations/Population)*100 as PercentPopulationVaccinated from Pop_vs_Vac


--Creating Views for storing useful Data
Create view PercentPopulationVaccinated as
Select cv.continent, cv.location, cv.date, cd.population, cv.new_vaccinations,
sum(cast(new_vaccinations as bigint)) over(partition by cv.location order by cv.location, cv.date) as RollingCountVaccinations
from [Portfolio Project]..CovidVaccinations cv join [Portfolio Project]..CovidDeaths cd
on cv.location = cd.location and cv.date = cd.date
where cv.continent is not null













